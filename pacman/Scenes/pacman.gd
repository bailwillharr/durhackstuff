extends Area2D

@export var tile_size := 24
@export var animation_speed := 5.0

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
	self.body_entered.connect(Callable(self, "_on_body_entered"))
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
	if not dead:
		ray.target_position = current_dir * (tile_size * 0.7)
		ray.force_raycast_update()
		if not ray.is_colliding():
			var tween := create_tween()
			tween.tween_property(self, "position",
				position + dir * tile_size, 1.0 / animation_speed).set_trans(Tween.TRANS_LINEAR)
			moving = true
			await tween.finished
			moving = false
		else:
			moving = false

# Called when a body enters this Area2D
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("ghost"):
		die()

func die() -> void:
	dead = true
	$AnimatedSprite2D.rotation = 0
	$AnimatedSprite2D.play("death")
	$CollisionShape2D.disabled = true

	# Stop movement
	current_dir = Vector2.ZERO
	moving = false

	await get_tree().create_timer(3.0).timeout

	# Reset position and state
	global_position.x = -35
	global_position.y = 25
	$CollisionShape2D.disabled = false
	$AnimatedSprite2D.play("default")
	dead = false





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
