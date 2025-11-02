extends Area2D

func _ready():
    monitoring = true
    monitorable = true
    self.area_entered.connect(Callable(self, "_on_area_entered"))

func _on_area_entered(area: Area2D) -> void:
    if area.is_in_group("player"):
        queue_free()
        get_parent().pellet_eaten(self)
