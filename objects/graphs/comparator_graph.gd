class_name ComparatorGraph extends Graph

var _governor: Governor 


func init (governor: Governor, header_frame: Array[String]) -> void:
	_governor = governor
	
	header_frame.append(governor.get_name() + ".sensor_max")
	header_frame.append(governor.get_name() + ".sensor_min")
	header_frame.append(governor.get_name() + ".sensor_value")
	header_frame.append(governor.get_name() + ".error_threshold")
	header_frame.append(governor.get_name() + ".error_peak")
	

func add_frame_to_graph(data_frame: Array[float]) -> void:
	var sensor = _governor.get_sensor()
	var value = sensor.get_max()
	$SensorMax.text = str("%d" % value)
	data_frame.append(value)
	
	value = sensor.get_min()
	$SensorMin.text = str("%d" % value)
	data_frame.append(value)
	
	value = sensor.get_value()
	_add_point($GraphLine, _graph_y(value, sensor.get_min(), sensor.get_max(), 0, 0))
	data_frame.append(value)
	
	value = _governor.error_threshold()
	_add_point($ErrorThreshold, _graph_y(value, sensor.get_min(), sensor.get_max(), 0, 0))
	data_frame.append(value)
	
	value = _governor.error_peak()
	_add_point($ErrorPeak, _graph_y(value, sensor.get_min(), sensor.get_max(), 0, 0))
	data_frame.append(value)


func get_min_header_width() -> float:
	return $Name.get_minimum_size().x + (TEXT_MARGIN * 2)


func set_header_width(value: float) -> void:
	_init_label_x($Name, value - $Name.size.x - TEXT_MARGIN)
	_init_label_x($SensorMax, value - $SensorMax.size.x - TEXT_MARGIN)
	_init_label_x($SensorMin, value - $SensorMin.size.x - TEXT_MARGIN)
	_init_line_x($StartLine, value, true)
	var sensor = _governor.get_sensor()
	var min = sensor.get_min()
	var max = sensor.get_max()
	_init_line_xy($GraphLine, value, _graph_y(sensor.get_value(), min, max, 0, 0))
	_init_line_xy($ErrorThreshold, value, _graph_y(_governor.error_threshold(), min, max, 0, 0))
	_init_line_xy($ErrorPeak, value, _graph_y(_governor.error_peak(), min, max, 0, 0))
