## CLYDE
extends CharacterBody2D

@export var speed: float = 100.0
const TILE_SIZE: float = 16.0

var pacman: Node2D = null

# Wanderin’ state
var target_distance: float = 0.0
var distance_travelled: float = 0.0
var dir: Vector2 = Vector2.ZERO

func _ready() -> void:
	add_to_group("ghost")
	$AnimatedSprite2D.play("default")
	choose_new_direction()

func choose_new_direction() -> void:
	var dirs = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
	dir = dirs[randi() % dirs.size()]
	
	# Choose a random number of tiles (3–7)
	target_distance = randf_range(3.0, 7.0) * TILE_SIZE
	distance_travelled = 0.0
	
	if dir == Vector2.UP:
		$Sprite2D.texture = load('res://pacman/Assets/Ghost/Ghost_Eyes_Up.png')
	elif dir == Vector2.DOWN:
		$Sprite2D.texture = load('res://pacman/Assets/Ghost/Ghost_Eyes_Down.png')
	elif dir == Vector2.LEFT:
		$Sprite2D.texture = load('res://pacman/Assets/Ghost/Ghost_Eyes_Left.png')
	elif dir == Vector2.RIGHT:
		$Sprite2D.texture = load('res://pacman/Assets/Ghost/Ghost_Eyes_Right.png')

func _physics_process(_delta: float) -> void:
	velocity = dir * speed
	var old_pos = global_position
	move_and_slide()
	
	distance_travelled += (global_position - old_pos).length()
	
	if distance_travelled >= target_distance:
		choose_new_direction()
