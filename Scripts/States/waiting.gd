extends State

@export var fidget_range_in_pixels: int = 150

@onready var ball: CharacterBody2D = $"../../../Ball"

# Safety
var fidget_wanted: bool = false


# Time left before the paddle picks a new fidget goal
var pause: float = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:

	if ball.horizontal_direction > 0:
		request_transition("Tracking")
	elif ball.horizontal_direction < 0:
		pass
	else:
		push_warning("Ball horizontal direction is 0, cannot determine direction.")
	



func enter() -> void:
	print(self.name)
	fidget_wanted = true
	fidget_paddle()

func exit() -> void:
	fidget_wanted = false

func fidget_paddle() -> void:
	if fidget_wanted:
		await get_tree().create_timer(randf_range(0.3, 1.2)).timeout
		state_machine.body.goal_y_position = random_y_position_near_ball(fidget_range_in_pixels)
		fidget_paddle()


func random_y_position_near_ball(range_in_pixels: int):
	var random_y: float = randf_range(ball.position.y - range_in_pixels, ball.position.y + range_in_pixels)
	return random_y
