extends CharacterBody2D

# Finds other nodes in the scene
@onready var camera: Camera2D = $"../Camera2D"
@onready var ball: CharacterBody2D = $"../Ball"


@export var speed: float = 300.0

var window_size: Vector2 = Vector2.ZERO

func _ready() -> void:
	
	# Gets the window size from the camera
	# Pushes warning if no camera is found
	if camera:
		window_size = camera.get_viewport_rect().size * 0.5
	else:
		push_error("Paddle found no camera, clamp not functioning.")


func _physics_process(_delta: float) -> void:
	
	# Gets the initial position of the paddle
	var initial_position: float = position.x
	
	

	# Gets the input direction from the player
	var direction = Input.get_axis("up", "down")


	# Multiplies the input direction by the speed to keep it positive or flip it
	# Sets the velocity of the paddle to the output of the multiplication
	velocity.y = direction * speed
	
	#Moves the paddle with the velocity given
	move_and_slide()
	
	# Clamps the paddle to the window size
	position.y = clamp(position.y, -window_size.y + 50, window_size.y - 50)
	
	# Resets the position of the paddle to the initial position
	position.x = initial_position