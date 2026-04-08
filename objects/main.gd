extends Node

var _aim_model_name # holds name between file dialogs
var _aim_model_dict # holds dict between file dialogs
var governor_graphs: Dictionary[String, GovernorGraph]

@export var governor_graph_template: PackedScene

@export var frame_rate: float

enum {OPEN_FILES}


func _ready() -> void:
	$FileMenu.get_popup().index_pressed.connect(_on_file_menu_index_pressed)
	$FileDialog.set_current_dir("mitw-common/models")
	$PlayButton.hide()
	$FrameCount.hide()
	$FrameRateSlider.value = frame_rate
	$FrameRateValue.text = str(frame_rate)
	$Timer.set_wait_time(1/frame_rate)
	$Timer.paused = true


func _on_file_menu_index_pressed(index) -> void:
	match index:
		OPEN_FILES:
			_on_open_files_menu_pressed()


func _on_open_files_menu_pressed() -> void:
	_aim_model_name = null
	_aim_model_dict = null
	$FileDialog.set_title("Open an AIM File")
	$FileDialog.set_filters(["*.aim"])
	$FileDialog.popup()


func _on_file_dialog_file_selected(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	var dict = JSON.parse_string(file.get_as_text())
	file.close()
	
	if _aim_model_name == null:
		_aim_model_name = path.get_basename().get_file().capitalize()
		_aim_model_dict = dict # Hold data until gam model is selected below.
		await get_tree().create_timer(0.5).timeout # Wait for dialog to go away.
		$FileDialog.set_title("Open a GAM File")
		$FileDialog.set_filters(["*.gam"])
		$FileDialog.popup()
	else:
		$FileNames.text = _aim_model_name + " - " + path.get_basename().get_file().capitalize()
		MITW.init(_aim_model_dict, dict)
		MITW.init_action()
		add_governor_graphs()
		
		$PlayButton.show()
		$PlayButton.set_pressed_no_signal(false)
		$Timer.paused = true
		$FrameCount.show()
		$FrameCount.text = "0"
		
		_aim_model_name = null
		_aim_model_dict = null


func add_governor_graphs() -> void:
	if governor_graphs.size() > 0:
		for governor_graph: GovernorGraph in governor_graphs.values():
			remove_child(governor_graph)
		governor_graphs.clear()
	
	var header_margin = 48
	var row_margin = 2
	var row_location = header_margin
	var header_width = 0.0
	for governor: Governor in MITW.gam_model().get_governors():
		var graph = governor_graph_template.instantiate()
		graph.init(governor, row_location)
		var min_header_width = graph.get_min_header_width()
		if header_width < min_header_width:
			header_width = min_header_width
		
		add_child(graph)
		governor_graphs.set(governor.get_name(), graph)
		row_location = row_location + graph.size.y + row_margin
		
	for governor_graph: GovernorGraph in governor_graphs.values():
		governor_graph.set_header_width(header_width)


func _on_frame_rate_slider_value_changed(value: float) -> void:
	$FrameRateValue.text = str(value)
	$Timer.set_wait_time(1/value)
	frame_rate = value


func _on_play_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$Timer.paused = false
	else:
		$Timer.paused = true


func _on_timer_timeout() -> void:
	MITW.go_to_next_frame()
	$FrameCount.text = str(MITW.get_frame_count())
	add_frame_to_graph()


func add_frame_to_graph() -> void:
	for governor_graph: GovernorGraph in governor_graphs.values():
		governor_graph.add_frame_to_graph()
