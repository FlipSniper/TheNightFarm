extends Node
var label = 0
var prev_label = 0
var skippable = false
@onready var particle = $props/CPUParticles3D
func _ready() -> void:
	$Story/fade.visible = true
	$Story/AnimationPlayer.play("fade")
	await get_tree().create_timer(2).timeout
	$Story/fade.visible = false
	skippable = true
	$Sounds/calm_wind.play()

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
		if label == 4:
			label4()

func label1():
	skippable = false
	$Story/Label.visible = true
	$Sounds/Narrator1.play()
	await get_tree().create_timer(5).timeout
	skippable = true

func label2():
	$Story/Label.visible = false
	skippable = false
	$Story/Label2.visible = true
	$Sounds/Eli1.play()
	await get_tree().create_timer(6.3).timeout
	skippable = true
	$Sounds/rage_wind.play()
	particle.amount = 500.0
func label3():
	$Story/Label2.visible = false
	skippable = false
	$Story/Label3.visible = true
	$Sounds/Eli2.play()
	await get_tree().create_timer(5).timeout
	skippable = true
func label4():
	$Sounds/rage_wind.volume_db = -13.0
	$Story/Label3.visible = false
	skippable = false
	$Story/Label4.visible = true
	$Sounds/Narrator2.play()
	await get_tree().create_timer(5).timeout
	$spawns.spawn()
	$Sounds/grr.play()
	skippable = true
