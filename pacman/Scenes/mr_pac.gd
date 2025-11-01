# # res://pacman_controller.gd
# extends CharacterBody2D

# @export var speed: float = 120.0
# @export var cell_size: int = 32
# @export var tilemap_path: NodePath

# var _tilemap: TileMapLayer
# var _cur_dir: Vector2 = Vector2.ZERO
# var _want_dir: Vector2 = Vector2.ZERO

# func _ready():
# 	if tilemap_path != NodePath():
# 		_tilemap = get_node(tilemap_path)
# 	else:
# 		push_error("Yarrr! Ye forgot to set the TileMap path for Pac-Man!")

# func _physics_process(_delta: float) -> void:
# 	_read_input()

# 	if _is_centered_on_tile():
# 		if _want_dir != Vector2.ZERO and _can_move_in_dir(_want_dir):
# 			_cur_dir = _want_dir
# 		elif not _can_move_in_dir(_cur_dir):
# 			_cur_dir = Vector2.ZERO

# 	velocity = _cur_dir * speed
# 	move_and_slide()

# func _read_input() -> void:
# 	var left = Input.is_action_pressed("ui_left")
# 	var right = Input.is_action_pressed("ui_right")
# 	var up = Input.is_action_pressed("ui_up")
# 	var down = Input.is_action_pressed("ui_down")

# 	if left:
# 		_want_dir = Vector2.LEFT
# 	elif right:
# 		_want_dir = Vector2.RIGHT
# 	elif up:
# 		_want_dir = Vector2.UP
# 	elif down:
# 		_want_dir = Vector2.DOWN

# func _is_centered_on_tile() -> bool:
# 	if _tilemap == null:
# 		return true
# 	var world_pos = global_position
# 	var cell = _tilemap.local_to_map(world_pos)
# 	var cell_center = _tilemap.map_to_local(cell) + Vector2(cell_size / 2.0, cell_size / 2.0)
# 	return world_pos.distance_to(cell_center) < 3.0

# func _can_move_in_dir(dir: Vector2) -> bool:
# 	if dir == Vector2.ZERO or _tilemap == null:
# 		return false
# 	var cur_cell = _tilemap.local_to_map(global_position)
# 	var target_cell = cur_cell + Vector2i(int(dir.x), int(dir.y))
# 	var tile_data = _tilemap.get_cell_source_id(target_cell)
# 	return tile_data == -1  # free space only if -1 (no tile)
pass
