extends Area2D

@export var tile_size := 24
@export var animation_speed := 5       # sprite animation speed
@export var speed := 100               # pixels per second
@export var pacman_path: NodePath
@export var player_path: NodePath      # ☠️ for when Pac-Man’s ghost sets sail
@export var scatter_distance := 5.0    # in tiles

var moving := false
var current_dir := Vector2.ZERO
var pacman: Node2D = null
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
	if player_path != NodePath():
		player = get_node(player_path)

func _physics_process(_delta):
	if pacman == null or moving:
		return

	var target_pos := _get_target_position()
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

func _get_target_position() -> Vector2:
	if chasing_player and player != null:
		# ☠️ When Pac-Man dies, Clyde targets the player
		return player.global_position

	# ⚓ Normal cowardly Clyde logic
	var distance_to_pac := global_position.distance_to(pacman.global_position)
	if distance_to_pac > scatter_distance * tile_size:
		# Far from Pac-Man: chase him
		return pacman.global_position
	else:
		# Close to Pac-Man: scatter to the top-left corner
		return Vector2.ZERO

func _can_move(dir: Vector2) -> bool:
	ray.target_position = dir * tile_size * 0.7
	ray.force_raycast_update()
	return not ray.is_colliding()

func _move_in_direction(dir: Vector2) -> void:
	moving = true
	var move_distance: Vector2 = dir * tile_size
	var duration: float = move_distance.length() / speed  # speed in pixels/sec

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

# ☠️ Call this from yer Pac-Man script when the poor lad dies
func on_pacman_dead():
	if player == null or chasing_player:
		return
	chasing_player = true
	await get_tree().create_timer(10.0).timeout
	chasing_player = false
