extends Area2D

@export var tile_size := 24
@export var animation_speed := 1
@export var player_path: NodePath

var speed = 140

var moving := false
var current_dir := Vector2.ZERO
var player: Node2D = null
var directions := [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]

@onready var ray := $RayCast2D
@onready var sprite := $AnimatedSprite2D

var dead := false

func _ready():
	add_to_group("pacman")
	monitoring = true
	monitorable = true
	self.area_entered.connect(Callable(self, "_on_area_entered"))
	sprite.play("default")
	position = position.snapped(Vector2.ONE * (tile_size / 2))
	if player_path != NodePath():
		player = get_node(player_path)

func _physics_process(_delta):
	if player == null or moving or dead:
		return

	var diff := player.global_position - global_position

	# Decide preferred directions like Blinky
	var preferred_dirs := []
	if abs(diff.x) > abs(diff.y):
		preferred_dirs = [Vector2(sign(diff.x), 0), Vector2(0, sign(diff.y))]
	else:
		preferred_dirs = [Vector2(0, sign(diff.y)), Vector2(sign(diff.x), 0)]

	var tried_dirs := preferred_dirs + directions
	for dir in tried_dirs:
		if _can_move(dir):
			current_dir = dir
			_update_rotation()
			_try_move(dir)
			break

func _can_move(dir: Vector2) -> bool:
	ray.target_position = dir * tile_size * 0.7
	ray.force_raycast_update()
	return not ray.is_colliding()

func _try_move(dir: Vector2) -> void:
	if dead:
		return
	ray.target_position = dir * tile_size * 0.7
	ray.force_raycast_update()
	if not ray.is_colliding():
		var move_distance := dir * tile_size
		var duration : float = move_distance.length() / speed  # pixels per second

		var tween := create_tween()
		tween.tween_property(self, "global_position",
			global_position + move_distance, duration).set_trans(Tween.TRANS_LINEAR)

		moving = true
		await tween.finished
		moving = false
	else:
		moving = false


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("ghost"):
		die()

func die() -> void:
	dead = true
	sprite.hide()
	$CollisionShape2D.disabled = true
	current_dir = Vector2.ZERO
	moving = false

	await get_tree().create_timer(3.0).timeout

	global_position = Vector2(-35, 25)
	$CollisionShape2D.disabled = false
	sprite.rotation = 0
	sprite.show()
	sprite.play("default")
	dead = false

	for ghost in get_tree().get_nodes_in_group("ghost"):
		ghost.on_pacman_dead()

func _update_rotation():
	match current_dir:
		Vector2.RIGHT:
			sprite.rotation = 0
		Vector2.LEFT:
			sprite.rotation = PI
		Vector2.UP:
			sprite.rotation = 3 * PI / 2
		Vector2.DOWN:
			sprite.rotation = PI / 2
