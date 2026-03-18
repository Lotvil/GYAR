extends PanelContainer

@onready var title: Label = $MarginContainer/VBoxContainer/Title
@onready var count: Label = $MarginContainer/VBoxContainer/Count
@onready var number: Label = $MarginContainer/VBoxContainer/Number
@onready var mass: Label = $MarginContainer/VBoxContainer/Mass
@onready var category: Label = $MarginContainer/VBoxContainer/Category
@onready var melting: Label = $MarginContainer/VBoxContainer/Melting
@onready var boiling: Label = $MarginContainer/VBoxContainer/Boiling
@onready var density: Label = $MarginContainer/VBoxContainer/Density
@onready var summary: RichTextLabel = $MarginContainer/VBoxContainer/Summary
@onready var compund_container: VBoxContainer = $MarginContainer/VBoxContainer/CompundContainer
@onready var game: Node2D = $"../../../../../.."


signal block_selected(tile_name)

var hovered_block : String = ""
var last_tile_name := ""

signal bind_key(block_name, key)

func _input(event):

	if hovered_block == "":
		return

	if event is InputEventKey and event.pressed:

		if event.keycode >= KEY_1 and event.keycode <= KEY_8:
			
			last_tile_name = hovered_block
			emit_signal("bind_key", hovered_block, event.keycode)

func _on_block_pressed(tile_name):
	emit_signal("block_selected", tile_name)

func show_element(data, discovered, counts, unlocked_blocks, blocks, last_key := -1):
	
	for child in compund_container.get_children():
		child.queue_free()

	if !discovered:

		title.text = "???" + " (" + data["symbol"] + ")"
		count.text = "Antal: 0"
		
		number.text = "Atomnummer: ???"
		mass.text = "Atommassa: ???"
		category.text = "Kategori: ???"
		melting.text = "Smältpunkt: ???"
		boiling.text = "Kokpunkt: ???"
		density.text = "Densitet: ???"
		summary.text = "?????"

		return


	title.text = data["namn"] + " (" + data["symbol"] + ")"
	count.text = "Antal: " + str(counts)
	
	number.text = "Atomnummer: " + data["atomnummer"]
	mass.text = "Atommassa: " + data["atommassa"]
	category.text = "Kategori: " + data["kategori"]
	melting.text = "Smältpunkt: " + data["smältpunkt_K"] + " K"
	boiling.text = "Kokpunkt: " + data["kokpunkt_K"] + " K"
	density.text = "Densitet: " + data["densitet_kg_m3"] + " kg/m³"
	summary.text = data["sammanfattning"]
	
	for tile_name in unlocked_blocks:

		var block = blocks[tile_name]

		# Only show if this element is part of the block
		if !block.elements.has(data["symbol"]):
			continue

		var btn = LinkButton.new()
		var key_text = get_bound_key_text(tile_name)
		if !last_key == -1 and last_tile_name == tile_name:
			key_text = str(last_key - KEY_0)

		btn.text = tile_name.capitalize() + " [" + key_text + "]"

		btn.mouse_entered.connect(_on_button_hover.bind(tile_name))
		btn.mouse_exited.connect(_on_button_exit)

		compund_container.add_child(btn)

func get_bound_key_text(tile_name):

	for key in game.keybinds:

		if game.keybinds[key] == tile_name:
			return str(key - KEY_0)

	return "-"

func _on_button_hover(tile_name):
	hovered_block = tile_name

func _on_button_exit():
	hovered_block = ""
