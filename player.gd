extends ColorRect

@onready var box: ColorRect = $"../Box"
@onready var goal: ColorRect = $"../Goal"
@onready var win_label: Label = $"../WinLabel"

var has_won := false

func _ready() -> void:
	win_label.hide()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_pressed() and not event.is_echo():
		if event.keycode == KEY_R:
			get_tree().reload_current_scene()
			return

	if has_won:
		return

	if not event.is_pressed() or event.is_echo():
		return

	var direction := Vector2.ZERO

	if event.is_action_pressed("ui_right"):
		direction = Vector2.RIGHT
	elif event.is_action_pressed("ui_left"):
		direction = Vector2.LEFT
	elif event.is_action_pressed("ui_down"):
		direction = Vector2.DOWN
	elif event.is_action_pressed("ui_up"):
		direction = Vector2.UP
	else:
		return

	var next_position := position + direction * 64

	if not is_inside_floor(next_position):
		return

	if next_position.is_equal_approx(box.position):
		var box_next_position := box.position + direction * 64

		if not is_inside_floor(box_next_position):
			return

		box.position = box_next_position

	position = next_position
	check_win()

func is_inside_floor(target: Vector2) -> bool:
	return (
		target.x >= 76 and target.x <= 332
		and target.y >= 76 and target.y <= 332
	)

func check_win() -> void:
	var box_center := box.position + box.size / 2
	var goal_center := goal.position + goal.size / 2

	if box_center.is_equal_approx(goal_center):
		has_won = true
		win_label.show()
