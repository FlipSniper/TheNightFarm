extends Node3D

@export var damage: float = 25
@export var speed: float = 20.0
@export var lifetime: float = 1.0

var hit: bool = false
var direction: Vector3 = Vector3.ZERO

func _ready() -> void:
	await get_tree().create_timer(lifetime).timeout
	on_death()

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func damage_taken(body: Node3D) -> void:
	if body.is_in_group("enemy") and !hit:
		hit = true
		var attack = Attack.new(damage, self)
		var health_component: Node = body.get_node_or_null("HealthComponent")
		if health_component:
			health_component.damage(attack)
		on_death()

func on_death() -> void:
	queue_free()
