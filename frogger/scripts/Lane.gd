extends Node2D



@export var car_scene: PackedScene
@export var car_count := 10
@export var lane_speed := 20.0
@export var direction := Vector2.RIGHT
@export var lane_width := 800

# Called when the node enters the scene tree for the first time.

func _ready():
	for i in range(car_count):
		var car = car_scene.instantiate()
		add_child(car)
		car.direction = direction
		car.speed = lane_speed
		car.position = Vector2(randf() * lane_width, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
