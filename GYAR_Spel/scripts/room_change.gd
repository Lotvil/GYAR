extends Area2D

#Håller filvägen till rummet vi ska in i
@export var ConnectedRoom: String

#positionen player spawnar i det nya rummet
@export var PlayerPos: Vector2

#Om vi vill lägga till ett hopp när man går in i det nya rummet
@export var PlayerJumpOnEnter: bool = false

func _on_body_entered(body: Node2D) -> void:
	#dubbelkollar så det som går in i dörren är spelaren
	if body.is_in_group("player"):
		RoomChangeGlobal.Activate = true
		RoomChangeGlobal.PlayerPos = PlayerPos
		RoomChangeGlobal.PlayerJumpOnEnter = PlayerJumpOnEnter
		
		get_tree().call_deferred("change_scene_to_file", ConnectedRoom)
		
