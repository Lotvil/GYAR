extends Control

const TILE = preload("res://scenes/element_tile.tscn")

@onready var table_grid: GridContainer = $VSplitContainer/HSplitContainer/TableGrid

@onready var grid: GridContainer = $VSplitContainer/HSplitContainer/TableGrid
@onready var sidebar: PanelContainer = $VSplitContainer/HSplitContainer/Sidebar

@export var blocks : Dictionary[String, BlockData]

var elements = []
var tiles = {}

var tiles_by_symbol : Dictionary = {}
var last_open_element = "-1"

func _ready():
	close()

	load_elements()
	build_table()

func open():
	visible = true

func close():
	visible = false

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

	var unlocked_blocks = get_unlocked_blocks()

	sidebar.show_element(data, discovered, count, unlocked_blocks, blocks)

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

func check_element(symbol:String, amount:int = 1):
	if !tiles_by_symbol.has(symbol):
		return false
	
	var tile = tiles_by_symbol[symbol]
	
	if tile.count >= amount:
		return true
	
	return false


func get_unlocked_blocks() -> Array:

	var unlocked = []

	for tile_name in blocks:

		var block = blocks[tile_name]

		if !block.is_placable:
			continue

		var valid = true

		for symbol in block.elements:

			if tiles_by_symbol.has(symbol):
				var tile = tiles_by_symbol[symbol]
				
				if !tile.discovered == true:
					valid = false
			else:
				valid = false

		if valid:
			unlocked.append(tile_name)

	return unlocked
