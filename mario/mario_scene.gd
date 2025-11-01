extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# initialisation
	get_window().size = Vector2i(640, 480)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
