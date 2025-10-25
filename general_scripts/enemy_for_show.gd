extends CharacterBody3D

@export var walk_speed: float = 1.5
@export var wander_radius: float = 4.0  # how far it can move around from its start point
@export var change_dir_time: float = 2.5  # how often it picks a new direction

var start_pos: Vector3
var wander_direction: Vector3 = Vector3.ZERO
var timer: float = 0.0


func _ready() -> void:
	start_pos = global_position
	_pick_new_direction()

func _physics_process(delta: float) -> void:
	timer -= delta
	if timer <= 0.0:
		_pick_new_direction()

	# Move enemy gently in the wander direction
	velocity = wander_direction * walk_speed
	move_and_slide()

	# Smooth turning toward direction
	if wander_direction.length() > 0.01:
		var target = global_position + wander_direction
		var new_basis = global_transform.looking_at(target, Vector3.UP).basis
		global_transform.basis = global_transform.basis.slerp(new_basis, delta * 5.0)

	# Stay near the start position
	var offset = global_position - start_pos
	if offset.length() > wander_radius:
		# Turn back toward start area
		wander_direction = (-offset).normalized()

func _pick_new_direction() -> void:
	wander_direction = Vector3(randf_range(-1.0, 1.0), 0.0, randf_range(-1.0, 1.0)).normalized()
	timer = randf_range(change_dir_time * 0.5, change_dir_time * 1.5)
