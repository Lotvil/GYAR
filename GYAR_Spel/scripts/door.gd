extends Area2D

@onready var player: CharacterBody2D = $"../Player"
@onready var camera_2d: Camera2D = $"../Player/Camera2D"

var enterSide:String

func _on_stop_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var pos = camera_2d.global_position
		print("touch")
		camera_2d.top_level = true
		camera_2d.global_position = pos



func _on_stop_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("exit")
		camera_2d.top_level = false
		camera_2d.global_position = player.global_position




func _on_door_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if player.global_position > global_position:
			print("entered from right")
			enterSide = "right"
		else:
			print("entered from left")
			enterSide = "left"




func _on_door_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		if enterSide == "left":
			camera_2d.global_position.x = $markerRight.global_position.x
			
			
		if enterSide == "right":
			camera_2d.global_position.x = $markerLeft.global_position.x
