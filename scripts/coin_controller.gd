extends Area2D

var hud: Label

func _ready() -> void:
	
	hud = get_tree().get_first_node_in_group("points_ui")
	
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	
	GameController.get_instance().points += 1
	var pts := GameController.get_instance().points

	
	if hud:
		hud.text = "Points: " + str(pts)
		if pts == 5:
			hud.text += "  — Double Jump liberado!"

	queue_free()
