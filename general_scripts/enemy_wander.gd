extends State
class_name EnemyWander

var wander_direction : Vector3
var wander_time: float = 0.0

var player: CharacterBody3D = null
@onready var enemy: CharacterBody3D = get_parent().get_parent()
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func randomize_variables():
	wander_direction = Vector3(randf_range(-1.0,1.0),0.0, randf_range(-1.0,1.0))
	wander_time = randf_range(1.5,4.0)

func enter():
	randomize_variables()

func _process(delta: float):
	if wander_time < 0.0:
		randomize_variables()
	
	wander_time -= delta
	
	if enemy.global_position.distance_to(player.global_position) < enemy.ChaseDistance:
		emit_signal("Transitioned",self, "EnemyChase")
func _physics_process(delta: float):
	enemy.velocity = wander_direction * enemy.WalkSpeed
	
	if not enemy.is_on_floor():
		enemy.velocity += enemy.get_gravity()
