extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var inventory = $Inventory
@onready var ui = $CanvasLayer
@onready var interacter = $Camera3D/Interacter
@onready var health_lbl : Label = $HealthLbl
@onready var health_component : Node = $HealthComponent
@onready var sword = get_tree().current_scene.get_node("Player/Camera3D/SWORD")

@export var FIREBALL : PackedScene

var equipped = ""
var travel = false
var seed_equipped = ""
var spell_equipped = ""
var equippable = ["SWORD","BROKEN_MACE"]
var spells = ["FIREBALL"]

var active_fireball: Node3D = null
var fireball_ready: bool = true
var charging: bool = false
var travelled = 0
var fire

func _ready() -> void:
	interacter.connect("update_prompt_text", Callable(ui, "update_prompt_text"))
	interacter.connect("harvested_crop", Callable(inventory, "add_crop"))
	inventory.connect("inventory_updated", Callable(ui, "update_crop_amount"))
	sword.visible = false
	sword.usable = false

func _process(delta: float) -> void:
	health_lbl.text = str(health_component.health)
	if Input.is_action_just_pressed("attack") and spell_equipped == "FIREBALL":
		if fireball_ready and !charging:
			start_fireball()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

	if travel and travelled < 10:
		fire.global_position += -global_transform.basis.z
		travelled += 1
	elif travelled >= 10 and fire:
		travel = false
		travelled = 0
		fire.on_death()

func equip_item(item):
	if equipped in equippable:
		get_tree().current_scene.get_node("Player/Camera3D/"+equipped).visible = false
		get_tree().current_scene.get_node("Player/Camera3D/"+equipped).usable = false
	equipped = item
	if equipped in equippable:
		get_tree().current_scene.get_node("Player/Camera3D/"+equipped).visible = true
		get_tree().current_scene.get_node("Player/Camera3D/"+equipped).usable = true
		seed_equipped = ""
		spell_equipped = ""
	if "seed" in equipped.to_lower():
		seed_equipped = item
	if equipped in spells:
		spell_equipped = equipped

func start_fireball() -> void:
	fireball_ready = false
	charging = true
	await get_tree().create_timer(.1).timeout  # charge time
	shoot_fireball()
	charging = false

	# reload cooldown
	await get_tree().create_timer(.4).timeout
	fireball_ready = true

func shoot_fireball() -> void:
	if active_fireball and is_instance_valid(active_fireball):
		active_fireball.queue_free()

	active_fireball = FIREBALL.instantiate()
	active_fireball.hit = false
	active_fireball.global_position = global_transform.origin + -global_transform.basis.z * 2
	active_fireball.direction = -global_transform.basis.z.normalized()
	get_tree().current_scene.add_child(active_fireball)

func on_death() -> void:
	get_tree().quit()
