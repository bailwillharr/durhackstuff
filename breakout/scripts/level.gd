extends Node2D

@onready var brickObject = preload("res://breakout/scenes/brick.tscn")

@export var paddle: Node2D
@export var ball_scene: PackedScene
var active_balls: Array = []
var active_bricks: Array = []   

@export var speed: float = 400.0
var direction: Vector2 = Vector2(0, -1)

@export var auto_spawn_bricks := true
@export var brick_spawn_interval := 5.0   
@export var max_bricks := 100              

var columns = 17
var rows = 7
var margin = 12
var xspacing = 64
var yspacing = 32

var lives := 3


func _ready() -> void:
	setupLevel()

	if auto_spawn_bricks:
		var brick_timer = Timer.new()
		brick_timer.wait_time = brick_spawn_interval
		brick_timer.one_shot = false
		brick_timer.autostart = true
		add_child(brick_timer)
		brick_timer.timeout.connect(spawn_random_brick)


func setupLevel():
	var colors = getColors()
	colors.shuffle()

	for r in range(rows):
		for c in range(columns):
			var randomNumber = randi_range(0, 2)
			if randomNumber > 0:
				spawn_brick(Vector2(33 + margin + (xspacing * c), 120 + margin + (yspacing * r)), colors, r)


func spawn_brick(pos: Vector2, colors: Array, row_index: int):
	var newBrick = brickObject.instantiate()
	add_child(newBrick)
	newBrick.position = pos
	active_bricks.append(newBrick)  

	newBrick.tree_exited.connect(_on_brick_destroyed.bind(newBrick))

	var sprite = newBrick.get_node("Sprite2D")
	if row_index <= 3:
		sprite.modulate = colors[0]
	if row_index < 2:
		sprite.modulate = colors[1]
	if row_index < 1:
		sprite.modulate = colors[2]


func _on_brick_destroyed(brick):
	if brick in active_bricks:
		active_bricks.erase(brick)
		check_win_condition()
		print("SIX SEVEN")


func check_win_condition():
	var threshold = 0.1
	if active_bricks.size() <= int(9):
		win_game()


func win_game():
	print("🎉 You Win! 🎉")
	get_tree().paused = true


func spawn_random_brick():
	if active_bricks.size() >= max_bricks:
		return # stop spawning if too many

	var random_x = randi_range(100, 1000)
	var random_y = randi_range(100, 400)
	var pos = Vector2(random_x, random_y)

	var colors = getColors()
	colors.shuffle()

	spawn_brick(pos, colors, randi_range(0, 3))


func getColors():
	return [
		Color(0,1,1,1),
		Color(0.54,0.17,0.89,1),
		Color(0.68,1,0.18,1),
		Color(1,1,1,1)
	]


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("spawn_ball"):
		spawn_ball_above_paddle()


func spawn_ball_above_paddle():
	if paddle == null or ball_scene == null:
		return
	var ball = ball_scene.instantiate()
	add_child(ball)
	ball.position = paddle.position - Vector2(0, 20)
	active_balls.append(ball)


func spawn_ball(position: Vector2, direction: Vector2):
	var ball = ball_scene.instantiate()
	ball.position = position
	add_child(ball)
	active_balls.append(ball)


func _on_ball_timer_timeout() -> void:
	spawn_ball(Vector2(300,300), Vector2(1,1))


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
