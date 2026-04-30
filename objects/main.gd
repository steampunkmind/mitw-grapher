extends Node

var _aim_model_name # holds name between file dialogs
var _aim_model_dict # holds dict between file dialogs
var _data_frames: Array[Array]

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
		var header_frame = $Scroll/Graphs.add_graphs()
		_data_frames.append(header_frame)
		
		$FileMenu.get_popup().set_item_disabled(SAVE_DATA, false)
		$PlayButton.show()
		$PlayButton.set_pressed_no_signal(false)
		$Timer.paused = true
		$FrameCount.show()
		$FrameCount.text = "0"
		
		_aim_model_name = null
		_aim_model_dict = null
		_open_dir = $FileDialog.current_dir


func _save_data(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.WRITE)
	var line: String
	var frame: int = 0
	for data_frame: Array in _data_frames:
		if file.get_length() == 0:
			line = "Frame"
			for column_header: String in data_frame:
				line += "," + column_header
		else:
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
	var data_frame = $Scroll/Graphs.add_frame_to_graph()
	_data_frames.append(data_frame)
