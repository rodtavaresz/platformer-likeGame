extends CharacterBody2D

@export var speed: int = 80
var direction: int = 1
const MIN_TURN_DELAY := 0.20
var turn_cooldown: float = 0.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var wall_check: RayCast2D = $WallCheck
@onready var ledge_check: RayCast2D = $LedgeCheck

func _ready() -> void:
	if is_instance_valid(wall_check):
		wall_check.enabled = true
		wall_check.exclude_parent = true
	if is_instance_valid(ledge_check):
		ledge_check.enabled = true
		ledge_check.exclude_parent = true
	_update_rays()

func _physics_process(delta: float) -> void:
	turn_cooldown = max(0.0, turn_cooldown - delta)
	velocity.x = speed * direction
	if not is_on_floor():
		velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta
	else:
		velocity.y = 0
	move_and_slide()
	sprite.flip_h = direction < 0
	if turn_cooldown <= 0.0 and is_on_floor():
		var parede_a_frente := is_instance_valid(wall_check) and wall_check.is_colliding()
		var sem_chao_a_frente := is_instance_valid(ledge_check) and not ledge_check.is_colliding()
		if parede_a_frente or sem_chao_a_frente:
			direction *= -1
			_update_rays()
			turn_cooldown = MIN_TURN_DELAY

func _update_rays() -> void:
	if is_instance_valid(wall_check):
		wall_check.position = Vector2(10 * direction, 0)
		wall_check.target_position = Vector2(12 * direction, 0)
	if is_instance_valid(ledge_check):
		ledge_check.position = Vector2(8 * direction, 0)
		ledge_check.target_position = Vector2(0, 24)

func die() -> void:
	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)
	call_deferred("queue_free")
	
