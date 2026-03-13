extends Node2D
 
@export var block : Dictionary[String, BlockData]
@onready var ground: TileMapLayer = $Node/Room
@onready var laser: RayCast2D = $Player/ClawLaser/LaserBeam2D



var broken_tiles_health : Dictionary = {}
var current_block = "soil"
 
var inventory = {
	"soil" : 0,
	"mud" : 0,
	"stone" : 0
}

func _ready():
	laser.hit_tile.connect(_on_laser_hit_tile)

func _on_laser_hit_tile(tile_pos: Vector2i, damage: float):

	print(ground.get_cell_atlas_coords(tile_pos))
	var data = ground.get_cell_tile_data(tile_pos)
	var tile_name
	if data:
		tile_name = data.get_custom_data("tile_name")
		take_damage(tile_name, tile_pos, damage)
 
		print(tile_name)
		print(block[tile_name].health)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var tile_pos = get_snapped_position(get_global_mouse_position())
 
		if is_placable(event):
			ground.set_cell(tile_pos, block[current_block].source_id, block[current_block].atlas_coords[0])
			inventory[current_block] -= 1
 
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
		inventory[tile_name] += 1
		return

	var stage_count = block[tile_name].atlas_coords.size()

	var stage = int((1.0 - current_health / max_health) * stage_count)
	stage = clamp(stage, 0, stage_count - 1)

	var atlas = block[tile_name].atlas_coords[stage]

	ground.set_cell(tile_pos, block[tile_name].source_id, atlas)

func switch_block(event):
	if event.keycode == KEY_1 and event.pressed:
		current_block = "soil"
	if event.keycode == KEY_2 and event.pressed:
		current_block = "mud"
	if event.keycode == KEY_3 and event.pressed:
		current_block = "stone"
 
func is_placable(event) -> bool:
	return event.button_index == MOUSE_BUTTON_RIGHT and inventory[current_block] > 0
