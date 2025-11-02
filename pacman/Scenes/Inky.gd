extends Area2D

@export var tile_size := 24
@export var animation_speed := 24
@export var pacman_path: NodePath
@export var blinky_path: NodePath
@export var ahead_distance := 2  # tiles ahead of Pacman for calculation

var moving := false
var current_dir := Vector2.ZERO
var pacman: Node2D = null
var blinky: Node2D = null
var directions := [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]

@onready var ray := $RayCast2D
@onready var sprite := $AnimatedSprite2D

func _ready():
	add_to_group("ghost")
	sprite.play("default")
	position = position.snapped(Vector2.ONE * (tile_size / 2))

	if pacman_path != NodePath():
		pacman = get_node(pacman_path)
	if blinky_path != NodePath():
		blinky = get_node(blinky_path)

func _physics_process(_delta):
	if pacman == null or blinky == null or moving:
		return

	# Step 1: get position a few tiles in front of Pacman
	var pac_dir := Vector2.ZERO
	if "current_dir" in pacman:
		pac_dir = pacman.current_dir
	var ahead_pos := pacman.global_position + pac_dir * ahead_distance * tile_size

	# Step 2: vector from Blinky to that position
	var vec_from_blinky := ahead_pos - blinky.global_position

	# Step 3: double it to get Inky’s target
	var target_pos := blinky.global_position + vec_from_blinky * 2.0

	# Step 4: move toward that target
	var diff := target_pos - global_position

	# Prefer horizontal or vertical movement depending on larger distance
	var preferred_dirs := []
	if abs(diff.x) > abs(diff.y):
		preferred_dirs = [Vector2(sign(diff.x), 0), Vector2(0, sign(diff.y))]
	else:
		preferred_dirs = [Vector2(0, sign(diff.y)), Vector2(sign(diff.x), 0)]

	# Try preferred directions first, then fallback
	var tried_dirs := preferred_dirs + directions
	for dir in tried_dirs:
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
		global_position + dir * tile_size, tile_size / animation_speed).set_trans(Tween.TRANS_LINEAR)
	await tween.finished
	moving = false

func _update_sprite_direction():
	match current_dir: 
		Vector2.RIGHT: 
			$Sprite2D.texture = load('res://pacman/Assets/Ghost/Ghost_Eyes_Right.png') 
		Vector2.LEFT: 
			$Sprite2D.texture = load('res://pacman/Assets/Ghost/Ghost_Eyes_Left.png') 
		Vector2.UP: 
			$Sprite2D.texture = load('res://pacman/Assets/Ghost/Ghost_Eyes_Up.png') 
		Vector2.DOWN: 
			$Sprite2D.texture = load('res://pacman/Assets/Ghost/Ghost_Eyes_Down.png')
