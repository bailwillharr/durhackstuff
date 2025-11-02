extends StaticBody2D

@export var Speed = 10
@export var StartRight =false
@export var Player: PlatformerController2D

signal player_died

var goomba_dead = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var moving_right = StartRight

func isNearLedge(right):
	if right:
		return !$RayCast2DRight.is_colliding()
	else:
		return !$RayCast2DLeft.is_colliding()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !goomba_dead:
		if isNearLedge(moving_right):
			moving_right = !moving_right
		if moving_right:
			$AnimatedSprite2D.play("right")
			position.x += delta * Speed
		else:
			$AnimatedSprite2D.play("left")
			position.x -= delta * Speed
		if ((transform.get_origin() - Player.transform.get_origin()).length()) < 150:
			emit_signal("player_died")
	else:
		$AnimatedSprite2D.play("dying")
		position.x -= delta * Speed * 8.0
		pass

func _on_player_killed_goomba(goomba_obj: Variant) -> void:
	if (goomba_obj == self):
		goomba_dead = true
