class_name Graph extends ColorRect

var _header_width: float

const TEXT_MARGIN = 4


func get_min_header_width() -> float:
	return 0


func set_header_width(value: float) -> void:
	_header_width = value


func add_frame_to_graph(_data_frame: Array[float]) -> void:
	pass


### Utils ###
func _init_label_x(label: Label, x: float):
	var p = label.position
	p.x = x
	label.set_position(p)


func _init_line_x(line: Line2D, x: float, both: bool):
	var point = line.get_point_position(0)
	point.x = x
	line.set_point_position(0, point)
	if both:
		point = line.get_point_position(1)
		point.x = x
		line.set_point_position(1, point)


func _init_line_xy(line: Line2D, x: float, y: float):
	var point = line.get_point_position(0)
	point.x = x
	point.y = y
	line.set_point_position(0, point)
	if line.get_point_count() > 1:
		point = line.get_point_position(1)
		point.x = x
		point.y = y
		line.set_point_position(1, point)


func _graph_y(y: float, _min: float, _max: float, y_adjust: float, y_shift: float) -> float:
	var ratio = (size.y - y_adjust)/(_max - _min)
	var scaled_value = (y - _min) * ratio
	var graph_y = (size.y - y_shift) - scaled_value;
	if graph_y > size.y - 1:
		graph_y = size.y - 1
	if graph_y < 1:
		graph_y = 1
	return graph_y


func _add_point(line: Line2D, y: float) -> void:
	
	if line.get_point_count() > size.x - _header_width:
		line.remove_point(0)
		
	for i in range(line.get_point_count()):
		var p = line.get_point_position(i)
		p.x = p.x + 1
		line.set_point_position(i, p)
		
	var point = line.get_point_position(line.get_point_count()-1)
	point.x = point.x - 1
	point.y = y
	line.add_point(point)
