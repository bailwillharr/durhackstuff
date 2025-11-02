extends CharacterBody2D

@export var hop_distance := 32
@export var hop_speed := 10.0

var moving := false
var target_position: Vector2

func _ready():
    target_position = position
    add_to_group("player")  # let logs find you

func _physics_process(delta):
    if moving:
        position = position.move_toward(target_position, hop_speed)
        if position == target_position:
            moving = false

func _input(event):
    if moving:
        return
    if event.is_action_pressed("ui_up"):
        hop(Vector2.UP)
    elif event.is_action_pressed("ui_down"):
        hop(Vector2.DOWN)
    elif event.is_action_pressed("ui_left"):
        hop(Vector2.LEFT)
    elif event.is_action_pressed("ui_right"):
        hop(Vector2.RIGHT)

func hop(dir: Vector2):
    target_position = position + dir * hop_distance
    moving = true
