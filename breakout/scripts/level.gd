extends Node2D


@onready var brickObject = preload("res://breakout/scenes/brick.tscn")

@export var paddle: Node2D

@export var ball_scene: PackedScene
var active_balls: Array = []

@export var speed: float = 400.0
var direction: Vector2 = Vector2(0, -1)

func spawn_ball(position: Vector2, direction: Vector2):
	var ball = ball_scene.instantiate()
	ball.position = position
	#ball.direction = direction.normalized()
	add_child(ball)
	active_balls.append(ball)




var columns = 17
var rows = 4
var margin = 12

var xspacing = 64
var yspacing = 32

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setupLevel()
	pass # Replace with function body.


func setupLevel():


	var colors = getColors()
	colors.shuffle()

	#spawn_ball(Vector2(300,300), Vector2(1,1))


	for r in rows:
		for c in columns:
			var randomNumber = randi_range(0,2)
			if randomNumber>0:

				var newBrick = brickObject.instantiate()

					
				add_child(newBrick)
				newBrick.position = Vector2(33+margin + (xspacing*c), 120+margin+(yspacing*r))

				var sprite = newBrick.get_node('Sprite2D')
				if r <= 3:
					sprite.modulate = colors[0]
				if r<2:
					sprite.modulate = colors[1]
				if r<1:
					sprite.modulate = colors[2]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func getColors():
	var colors = [
		Color(0,1,1,1),
		Color(0.54,0.17,0.89,1),
		Color(0.68,1,0.18,1),
Color(1,1,1,1)
	]
	return colors


func _on_ball_timer_timeout() -> void:
	spawn_ball(Vector2(300,300), Vector2(1,1))
	pass # Replace with function body.

var lives := 3

func _on_ball_lost():
	lives -= 1
	if lives > 0:
		respawn_ball()
	else:
		lose_game()

func respawn_ball():
	var ball_scene = preload("res://breakout/scenes/ball.tscn")
	var new_ball = ball_scene.instantiate()
	add_child(new_ball)
	new_ball.position = $Paddle.position - Vector2(0, 20)

func lose_game():
	print("Game Over!")
	get_tree().paused = true
