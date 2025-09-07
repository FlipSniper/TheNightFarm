extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var inventory = $Inventory
@onready var ui = $CanvasLayer
@onready var interacter = $Camera3D/Interacter
@onready var health_lbl :Label = $HealthLbl
@onready var health_component :Node = $HealthComponent
var equipped = ""
var seed_equipped = ""
@onready var sword = get_tree().current_scene.get_node("Player/Camera3D/SWORD")
var equippable = ["SWORD","BROKEN_MACE"]
func _ready() -> void:
	interacter.connect("update_prompt_text", Callable(ui, "update_prompt_text"))
	interacter.connect("harvested_crop", Callable(inventory, "add_crop"))
	inventory.connect("inventory_updated", Callable(ui, "update_crop_amount"))
	sword.visible = false
	sword.usable = false
	


func _process(delta: float) -> void:
	health_lbl.text = str(health_component.health)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func equip_item(item):
	print(item)
	if equipped in equippable:
		get_tree().current_scene.get_node("Player/Camera3D/"+equipped).visible = false
		get_tree().current_scene.get_node("Player/Camera3D/"+equipped).usable = false
	equipped = item
	if equipped in equippable:
		get_tree().current_scene.get_node("Player/Camera3D/"+equipped).visible = true
		get_tree().current_scene.get_node("Player/Camera3D/"+equipped).usable = true
		seed_equipped = ""
	if "seed" in equipped.to_lower():
		print("here")
		seed_equipped = item
	

func on_death() -> void:
	get_tree().quit()
