extends Node2D

func _ready() -> void:
	ResourceLoader.load_threaded_request("res://scenes/game.tscn")
	
	$AudioStreamPlayer2D.play()
	
	await wait_for_loading_and_audio()
	
	var packed_scene = ResourceLoader.load_threaded_get("res://scenes/game.tscn")
	get_tree().change_scene_to_packed(packed_scene)

func wait_for_loading_and_audio():
	while true:
		var status = ResourceLoader.load_threaded_get_status("res://scenes/game.tscn")
		
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			break
		
		await get_tree().process_frame
	
	await $AudioStreamPlayer2D.finished
