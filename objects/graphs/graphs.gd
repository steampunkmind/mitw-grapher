extends VBoxContainer

var _spacers: Array[Control]
var _graphs: Array[Graph]
var _visible_count: int = 1

@export var action_graph_template: PackedScene
@export var waiting_graph_template: PackedScene
@export var wondering_graph_template: PackedScene
@export var individual_error_graph_template: PackedScene
@export var total_error_graph_template: PackedScene
@export var header_graph_template: PackedScene
@export var comparator_graph_template: PackedScene
@export var error_graph_template: PackedScene
@export var action_evaluation_template: PackedScene
@export var spacer_template: PackedScene


func add_graphs() -> Array[String]:
	for spacer: Control in _spacers:
		remove_child(spacer)
	_spacers.clear()
	
	for graph: Graph in _graphs:
		remove_child(graph)
	_graphs.clear()
	
	var header_frame: Array[String] = []
	_add_system_graph(action_graph_template.instantiate(), header_frame)
	_add_system_graph(waiting_graph_template.instantiate(), header_frame)
	_add_system_graph(wondering_graph_template.instantiate(), header_frame)
	_add_system_graph(individual_error_graph_template.instantiate(), header_frame)
	_add_system_graph(total_error_graph_template.instantiate(), header_frame)
		
	for governor: Governor in MITW.gam_model().get_governors():
		if _graphs.size() > 0:
			var spacer = spacer_template.instantiate()
			add_child(spacer)
			_spacers.append(spacer)
			
		_add_governor_graph(header_graph_template.instantiate(), governor, header_frame)
		_add_governor_graph(comparator_graph_template.instantiate(), governor, header_frame)
		_add_governor_graph(error_graph_template.instantiate(), governor, header_frame)
		
		for action: Action in MITW.aim_model().get_behavioral_actions():
			var action_evaluation_graph = action_evaluation_template.instantiate()
			action_evaluation_graph.init(governor, action, header_frame)
			_add_graph(action_evaluation_graph)
			
	set_header_width(get_min_header_width())
	return header_frame


func _add_system_graph(graph: Graph, header_frame: Array[String]) -> void:
	graph.init(header_frame)
	add_child(graph)
	_graphs.append(graph)


func _add_governor_graph(graph: Graph, governor: Governor, header_frame: Array[String]) -> void:
	graph.init(governor, header_frame)
	_add_graph(graph)


func _add_graph(graph: Graph) -> void:
	if graph is ComparatorGraph or graph is ActionEvaluationGraph:
		graph.set_visible(false)
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


func _on_comparitor_button_toggled(toggled_on: bool) -> void:
	_update_visible_count(toggled_on)
	for graph: Graph in _graphs:
		if graph is ComparatorGraph:
			graph.set_visible(toggled_on)


func _on_error_button_toggled(toggled_on: bool) -> void:
	_update_visible_count(toggled_on)
	for graph: Graph in _graphs:
		if graph is ErrorGraph:
			graph.set_visible(toggled_on)


func _on_action_evaluation_button_toggled(toggled_on: bool) -> void:
	_update_visible_count(toggled_on)
	for graph: Graph in _graphs:
		if graph is ActionEvaluationGraph:
			graph.set_visible(toggled_on)


func _update_visible_count(toggled_on: bool) -> void:
	if toggled_on: 
		_visible_count += 1
		if _visible_count == 1:
			for graph: Graph in _graphs:
				if graph is HeaderGraph:
					var size = graph.get_custom_minimum_size()
					size.y = 0
					graph.set_custom_minimum_size(size)
	else:
		_visible_count -= 1
		if _visible_count == 0:
			for graph: Graph in _graphs:
				if graph is HeaderGraph:
					var size = graph.get_custom_minimum_size()
					size.y = 25
					graph.set_custom_minimum_size(size)
