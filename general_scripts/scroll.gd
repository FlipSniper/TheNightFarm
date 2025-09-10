extends CanvasLayer

@export var scroll_speed: float = 20.0
@onready var player = get_tree().current_scene.get_node("Player")
@onready var sword = get_tree().current_scene.get_node("Player/Camera3D/SWORD")

# Dictionary for item → texture file path
var item_icons := {
	"SWORD": "res://assets/icons/sword.png",
	"SWORD_SEED": "res://assets/icons/seed.jpg",
	"HELMET": "res://assets/icons/helmet.png",
	"CHESTPLATE": "res://assets/icons/chestplate.png",
	"LEGGINGS": "res://assets/icons/leggings.png",
	"BOOTS": "res://assets/icons/boots.png"
}

# Filtered cache so UI and slot press match
var filtered_keys: Array = []
var filtered_values: Array = []

func _ready() -> void:
	visible = false
	# Connect all slots to equip function
	for i in range(1, 21):
		var slot = get_node("Panel/levels/Slot" + str(i))
		slot.connect("pressed", Callable(self, "_on_slot_pressed").bind(i))

func _physics_process(delta: float) -> void:
	# Scroll UP
	if Input.is_action_just_pressed("scrollUp") and $"Panel/levels".position.y < 280.0:
		$"Panel/levels".position.y += scroll_speed

	# Scroll DOWN
	if Input.is_action_just_pressed("scrollDown") and $"Panel/levels".position.y > -280.0:
		$"Panel/levels".position.y -= scroll_speed

	# Update inventory UI
	update_inventory_ui()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		visible = !visible
	if visible:
		sword.swing = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if !visible and !$"../Shop".visible:
		sword.swing = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# ---------------------------
# UI UPDATE
# ---------------------------
func update_inventory_ui() -> void:
	# Reset filtered lists
	filtered_keys.clear()
	filtered_values.clear()

	# Filter out items with amount <= 0
	for key in Inventory.inventory.keys():
		var amount = Inventory.inventory[key]
		if amount > 0:
			filtered_keys.append(key)
			filtered_values.append(amount)

	# Loop through 20 slots and fill them in order
	for i in range(1, 21):
		var slot = get_node("Panel/levels/Slot" + str(i))
		var item_label = slot.get_node("ItemLabel")
		var amount_label = slot.get_node("AmountLabel")
		var icon_rect = slot.get_node("Icon")

		if i - 1 < filtered_keys.size():
			var item_name = str(filtered_keys[i - 1])
			var item_amount = int(filtered_values[i - 1])

			# Display item info
			item_label.text = item_name
			amount_label.text = str(item_amount)

			# Assign icon if available in dictionary
			if item_icons.has(item_name):
				icon_rect.texture = load(item_icons[item_name])
			else:
				icon_rect.texture = null
		else:
			# Clear empty slots
			item_label.text = ""
			amount_label.text = ""
			icon_rect.texture = null


# ---------------------------
# SLOT PRESSED
# ---------------------------
func _on_slot_pressed(index: int) -> void:
	if index - 1 < filtered_keys.size():
		var item_name = filtered_keys[index - 1]
		var item_amount = filtered_values[index - 1]

		if item_amount > 0:
			print("Equipped: ", item_name)
			player.equip_item(item_name)  # this should be in your Player script
