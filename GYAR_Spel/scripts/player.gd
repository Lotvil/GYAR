extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -1250.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var periodic_table: Control = $Camera2D/PeriodicTable
@onready var laser_beam_2d: RayCast2D = $ClawLaser/LaserBeam2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


@export var ps_is_open = false
var ps_is_open2 = false
var playing_speed := 1.5

func _process(_delta):
	if Input.is_action_just_pressed("inventory"):
		if animation_player.is_playing():
			if animation_player.get_playing_speed() == playing_speed:
				animation_player.speed_scale = -1*playing_speed
				ps_is_open2 = false
			else:
				animation_player.speed_scale = playing_speed
				ps_is_open2 = true
		else:
			if ps_is_open2:
				animation_player.play("ps_open", -1.0, 1.0, true)
				animation_player.speed_scale = -1*playing_speed
				ps_is_open2 = false
			else:
				animation_player.play("ps_open")
				animation_player.speed_scale = playing_speed
				ps_is_open2 = true


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 2
			
	var direction = 0
	
	if !ps_is_open:
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction -1, 0, 1
		direction = Input.get_axis("moveLeft", "moveRight")
		
		# Flip sprite
		if direction > 0:
			animated_sprite.flip_h = false
		elif direction < 0:
			animated_sprite.flip_h = true
		
		# Play animations
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("move")
		else:
			animated_sprite.play("jump")
	
	
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func _ready() -> void:
	add_to_group("player")
