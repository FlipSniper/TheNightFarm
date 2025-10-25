extends Node

var label = 0
var prev_label = 0
var skippable = false
@onready var particle = $props/CPUParticles3D
@onready var sounds_node = $Sounds

func _ready() -> void:
	$Story/fade.visible = true
	$Story/AnimationPlayer.play("fade")
	await get_tree().create_timer(2).timeout
	$Story/fade.visible = false
	skippable = true
	play_sound("calm_wind")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click") and !$Story/AnimationPlayer.is_playing() and skippable:
		label += 1
	if prev_label != label:
		prev_label = label
		$Story/fade.visible = true
		$Story/AnimationPlayer.play("fade")
		await get_tree().create_timer(2).timeout
		$Story/fade.visible = false
		match label:
			1: label1()
			2: label2()
			3: label3()
			4: label4()
			5: label5()
			6: label6()
			7: label7()
			8: label8()
			9: label9()

func fade():
	$Story/fade.visible = true
	$Story/AnimationPlayer.play("fade")
	await get_tree().create_timer(2).timeout
	$Story/fade.visible = false

func play_sound(name: String) -> void:
	if not sounds_node:
		return
	if not sounds_node.has_node(name):
		return
	var snd = sounds_node.get_node(name)
	if not (snd is AudioStreamPlayer or snd is AudioStreamPlayer3D):
		return
	if snd.stream == null:
		return
	snd.play()

func label1():
	skippable = false
	$Story/Label.visible = true
	play_sound("Narrator1")
	await get_tree().create_timer(5).timeout
	skippable = true

func label2():
	$Story/Label.visible = false
	skippable = false
	$Story/Label2.visible = true
	play_sound("Eli1")
	await get_tree().create_timer(6.3).timeout
	skippable = true
	play_sound("rage_wind")
	particle.amount = 500.0

func label3():
	$Sounds/rage_wind.volume_db = -13.0
	$Story/Label2.visible = false
	skippable = false
	$Story/Label3.visible = true
	play_sound("Eli2")
	await get_tree().create_timer(5).timeout
	skippable = true

func label4():
	play_sound("rage_wind")
	$Story/Label3.visible = false
	skippable = false
	$Story/Label4.visible = true
	play_sound("Narrator2")
	await get_tree().create_timer(5).timeout
	$spawns.spawn()
	play_sound("grr")
	skippable = true

func label5():
	$Story/Label4.visible = false
	skippable = false
	$Story/Label5.visible = true
	play_sound("Eli3")
	await get_tree().create_timer(5).timeout
	skippable = true

func label6():
	$Story/Label5.visible = false
	skippable = false
	$Story/Label6.visible = true
	play_sound("Eli4")
	await get_tree().create_timer(6.3).timeout
	skippable = true

func label7():
	$Story/Label6.visible = false
	skippable = false
	$Story/Label7.visible = true
	play_sound("Eli5")
	await get_tree().create_timer(5).timeout
	skippable = true

func label8():
	$Story/AnimationPlayer.play("circle")
	$Story/Label7.visible = false
	skippable = false
	$Story/Label8.visible = true
	play_sound("Narrator3")
	await get_tree().create_timer(5).timeout
	skippable = true

func label9():
	fade()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/world.tscn")
