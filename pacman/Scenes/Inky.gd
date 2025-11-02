extends Area2D

@export var tile_size := 24
@export var animation_speed := 5        # sprite animation speed
@export var speed := 100               # pixels/sec
@export var pacman_path: NodePath
@export var blinky_path: NodePath
@export var player_path: NodePath       # ☠️ the player ye be targetin’ when Pac-Man dies!
@export var ahead_distance := 2         # tiles ahead of Pacman

var moving := false
var current_dir := Vector2.ZERO
var pacman: Node2D = null
var blinky: Node2D = null
var player: Node2D = null
var chasing_player := false
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
	if player_path != NodePath():
		player = get_node(player_path)

func _physics_process(_delta):
	if moving or pacman == null or blinky == null:
		return

	var target_pos := _get_target_position()
	var diff := target_pos - global_position

	# Prefer horizontal or vertical movement depending on larger distance
	var preferred_dirs := []
	if abs(diff.x) > abs(diff.y):
		preferred_dirs = [Vector2(sign(diff.x), 0), Vector2(0, sign(diff.y))]
	else:
		preferred_dirs = [Vector2(0, sign(diff.y)), Vector2(sign(diff.x), 0)]

	var tried_dirs := preferred_dirs + directions
	for dir in tried_dirs:
		if _can_move(dir):
			current_dir = dir
			_update_sprite_direction()
			_move_in_direction(dir)
			break

func _get_target_position() -> Vector2:
	if chasing_player and player != null:
		# 🏴‍☠️ Chase the player directly when Pac-Man’s dead
		return player.global_position

	# ⚓ Normal Inky logic:
	var pac_dir := Vector2.ZERO
	if "current_dir" in pacman:
		pac_dir = pacman.current_dir
	var ahead_pos := pacman.global_position + pac_dir * ahead_distance * tile_size
	var vec_from_blinky := ahead_pos - blinky.global_position
	return blinky.global_position + vec_from_blinky * 2.0

func _can_move(dir: Vector2) -> bool:
	ray.target_position = dir * tile_size * 0.7
	ray.force_raycast_update()
	return not ray.is_colliding()

func _move_in_direction(dir: Vector2) -> void:
	moving = true
	var move_distance: Vector2 = dir * tile_size
	var duration: float = move_distance.length() / speed

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

# ☠️ When Pac-Man dies, call this from yer Pac-Man script:
func on_pacman_dead():
	if player == null or chasing_player:
		return
	chasing_player = true
	await get_tree().create_timer(10.0).timeout
	chasing_player = false
