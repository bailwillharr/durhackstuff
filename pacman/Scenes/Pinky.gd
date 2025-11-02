extends Area2D

@export var tile_size := 24
@export var animation_speed := 5        # sprite animation speed
@export var speed := 50               # pixels per second
@export var pacman_path: NodePath
@export var ambush_distance := 4        # tiles ahead of Pacman

var moving := false
var current_dir := Vector2.ZERO
var pacman: Node2D = null
var directions := [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]

@onready var ray := $RayCast2D
@onready var sprite := $AnimatedSprite2D

func _ready():
	add_to_group("ghost")
	sprite.play("default")
	position = position.snapped(Vector2.ONE * (tile_size / 2))
	if pacman_path != NodePath():
		pacman = get_node(pacman_path)

func _physics_process(_delta):
	if pacman == null or moving:
		return

	# Predict Pacman's position a few tiles ahead
	var pac_dir := Vector2.ZERO
	if "current_dir" in pacman:
		pac_dir = pacman.current_dir
	var target_pos := pacman.global_position + pac_dir * ambush_distance * tile_size

	var diff := target_pos - global_position

	# Prefer horizontal or vertical movement depending on larger distance
	var preferred_dirs := []
	if abs(diff.x) > abs(diff.y):
		preferred_dirs = [Vector2(sign(diff.x), 0), Vector2(0, sign(diff.y))]
	else:
		preferred_dirs = [Vector2(0, sign(diff.y)), Vector2(sign(diff.x), 0)]

	# Try each preferred direction first, then fall back to others if blocked
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
	var move_distance: Vector2 = dir * tile_size
	var duration: float = move_distance.length() / speed  # pixels/sec

	var tween := create_tween()
	tween.tween_property(self, "global_position",
		global_position + move_distance, duration).set_trans(Tween.TRANS_LINEAR)
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
