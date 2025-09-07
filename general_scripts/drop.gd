extends RigidBody3D

@export var drop_type : String
@onready var collected = false

func triggered(body):
	if body.name == "Player" and !collected:
		Inventory.add_crop(drop_type,1)	
		collected = true
	if collected:
		queue_free()
