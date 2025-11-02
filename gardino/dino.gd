extends CharacterBody2D

var tile_size = 64
var zone_size = Vector2(17, 10)
var inputs = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}
@onready var ray = $ray
@export var camera_path: NodePath
@onready var camera = get_node(camera_path)
var initial_camera_position = Vector2.ZERO
var animation_speed = 8
var moving = false
var player_tile = Vector2(8, 5)
var player_zone = Vector2.ZERO

func _ready():
	$visuals.play("idle")
	position = position.snapped(Vector2.ZERO)
	# position += Vector2.ONE * tile_size / 2

func _unhandled_input(event):
	if moving:
		return
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			if dir == "right":
				$visuals.flip_h = false
			if dir == "left":
				$visuals.flip_h = true
			$visuals.play("walk")
			move(dir)

			if player_tile.x < 0:
				player_tile.x += zone_size.x
				player_zone += inputs[dir]
				camera_move(dir)
			if player_tile.y < 0:
				player_tile.y += zone_size.y
				player_zone += inputs[dir]
				camera_move(dir)
			if player_tile.x >= zone_size.x or player_tile.y >= zone_size.y:
				player_tile.x = int(player_tile.x) % int(zone_size.x)
				player_tile.y = int(player_tile.y) % int(zone_size.y)
				player_zone += inputs[dir]
				camera_move(dir)

func move(dir):
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		player_tile += inputs[dir]
		var tween = create_tween()
		tween.tween_property(
			self, "position", position + inputs[dir] * tile_size, 1.0 / animation_speed
		).set_trans(Tween.TRANS_BOUNCE)
		moving = true
		await tween.finished
		moving = false
		$visuals.play("idle")


func camera_move(dir):
	var camera_tween = create_tween()
	var offset = Vector2(
		inputs[dir].x * tile_size * zone_size.x,
		inputs[dir].y * tile_size * zone_size.y
	)
	var new_position = camera.position + offset
	camera_tween.tween_property(
		camera, "position", new_position, 0.5
	).set_trans(Tween.TRANS_SINE)
