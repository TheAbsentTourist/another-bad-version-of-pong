extends CharacterBody2D

@onready var camera: Camera2D = $"../Camera2D"

@export var speed: float = 200.0

var start_position: Vector2 = Vector2.ZERO

var window_size: Vector2 = Vector2.ZERO

const RADIUS: float = 10.0

var score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if camera: 
		window_size = camera.get_viewport_rect().size * 0.5
	else:
		push_warning("Ball found no camera, clamp not functioning.")
	
	reset_ball()


func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())

	if position.y <= -window_size.y + RADIUS or position.y >= window_size.y - RADIUS:
		velocity.y = -velocity.y
		position.y = clamp(position.y, -window_size.y + RADIUS, window_size.y - RADIUS)

	if position.x <= -window_size.x + RADIUS:
		reset_ball()
	if position.x >= window_size.x - RADIUS:
		score += 1
		print("Score: ", score)
		reset_ball()



func random_direction() -> Vector2:
	var angle = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	if angle.x < 1 and angle.x > -1:
		angle.x = -1.0
	return angle

func reset_ball() -> void:
	position = start_position
	velocity = random_direction() * speed