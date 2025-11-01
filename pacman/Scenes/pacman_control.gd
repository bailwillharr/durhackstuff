extends AnimatedSprite2D

@export var speed: float = 200.0

var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	play("default")

func _process(delta: float) -> void:
	velocity = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	elif Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	elif Input.is_action_pressed("ui_down"):
		velocity.y += 1

	# Normalize so diagonal movement doesn’t go faster
	if velocity != Vector2.ZERO:
		velocity = velocity.normalized() * speed * delta
		position += velocity

		# Rotate sprite toward direction of movement
		rotation = velocity.angle()
