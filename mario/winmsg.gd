extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if visible:
		if position.y > 500:
			position.y -= delta * 100
		else:
			get_tree().change_scene_to_file("res://gardino/gardino.tscn")


func _on_player_win_signal() -> void:
	visible = true
	pass # Replace with function body.
