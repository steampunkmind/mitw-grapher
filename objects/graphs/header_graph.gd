class_name HeaderGraph extends Graph


func init (governor: Governor, _header_frame: Array[String]):
	$Name.text = governor.get_name()


func get_min_header_width() -> float:
	return $Name.get_minimum_size().x + 48


func set_header_width(value: float) -> void:
	super.set_header_width(value)
	pass


func add_frame_to_graph(_data_frame: Array[float]) -> void:
	pass
