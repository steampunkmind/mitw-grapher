class_name GovernorGraph extends ColorRect

var _governor: Governor 
var _header_width: float = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func init (governor: Governor, y: float):
	_governor = governor
	$Name.text = governor.get_name()
	var p = get_position()
	p.y = y
	set_position(p)


func get_min_header_width() -> float:
	return $Name.get_minimum_size().x + 14


func set_header_width(point_x: float) -> void:
	_header_width = point_x
	# Init start line
	var point = $StartLine.get_point_position(0)
	point.x = point_x
	$StartLine.set_point_position(0, point)
	point = $StartLine.get_point_position(1)
	point.x = point_x
	$StartLine.set_point_position(1, point)
	# Init graph line
	point = $GraphLine.get_point_position(0)
	point.x = point_x
	point.y = point_y()
	$GraphLine.set_point_position(0, point)
	point = $GraphLine.get_point_position(1)
	point.x = point_x
	point.y = point_y()
	$GraphLine.set_point_position(1, point)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_frame_to_graph() -> void:
	var line = $GraphLine
		
	# Move points to right
	for i in range(line.get_point_count()):
		var point = line.get_point_position(i)
		point.x = point.x + 1
		line.set_point_position(i, point)
		
	# Remove if off right side
	if (line.get_point_position(0).x > size.x):
		line.remove_point(0)
	
	# Add new point
	var point = line.get_point_position(line.get_point_count()-1)
	point.x = point.x - 1
	point.y = point_y()
	line.add_point(point)


### Utils ###	
func point_y() -> float:
	var sensor = _governor.get_sensor()
	var value_above_min = sensor.get_value() - sensor.get_min()
	var range = sensor.get_max() - sensor.get_min()
	var ratio = size.y/range
	var scaled_value = value_above_min * ratio
	return size.y - scaled_value;
