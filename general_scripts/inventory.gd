extends Node

signal inventory_updated(item_name, new_amount)

# Inventory dictionary (item name → amount)
@onready var inventory = {
	"SWORD": 0,
	"SWORD_SEED": 0,
	"BROKEN_MACE": 0,
	"BROKEN_MACE_SEED": 0,
	"COINS": 20,
	"WATER": 1
}

# Add items to inventory (works for any item)
func add_crop(item_name: String, amount_to_add: int) -> void:
	if inventory.has(item_name):
		inventory[item_name] += amount_to_add
	else:
		inventory[item_name] = amount_to_add
	emit_signal("inventory_updated", item_name, inventory[item_name])
	print(inventory)

# Use items from inventory (works for any item)
func use_item(item_name: String, amount_used: int) -> void:
	if inventory.has(item_name):
		inventory[item_name] = max(0, inventory[item_name] - amount_used)
		emit_signal("inventory_updated", item_name, inventory[item_name])
		print(inventory)
	else:
		print("Item not found in inventory: ", item_name)
	print(inventory)
