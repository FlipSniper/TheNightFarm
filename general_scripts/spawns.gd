extends Node3D

@export var spawns : Array[Node3D]
@export var enemy : PackedScene

func spawn():
	for i in spawns:
		var evil = enemy.instantiate()
		add_child(evil)
		evil.global_position = i.global_position
