extends Area2D


func _ready() -> void:
	monitoring = true
	monitorable = true
	body_entered.connect(Callable(self, "_on_body_entered"))


func _on_body_entered(body: CharacterBody2D) -> void:
	print(body.name)
	get_tree().change_scene_to_file("res://pacman/Scenes/main.tscn")


func _process(delta: float) -> void:
	pass
