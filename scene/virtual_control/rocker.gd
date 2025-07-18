extends TouchScreenButton

@onready var rest_pos := global_position
var drag_offset: Vector2
var finger_index := -1
const DRAG_RADIUS := 16.0

func _input(event: InputEvent) -> void:
	var st := event as InputEventScreenTouch
	if st:
		if st.pressed and finger_index == -1:
			var global_pos := st.position * get_canvas_transform()
			var local_pos := to_local(global_pos)
			var rect := Rect2(Vector2.ZERO, texture_normal.get_size())
			if rect.has_point(local_pos):
				# 按下
				finger_index = st.index
				drag_offset = global_pos - global_position
		elif not st.pressed and st.index == finger_index:
			# 松开
			Input.action_release('move_right')
			Input.action_release('move_left')
			Input.action_release('move_down')
			Input.action_release('move_up')
			finger_index = -1
			global_position = rest_pos
	
	var sd := event as InputEventScreenDrag
	if sd and sd.index == finger_index:
		# 拖动
		var wish_pos = sd.position * get_canvas_transform() - drag_offset
		var movement = (wish_pos - rest_pos).limit_length(DRAG_RADIUS)
		global_position = rest_pos + movement
		
		movement /= DRAG_RADIUS
		if movement.x > 0.333:
			Input.action_press('move_right')
		else:
			Input.action_release('move_right')
		if movement.x < -0.333:
			Input.action_press('move_left')
		else:
			Input.action_release('move_left')
		if movement.y > 0.333:
			Input.action_press('move_down')
		else:
			Input.action_release('move_down')
		if movement.y < -0.333:
			Input.action_press('move_up')
		else:
			Input.action_release('move_up')
