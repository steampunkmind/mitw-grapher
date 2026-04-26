class_name GovernorGraph extends Graph

var _governor: Governor 

var _governor_action_graphs: Dictionary[String, GovernorActionGraph]
@export var governor_action_graph_template: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func init (governor: Governor, y: float):
	_governor = governor
	$Name.text = governor.get_name()
	var p = get_position()
	p.y = y
	set_position(p)
	_add_governor_action_graphs()


func _add_governor_action_graphs() -> void:
	if _governor_action_graphs.size() > 0:
		for governor_action_graph: GovernorActionGraph in _governor_action_graphs.values():
			remove_child(governor_action_graph)
		_governor_action_graphs.clear()
	
	var header_margin = 158
	var row_margin = 2
	var row_location = header_margin
	var header_width = 0.0
	for action: Action in MITW.aim_model().get_behavioral_actions():
		var graph = governor_action_graph_template.instantiate()
		graph.init(_governor, action, row_location)
		var min_header_width = graph.get_min_header_width()
		if header_width < min_header_width:
			header_width = min_header_width
		
		add_child(graph)
		_governor_action_graphs.set(action.get_name(), graph)
		row_location = row_location + graph.size.y + row_margin
		
	var min_size = get_custom_minimum_size()
	min_size.y = row_location
	set_custom_minimum_size(min_size)



func get_min_header_width() -> float:
	var result = $Name.get_minimum_size().x + $SensorMax.size.x + 20
	for governor_action_graph: GovernorActionGraph in _governor_action_graphs.values():
		var width = governor_action_graph.get_min_header_width()
		if result < width:
			result = width
			
	return result


func set_header_width(value: float) -> void:
	_init_label_x($GovLabel, value - $GovLabel.size.x - 6)
	_init_label_x($ErrorLabel, value - $ErrorLabel.size.x - 6)
	
	var label_x = value - 4 - $SensorMax.size.x
	_init_label_x($SensorMax, label_x)
	_init_label_x($SensorMin, label_x)
	_init_label_x($ErrorMax, label_x)
	_init_label_x($ErrorMin, label_x)
	
	_init_line_x($StartLine, value, true)
	_init_line_x($HorzLine, value - $SensorMax.size.x, false)
	init_governor_line_xy($GraphLine, value, _governor.get_sensor().get_value())
	init_governor_line_xy($ErrorThreshold, value, _governor.error_threshold())
	init_governor_line_xy($ErrorPeak, value, _governor.error_peak())
	init_error_line_xy($ErrorLine, value, 0)
	
	for governor_action_graph: GovernorActionGraph in _governor_action_graphs.values():
		governor_action_graph.set_header_width(value)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_frame_to_graph() -> void:
	$SensorMax.text = str("%d" % _governor.get_sensor().get_max())
	$SensorMin.text = str("%d" % _governor.get_sensor().get_min())
	$ErrorMax.text = str(_governor.error_max())
	add_governor_point($GraphLine, _governor.get_sensor_value())
	add_governor_point($ErrorThreshold, _governor.error_threshold())
	add_governor_point($ErrorPeak, _governor.error_peak())
	add_error_point($ErrorLine, _governor.get_error_value())
	
	for governor_action_graph: GovernorActionGraph in _governor_action_graphs.values():
		governor_action_graph.add_frame_to_graph()


### Utils ###
func init_error_line_xy(line: Line2D, x: float, y: float):
	_init_line_xy(line, x, graph_error_y(y))


func init_governor_line_xy(line: Line2D, x: float, y: float):
	_init_line_xy(line, x, graph_governor_y(y))


func graph_governor_y(y: float) -> float:
	var sensor = _governor.get_sensor()
	return _graph_y(y, sensor.get_min(), sensor.get_max(), 57, 55)


func graph_error_y(y: float) -> float:
	return _graph_y(y, 0.0, _governor.error_max(), 107.5, 2)


func add_error_point(line: Line2D, y: float) -> void:
	_add_point(line, graph_error_y(y))


func add_governor_point(line: Line2D, y: float) -> void:
	_add_point(line, graph_governor_y(y))
