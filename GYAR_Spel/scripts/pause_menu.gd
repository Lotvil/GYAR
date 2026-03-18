extends Control

func _ready() -> void:
	$AnimationPlayer.play("RESET")

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	
	
func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")

func _input(event):
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			resume()
		else:
			pause()

func _on_resume_pressed() -> void:
	resume()


func _on_restart_pressed() -> void:
	resume()
	get_tree().reload_current_scene()


func _on_quit_pressed() -> void:
	resume()
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
