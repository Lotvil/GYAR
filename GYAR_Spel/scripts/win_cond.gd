extends Node2D

@export var didWin: bool

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if didWin:
			get_tree().change_scene_to_file("res://scenes/win.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/lose.tscn")
