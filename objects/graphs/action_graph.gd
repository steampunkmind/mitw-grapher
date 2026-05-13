class_name ActionGraph extends Graph

var action_names: Array[Control]
var action_lines: Array[Node2D]


func init (header_frame: Array[String]) -> void:
	header_frame.append("action")


func get_min_header_width() -> float:
	return 0


func set_header_width(value: float) -> void:
	super.set_header_width(value)
	_init_label_x($ActionNameTemplate, value - $ActionNameTemplate.size.x - TEXT_MARGIN)
	var p = $ActionLineTemplate.position
	p.x = value + 1
	$ActionLineTemplate.set_position(p)


func add_frame_to_graph(_data_frame: Array[float]) -> void:
	var action: Action = MITW.get_frame_action() 
	if action != null:
		_set_action(action)
		_data_frame.append(MITW.aim_model().get_actions().find(action) + 1)
	else:
		_data_frame.append(0)
	
	var erase_name
	for control: Control in action_names:
		if (control.position.x + control.size.x + TEXT_MARGIN < size.x):
			control.position.x = control.position.x + 1
		else:
			remove_child(control)
			erase_name = control
	if erase_name:
		action_names.erase(erase_name)
	
	var erase_line
	for node in action_lines:
		if (node.position.x < size.x):
			node.position.x = node.position.x + 1
		else:
			remove_child(node)
			erase_line = node
	if erase_line:
		action_lines.erase(erase_line)


func _set_action(action: Action) -> void:
		var new_action_name = $ActionNameTemplate.duplicate(1)
		new_action_name.visible = true
		new_action_name.text = action.get_name()
		add_child(new_action_name)
		action_names.insert(0, new_action_name)
	
		var new_action_line = $ActionLineTemplate.duplicate(1)
		new_action_line.visible = true
		add_child(new_action_line)
		action_lines.insert(0, new_action_line)
