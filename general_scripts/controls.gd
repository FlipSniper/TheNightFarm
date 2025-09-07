extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("controls"):
		visible = !visible
	if visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif !$"../InventoryUI".visible and !visible and !$"../Shop".visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
