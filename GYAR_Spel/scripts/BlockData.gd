extends Resource
class_name BlockData

@export var tile_name: String = "default_block"
@export var health: int = 3
@export var atlas_coords: Array[Vector2i] = []
@export var source_id: int = 0
@export var elements: Dictionary[String, int] = {}
@export var is_placable: bool = false
@export var laser_lvl: int = 1
