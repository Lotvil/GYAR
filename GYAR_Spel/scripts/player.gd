extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -1250.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var periodic_table: Control = $Camera2D/PeriodicTable
@onready var laser_beam_2d: RayCast2D = $ClawLaser/LaserBeam2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var claw_laser: AnimatedSprite2D = $ClawLaser


@export var ps_is_open = false
var ps_is_open2 = false
var playing_speed := 1.5
var hit_floor = false

@export var flip = false

func _process(_delta):
	if ps_is_open:
		laser_beam_2d.z_index = 5
		claw_laser.z_index = 5
	else:
		if flip:
			laser_beam_2d.z_index = 1
			claw_laser.z_index = 1
		else:
			laser_beam_2d.z_index = 5
			claw_laser.z_index = 5
	
	if Input.is_action_just_pressed("inventory"):
		var pos = animation_player.current_animation_position
		if animation_player.get_current_animation() == "ps_open":
			animation_player.play_section("ps_close", 0, pos, -1, 1, true)
			animation_player.speed_scale = -1*playing_speed
			ps_is_open2 = false
		elif animation_player.get_current_animation() == "ps_close":
			animation_player.play_section("ps_open", pos, 1, -1, 1, false)
			animation_player.speed_scale = playing_speed
			ps_is_open2 = true
		else:
			if ps_is_open2:
				animation_player.play("ps_close", -1.0, 1.0, true)
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
			flip = true
		elif direction < 0:
			animated_sprite.flip_h = true
			flip = false
		
		
		# Play animations
		animation_player.speed_scale = 1
		if is_on_floor():
			if hit_floor:
				$Walk.playing = true
				hit_floor = false
			
			if direction == 0:
				if flip:
					animation_player.play("idle_r")
				else:
					animation_player.play("idle_l")
			else:
				if flip:
					animation_player.play("walk_r")
				else:
					animation_player.play("walk_l")
		else:
			if !hit_floor:
				$Walk.playing = true
				hit_floor = true
			if flip:
				animation_player.play("jump_r")
			else:
				animation_player.play("jump_l")
			
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func _ready() -> void:
	add_to_group("player")
