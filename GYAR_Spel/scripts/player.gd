extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -1250.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var periodic_table: Control = $Camera2D/PeriodicTable
@onready var laser_beam_2d: RayCast2D = $ClawLaser/LaserBeam2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


@export var ps_is_open = false

func _process(_delta):
	if Input.is_action_just_pressed("inventory"):
		if ps_is_open:
			animated_sprite.play_backwards("turn")
			animation_player.play_backwards("ps_open")
			ps_is_open = false
			periodic_table.close()
			laser_beam_2d.ps_is_open = false
		else:
			ps_is_open = true
			periodic_table.open()
			laser_beam_2d.ps_is_open = true
			animated_sprite.play("turn")
			animation_player.play("ps_open")
	
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
