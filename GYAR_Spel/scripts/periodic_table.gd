extends Control

const TILE = preload("res://scenes/element_tile.tscn")

@onready var table_grid: GridContainer = $HSplitContainer/VBoxContainer/TableGrid

@onready var grid: GridContainer = $HSplitContainer/VBoxContainer/TableGrid
@onready var lanthanides: GridContainer = $HSplitContainer/VBoxContainer/LanthanideRow
@onready var actinides: GridContainer = $HSplitContainer/VBoxContainer/ActinideRow
@onready var sidebar: PanelContainer = $HSplitContainer/Sidebar


var elements = []
var tiles = {}

var tiles_by_symbol : Dictionary = {}
var last_open_element = "-1"

var is_open = false

func _ready():
	close()

	load_elements()
	build_table()

func _process(_delta):
	if Input.is_action_just_pressed("inventory"):
		if is_open:
			close()
		else:
			open()

func open():
	visible = true
	is_open = true

func close():
	visible = false
	is_open = false



"""
func resize_tiles():

	var window_width = 900

	var tile_size = window_width / 18.0

	for tile in get_tree().get_nodes_in_group("elements"):

		tile.custom_minimum_size = Vector2(tile_size, tile_size)
"""
func load_elements():

	var file = FileAccess.open("res://data/elements.csv", FileAccess.READ)

	file.get_csv_line()

	while !file.eof_reached():

		var row = file.get_csv_line()

		if row.size() < 12:
			continue

		var data = {
			"atomnummer": row[0],
			"symbol": row[1],
			"namn": row[2],
			"atommassa": row[3],
			"grupp": row[4],
			"period": row[5],
			"kategori": row[6],
			"tillstånd": row[7],
			"smältpunkt_K": row[8],
			"kokpunkt_K": row[9],
			"densitet_kg_m3": row[10],
			"sammanfattning": row[11]
		}

		elements.append(data)


func build_table():

	var total_cells = 10 * 18

	# Step 1 — create empty placeholders
	for i in total_cells:
		var spacer = Control.new()
		spacer.custom_minimum_size = Vector2(50,50)
		grid.add_child(spacer)

	# Step 2 — place elements
	for element in elements:

		var group = element["grupp"]

		if group == "":
			continue

		var period = int(element["period"])
		group = int(group)

		var index = (period - 1) * 18 + (group - 1)

		var tile = TILE.instantiate()
		grid.add_child(tile)
		tile.setup(element)
		
		tiles_by_symbol[element["symbol"]] = tile

		tile.connect("element_clicked", _on_element_clicked)

		var placeholder = grid.get_child(index)

		grid.remove_child(placeholder)
		placeholder.queue_free()

		grid.move_child(tile, index)

func _on_element_clicked(data, discovered, count):
	last_open_element = data["symbol"]
	
	sidebar.show_element(data, discovered, count)

func add_element(symbol:String, amount:int = 1):
	
	if !tiles_by_symbol.has(symbol):
		return

	var tile = tiles_by_symbol[symbol]

	tile.count += amount

	if !tile.discovered:
		tile.discovered = true
	
	if last_open_element == symbol:
		tile._pressed()

	tile.update_visual()
