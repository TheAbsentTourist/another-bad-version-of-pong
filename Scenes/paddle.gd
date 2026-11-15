extends CharacterBody2D

@onready var camera: Camera2D = $"../Camera2D"

@export var speed: float = 300.0

var window_size: Vector2 = Vector2.ZERO

func _ready() -> void:
	if camera:
		window_size = camera.get_viewport_rect().size * 0.5
	else:
		push_warning("Paddle found no camera, clamp not functioning.")


func _physics_process(delta: float) -> void:
	
	var direction = Input.get_axis("up", "down")
	if direction != 0:
		velocity.y = direction * speed
	else:
		velocity.y = 0.0


	
	move_and_slide()
	position.y = clamp(position.y, -window_size.y + 50, window_size.y - 50)
