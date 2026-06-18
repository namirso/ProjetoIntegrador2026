extends Control

@onready var progress_bar: ProgressBar = $ProgressBar

var progresso := []
var status_carregamento := 0

func _ready() -> void:
	ResourceLoader.load_threaded_request(Global.proxima_fase_path)


func _process(_delta: float) -> void:
	status_carregamento = ResourceLoader.load_threaded_get_status(Global.proxima_fase_path, progresso)
	
	progress_bar.value = progresso[0] * 100
	
	if status_carregamento == 3:
		var nova_fase = ResourceLoader.load_threaded_get(Global.proxima_fase_path)
		get_tree().change_scene_to_packed(nova_fase)
