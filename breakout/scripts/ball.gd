extends CharacterBody2D

var speed = 400 # initial speed
var dir = Vector2.DOWN #which direction
var is_active = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity = Vector2(speed * -1,speed) # set initial direction for the ball when scene loads


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

	gameOver()


	pass # Replace with function body.
