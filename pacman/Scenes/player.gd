extends Area2D

@export var tile_size := 24
@export var animation_speed := 1

var speed = 150

var moving := false
var current_dir := Vector2.ZERO
var inputs := {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}

@onready var ray := $RayCast2D
@onready var sprite := $AnimatedSprite2D

var dead = false;

func _ready():
	add_to_group("player")
	monitoring = true   # must be enabled
	monitorable = true  # optional but good
	self.area_entered.connect(Callable(self, "_on_area_entered"))
	sprite.play("default")
	position = position.snapped(Vector2.ONE * (tile_size / 2))

func _unhandled_input(event):
	# If input is pressed, change desired direction
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			current_dir = inputs[dir]
			_update_rotation()

func _physics_process(_delta):
	if not moving and current_dir != Vector2.ZERO:
		_try_move(current_dir)

func _try_move(dir: Vector2) -> void:
	if dead:
		return

	ray.target_position = dir * tile_size * 0.7
	ray.force_raycast_update()
	if not ray.is_colliding():
		var move_distance: Vector2 = dir * tile_size
		var duration: float = move_distance.length() / speed  # speed in pixels/sec

		var tween := create_tween()
		tween.tween_property(self, "global_position",
			global_position + move_distance, duration).set_trans(Tween.TRANS_LINEAR)

		moving = true
		await tween.finished
		moving = false
	else:
		moving = false


# Called when a body enters this Area2D
func _on_area_entered(area: Area2D) -> void:
	print(area.name)
	if area.is_in_group("ghost") or area.is_in_group("pacman"):
		die()
		
func die() -> void:
	dead = true
	$AnimatedSprite2D.hide()           # hide the sprite
	$CollisionShape2D.disabled = true  # disable collisions
	current_dir = Vector2.ZERO
	moving = false

	await get_tree().create_timer(3.0).timeout

	# Reset position and state
	global_position = Vector2(-12, 360)
	$CollisionShape2D.disabled = false
	$AnimatedSprite2D.show()           # show the sprite again
	$AnimatedSprite2D.play("default")
	dead = false






func _update_rotation():
	match current_dir:
		Vector2.RIGHT:
			sprite.flip_h = false
			sprite.rotation = 0
		Vector2.LEFT:
			sprite.flip_h = true
			sprite.rotation = 0
		Vector2.UP:
			sprite.rotation = PI / 2
		Vector2.DOWN:
			sprite.rotation = -1 * PI / 2
