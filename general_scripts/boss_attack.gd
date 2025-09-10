extends Node3D

var swinging: bool = false
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var attack_area: Area3D =$"../attack_air/Area3D"
@onready var player_health = get_tree().current_scene.get_node("Player/HealthComponent")

func enemy_attack():
	if not swinging:
		swinging = true
		anim.play("swing")
		attack_area.visible = true
		attack_area.global_transform.origin = global_transform.origin + -global_transform.basis.z * 1.5
		attack_area.monitoring = true  # Area3D monitoring must be true to detect collisions

func _process(delta):
	if swinging and anim.current_animation != "swing":
		swinging = false
		attack_area.monitoring = false
		attack_area.visible = false

func damage_taken(body):
	if swinging and body.name == "Player":
		var attack = Attack.new(10.0, self)
		player_health.damage(attack)
