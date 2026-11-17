@tool
extends Node2D

# Any time the circle_position is changed, the circle is redrawn
var circle_position: Vector2 = Vector2.ZERO:
	set(value):
		circle_position = value
		queue_redraw()

# Any time the circle_radius is changed, the circle is redrawn
@export var circle_radius: float = 100.0:
	set(value):
		circle_radius = value
		queue_redraw()

# Any time the circle_color is changed, the circle is redrawn
@export var circle_color: Color = Color.WHITE:
	set(value):
		circle_color = value
		queue_redraw()


# Draws the circle
func _draw() -> void:
	draw_circle(circle_position, circle_radius, circle_color, true)
