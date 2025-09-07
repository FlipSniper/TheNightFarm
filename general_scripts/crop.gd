extends StaticBody3D

@export var crop_type : String
@export var harvest_amount : int = 1

@onready var large = $Large
@onready var medium = $Medium
@onready var small = $Small

var growth_value = 0.0
@export var growth_time_in_seconds : float

var harvestable = false

func _ready() -> void:
	add_to_group("interactable")

func get_crop_type():
	return crop_type

func get_harvest_amount():
	return harvest_amount

func update_prompt_text() -> String:
	if harvestable:
		return "Click to harvest"
	else:
		return "Not ready"


func interact():
	if harvestable:
		queue_free()

func _physics_process(delta: float) -> void:
	if growth_value < 1.0:
		growth_value += delta / growth_time_in_seconds

	# Handle visuals
	small.visible = growth_value < 0.5
	medium.visible = growth_value < 1.0 and growth_value > 0.5
	large.visible = growth_value >= 1.0

	# Handle collisions (if they’re CollisionShapes)
	small.disabled = growth_value > 0.5
	medium.disabled = growth_value > 1.0 or growth_value < 0.5
	large.disabled = growth_value < 1.0

	# Ready to harvest check
	harvestable = growth_value >= 1.0
