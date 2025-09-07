extends CanvasLayer

# Example trades
var trades := {
	"SWORD_SEED": {
		"cost": {"COINS": 15, "WATER": 1},
		"icon": "res://assets/icons/sword.png",
		"reward": {"SWORD_SEED": 1}
	},
	"BORKEN_MACE_SEED": {
		"cost": {"COINS": 100, "WATER": 5},
		"icon": "res://assets/icons/mace.png",
		"reward": {"MACE_SEED": 1}
	},
	"SELL_MUTATED_WATER_ORB": {
		"cost": {"MUTATED WATER ORB": 1},
		"icon": "res://assets/icons/coin.png",
		"reward": {"COINS": 10} 
	},
	"SELL_RADIOACTIVE_VIAL": {
		"cost": {"RADIOACTIVE VIAL": 1},
		"icon": "res://assets/icons/coin.png",
		"reward": {"COINS": 50} 
	}
}

func _ready() -> void:
	var vbox = $Panel/VBoxContainer
	var trade_names = trades.keys()

	for i in range(min(vbox.get_child_count(), trade_names.size())):
		var trade_ui = vbox.get_child(i)
		var trade_name = trade_names[i]
		var trade_data = trades[trade_name]

		var reward_icon = trade_ui.get_node("RewardIcon")
		reward_icon.texture = load(trade_data["icon"])

		_update_cost_label(trade_ui, trade_data)

		var buy_button = trade_ui.get_node("BuyButton")
		buy_button.text = "Buy " + trade_name
		buy_button.pressed.connect(_on_buy_pressed.bind(trade_name, trade_data))

func _process(delta: float) -> void:
	if visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif !$"../InventoryUI".visible and !visible and !$"../Controls".visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _update_all_cost_labels() -> void:
	var vbox = $Panel/VBoxContainer
	var trade_names = trades.keys()

	for i in range(min(vbox.get_child_count(), trade_names.size())):
		var trade_ui = vbox.get_child(i)
		var trade_data = trades[trade_names[i]]
		_update_cost_label(trade_ui, trade_data)

func _update_cost_label(trade_ui: Node, trade_data: Dictionary) -> void:
	var cost_label = trade_ui.get_node("CostLabel")
	var cost_text = ""

	for item in trade_data["cost"].keys():
		var required = trade_data["cost"][item]
		var have = Inventory.inventory.get(item, 0)
		cost_text += "%s: %d / %d\n" % [item, have, required]

	cost_label.text = cost_text.strip_edges()

func _on_buy_pressed(trade_name: String, trade_data: Dictionary) -> void:
	for item in trade_data["cost"].keys():
		var required = trade_data["cost"][item]
		if Inventory.inventory.get(item, 0) < required:
			print("Not enough %s to buy %s" % [item, trade_name])
			return

	for item in trade_data["cost"].keys():
		var required = trade_data["cost"][item]
		Inventory.use_item(item, required)

	for reward_item in trade_data["reward"].keys():
		var reward_amount = trade_data["reward"][reward_item]
		if reward_item == "COINS":
			Inventory.inventory["COINS"] += reward_amount
		else:
			if !Inventory.inventory.has(reward_item):
				Inventory.inventory[reward_item] = 0
			Inventory.add_crop(reward_item, reward_amount)

	print("Bought:", trade_name)

	_update_all_cost_labels()

func close() -> void:
	visible = false
