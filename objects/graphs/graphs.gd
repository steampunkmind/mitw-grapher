extends VBoxContainer

var _graphs: Array[Graph]

@export var individual_error_graph_template: PackedScene
@export var total_error_graph_template: PackedScene
@export var header_graph_template: PackedScene
@export var comparator_graph_template: PackedScene
@export var error_graph_template: PackedScene
@export var action_evaluation_template: PackedScene
@export var spacer_template: PackedScene


func add_graphs() -> Array[String]:
	for graph: Node in _graphs:
		remove_child(graph)
	_graphs.clear()
	
	var individual_error_graph = individual_error_graph_template.instantiate()
	_add_graph(individual_error_graph)
	
	var total_error_graph = total_error_graph_template.instantiate()
	_add_graph(total_error_graph)
		
	var header_frame: Array[String] = []
	for governor: Governor in MITW.gam_model().get_governors():
		
		if _graphs.size() > 0:
			add_child(spacer_template.instantiate())
		
		var header_graph = header_graph_template.instantiate()
		header_graph.init(governor)
		_add_graph(header_graph)
		
		var comparator_graph = comparator_graph_template.instantiate()
		comparator_graph.init(governor, header_frame)
		_add_graph(comparator_graph)
		
		var error_graph = error_graph_template.instantiate()
		error_graph.init(governor, header_frame)
		_add_graph(error_graph)
		
		for action: Action in MITW.aim_model().get_behavioral_actions():
			var action_evaluation_graph = action_evaluation_template.instantiate()
			action_evaluation_graph.init(governor, action, header_frame)
			_add_graph(action_evaluation_graph)
			
	set_header_width(get_min_header_width())
	return header_frame


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


func add_frame_to_graph() -> Array[float]:
	var data_frame: Array[float] = []
	for graph: Graph in _graphs:
		graph.add_frame_to_graph(data_frame)
	return data_frame
