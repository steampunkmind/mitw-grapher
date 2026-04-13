class_name GovernorGraph extends ColorRect

var _governor: Governor 
var _header_width: float = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func init (governor: Governor, y: float):
	_governor = governor
	$Name.text = governor.get_name()
	var p = get_position()
	p.y = y
	set_position(p)


func get_min_header_width() -> float:
	return $Name.get_minimum_size().x + 14


func set_header_width(value: float) -> void:
	_header_width = value
	init_line_x($StartLine, value, true)
	init_line_x($HorzLine, value, false)
	init_line_xy($GraphLine, value, _governor.get_sensor().get_value(), true)
	init_line_xy($ErrorThreshold, value, _governor.error_threshold(), true)
	init_line_xy($ErrorPeak, value, _governor.error_peak(), true)
	init_line_xy($ErrorLine, value, 0, false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_frame_to_graph() -> void:
	add_point($GraphLine, _governor.get_sensor_value(), true)
	add_point($ErrorThreshold, _governor.error_threshold(), true)
	add_point($ErrorPeak, _governor.error_peak(), true)
	add_point($ErrorLine, _governor.get_error_value(), false)


### Utils ###
func init_line_x(line: Line2D, x: float, both: bool):
	var point = line.get_point_position(0)
	point.x = x
	line.set_point_position(0, point)
	if both:
		point = line.get_point_position(1)
		point.x = x
		line.set_point_position(1, point)


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
