extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("balls"):
		body.queue_free()  # remove ball
		print("67")
		# check_if_no_balls_left()
	elif body.is_in_group("player"):
		pass
		# respawn_player()
