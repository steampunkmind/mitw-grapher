extends Graph

var _governor: Governor 

const TEXT_MARGIN = 10


func init (governor: Governor, header_frame: Array[String]) -> void:
	_governor = governor
	header_frame.append(governor.get_name() + ".error_value")
	header_frame.append(governor.get_name() + ".error_max")
	header_frame.append(governor.get_name() + ".error_min")
	

func add_frame_to_graph(data_frame: Array[float]) -> void:
	var value = _governor.get_error_value()
	_add_point($ErrorLine, _graph_y(value, 0, _governor.error_max(), 0, 1.5))
	data_frame.append(value)

	value = _governor.error_max()
	$ErrorMax.text = str(value)
	data_frame.append(value)
	
	value = _governor.error_min()
	$ErrorMin.text = str(value)
	data_frame.append(value)
	

func get_min_header_width() -> float:
	return $Name.get_minimum_size().x + TEXT_MARGIN


func set_header_width(value: float) -> void:
	_init_label_x($Name, value - $Name.size.x - 6)
	_init_line_x($StartLine, value, true)
	_init_line_x($ErrorLine, value, false)
	var label_x = value - 4 - $ErrorMax.size.x
	_init_label_x($ErrorMax, label_x)
	_init_label_x($ErrorMin, label_x)
	
