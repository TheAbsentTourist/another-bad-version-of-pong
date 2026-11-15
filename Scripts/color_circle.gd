@tool
extends Node2D

var circle_position: Vector2 = Vector2.ZERO:
	set(value):
		circle_position = value
		queue_redraw()


@export var circle_radius: float = 100:
	set(value):
		circle_radius = value
		queue_redraw()

@export var circle_color: Color = Color.WHITE:
	set(value):
		circle_color = value
		queue_redraw()



func _draw() -> void:
	draw_circle(circle_position, circle_radius, circle_color, true)
