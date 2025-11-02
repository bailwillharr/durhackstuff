## INKY
extends CharacterBody2D

@export var speed: float = 100.0
@export var pacman_path: NodePath
@export var blinky_path: NodePath
@export var tile_size: float = 24.0

var pacman: Node2D = null
var blinky: Node2D = null
var moving := false
var current_dir := Vector2.ZERO

@onready var ray := $RayCast2D
@onready var sprite := $AnimatedSprite2D

func _ready() -> void:
	add_to_group("ghost")
	sprite.play("default")
	if pacman_path != NodePath():
		pacman = get_node(pacman_path)
	if blinky_path != NodePath():
		blinky = get_node(blinky_path)

	# Snap to grid
	global_position = global_position.snapped(Vector2.ONE * tile_size)

func _physics_process(_delta: float) -> void:
	if pacman == null or blinky == null or moving:
		return

	# Step 1: get position 4 tiles in front of Pac-Man
	var pac_dir: Vector2 = Vector2.ZERO
	if "current_dir" in pacman:
		pac_dir = pacman.current_dir
	var ahead_pos: Vector2 = pacman.global_position + pac_dir * 4 * tile_size

	# Step 2: draw vector from Blinky to that position
	var vec_from_blinky: Vector2 = ahead_pos - blinky.global_position

	# Step 3: double it to find Inky’s target
	var target_pos: Vector2 = blinky.global_position + vec_from_blinky * 2.0

	# Step 4: choose direction toward target
	var diff: Vector2 = target_pos - global_position
	var preferred_dirs := []
	if abs(diff.x) > abs(diff.y):
		preferred_dirs = [Vector2(sign(diff.x), 0), Vector2(0, sign(diff.y))]
	else:
		preferred_dirs = [Vector2(0, sign(diff.y)), Vector2(sign(diff.x), 0)]

	# Move in the first valid direction that doesn’t hit a wall
	for dir in preferred_dirs:
		if _can_move(dir):
			current_dir = dir
			_update_sprite_direction()
			_move_in_direction(dir)
			break

func _can_move(dir: Vector2) -> bool:
	ray.target_position = dir * tile_size * 0.7
	ray.force_raycast_update()
	return not ray.is_colliding()

func _move_in_direction(dir: Vector2) -> void:
	moving = true
	var tween := create_tween()
	tween.tween_property(self, "global_position",
		global_position + dir * tile_size, tile_size / speed).set_trans(Tween.TRANS_LINEAR)
	await tween.finished
	moving = false

func _update_sprite_direction():
	if current_dir.y > 0:
		sprite.texture = load('res://pacman/Assets/Ghost/Ghost_Eyes_Down.png')
	elif current_dir.y < 0:
		sprite.texture = load('res://pacman/Assets/Ghost/Ghost_Eyes_Up.png')
	elif current_dir.x > 0:
		sprite.texture = load('res://pacman/Assets/Ghost/Ghost_Eyes_Right.png')
	elif current_dir.x < 0:
		sprite.texture = load('res://pacman/Assets/Ghost/Ghost_Eyes_Left.png')
