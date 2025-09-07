extends Node3D

@onready var anim: AnimationPlayer = $AnimationPlayer
@export var damage: float = 25.0

var swinging: bool = false
var swing: bool = true
var usable: bool = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack") and swing and usable:
		anim.play("swing")
	swinging = anim.current_animation == "swing"

func damage_taken(body: Node3D) -> void:
	if swinging and body.is_in_group("enemy") and usable:
		var attack = Attack.new(damage, self)
		var health_component: Node = body.get_node_or_null("HealthComponent")
		if health_component:
			health_component.damage(attack)
