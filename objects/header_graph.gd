class_name HeaderGraph extends Graph

var _governor: Governor 


func init (governor: Governor):
	_governor = governor
	$Name.text = governor.get_name()


func get_min_header_width() -> float:
	return $Name.get_minimum_size().x + 48


func set_header_width(value: float) -> void:
	pass


func add_frame_to_graph() -> void:
	pass
