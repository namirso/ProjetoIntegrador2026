extends CanvasLayer

@onready var painel: Panel = $Panel
@onready var btn_continuar: Button = $Panel/VBoxContainer/continuar
@onready var btn_voltar: Button = $Panel/VBoxContainer/voltarMenu

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	btn_continuar.focus_mode = Control.FOCUS_NONE
	btn_voltar.focus_mode = Control.FOCUS_NONE
	
	painel.hide()
	
	btn_continuar.pressed.connect(_ao_apertar_continuar)
	btn_voltar.pressed.connect(_ao_apertar_voltar)


func _input(event: InputEvent) -> void:
	if get_tree().current_scene:
		var telas_sem_pause = [
			"res://cenas/menu_inicio.tscn",
			"res://cenas/intro.tscn"
		]
		
		if get_tree().current_scene.scene_file_path in telas_sem_pause:
			return

	if event.is_action_pressed("ui_cancel"):
		alternar_pausa()


func alternar_pausa() -> void:
	var estado_pausa = not get_tree().paused
	get_tree().paused = estado_pausa
	
	painel.visible = estado_pausa


func _ao_apertar_continuar() -> void:
	alternar_pausa()


func _ao_apertar_voltar() -> void:
	get_tree().paused = false
	
	get_tree().change_scene_to_file("res://cenas/menu_inicio.tscn")
