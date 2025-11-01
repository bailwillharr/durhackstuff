extends AnimatedSprite2D

@export var speed = 200.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var going_left = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_right"):
		going_left = false
		self.play("right")
		position.x += delta * speed
	elif Input.is_action_pressed("ui_left"):
		going_left = true;
		self.play("left")
		position.x -= delta * speed
	else:
		if going_left:
			self.play("idle_left")
		else:
			self.play("idle_right")
			
	if Input.is_action_just_pressed("up"):
		pass
