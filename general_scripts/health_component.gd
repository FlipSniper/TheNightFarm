extends Node

var MaxHealth: float
@export var player: bool = false
@export var enemy_level: int = 0

var health: float

func _ready() -> void:
	if player:
		MaxHealth = 100
	elif enemy_level == 1:
		MaxHealth = 50
	else:
		MaxHealth = 25  # fallback so it's never null
	health = MaxHealth

func damage(attack: Attack) -> void:
	health -= attack.damage
	var parent: Node3D = get_parent()
	if parent.has_method("on_damage"):
		parent.on_damage(attack)
	if health <= 0:
		if parent.has_method("on_death"):
			parent.on_death()
