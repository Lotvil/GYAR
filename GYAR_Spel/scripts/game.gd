extends Node2D
 
@onready var ground: TileMapLayer = $room/ground
@onready var laser: RayCast2D = $Player/ClawLaser/LaserBeam2D
@onready var periodic_table: Control = $Player/Camera2D/PeriodicTable

@export var block : Dictionary[String, BlockData]

var broken_tiles_health : Dictionary = {}
var current_block = ""
var keybinds : Dictionary = {}  # int -> block_name

func _ready():
	periodic_table.blocks = block
	laser.hit_tile.connect(_on_laser_hit_tile)
	periodic_table.sidebar.block_selected.connect(_on_block_selected)
	periodic_table.sidebar.bind_key.connect(_on_bind_key)

func _on_laser_hit_tile(tile_pos: Vector2i, damage: float):

	var data = ground.get_cell_tile_data(tile_pos)
	var tile_name
	if data:
		tile_name = data.get_custom_data("tile_name")
		if !tile_name == "":
			take_damage(tile_name, tile_pos, damage)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var tile_pos = get_snapped_position(get_global_mouse_position())
 
		if is_placable(event, tile_pos):
			ground.set_cell(tile_pos, block[current_block].source_id, block[current_block].atlas_coords[0])
			add_elements(current_block, -1)
 
	if event is InputEventKey:
		switch_block(event)
 
func get_snapped_position(global_pos: Vector2) -> Vector2i:
	var local_pos = ground.to_local(global_pos)
	var tile_pos = ground.local_to_map(local_pos)
	return tile_pos

func take_damage(tile_name: StringName, tile_pos: Vector2i, amount: float = 1):

	if tile_pos not in broken_tiles_health:
		broken_tiles_health[tile_pos] = block[tile_name].health

	broken_tiles_health[tile_pos] -= amount

	var current_health = broken_tiles_health[tile_pos]
	var max_health = block[tile_name].health

	if current_health <= 0:
		ground.erase_cell(tile_pos)
		broken_tiles_health.erase(tile_pos)
		add_elements(tile_name)
		return

	var stage_count = block[tile_name].atlas_coords.size()

	var stage = int((1.0 - current_health / max_health) * stage_count)
	stage = clamp(stage, 0, stage_count - 1)

	var atlas = block[tile_name].atlas_coords[stage]

	var current_stage = ground.get_cell_atlas_coords(tile_pos)

	if current_stage != atlas:
		ground.set_cell(tile_pos, block[tile_name].source_id, atlas)

func add_elements(tile_name, mod : int = 1):
	for symbol in block[tile_name].elements:
		periodic_table.add_element(symbol, mod * block[tile_name].elements[symbol])
	

func has_adjacent_tile(tile_pos: Vector2i) -> bool:
	var directions = [
		Vector2i(1, 0),
		Vector2i(-1, 0),
		Vector2i(0, 1),
		Vector2i(0, -1)
	]

	for dir in directions:
		var neighbor = tile_pos + dir
		if ground.get_cell_source_id(neighbor) != -1:
			return true

	return false
 
func switch_block(event):

	if !event.pressed:
		return

	var key = event.keycode

	if key >= KEY_1 and key <= KEY_8:

		if keybinds.has(key):
			current_block = keybinds[key]

func _on_bind_key(block_name, key):

	for k in keybinds:
		if keybinds[k] == block_name:
			keybinds.erase(k)
			break
	
	keybinds[key] = block_name

func is_placable(event, tile_pos) -> bool:
	var r = true
	
	if current_block == "":
		return false
	
	if event.button_index != MOUSE_BUTTON_RIGHT:
		return false
	
	if ground.get_cell_source_id(tile_pos) != -1:
		return false

	if !has_adjacent_tile(tile_pos):
		return false
		
	for symbol in block[current_block].elements:
		if !periodic_table.check_element(symbol):
			r = false
	
	if r:
		return true
	
	return false

func _on_block_selected(block_name):
	current_block = block_name
