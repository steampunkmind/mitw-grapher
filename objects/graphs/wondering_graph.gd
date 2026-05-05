class_name WonderingGraph extends Graph


func init (header_frame: Array[String]) -> void:
	header_frame.append("wondering_value")
	header_frame.append("wondering_max")


func add_frame_to_graph(data_frame: Array[float]) -> void:
	var value = MITW.get_wondering_value()
	var max = MITW.get_wondering_max()
	_add_point($WonderingLine, _graph_y(value, 0, max, 0, 0))
	data_frame.append(value)
	
	$WonderingMax.text = str(max)
	data_frame.append(max)
	

func get_min_header_width() -> float:
	return $Name.get_minimum_size().x + (TEXT_MARGIN * 2)


func set_header_width(value: float) -> void:
	_init_label_x($Name, value - $Name.size.x - TEXT_MARGIN)
	_init_label_x($WonderingMax, value - $WonderingMax.size.x - TEXT_MARGIN)
	_init_line_x($StartLine, value, true)
	_init_line_x($WonderingLine, value, false)
