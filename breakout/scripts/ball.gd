extends CharacterBody2D

var speed = 400 # initial speed
var dir = Vector2.UP #which direction
var is_active = true



func _ready() -> void:
	randomize()
	var x_dir = 1
	if randf() < 0.5:
		x_dir = -1
	# Give the ball a random left/right start
	velocity = Vector2(speed * x_dir, -speed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_active:
		#move the ball
		var collision = move_and_collide(velocity * delta)
		#if collision, bounce
		if collision:
			velocity = velocity.bounce(collision.get_normal()) # get the direction it should bounce
			

			#trigger hit()
			if collision.get_collider().has_method("hit"):
				collision.get_collider().hit() #call hit() on the brick we just collided with

			#keep ball from stalling
			if(velocity.y > 0 and velocity.y < 100):
				velocity.y = -200 #for if ball is going side to side too much
			if(velocity.x == 0):
				velocity.x = -200 #for when ball is stuck up and down
			


func gameOver():
	get_tree().reload_current_scene()

func _on_deathzone_body_entered(body: Node2D) -> void:
	pass
	gameOver()


	pass # Replace with function body.
