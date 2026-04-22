class_name Graph extends ColorRect


func init_line_x(line: Line2D, x: float, both: bool):
	var point = line.get_point_position(0)
	point.x = x
	line.set_point_position(0, point)
	if both:
		point = line.get_point_position(1)
		point.x = x
		line.set_point_position(1, point)
