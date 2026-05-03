class_name ActionEvaluationGraph extends Graph

var _governor: Governor
var _action: Action


func init (governor: Governor, action: Action, header_frame: Array[String]):
	_governor = governor
	_action = action
	$Name.text = action.get_name()
	
	header_frame.append(governor.get_name() + "." + action.get_name() + ".evaluation")


func add_frame_to_graph(data_frame: Array[float]) -> void:
	# all of this code is to zoom in the action evaluation so it can be seen better
	# Hopefully it can be removed someday 
	var range = _governor.percept_range() * .25 # Zoom level 4x
	var y = _governor.get_action_evaluation_value(_action)
	
	if y < -range:
		y = -range
		
	if y > range:
		y = range
		
	_add_point($EvaluationLine, _graph_y(y, -range, range, 1, 0))
	data_frame.append(y)


func get_min_header_width() -> float:
	return $Name.get_minimum_size().x + 10


func set_header_width(value: float) -> void:
	_init_label_x($Name, value - $Name.size.x - 6)
	_init_line_x($StartLine, value, true)
	_init_line_x($EvaluationLine, value, false)
