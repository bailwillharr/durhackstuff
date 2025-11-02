extends Area2D

@export var speed := 80.0
@export var direction := Vector2.RIGHT
var player_on_log := false
var player_ref: Node = null

func _ready():
	# Grab reference to the player by group name
	player_ref = get_tree().get_first_node_in_group("player")

	# Connect signals (you can also connect them manually in the editor)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(delta):
	# Move the log
	position += direction * speed * delta

	# Wrap around screen horizontally
	if position.x > 900:
		position.x = -100
	elif position.x < -100:
		position.x = 900

	# Move the player if they are standing on the log
	if player_on_log and player_ref:
		player_ref.position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_on_log = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_on_log = false
