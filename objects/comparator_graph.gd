class_name ComparatorGraph extends Graph

var _governor: Governor 

const TEXT_MARGIN = 10


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func init (governor: Governor) -> void:
	_governor = governor


func get_min_header_width() -> float:
	var result = $ComparatorLabel.get_minimum_size().x + TEXT_MARGIN
	if result < $ErrorLabel.get_minimum_size().x + TEXT_MARGIN:
		result = $ErrorLabel.get_minimum_size().x + TEXT_MARGIN
		
	return result


func set_header_width(value: float) -> void:
	_init_label_x($ComparatorLabel, value - $ComparatorLabel.size.x - 6)
	_init_label_x($ErrorLabel, value - $ErrorLabel.size.x - 6)
	
	var label_x = value - 4 - $SensorMax.size.x
	_init_label_x($SensorMax, label_x)
	_init_label_x($SensorMin, label_x)
	_init_label_x($ErrorMax, label_x)
	_init_label_x($ErrorMin, label_x)
	
	_init_line_x($StartLine, value, true)
	_init_line_x($HorzLine, value - $SensorMax.size.x, false)
	init_governor_line_xy($GraphLine, value, _governor.get_sensor().get_value())
	init_governor_line_xy($ErrorThreshold, value, _governor.error_threshold())
	init_governor_line_xy($ErrorPeak, value, _governor.error_peak())
	init_error_line_xy($ErrorLine, value, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_frame_to_graph(data_frame: Array[float]) -> void:
	
	var value = _governor.get_sensor().get_max()
	$SensorMax.text = str("%d" % value)
	data_frame.append(value)
	
	value = _governor.get_sensor().get_min()
	$SensorMin.text = str("%d" % value)
	data_frame.append(value)
	
	value = _governor.error_max()
	$ErrorMax.text = str(value)
	data_frame.append(value)
	
	value = _governor.get_sensor_value()
	add_governor_point($GraphLine, value)
	data_frame.append(value)
	
	value = _governor.error_threshold()
	add_governor_point($ErrorThreshold, value)
	data_frame.append(value)
	
	value = _governor.error_peak()
	add_governor_point($ErrorPeak, value)
	data_frame.append(value)
	
	value = _governor.get_error_value()
	add_error_point($ErrorLine, value)
	data_frame.append(value)


### Utils ###
func init_error_line_xy(line: Line2D, x: float, y: float):
	_init_line_xy(line, x, graph_error_y(y))


func init_governor_line_xy(line: Line2D, x: float, y: float):
	_init_line_xy(line, x, graph_governor_y(y))


func graph_governor_y(y: float) -> float:
	var sensor = _governor.get_sensor()
	return _graph_y(y, sensor.get_min(), sensor.get_max(), 055, 55) # this is no longer right because fo graph height change


func graph_error_y(y: float) -> float:
	return _graph_y(y, 0.0, _governor.error_max(), 107.5, 2)


func add_error_point(line: Line2D, y: float) -> void:
	_add_point(line, graph_error_y(y))


func add_governor_point(line: Line2D, y: float) -> void:
	_add_point(line, graph_governor_y(y))
