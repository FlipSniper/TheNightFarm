extends CharacterBody3D

@export var RunSpeed: float = 3.0
@export var MinDistance: float = 6.0
@export var MaxDistance: float = 10.0
@export var AttackCooldown: float = 2.0
@export var AttackDuration: float = 1.5
@export var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var shockwave_scene: PackedScene

@onready var player: CharacterBody3D = get_tree().current_scene.get_node("Player")
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var anim: AnimationPlayer = $Sword/AnimationPlayer

var attack_timer: float = 0.0
var in_attack: bool = false
var cooldown_timer: float = 0.0

func _physics_process(delta: float) -> void:
	if not player:
		return

	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0

	var distance := global_position.distance_to(player.global_position)

	if in_attack:
		# Stand still and stop rotating
		velocity.x = 0
		velocity.z = 0
		attack_timer -= delta
		if attack_timer <= 0:
			in_attack = false
	else:
		cooldown_timer -= delta

		# Smart distancing behavior
		if distance < MinDistance:
			# Too close → back up
			var dir = (global_position - player.global_position).normalized()
			velocity.x = dir.x * RunSpeed
			velocity.z = dir.z * RunSpeed
		elif distance > MaxDistance:
			# Too far → move closer
			navigation_agent.target_position = player.global_position
			if not navigation_agent.is_navigation_finished():
				var next_pos = navigation_agent.get_next_path_position()
				var dir = (next_pos - global_position).normalized()
				velocity.x = dir.x * RunSpeed
				velocity.z = dir.z * RunSpeed
			else:
				velocity.x = 0
				velocity.z = 0
		else:
			# Perfect range → stay still
			velocity.x = 0
			velocity.z = 0

			# If cooldown is up, attack
			if cooldown_timer <= 0:
				start_attack()

		# Only rotate to face player if not attacking
		var look_target = Vector3(player.global_position.x, global_position.y, player.global_position.z)
		look_at(look_target, Vector3.UP)

	move_and_slide()

func start_attack() -> void:
	in_attack = true
	attack_timer = AttackDuration
	cooldown_timer = AttackCooldown
	velocity = Vector3.ZERO
	anim.play("swing")
	$Sword.enemy_attack()

func get_away():
	in_attack = true
	attack_timer = AttackDuration
	AttackCooldown
	velocity = Vector3.ZERO
	anim.play("get_away")
	var shockwave = shockwave_scene.instantiate()
	get_tree().current_scene.add_child(shockwave)
	shockwave.global_position = global_position
