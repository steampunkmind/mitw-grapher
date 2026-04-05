extends Node

var _aim_model = ActionInfluenceModel.new()
var _aim_model_name # holds name between file dialogs
var _aim_model_json # holds json between file dialogs
var _gam_model = GovernorActionModel.new()

@export var frame_rate: float
var _frame_count: int = 0

enum {OPEN_FILES}


func _ready() -> void:
	$FileMenu.get_popup().index_pressed.connect(_on_file_menu_index_pressed)
	$FileDialog.set_current_dir("mitw-common/models")
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
	_aim_model_json = null
	$FileDialog.set_title("Open an AIM File")
	$FileDialog.set_filters(["*.aim"])
	$FileDialog.popup()


func _on_file_dialog_file_selected(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	var json = JSON.parse_string(file.get_as_text())
	file.close()
	
	if _aim_model_name == null:
		_aim_model_name = path.get_basename().get_file().capitalize()
		_aim_model_json = json # Hold data until gam model is selected below.
		await get_tree().create_timer(0.5).timeout # Wait for dialog to go away.
		$FileDialog.set_title("Open a GAM File")
		$FileDialog.set_filters(["*.gam"])
		$FileDialog.popup()
	else:
		$FileNames.text = _aim_model_name + " - " + path.get_basename().get_file().capitalize()
		_aim_model.clear_model()
		_gam_model.clear_model()
		_aim_model.set_model(_aim_model_json)
		_gam_model.set_model(json, _aim_model)
		_aim_model_name = null
		_aim_model_json = null


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
	_frame_count = _frame_count + 1
	$FrameCount.text = str(_frame_count)
