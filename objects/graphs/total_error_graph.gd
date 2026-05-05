class_name TotalErrorGraph extends Graph


func init (header_frame: Array[String]) -> void:
	header_frame.append("total_error_value")


func add_frame_to_graph(data_frame: Array[float]) -> void:
	var value = 0
	var max = 0
	for governor: Governor in MITW.gam_model().get_governors():
		value += governor.get_error_value()
		max += governor.error_max()
		
	_add_point($ErrorLine, _graph_y(value, 0, max, 0, 0))
	data_frame.append(value)


func get_min_header_width() -> float:
	return $Name.get_minimum_size().x + (TEXT_MARGIN * 2)


func set_header_width(value: float) -> void:
	_init_label_x($Name, value - $Name.size.x - TEXT_MARGIN)
	_init_line_x($StartLine, value, true)
	_init_line_x($ErrorLine, value, false)
