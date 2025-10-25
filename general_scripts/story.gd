extends Node

func _ready() -> void:
	$Story/fade.visible = true
	$Story/AnimationPlayer.play("fade")
	await get_tree().create_timer(2).timeout
	$Story/Label8.visible = false
	$Story/Label.visible = true

func label1():
	$Story/Label.visible = true

func label2():
	$Story/Label.visible = false
	$Story/Label2.visible = true
