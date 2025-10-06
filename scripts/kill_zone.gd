extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if body.has_method("_die"):
			body._die()
		return

	if body.is_in_group("enemy"):
		body.queue_free()
