class_name GovernorRow extends Control

var _governor: Governor 


func init (governor: Governor):
	_governor = governor
	$Name.text = governor.get_name()


func get_min_header_width() -> float:
	var result = $Name.get_minimum_size().x + 54
	return result


func set_header_width(value: float) -> void:
	pass


func add_frame_to_graph() -> void:
	pass
