@tool
extends RayCast2D

## Speed at which the laser extends when first fired, in pixels per seconds.
@export var cast_speed := 8000.0
## Maximum length of the laser in pixels.
@export var max_length := 1400.0
## Distance in pixels from the origin to start drawing and firing the laser.
@export var start_distance := 90.0
## Base duration of the tween animation in seconds.
@export var growth_time := 0.1
@export var color := Color.WHITE: set = set_color

@export var damage_per_second: float = 3.0

@export var is_casting := false: set = set_is_casting

@export var ps_is_open := false

var tween: Tween = null
var finished_appearing := false

@onready var line_2d: Line2D = %Line2D
@onready var casting_particles: GPUParticles2D = %CastingParticles2D
@onready var collision_particles: GPUParticles2D = %CollisionParticles2D
@onready var beam_particles: GPUParticles2D = %BeamParticles2D
@onready var end_particles: GPUParticles2D = %EndParticles2D

@onready var line_width := line_2d.width

@onready var ground: TileMapLayer = $"../../../room/ground"

signal hit_tile(tile_pos: Vector2i, damage: float)

func _ready() -> void:
	set_color(color)
	set_is_casting(is_casting)
	line_2d.points[0] = Vector2.RIGHT * start_distance
	line_2d.points[1] = Vector2.ZERO
	line_2d.visible = false
	casting_particles.position = line_2d.points[0]

	if not Engine.is_editor_hint():
		set_physics_process(false)

func _process(_delta) -> void:
	collide_with_bodies = !ps_is_open
	if ps_is_open:
		cast_speed = 40000.0
		max_length = 2000.0
		modulate = Color.AQUA
	else:
		cast_speed = 8000.0
		max_length = 1400.0
		modulate = Color.GREEN

func _physics_process(delta: float) -> void:
	var mouse_pos : Vector2 = to_local(get_global_mouse_position())
	var dir : Vector2 = mouse_pos.normalized()
	var dist : float = min(mouse_pos.length(), max_length)

	var desired_target : Vector2 = dir * dist
	target_position = target_position.move_toward(desired_target, cast_speed * delta)

	var laser_end_position := target_position
	force_raycast_update()

	if is_colliding():
		if ground == null:
			return
		
		laser_end_position = to_local(get_collision_point())
		
		var collision_point = get_collision_point()
		var normal = get_collision_normal()

		var corrected_point = collision_point - normal * 2.0

		var tile_pos = ground.local_to_map(
			ground.to_local(corrected_point)
		)
		
		var damage = damage_per_second * delta

		emit_signal("hit_tile", tile_pos, damage)
		
		collision_particles.global_rotation = get_collision_normal().angle()
		collision_particles.position = laser_end_position

	line_2d.points[1] = laser_end_position

	var laser_start_position := line_2d.points[0]
	beam_particles.position = laser_start_position + (laser_end_position - laser_start_position) * 0.5
	beam_particles.process_material.emission_box_extents.x = laser_end_position.distance_to(laser_start_position) * 0.5

	collision_particles.emitting = is_colliding()
	if end_particles:
		end_particles.position = line_2d.points[1]
		end_particles.emitting = finished_appearing and not is_colliding()


func set_is_casting(new_value: bool) -> void:
	if is_casting == new_value:
		return
	is_casting = new_value
	set_physics_process(is_casting)

	if beam_particles == null:
		return

	beam_particles.emitting = is_casting
	casting_particles.emitting = is_casting
	

	if is_casting:
		var laser_start := Vector2.RIGHT * start_distance
		line_2d.points[0] = laser_start
		line_2d.points[1] = laser_start
		casting_particles.position = laser_start

		appear()
	else:
		target_position = Vector2.ZERO
		collision_particles.emitting = false
		end_particles.emitting = false
		disappear()


func appear() -> void:
	line_2d.visible = true
	finished_appearing = false
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(line_2d, "width", line_width, growth_time * 2.0).from(0.0)
	tween.tween_callback(func(): finished_appearing = true)


func disappear() -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(line_2d, "width", 0.0, growth_time).from_current()
	tween.tween_callback(line_2d.hide)


func set_color(new_color: Color) -> void:
	color = new_color

	if line_2d == null:
		return

	line_2d.modulate = new_color
	casting_particles.modulate = new_color
	collision_particles.modulate = new_color
	beam_particles.modulate = new_color
