extends CharacterBody3D

@export var WalkSpeed : float = 1.5
@export var RunSpeed : float = 3.0
@export var ChaseDistance : float = 8.0
@onready var world = get_tree().current_scene

@onready var navigation_agent : NavigationAgent3D = $NavigationAgent3D
@onready var player = get_tree().current_scene.get_node("Player")
@onready var ray = $RayCast3D

@export var drops : Array[PackedScene]

var direction: Vector3 = Vector3.ZERO
var please = false

func _physics_process(delta: float) -> void:
	if !(world.currentTime < 7.0 or world.currentTime > 18.0):
		on_despawn()
	
	var obj = ray.get_collider()
	var delay = randi_range(0,200)
	if delay > 197:
		please = true
	if obj:
		if obj.name == "Player" and please:
			$Sword.enemy_attack()
			please = false

	if player:
		navigation_agent.target_position = player.global_position

	if not navigation_agent.is_navigation_finished():
		var next_pos = navigation_agent.get_next_path_position()
		direction = (next_pos - global_position).normalized()
	else:
		direction = Vector3.ZERO

	velocity = direction * RunSpeed
	move_and_slide()

	if direction.length() > 0.01:
		var target = global_position + Vector3(direction.x, 0, direction.z)
		var new_basis = global_transform.looking_at(target, Vector3.UP).basis
		global_transform.basis = global_transform.basis.slerp(new_basis, delta * 5.0)

func on_death() -> void:
	var pos = global_position

	var drop : Node3D
	var drop1 : Node3D
	if randi_range(1,100) > 94:
		drop = drops[1].instantiate()
		drop1 = drops[2].instantiate()
	else:
		drop = drops[0].instantiate()
		drop1 = drops[2].instantiate()

	get_tree().current_scene.add_child(drop)
	drop.global_position = pos
	get_tree().current_scene.add_child(drop1)
	drop1.global_position = pos

	queue_free()

func on_despawn() -> void:
	queue_free()
