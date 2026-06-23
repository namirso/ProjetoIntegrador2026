extends CanvasLayer

@onready var btn_continuar: Button = $VBoxContainer/Continuar

func _ready() -> void:
	get_tree().paused = true
	
	btn_continuar.pressed.connect(_ao_apertar_continuar)
	btn_continuar.focus_mode = Control.FOCUS_NONE


func _ao_apertar_continuar() -> void:
	get_tree().paused = false
	
	get_tree().reload_current_scene()
