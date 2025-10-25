extends Node
var label = 0
var prev_label = 0
var skippable = false

func _ready() -> void:
	$Story/fade.visible = true
	$Story/AnimationPlayer.play("fade")
	await get_tree().create_timer(2).timeout
	$Story/fade.visible = false
	skippable = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click") and !$Story/AnimationPlayer.is_playing() and skippable:
		label+=1
	if prev_label != label:
		prev_label = label
		if label == 1:
			label1()
		if label == 2:
			label2()
		if label == 3:
			label3()

func label1():
	skippable = false
	$Story/Label.visible = true
	$Narrator1.play()
	await get_tree().create_timer(5).timeout
	skippable = true

func label2():
	$Story/Label.visible = false
	skippable = false
	$Story/Label2.visible = true
	$Eli1.play()
	await get_tree().create_timer(8).timeout
	skippable = true
func label3():
	$Story/Label2.visible = false
	skippable = false
	$Story/Label3.visible = true
	$Eli2.play()
	await get_tree().create_timer(5).timeout
	skippable = true
