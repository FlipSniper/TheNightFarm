extends Node3D

var swinging = false

@onready var player_health = get_tree().current_scene.get_node("Player/HealthComponent")
@onready var anim = $AnimationPlayer

func enemy_attack():
	anim.play("swing")

func _process(delta: float) -> void:
	swinging = anim.current_animation == "swing"

func damage_taken(body):
	if swinging and body.name == "Player":
		var attack = Attack.new(10.0, self)
		player_health.damage(attack)
