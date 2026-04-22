class_name GovernorActionGraph extends Graph

var _governor: Governor
var _action: Action
var _header_width: float = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func init (governor: Governor, action: Action, y: float):
	_governor = governor
	_action = action
	$Name.text = action.get_name()
	var p = get_position()
	p.y = y
	set_position(p)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func get_min_header_width() -> float:
	return $Name.get_minimum_size().x + 10


func set_header_width(value: float) -> void:
	_header_width = value
	var size = $Name.get_size()
	size.x = value - 10
	$Name.set_size(size)
	init_line_x($StartLine, value, true)
