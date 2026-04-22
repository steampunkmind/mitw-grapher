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
		for governor_action_graph: GovernorGraph in _governor_action_graphs.values():
			remove_child(governor_action_graph)
		_governor_action_graphs.clear()
	
	var header_margin = 158
	var row_margin = 1
	var row_location = header_margin
	var header_width = 0.0
	for action: Action in MITW.aim_model().get_actions():
		var graph = governor_action_graph_template.instantiate()
		graph.init(_governor, action, row_location)
		var min_header_width = graph.get_min_header_width()
		if header_width < min_header_width:
			header_width = min_header_width
		
		add_child(graph)
		_governor_action_graphs.set(action.get_name(), graph)
		row_location = row_location + graph.size.y + row_margin


func get_min_header_width() -> float:
	var result = $Name.get_minimum_size().x + $SensorMax.size.x + 20
	for governor_action_graph: GovernorActionGraph in _governor_action_graphs.values():
		var width = governor_action_graph.get_min_header_width()
		if result < width:
			result = width
			
	return result


func set_header_width(value: float) -> void:
	init_label_x($SensorMax, value)
	init_label_x($SensorMin, value)
	init_label_x($ErrorMax, value)
	init_label_x($ErrorMin, value)
	
	init_line_x($StartLine, value, true)
	init_line_x($HorzLine, value - $SensorMax.size.x, false)
	init_line_x($BaseLine, value - $SensorMax.size.x, false)
	init_line_xy($GraphLine, value, _governor.get_sensor().get_value(), true)
	init_line_xy($ErrorThreshold, value, _governor.error_threshold(), true)
	init_line_xy($ErrorPeak, value, _governor.error_peak(), true)
	init_line_xy($ErrorLine, value, 0, false)
	
	for governor_action_graph: GovernorActionGraph in _governor_action_graphs.values():
		governor_action_graph.set_header_width(value)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_frame_to_graph() -> void:
	$SensorMax.text = str("%d" % _governor.get_sensor().get_max())
	$SensorMin.text = str("%d" % _governor.get_sensor().get_min())
	$ErrorMax.text = str(_governor.error_max())
	add_point($GraphLine, _governor.get_sensor_value(), true)
	add_point($ErrorThreshold, _governor.error_threshold(), true)
	add_point($ErrorPeak, _governor.error_peak(), true)
	add_point($ErrorLine, _governor.get_error_value(), false)


### Utils ###
func init_label_x(label: Label, x: float):
	var p = label.position
	p.x = x - 4 - $SensorMax.size.x
	label.set_position(p)


func init_line_xy(line: Line2D, x: float, y: float, top_graph: bool):
	y = graph_y(y, top_graph)
	var point = line.get_point_position(0)
	point.x = x
	point.y = y
	line.set_point_position(0, point)
	point = line.get_point_position(1)
	point.x = x
	point.y = y
	line.set_point_position(1, point)


func graph_y(y: float, top_graph: bool) -> float:
	var value_above_min = y
	var range = _governor.error_max()
	var y_adjust = 107.5
	var y_shift = 2
	if top_graph:
		var sensor = _governor.get_sensor()
		value_above_min = y - sensor.get_min()
		range = sensor.get_max() - sensor.get_min()
		y_adjust = 57
		y_shift = 55
	var ratio = (size.y - y_adjust)/range
	var scaled_value = value_above_min * ratio
	return (size.y - y_shift) - scaled_value;


func add_point(line: Line2D, y: float, top_graph: bool) -> void:
	for i in range(line.get_point_count()):
		var point = line.get_point_position(i)
		point.x = point.x + 1
		line.set_point_position(i, point)
	
	var point = line.get_point_position(line.get_point_count()-1)
	point.x = point.x - 1
	point.y = graph_y(y, top_graph)
	line.add_point(point)
