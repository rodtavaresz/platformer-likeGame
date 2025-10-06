extends Label
class_name PointsUI

var points: int = 0

func _ready() -> void:
	text = "Points: %d" % points

func add(n: int) -> void:
	points += n
	text = "Points: %d" % points

func reset() -> void:
	points = 0
	text = "Points: 0"
