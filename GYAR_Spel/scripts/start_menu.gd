extends Node2D

@onready var anim: AnimationPlayer = $AnimationPlayer



func _on_start_pressed() -> void:
	anim.play("dissolve")
	await anim.animation_finished
	get_tree().change_scene_to_file("res://scenes/rooms/transition.tscn")



func _on_quit_pressed() -> void:
	get_tree().quit()
