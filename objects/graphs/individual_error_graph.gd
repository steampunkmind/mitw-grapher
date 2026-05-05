class_name IndividualErrorGraph extends Graph


func init (header_frame: Array[String]) -> void:
	header_frame.append("individual_error_value")
	header_frame.append("individual_error_max")
	header_frame.append("individual_error_min")


func add_frame_to_graph(data_frame: Array[float]) -> void:
	var value = 0
	var max = 0
	var min = 999999
	for governor: Governor in MITW.gam_model().get_governors():
		var e = governor.get_error_value()
		if value < e: 
			value = e
		e = governor.error_max()
		if max < e: 
			max = e
		e = governor.error_min()
		if min > e: 
			min = e
		
	_add_point($ErrorLine, _graph_y(value, 0, max, 0, 0))
	data_frame.append(value)
	
	$ErrorMax.text = str(max)
	data_frame.append(max)
	
	$ErrorMin.text = str(min)
	data_frame.append(min)


func get_min_header_width() -> float:
	return $Name.get_minimum_size().x + (TEXT_MARGIN * 2)


func set_header_width(value: float) -> void:
	_init_label_x($Name, value - $Name.size.x - TEXT_MARGIN)
	_init_label_x($ErrorMax, value - $ErrorMax.size.x - TEXT_MARGIN)
	_init_label_x($ErrorMin, value - $ErrorMin.size.x - TEXT_MARGIN)
	_init_line_x($StartLine, value, true)
	_init_line_x($ErrorLine, value, false)
	
