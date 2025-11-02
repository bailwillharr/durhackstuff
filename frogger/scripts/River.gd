extends Node2D


@export var log_scene: PackedScene
@export var log_count :=3
@export var river_speed :=20.0
@export var direction := Vector2.RIGHT
@export var river_width := 800

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(log_count):
		var log = log_scene.instantiate()
		add_child(log)
	
		log.direction = direction
		log.speed = river_speed
		log.position = Vector2(randf() * river_width, 0)
	
	pass
	 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
