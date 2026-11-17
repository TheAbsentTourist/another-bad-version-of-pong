extends CharacterBody2D


@onready var camera: Camera2D = $"../Camera2D"

# Ball stuff
@export var speed: float = 200.0

# Flattest and steepest allowed tilt, in degrees from sideways.
# 0 would skim straight across. 90 would bounce straight up and down.
# max_angle_degrees stays above min_angle_degrees.
@export var min_angle_degrees: float = 25.0
@export var max_angle_degrees: float = 60.0

var start_position: Vector2 = Vector2.ZERO

const RADIUS: float = 10.0

var horizontal_direction: float
var vertical_direction: float

# Misc variables
var window_size: Vector2 = Vector2.ZERO
var score: int = 0


# Initialization
func _ready() -> void:
	
	# Gets the window size from the camera and
	# Pushes warning if no camera is found
	if camera: 
		window_size = camera.get_viewport_rect().size * 0.5
	else:
		push_error("Ball found no camera, clamp not functioning.")
	
	reset_ball()


func _physics_process(delta: float) -> void:
	
	# Moves the ball and waits for a collision
	var collision = move_and_collide(velocity * delta)

	# If a collision is detected, the ball bounces off the surface
	if collision:
		velocity = velocity.bounce(collision.get_normal())

	# If the ball hits the top or bottom of the screen it bounces off the surface
	if position.y <= -window_size.y + RADIUS or position.y >= window_size.y - RADIUS:
		velocity.y = -velocity.y
		position.y = clamp(position.y, -window_size.y + RADIUS, window_size.y - RADIUS)

	# If the ball hits the left of the screen it resets the ball
	if position.x <= -window_size.x + RADIUS:
		reset_ball()
	
	# If the ball hits the right of the screen it increments the score and resets the ball
	if position.x >= window_size.x - RADIUS:
		score += 1
		print("Score: ", score)
		reset_ball()
	
	# A bounce can leave the shot too flat, too steep, or longer than `speed`.
	# This pulls the tilt back into range and sets the length to exactly `speed`.
	limit_velocity()

	# Each axis as a fraction of speed. The tilt limit keeps both below 1,
	# since neither axis is allowed to take the whole velocity.
	horizontal_direction = velocity.x / speed
	vertical_direction = velocity.y / speed




# Returns a random direction with a length of 1, inside the allowed tilt
func random_direction() -> Vector2:
	
	# Randomly chooses a horizontal direction, binary either -1 or 1
	var horizontal: float
	if randi() % 2 == 0:
		horizontal = -1.0
	else:
		horizontal = 1.0

	# Randomly chooses a vertical direction from -1 to 1.
	# limit_direction pulls that raw tilt back into the allowed range.
	var vertical: float = randf_range(-1, 1)

	return limit_direction(Vector2(horizontal, vertical))


func reset_ball() -> void:
	position = start_position
	velocity = random_direction() * speed


# Points velocity along the allowed tilt and gives it a length of exactly `speed`.
# Every shot has the same length, so a diagonal moves as fast as a shallow angle.
func limit_velocity() -> void:
	if velocity.length() < 0.001:
		push_warning("Ball velocity is 0, cannot normalize velocity.")
		return
	velocity = limit_direction(velocity) * speed


# Rebuilds a direction whose tilt stays between the min and max angles.
# The vector it returns has a length of 1.
func limit_direction(raw_velocity: Vector2) -> Vector2:
	# The tilt math below uses absolute values. These signs put the ball
	# back on the side it was already traveling.
	var x_sign: float = signf(raw_velocity.x)
	var y_sign: float = signf(raw_velocity.y)

	# A perfectly flat or vertical hit has a 0 on one axis.
	# Pick that side at random so the ball still leaves on a legal tilt.
	if x_sign == 0.0:
		if randi() % 2 == 0:
			x_sign = -1.0
		else:
			x_sign = 1.0
	if y_sign == 0.0:
		if randi() % 2 == 0:
			y_sign = -1.0
		else:
			y_sign = 1.0

	# Tilt from sideways, in degrees. 0 is flat, 90 is straight up or down.
	var angle: float = rad_to_deg(atan2(absf(raw_velocity.y), absf(raw_velocity.x)))
	angle = clamp(angle, min_angle_degrees, max_angle_degrees)

	# cos is the sideways share and sin is the up/down share.
	# sin² + cos² is always 1, so this direction stays length 1 at every tilt.
	# Multiplying by `speed` then cannot make a steeper shot faster.
	var radians: float = deg_to_rad(angle)
	return Vector2(cos(radians) * x_sign, sin(radians) * y_sign)
