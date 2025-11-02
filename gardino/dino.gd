extends CharacterBody2D

var tile_size = 64
var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}
@onready var ray = $ray
var animation_speed = 5
var moving = false

func _ready():
	$visuals.play("idle")
	position = position.snapped(Vector2.ONE * tile_size)
	# position += Vector2.ONE * tile_size / 2

func _unhandled_input(event):
	if moving:
		return
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			if Input.is_action_pressed("right"):
				$visuals.flip_h = false
				velocity.x += 1
			if Input.is_action_pressed("left"):
				$visuals.flip_h = true
			$visuals.play("walk")
			move(dir)
			return
	$visuals.play("idle")

func move(dir):
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		var tween = create_tween()
		tween.tween_property(
			self, "position", position + inputs[dir] * tile_size, 1.0 / animation_speed
		).set_trans(Tween.TRANS_LINEAR)
		moving = true
		await tween.finished
		moving = false
