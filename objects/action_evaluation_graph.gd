class_name ActionEvaluationGraph extends Graph

var _governor: Governor
var _action: Action


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func init (governor: Governor, action: Action):
	_governor = governor
	_action = action
	$Name.text = action.get_name()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_frame_to_graph() -> void:
	var range = _governor.percept_range() * .25 # Zoom level 4x
	var y = _governor.get_action_evaluation_value(_action)
	
	if y < -range:
		y = -range
		
	if y > range:
		y = range
		
	_add_point($EvaluationLine, _graph_y(y, -range, range, 0, 0))


func get_min_header_width() -> float:
	return $Name.get_minimum_size().x + 10


func set_header_width(value: float) -> void:
	_init_label_x($Name, value - $Name.size.x - 6)
	_init_line_x($StartLine, value, true)
	_init_line_x($EvaluationLine, value, false)
