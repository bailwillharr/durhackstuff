extends CharacterBody2D

@export var speed: float = 100.0
@export var pacman_path: NodePath

var pacman: Node2D = null

func _ready() -> void:
	$AnimatedSprite2D.play("default")
	if pacman_path != NodePath():
		pacman = get_node(pacman_path)

func _physics_process(_delta: float) -> void:
	if pacman == null:
		return

	var diff: Vector2 = pacman.global_position - global_position

	# Decide whether to move horizontally or vertically
	var dir: Vector2 = Vector2.ZERO

	if abs(diff.x) > abs(diff.y):
		# Move horizontally only
		dir.x = sign(diff.x)
	else:
		# Move vertically only
		dir.y = sign(diff.y)

	if dir.y > 0:
		$Sprite2D.texture = load('res://pacman/Assets/Ghost/Ghost_Eyes_Down.png')
	elif dir.y < 0:
		$Sprite2D.texture = load('res://pacman/Assets/Ghost/Ghost_Eyes_Up.png')
	elif dir.x > 0:
		$Sprite2D.texture = load('res://pacman/Assets/Ghost/Ghost_Eyes_Right.png')
	elif dir.x < 0:
		$Sprite2D.texture = load('res://pacman/Assets/Ghost/Ghost_Eyes_Left.png')


	velocity = dir * speed 
	move_and_slide()
