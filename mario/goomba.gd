extends StaticBody2D

@export var Speed = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var moving_right = true

func isNearLedge(right):
	if right:
		return !$RayCast2DRight.is_colliding()
	else:
		return !$RayCast2DLeft.is_colliding()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isNearLedge(moving_right):
		moving_right = !moving_right
	if moving_right:
		$AnimatedSprite2D.play("right")
		position.x += delta * Speed
	else:
		$AnimatedSprite2D.play("left")
		position.x -= delta * Speed
