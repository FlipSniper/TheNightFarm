extends Node3D

var swinging: bool = false

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var attack_air: Node3D = $"../attack_air"
@onready var projectile_area: Area3D = attack_air.get_node("Area3D")
@onready var player_health: Node = get_tree().current_scene.get_node("Player/HealthComponent")

@export var projectile_speed: float = 5
@export var projectile_lifetime: float = 5

var projectile_timer: float = 0.0
var active: bool = false
var direction: Vector3 = Vector3.ZERO

func _ready():
	attack_air.visible = false
	projectile_area.monitoring = false
	projectile_area.connect("body_entered", Callable(self, "_on_projectile_body_entered"))

func enemy_attack():
	if not swinging:
		swinging = true
		anim.play("swing")
		await get_tree().create_timer(2.0, false).timeout

		# Direction boss is facing
		direction = -global_transform.basis.z.normalized()
		var spawn_pos = global_transform.origin + direction * 1.5

		# Re-parent attack_air
		if attack_air.get_parent() != get_tree().current_scene:
			attack_air.get_parent().remove_child(attack_air)
			get_tree().current_scene.add_child(attack_air)

		# Position + rotation
		attack_air.global_transform.origin = spawn_pos
		attack_air.look_at(spawn_pos + direction, Vector3.UP)

		# Activate
		attack_air.visible = true
		projectile_area.monitoring = true

		active = true
		projectile_timer = projectile_lifetime

func _physics_process(delta):
	if swinging and anim.current_animation != "swing":
		swinging = false

	if active:
		attack_air.global_position += direction * projectile_speed * delta
		projectile_timer -= delta

		if projectile_timer <= 0.0:
			attack_air.visible = false
			projectile_area.monitoring = false
			active = false

func damage_taken(body):
	if active and body.name == "Player":
		var attack = Attack.new(25.0, self)
		player_health.damage(attack)
		# despawn projectile after hit
		attack_air.visible = false
		projectile_area.monitoring = false
		active = false
