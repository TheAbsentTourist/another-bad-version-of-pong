extends State

@export var tracking_range_in_pixels: int = 15

@onready var ball: CharacterBody2D = $"../../../Ball"

# Safety
# Stays true while this state is running so the loop below can stop itself
var tracking_wanted: bool = false

# Time left before the paddle picks a new fidget goal
var pause: float = 0.0

# While true, the paddle follows the ball's height every frame
var smooth: bool = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:

	# Ball heading left has passed this paddle, so go back to waiting
	if ball.horizontal_direction < 0:
		request_transition("Waiting")
	# A smooth stretch copies the ball's height straight into the goal
	elif smooth:
		state_machine.body.goal_y_position = ball.position.y


# Called when the state machine switches into this state
func enter() -> void:
	print(self.name)
	tracking_wanted = true
	smooth = false
	track_to_ball()


# Called when the state machine switches out of this state
func exit() -> void:
	tracking_wanted = false


# Picks a new goal on a short timer. Some intervals glide, the rest fidget.
func track_to_ball() -> void:
	if tracking_wanted:
		# Holds the current goal briefly so the paddle can arrive and pause
		await get_tree().create_timer(randf_range(0.3, 0.8)).timeout
		# About 4 in 10 intervals follow the ball live inside _process
		smooth = randf() < 0.4
		if not smooth:
			state_machine.body.goal_y_position = random_y_position_near_ball(tracking_range_in_pixels)
		track_to_ball()


# Picks a height near the ball, then shifts it using the ball's vertical direction
func random_y_position_near_ball(range_in_pixels: int):
	# Starts inside a small band around the ball's current height
	var random_y: float = randf_range(ball.position.y - range_in_pixels, ball.position.y + range_in_pixels)
	# Adds (vertical direction) * (paddle height - ball height).
	# That mixes the paddle's height in by the ball's up/down fraction of speed.
	# Downward movement pulls the goal toward the paddle. Upward movement
	# places it on the far side of the ball, the same distance past it.
	random_y += (ball.vertical_direction * (state_machine.body.position.y - ball.position.y))
	return random_y
