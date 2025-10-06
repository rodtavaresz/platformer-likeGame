extends Area2D

@export_file("*.tscn") var win_scene_path := ""

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		_win()

func _win() -> void:
	if win_scene_path != "":
		get_tree().paused = false
		get_tree().call_deferred("change_scene_to_file", win_scene_path)
