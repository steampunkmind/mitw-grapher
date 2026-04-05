extends Node

var _aim_model = ActionInfluenceModel.new()
var _aim_model_name # holds name between file dialogs
var _aim_model_json # holds json between file dialogs
var _gam_model = GovernorActionModel.new()

enum {OPEN_FILES}


func _ready() -> void:
	$FileMenu.get_popup().index_pressed.connect(_on_file_menu_index_pressed)
	$FileDialog.set_current_dir("mitw-common/models")


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
