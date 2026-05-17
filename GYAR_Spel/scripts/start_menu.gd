extends Node2D

@onready var anim: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	await get_tree().create_timer(10).timeout
	$secret.visible = true
	await get_tree().create_timer(1).timeout
	$secret.visible = false
	


func _on_start_pressed() -> void:
	anim.play("dissolve")
	await anim.animation_finished
	get_tree().change_scene_to_file("res://scenes/rooms/transition.tscn")



func _on_quit_pressed() -> void:
	get_tree().quit()
