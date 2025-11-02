extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if visible:
		rotate(delta)
		const shrink_speed = 1
		if scale.x > 0.1 and scale.y > 0.1:
			scale.x -= shrink_speed * delta
			scale.y -= shrink_speed * delta
			
			# Ensure the scale doesn't go below zero
			if scale.x < 0:
				scale.x = 0
			if scale.y < 0:
				scale.y = 0
		else:
			get_tree().change_scene_to_file("res://gardino/gardino.tscn")
	pass


func _on_mario_player_died() -> void:
	visible = true
	pass # Replace with function body.
