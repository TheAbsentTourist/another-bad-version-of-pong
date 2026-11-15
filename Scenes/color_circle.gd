@tool
extends Node2D

var circle_position: Vector2 = Vector2.ZERO

@export var circle_radius: float = 100

@export var circle_color: Color = Color.WHITE

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_circle(circle_position, circle_radius, circle_color, true)
