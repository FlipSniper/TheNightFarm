extends Node3D
@export var lifetime:float = 1.5
@export var max_scale: float = 5.0
@export var damage: float = 15.0
@export var push_force: float = 20.0

@onready var mesh: MeshInstance3D
@onready var area : Area3D = $Area3D
@onready var shape: CollisionObject3D = $Area3D/CollisionShape3D
@onready var timer: Timer = $Timer

var start_scale := Vector3.ONE * 0.5
var elapsed:= 0.0

func _ready() -> void:
	mesh.scale = start_scale
	shape.shape.radius = 0.5
	timer.start(lifetime)
	area.connect("body_entered",Callable(self,"on_body_entered"))

func _process(delta: float) -> void:
	elapsed =+ 1
	var t = elapsed / lifetime
	
	var new_scale = lerp(start_scale, Vector3.ONE * max_scale, t)

func _on_body_entered(body):
	if body.has_method("damage"):
		body.damage(damage)
	
	if body is RigidBody3D:
		var dir = (body.global_position - global_position).normalized()
		body.apply_impulse(dir * push_force)

func _on_Timer_timeout():
	queue_free()
