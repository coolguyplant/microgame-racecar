extends MicroGame

@export var level_scenes: Array[PackedScene] = []

@onready var current_level: Node = $CurrentLevel

var _level_index := -1

func _ready() -> void:
	difficulty = GameManager.difficulty_manager.current_difficulty
	print(difficulty)
	_advance_to_next_level()


func _advance_to_next_level() -> void:
	_level_index += 1

	if _level_index >= level_scenes.size():
		GameManager.win()
		return

	_load_level(_level_index)


func _load_level(index: int) -> void:
	_clear_current_level()

	var level: Node2D = level_scenes[index].instantiate()
	level.global_difficulty = difficulty
	current_level.add_child(level)
	level.level_completed.connect(_on_level_completed)
	level.level_failed.connect(_on_level_failed)


func _on_level_completed() -> void:
	_advance_to_next_level()


func _on_level_failed() -> void:
	GameManager.lose()


func _clear_current_level() -> void:
	for child in current_level.get_children():
		child.queue_free()
