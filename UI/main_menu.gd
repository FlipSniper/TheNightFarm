extends Node

func _ready() -> void:
	$Main_Menu/fade.visible = false

func play() -> void:
	print("ye mint")
	$Main_Menu/fade.visible = true
	$Main_Menu/AnimationPlayer.play("fade")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/story.tscn")


func _on_button_mouse_entered() -> void:
	print("ye mint")
