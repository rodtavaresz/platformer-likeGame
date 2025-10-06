extends CharacterBody2D

@export var speed: int = 100
var direction: int = 1

func _physics_process(delta: float) -> void:
	velocity.x = speed * direction
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	else:
		velocity.y = 0
	move_and_slide()
	if is_on_wall():
		direction *= -1
		$Sprite2D.flip_h = direction < 0
