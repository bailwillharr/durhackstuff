extends Area2D


@export var speed := 100.0
@export var direction := Vector2.RIGHT


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * speed * delta 
	if position.x > 800:
		position.x = -100
	elif position.x < -100:
		position.x =800
	pass
