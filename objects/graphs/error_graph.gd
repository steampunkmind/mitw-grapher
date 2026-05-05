class_name ErrorGraph extends Graph

var _governor: Governor 


func init (governor: Governor, header_frame: Array[String]) -> void:
	_governor = governor
	header_frame.append(governor.get_name() + ".error_value")
	header_frame.append(governor.get_name() + ".error_max")


func add_frame_to_graph(data_frame: Array[float]) -> void:
	var value = _governor.get_error_value()
	_add_point($ErrorLine, _graph_y(value, 0, _governor.error_max(), 0, 0))
	data_frame.append(value)
	
	value = _governor.error_max()
	$ErrorMax.text = str(value)
	data_frame.append(value)


func get_min_header_width() -> float:
	return $Name.get_minimum_size().x + (TEXT_MARGIN * 2)


func set_header_width(value: float) -> void:
	_init_label_x($Name, value - $Name.size.x - TEXT_MARGIN)
	_init_label_x($ErrorMax, value - $ErrorMax.size.x - TEXT_MARGIN)
	_init_line_x($StartLine, value, true)
	_init_line_x($ErrorLine, value, false)
