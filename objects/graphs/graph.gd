class_name Graph extends ColorRect

const TEXT_MARGIN = 6


func get_min_header_width() -> float:
	return 0


func set_header_width(value: float) -> void:
	pass


func add_frame_to_graph(data_frame: Array[float]) -> void:
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
	point = line.get_point_position(1)
	point.x = x
	point.y = y
	line.set_point_position(1, point)


func _graph_y(y: float, min: float, max: float, y_adjust: float, y_shift: float) -> float:
	var ratio = (size.y - y_adjust)/(max - min)
	var scaled_value = (y - min) * ratio
	var graph_y = (size.y - y_shift) - scaled_value;
	if graph_y > size.y - 1:
		graph_y = size.y - 1
	if graph_y < 1:
		graph_y = 1
	return graph_y


func _add_point(line: Line2D, y: float) -> void:
	for i in range(line.get_point_count()):
		var point = line.get_point_position(i)
		point.x = point.x + 1
		line.set_point_position(i, point)
	
	var point = line.get_point_position(line.get_point_count()-1)
	point.x = point.x - 1
	point.y = y
	line.add_point(point)
