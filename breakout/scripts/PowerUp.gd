# PowerUp.gd
extends Area2D

enum Type { ENLARGE_PADDLE, MULTI_BALL, SLOW_BALL }
@export var type: Type = Type.ENLARGE_PADDLE
@export var speed := 150

signal collected(powerup_type)

func _process(delta):
    position.y += speed * delta
    if position.y > 600: # fell off screen
        queue_free()

func _on_body_entered(body):
    if body.name == "Paddle":
        emit_signal("collected", type)
        queue_free()
