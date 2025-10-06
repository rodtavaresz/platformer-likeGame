extends CharacterBody2D

@export var SPEED := 300.0
@onready var sprite2d: AnimatedSprite2D = $AnimationSprite
@export var STOMP_BOUNCE := -300.0
const JUMP_VELOCITY := -400.0
@onready var points_ui := get_tree().get_first_node_in_group("points_ui")
var jumps_done := 0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		if velocity.y < 0:
			sprite2d.animation = "jumping"
		else:
			sprite2d.animation = "falling"
	else:
		jumps_done = 0
	var coins := GameController.get_instance().points
	var max_jumps: int = 2 if coins >= 5 else 1
	if Input.is_action_just_pressed("ui_accept") and jumps_done < max_jumps:
		velocity.y = JUMP_VELOCITY
		jumps_done += 1
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		sprite2d.flip_h = direction < 0
		velocity.x = direction * SPEED
		if is_on_floor():
			sprite2d.animation = "walking"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			sprite2d.animation = "idle"
			
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and velocity.y > 0.0:
		return
	if body.is_in_group("enemy"):
		_die()

signal died

var _is_dying := false

func _die() -> void:
	if _is_dying:
		return
	_is_dying = true

	if has_node("Area2D"):
		$Area2D.set_deferred("monitoring", false)
	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)

	emit_signal("died")



func _on_feet_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and velocity.y > 0.0:
		if body.has_method("die"):
			body.die()
		else:
			body.queue_free()
		velocity.y = STOMP_BOUNCE

func respawn(at_pos: Vector2) -> void:
	global_position = at_pos
	velocity = Vector2.ZERO
	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", false)
	if has_node("Area2D"):
		$Area2D.set_deferred("monitoring", true)
	_is_dying = false
