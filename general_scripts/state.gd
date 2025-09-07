extends Node
class_name State
signal Transitioned(state: State, new_state_name: String)

func enter():
	pass

func exit():
	pass

func _process(delta: float) -> void:
	pass
