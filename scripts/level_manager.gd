extends Node

@export var player_path: NodePath
@export var max_deaths: int = 3
@export var game_over_scene: String = ""  # ex: "res://game_over.tscn"
@export var spawn_override: Vector2 = Vector2.ZERO  # opcional (deixa vazio para usar posição inicial do player)

var deaths: int = 0
var spawn_pos: Vector2
@onready var player: Node = get_node(player_path)

func _ready() -> void:
	if not player:
		push_error("LevelManager: defina 'player_path' no Inspetor.")
		return

	if spawn_override == Vector2.ZERO:
		spawn_pos = (player as Node2D).global_position
	else:
		spawn_pos = spawn_override

	if player.has_signal("died"):
		player.died.connect(_on_player_died)
	else:
		push_error("Player não tem sinal 'died'.")

func _on_player_died() -> void:
	deaths += 1

	if deaths >= max_deaths:
		if game_over_scene != "":
			get_tree().call_deferred("change_scene_to_file", game_over_scene)
		else:
			get_tree().quit()
		return

	await get_tree().process_frame
	if player and player.has_method("respawn"):
		player.respawn(spawn_pos)
