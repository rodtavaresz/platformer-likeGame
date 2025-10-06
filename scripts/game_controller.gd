extends Node2D

class_name GameController
static var _instance: GameController = null

var points: int = 0

func _ready() -> void:
	GameController.get_instance().points = 0
	$CanvasLayer/PointsUI.text = "Points: 0"

static func get_instance() -> GameController:
	if _instance == null:
		_instance = GameController.new()
	return _instance
