class_name ActionGraph extends Graph

func init (header_frame: Array[String]) -> void:
	header_frame.append("action")


func get_min_header_width() -> float:
	return $Name.get_minimum_size().x + (TEXT_MARGIN * 2)


func set_header_width(value: float) -> void:
	_init_label_x($Name, value - $Name.size.x - TEXT_MARGIN)
	_init_line_x($StartLine, value, true)


func add_frame_to_graph(data_frame: Array[float]) -> void:
	pass
