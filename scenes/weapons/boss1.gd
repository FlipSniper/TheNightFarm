extends CharacterBody3D

@export var RunSpeed: float = 3.0
@export var MinDistance: float = 6.0
@export var MaxDistance: float = 10.0
@export var AttackCooldown: float = 2.0
@export var AttackDuration: float = 1.5

@onready var player: CharacterBody3D = get_tree().current_scene.get_node("Player")
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var anim: AnimationPlayer = $Sword/AnimationPlayer
@onready var ray: RayCast3D = $RayCast3D

@export var drops: Array[PackedScene]

var attack_timer: float = 0.0
var in_attack: bool = false
var direction: Vector3 = Vector3.ZERO

func _ready():
	pass

func _physics_process(delta):
	if not player:
		return

	var distance = global_position.distance_to(player.global_position)

	if in_attack:
		# Boss stays still while attacking
		velocity = Vector3.ZERO
		move_and_slide()
		attack_timer -= delta
		if attack_timer <= 0:
			in_attack = false
	else:
		# Maintain distance
		if distance < MinDistance:
			direction = (global_position - player.global_position).normalized()
		elif distance > MaxDistance:
			direction = (player.global_position - global_position).normalized()
		else:
			direction = Vector3.ZERO

		velocity = direction * RunSpeed
		move_and_slide()

		# Face player
		if direction.length() > 0.01:
			var target = global_position + Vector3(direction.x, 0, direction.z)
			global_transform.basis = global_transform.basis.slerp(
				global_transform.looking_at(target, Vector3.UP).basis,
				delta * 5.0
			)

		# Random chance to attack if player in range
		if distance <= MaxDistance and randi_range(0, 200) > 198:
			start_attack()

func start_attack():
	in_attack = true
	attack_timer = AttackDuration
	anim.play("swing")
	$Sword.enemy_attack()
	# Here you can trigger effects/projectiles/etc
