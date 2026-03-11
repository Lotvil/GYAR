extends Node2D

@export var block: Dictionary[String, BlockData]
@onready var ground: TileMapLayer = $Ground



func get_snapped_position(global_pos: Vector2) -> Vector2i:
	var local_pos = ground.to_local(global_pos)
	var tile_pos = ground.local_to_map(local_pos)
	return tile_pos
