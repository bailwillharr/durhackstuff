extends CharacterBody2D

@export var speed = 200


func _ready():
	$AnimatedSprite2D.play("default")


func _process(delta):
	if Input.is_action_pressed("right"):
		$AnimatedSprite2D.rotation = 0
		velocity.x = 1
		velocity.y = 0
	elif Input.is_action_pressed("left"):
		$AnimatedSprite2D.rotation = PI
		velocity.x = - 1
		velocity.y = 0
	elif Input.is_action_pressed("down"):
		$AnimatedSprite2D.rotation = PI/2
		velocity.y = 1
		velocity.x = 0
	elif Input.is_action_pressed("up"):
		$AnimatedSprite2D.rotation = 3 * PI/2
		velocity.y = -1
		velocity.x = 0

	if velocity != Vector2.ZERO:
		velocity = velocity.normalized() * speed

	position += velocity * delta
