## PINKY
extends CharacterBody2D

@export var speed: float = 100.0
@export var pacman_path: NodePath
@export var bug_mode: bool = true  # Toggle to mimic the original arcade bug

const TILE_SIZE: float = 16.0

var pacman: Node2D = null

func _ready() -> void:
	$AnimatedSprite2D.play("default")
	if pacman_path != NodePath():
		pacman = get_node(pacman_path)

func _physics_process(delta: float) -> void:
	if pacman == null:
		return

	var ahead_pos: Vector2
	
	if pacman.velocity.length() > 0:
		var dir = pacman.velocity.normalized()
		ahead_pos = pacman.global_position + dir * 4 * TILE_SIZE

		# Apply the "arcade bug" if enabled
		if bug_mode and dir == Vector2.UP:
			ahead_pos += Vector2(-4, 0) * TILE_SIZE
	else:
		ahead_pos = pacman.global_position

	# Calculate target difference
	var diff: Vector2 = ahead_pos - global_position

	# Move horizontally or vertically toward the target
	var move_dir: Vector2 = Vector2.ZERO
	if abs(diff.x) > abs(diff.y):
		move_dir.x = sign(diff.x)
	else:
		move_dir.y = sign(diff.y)

	# Eye textures, arr!
	if move_dir.y > 0:
		$Sprite2D.texture = load('res://pacman/Assets/Ghost/Ghost_Eyes_Down.png')
	elif move_dir.y < 0:
		$Sprite2D.texture = load('res://pacman/Assets/Ghost/Ghost_Eyes_Up.png')
	elif move_dir.x > 0:
		$Sprite2D.texture = load('res://pacman/Assets/Ghost/Ghost_Eyes_Right.png')
	elif move_dir.x < 0:
		$Sprite2D.texture = load('res://pacman/Assets/Ghost/Ghost_Eyes_Left.png')

	velocity = move_dir * speed
	move_and_slide()
