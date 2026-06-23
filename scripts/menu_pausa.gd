extends CanvasLayer

@onready var painel_pausa: Panel = $Panel
@onready var btn_continuar: Button = $Panel/VBoxContainer/continuar
@onready var btn_controles: Button = $Panel/VBoxContainer/controles
@onready var btn_voltar_menu: Button = $Panel/VBoxContainer/voltarMenu

@onready var painel_controles: Panel = $Controles
@onready var btn_voltar_pausa: Button = $Controles/voltarControles

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	btn_continuar.focus_mode = Control.FOCUS_NONE
	btn_controles.focus_mode = Control.FOCUS_NONE
	btn_voltar_menu.focus_mode = Control.FOCUS_NONE
	btn_voltar_pausa.focus_mode = Control.FOCUS_NONE
	
	painel_pausa.hide()
	painel_controles.hide()
	
	btn_continuar.pressed.connect(_ao_apertar_continuar)
	btn_controles.pressed.connect(_ao_apertar_controles)
	btn_voltar_menu.pressed.connect(_ao_apertar_voltar_menu)
	btn_voltar_pausa.pressed.connect(_ao_voltar_dos_controles)


func _input(event: InputEvent) -> void:
	if Global.lendo_documento:
		return

	if get_tree().current_scene:
		var telas_sem_pause = ["res://cenas/menu_inicio.tscn", "res://cenas/intro.tscn"]
		if get_tree().current_scene.scene_file_path in telas_sem_pause:
			return

	if event.is_action_pressed("ui_cancel"):
		if painel_controles.visible:
			_ao_voltar_dos_controles()
		else:
			alternar_pausa()


func alternar_pausa() -> void:
	var estado_pausa = not get_tree().paused
	get_tree().paused = estado_pausa
	
	painel_controles.hide()
	painel_pausa.visible = estado_pausa


func _ao_apertar_continuar() -> void:
	alternar_pausa()


func _ao_apertar_controles() -> void:
	painel_pausa.hide()
	painel_controles.show()


func _ao_voltar_dos_controles() -> void:
	painel_controles.hide()
	painel_pausa.show()


func _ao_apertar_voltar_menu() -> void:
	get_tree().paused = false
	painel_pausa.hide()
	painel_controles.hide()
	
	get_tree().change_scene_to_file("res://cenas/menu_inicio.tscn")
