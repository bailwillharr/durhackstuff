extends CharacterBody2D

@export var speed = 200
var screen_size


func _ready():
	$AnimatedSprite2D.play("idle")
	screen_size = get_viewport_rect().size


func _process(delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("right"):
		$AnimatedSprite2D.flip_h = false
		velocity.x += 1
	if Input.is_action_pressed("left"):
		$AnimatedSprite2D.flip_h = true
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 0.5
	if Input.is_action_pressed("up"):
		velocity.y -= 0.5

	if velocity != Vector2.ZERO:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("idle")

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
