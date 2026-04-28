extends Node

var _aim_model_name # holds name between file dialogs
var _aim_model_dict # holds dict between file dialogs
var _data_frames: Array[Array]
var _graphs: Array[Graph]

var _open_dir = "mitw-common/models"
var _save_dir = "../../../.." # directory containing project

@export var frame_rate: float

enum {OPEN_FILES, SAVE_DATA}


func _ready() -> void:
	$FileMenu.get_popup().index_pressed.connect(_on_file_menu_index_pressed)
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
		SAVE_DATA:
			_on_save_data_menu_pressed()


### Open Files/Save Data ###
func _on_open_files_menu_pressed() -> void:
	_aim_model_name = null
	_aim_model_dict = null
	$FileDialog.set_title("Open an AIM File")
	$FileDialog.set_filters(["*.aim"])
	$FileDialog.set_file_mode(FileDialog.FILE_MODE_OPEN_FILE)
	$FileDialog.set_current_dir(_open_dir)
	$FileDialog.popup()


func _on_save_data_menu_pressed() -> void:
	$FileDialog.set_current_file($FileNames.text + ".csv")
	$FileDialog.set_title("Save a MITW Data File")
	$FileDialog.set_filters(["*.csv"])
	$FileDialog.set_file_mode(FileDialog.FILE_MODE_SAVE_FILE)
	$FileDialog.set_current_dir(_save_dir)
	$FileDialog.popup()


func _on_file_dialog_file_selected(path: String) -> void:
	match $FileDialog.get_file_mode():
		FileDialog.FILE_MODE_OPEN_FILE:
			_open_file(path)
		FileDialog.FILE_MODE_SAVE_FILE:
			_save_data(path)


func _open_file(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	var dict = JSON.parse_string(file.get_as_text())
	file.close()
	
	if _aim_model_name == null:
		_aim_model_name = path.get_basename().get_file()
		_aim_model_dict = dict # Hold data until gam model is selected below.
		await get_tree().create_timer(0.5).timeout # Wait for dialog to go away.
		$FileDialog.set_title("Open a GAM File")
		$FileDialog.set_filters(["*.gam"])
		$FileDialog.popup()
	else:
		$FileNames.text = _aim_model_name + " - " + path.get_basename().get_file()
		MITW.init(_aim_model_dict, dict)
		MITW.init_action()
		_data_frames.clear()
		_add_governor_rows()
		
		$FileMenu.get_popup().set_item_disabled(SAVE_DATA, false)
		$PlayButton.show()
		$PlayButton.set_pressed_no_signal(false)
		$Timer.paused = true
		$FrameCount.show()
		$FrameCount.text = "0"
		
		_aim_model_name = null
		_aim_model_dict = null
		_open_dir = $FileDialog.current_dir

func _add_governor_rows() -> void:
	for graph: Node in _graphs:
		$Scroll/Graphs.remove_child(graph)
	_graphs.clear()
	
	var header_margin = 0
	var row_margin = (MITW.aim_model().get_behavioral_actions().size() * 52) + 6
	for governor: Governor in MITW.gam_model().get_governors():
		var governor_row = $Scroll/Graphs.header_graph_template.instantiate()
		governor_row.init(governor)
		_add_graph(governor_row)
		
		var governor_graph = $Scroll/Graphs.comparator_graph_template.instantiate()
		governor_graph.init(governor)
		_add_graph(governor_graph)
		
		for action: Action in MITW.aim_model().get_behavioral_actions():
			var action_graph = $Scroll/Graphs.action_evaluation_template.instantiate()
			action_graph.init(governor, action)
			_add_graph(action_graph)
		
	set_header_width(get_min_header_width())


func _add_graph(graph: Graph) -> void:
	$Scroll/Graphs.add_child(graph)
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


func _save_data(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.WRITE)
	var line: String = "\"Frame\""
	
	for governor: Governor in MITW.gam_model().get_governors():
		var name = ",\"" + governor.get_name() + "."
		line += name + "sensor max\""
		line += name + "sensor value\""
		line += name + "percept value\""
		line += name + "error threshold\""
		line += name + "error peak\""
		line += name + "sensor min\""
		line += name + "error max\""
		line += name + "error value\""
	file.store_line(line)
	
	var frame: int = 1
	for data_frame: Array in _data_frames:
		line = str(frame)
		for data_value: float in data_frame:
			line += str(",%.2f" % data_value)
		file.store_line(line)
		frame += 1
		
	_save_dir = $FileDialog.current_dir


### Transport ###
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
	_add_frame_data()
	_add_frame_to_graph()


func _add_frame_data() -> void:
	var data_frame: Array[float] = []
	for governor: Governor in MITW.gam_model().get_governors():
		data_frame.append(governor.get_sensor().get_max())
		data_frame.append(governor.get_sensor_value())
		data_frame.append(governor.get_percept_value())
		data_frame.append(governor.error_threshold())
		data_frame.append(governor.error_peak())
		data_frame.append(governor.get_sensor().get_min())
		data_frame.append(governor.error_max())
		data_frame.append(governor.get_error_value())
	_data_frames.append(data_frame)


func _add_frame_to_graph() -> void:
	for graph: Graph in _graphs:
		graph.add_frame_to_graph()
