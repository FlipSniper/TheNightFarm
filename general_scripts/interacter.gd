extends Node3D

signal harvested_crop(crop_type, harvest_amount)
signal update_prompt_text(new_text : String)

@onready var ray = $"../RayCast3D"
@onready var player = get_tree().current_scene.get_node("Player")

@export var crop_sword : PackedScene
@export var crop_mace : PackedScene
@export var Dirt : Array[Node3D]
@onready var Unavailable = []
@onready var pairs = {}

func _process(delta: float) -> void:
	var obj = ray.get_collider()

	if Input.is_action_just_pressed("interact") and ray.is_colliding() and obj and obj.is_in_group("interactable"):
		if obj.harvestable:
			emit_signal("harvested_crop", obj.get_crop_type(), obj.get_harvest_amount())
			obj.interact()
			print(str(obj.get_crop_type()))
			Unavailable.erase(pairs[obj])
			Inventory.add_crop(str(obj.get_crop_type()),1)

	if Input.is_action_just_pressed("interact") and ray.is_colliding() and obj and obj.name == "shop":
		$"../../UI/Shop".visible = true

	if Input.is_action_just_pressed("plant") and ray.is_colliding() and obj and obj.get_parent().name == "fertile" and obj not in Unavailable:
		print("pls")
		print(player.seed_equipped)
		if player.seed_equipped.to_lower() == "sword_seed" and Inventory.inventory["SWORD_SEED"] > 0:
			Inventory.use_item("SWORD_SEED",1)
			Unavailable.append(obj)
			var crop_instance = crop_sword.instantiate()
			get_tree().get_root().add_child(crop_instance)
			pairs[crop_instance] = obj
			crop_instance.global_transform.origin = obj.global_transform.origin
		elif player.seed_equipped.to_lower() == "broken_mace_seed" and Inventory.inventory["BROKEN_MACE_SEED"] > 0:
			print("her")
			Inventory.use_item("BROKEN_MACE_SEED",1)
			Unavailable.append(obj)
			var crop_instance = crop_mace.instantiate()
			get_tree().get_root().add_child(crop_instance)
			pairs[crop_instance] = obj
			crop_instance.global_transform.origin = obj.global_transform.origin

	if ray.is_colliding() and obj and obj.is_in_group("interactable"):
		emit_signal("update_prompt_text", obj.update_prompt_text())
	else:
		emit_signal("update_prompt_text", "")
