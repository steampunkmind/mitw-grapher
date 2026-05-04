class_name TotalErrorGraph extends Graph

const TEXT_MARGIN = 10

func init (header_frame: Array[String]) -> void:
	header_frame.append("total_error_value")


func add_frame_to_graph(data_frame: Array[float]) -> void:
	var value = 0 #_governor.get_error_value()
	for governor: Governor in MITW.gam_model().get_governors():
		value += governor.get_error_value()
		
	_add_point($ErrorLine, _graph_y(value, 0, 1, 0, 1))
	data_frame.append(value)


func get_min_header_width() -> float:
	return $Name.get_minimum_size().x + TEXT_MARGIN


func set_header_width(value: float) -> void:
	_init_label_x($Name, value - $Name.size.x - 6)
	_init_line_x($StartLine, value, true)
	_init_line_x($ErrorLine, value, false)
