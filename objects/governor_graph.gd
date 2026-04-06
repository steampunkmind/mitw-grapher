class_name GovernorGraph extends ColorRect

var _governor: Governor 


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


func set_header_width(value: float) -> void:
	var start_line_point = $StartLine.get_point_position(0)
	start_line_point.x = value
	$StartLine.set_point_position(0, start_line_point)
	start_line_point = $StartLine.get_point_position(1)
	start_line_point.x = value
	$StartLine.set_point_position(1, start_line_point)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
