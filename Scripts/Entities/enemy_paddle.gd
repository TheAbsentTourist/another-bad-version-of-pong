extends CharacterBody2D

# Camera
@onready var camera: Camera2D = $"../Camera2D"
var window_size: Vector2 = Vector2.ZERO

# Enemy Paddle
@export var speed: float = 300.0



# StateMachine
var goal_y_position: float = 0.0


func _ready() -> void:
	
	# Gets the window size from the camera
	# Pushes warning if no camera is found
	if camera:
		window_size = camera.get_viewport_rect().size * 0.5
	else:
		push_error("Enemy Paddle found no camera, clamp not functioning.")


func _physics_process(delta: float) -> void:
	
	# Gets the initial position of the paddle
	var initial_position: float = position.x

	#Moves the paddle with the velocity given
	move_and_slide()
	
	move_to_goal(delta)

	# Clamps the paddle to the window size
	position.y = clamp(position.y, -window_size.y + 50, window_size.y - 50)

	# Resets the position of the paddle to the initial position
	position.x = initial_position


func move_to_goal(delta: float) -> void:
	# Calculates the distance to the goal
	var to_goal := goal_y_position - position.y

	# If the paddle can reach the goal this frame, sets the velocity
	# so it lands exactly on the goal
	if absf(to_goal) < speed * delta:
		velocity.y = to_goal / delta
	# Otherwise moves toward the goal at full speed
	else:
		velocity.y = signf(to_goal) * speed