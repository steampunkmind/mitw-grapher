extends VBoxContainer

var _graphs: Array[Graph]

@export var header_graph_template: PackedScene
@export var comparator_graph_template: PackedScene
@export var action_evaluation_template: PackedScene


func _add_graphs() -> void:
	for graph: Node in _graphs:
		remove_child(graph)
	_graphs.clear()
	
	var header_margin = 0
	var row_margin = (MITW.aim_model().get_behavioral_actions().size() * 52) + 6
	for governor: Governor in MITW.gam_model().get_governors():
		var governor_row = header_graph_template.instantiate()
		governor_row.init(governor)
		_add_graph(governor_row)
		
		var governor_graph = comparator_graph_template.instantiate()
		governor_graph.init(governor)
		_add_graph(governor_graph)
		
		for action: Action in MITW.aim_model().get_behavioral_actions():
			var action_graph = action_evaluation_template.instantiate()
			action_graph.init(governor, action)
			_add_graph(action_graph)
		
	set_header_width(get_min_header_width())


func _add_graph(graph: Graph) -> void:
	add_child(graph)
	_graphs.append(graph)


func get_min_header_width() -> float:
	var result = 0
	for graph: Graph in _graphs:
		if result < graph.get_min_header_width():
			result = graph.get_min_header_width()
	return result


func set_header_width(value: float) -> void:
	for graph: Graph in _graphs:
		graph.set_header_width(value)


func _add_frame_to_graph() -> void:
	for graph: Graph in _graphs:
		graph.add_frame_to_graph()
