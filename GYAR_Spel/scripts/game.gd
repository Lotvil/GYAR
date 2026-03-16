extends Node2D
 
@export var block : Dictionary[String, BlockData]
@onready var ground: TileMapLayer = $Node/Room
@onready var laser: RayCast2D = $Player/ClawLaser/LaserBeam2D
@onready var periodic_table: Control = $Player/PeriodicTable



var broken_tiles_health : Dictionary = {}
var current_block = "soil"

func _ready():
	laser.hit_tile.connect(_on_laser_hit_tile)

func _on_laser_hit_tile(tile_pos: Vector2i, damage: float):

	var data = ground.get_cell_tile_data(tile_pos)
	var tile_name
	if data:
		tile_name = data.get_custom_data("tile_name")
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
	if tile_name == "soil":
		periodic_table.add_element("Si", mod * 1)
		periodic_table.add_element("O", mod * 5)
		periodic_table.add_element("Fe", mod * 2)
	if tile_name == "stone":
		periodic_table.add_element("Si", mod * 1)
		periodic_table.add_element("Al", mod * 2)
		periodic_table.add_element("Fe", mod * 2)
	if tile_name == "wood":
		periodic_table.add_element("C", mod * 6)
		periodic_table.add_element("H", mod * 12)
		periodic_table.add_element("O", mod * 6)
	

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
	if event.keycode == KEY_1 and event.pressed:
		current_block = "soil"
	if event.keycode == KEY_2 and event.pressed:
		current_block = "mud"
	if event.keycode == KEY_3 and event.pressed:
		current_block = "stone"
	if event.keycode == KEY_4 and event.pressed:
		current_block = "wood"

func is_placable(event, tile_pos) -> bool:
	if event.button_index != MOUSE_BUTTON_RIGHT:
		return false
	
	if ground.get_cell_source_id(tile_pos) != -1:
		return false

	if !has_adjacent_tile(tile_pos):
		return false
		
	if current_block == "soil":
		if periodic_table.check_element("Si", 1) and periodic_table.check_element("O", 5) and periodic_table.check_element("Fe", 2):
			return true
	if current_block == "stone":
		if periodic_table.check_element("Si", 1) and periodic_table.check_element("Al", 2) and periodic_table.check_element("Fe", 2):
			return true
	if current_block == "wood":
		if periodic_table.check_element("C", 6) and periodic_table.check_element("H", 12) and periodic_table.check_element("O", 6):
			return true
	
	return false
