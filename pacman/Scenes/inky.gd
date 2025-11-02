## INKY
extends CharacterBody2D

@export var speed: float = 100.0
@export var pacman_path: NodePath
@export var blinky_path: NodePath
const TILE_SIZE: float = 16.0

var pacman: Node2D = null
var blinky: Node2D = null

func _ready() -> void:
	add_to_group("ghost")
	$AnimatedSprite2D.play("default")
	if pacman_path != NodePath():
		pacman = get_node(pacman_path)
	if blinky_path != NodePath():
		blinky = get_node(blinky_path)

func _physics_process(_delta: float) -> void:
	if pacman == null or blinky == null:
		return

	# Step 1: get position 4 tiles in front of Pac-Man
	var ahead_pos: Vector2
	if pacman.velocity.length() > 0:
		var dir = pacman.velocity.normalized()
		ahead_pos = pacman.global_position + dir * 4 * TILE_SIZE
	else:
		ahead_pos = pacman.global_position

	# Step 2: draw vector from Blinky to that position
	var vec_from_blinky: Vector2 = ahead_pos - blinky.global_position

	# Step 3: double it to find Inky’s target
	var target_pos: Vector2 = blinky.global_position + vec_from_blinky * 2.0

	# Step 4: move toward that target
	var diff: Vector2 = target_pos - global_position
	var dir_to_target: Vector2 = Vector2.ZERO

	if abs(diff.x) > abs(diff.y):
		dir_to_target.x = sign(diff.x)
	else:
		dir_to_target.y = sign(diff.y)

	if dir_to_target.y > 0:
		$Sprite2D.texture = load('res://pacman/Assets/Ghost/Ghost_Eyes_Down.png')
	elif dir_to_target.y < 0:
		$Sprite2D.texture = load('res://pacman/Assets/Ghost/Ghost_Eyes_Up.png')
	elif dir_to_target.x > 0:
		$Sprite2D.texture = load('res://pacman/Assets/Ghost/Ghost_Eyes_Right.png')
	elif dir_to_target.x < 0:
		$Sprite2D.texture = load('res://pacman/Assets/Ghost/Ghost_Eyes_Left.png')

	velocity = dir_to_target * speed
	move_and_slide()


