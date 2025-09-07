extends Node
class_name Attack

var damage: float
var attacker: Node3D

func _init(damage: float = 25.0, attacker: Node3D = null) -> void:
	self.damage = damage
	self.attacker = attacker
