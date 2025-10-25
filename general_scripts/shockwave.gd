extends Node3D

@export var lifetime: float = 1.5
@export var max_scale: float = 20.0
@export var damage: float = 15.0
@export var push_force: float = 20.0

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var area: Area3D = $MeshInstance3D/Area3D
@onready var shape: CollisionShape3D = $MeshInstance3D/Area3D/CollisionShape3D
@onready var timer: Timer = $Timer
@onready var player_health: Node = get_tree().current_scene.get_node("Player/HealthComponent")

var start_scale := Vector3.ONE * 0.5
var elapsed := 0.0
var already_hit_players := []

# store original mesh and collision sizes
var base_mesh_scale := Vector3.ONE
var base_radius := 0.5

func _ready() -> void:
	mesh.scale = start_scale
	base_mesh_scale = mesh.scale

	if shape.shape is SphereShape3D:
		base_radius = shape.shape.radius

	timer.start(lifetime)
	area.connect("body_entered", Callable(self, "_on_body_entered"))
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))

func _process(delta: float) -> void:
	elapsed += delta
	var t = clamp(elapsed / lifetime, 0.0, 1.0)

	var target_scale = lerp(start_scale, Vector3.ONE * max_scale, t)
	mesh.scale = target_scale

	"""if shape.shape is SphereShape3D:
		shape.shape.radius = base_radius * target_scale.x / base_mesh_scale.x
	elif shape.shape is BoxShape3D:
		shape.shape.extents = target_scale"""

func _on_body_entered(body):
	if body.name == "Player" and body not in already_hit_players:
		damage_taken(body)
		already_hit_players.append(body)

func damage_taken(body):
	var attack = Attack.new(damage, self)
	player_health.damage(attack)

	if body is RigidBody3D:
		var dir = (body.global_position - global_position).normalized()
		body.apply_impulse(dir * push_force)

func _on_Timer_timeout():
	queue_free()
