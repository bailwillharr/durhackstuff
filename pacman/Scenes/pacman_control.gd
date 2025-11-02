extends CharacterBody2D

@export var speed = 200

var current_direction: Vector2 = Vector2.ZERO
var dead = false

func _ready():
	$AnimatedSprite2D.play("default")

func _physics_process(_delta):
	if not dead:
		if Input.is_action_pressed("right"):
			current_direction = Vector2.RIGHT
		elif Input.is_action_pressed("left"):
			current_direction = Vector2.LEFT
		elif Input.is_action_pressed("down"):
			current_direction = Vector2.DOWN
		elif Input.is_action_pressed("up"):
			current_direction = Vector2.UP

		if current_direction != Vector2.ZERO:
			velocity = current_direction.normalized() * speed
			move_and_slide()

			match current_direction:
				Vector2.RIGHT:
					$AnimatedSprite2D.rotation = 0
				Vector2.LEFT:
					$AnimatedSprite2D.rotation = PI
				Vector2.DOWN:
					$AnimatedSprite2D.rotation = PI/2
				Vector2.UP:
					$AnimatedSprite2D.rotation = 3 * PI/2
		else:
			velocity = Vector2.ZERO

		# Collision with ghosts
		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			var body = collision.get_collider()
			if body and body.is_in_group("ghost"):
				die()
				break

func die() -> void:
	dead = true
	$AnimatedSprite2D.rotation = 0
	velocity = Vector2.ZERO
	$AnimatedSprite2D.play("death")
	$CollisionShape2D.disabled = true

	await get_tree().create_timer(3.0).timeout

	global_position = Vector2.ZERO
	$CollisionShape2D.disabled = false
	$AnimatedSprite2D.play("default")
	dead = false
