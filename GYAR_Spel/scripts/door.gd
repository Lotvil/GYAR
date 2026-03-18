extends Node2D

var enterSide :String
var x_lock :bool

var touchLeft: bool
var touchRight: bool

@onready var player: CharacterBody2D = $"../../Player"
@onready var camera_2d: Camera2D = $"../../Player/Camera2D"



func _on_stop_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("touchLeft")
		touchLeft = true


func _on_stop_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("exitLeft")
		touchLeft = false
		


func _on_door_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("touchRight")
		touchRight = true


func _on_door_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("exitRight")
		touchRight = false


func _process(_delta: float) -> void:
	if touchRight or touchLeft:
		camera_2d.top_level = true
		camera_2d.global_position.y = player.global_position.y -324
		
	
	else:
		camera_2d.top_level = false
		camera_2d.global_position.x = player.global_position.x
		camera_2d.global_position.y = player.global_position.y -324
		
	
	if touchLeft and !touchRight:
		camera_2d.global_position.x = $markerLeft.global_position.x
	if touchRight and !touchLeft:
		camera_2d.global_position.x = $markerRight.global_position.x
