extends CanvasLayer

func _ready() -> void:
	get_tree().paused = true
	
	# Usa a trava global para o seu Menu de Pausa original ignorar o ESC
	Global.lendo_documento = true


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interagir") or event.is_action_pressed("ui_cancel"):
		fechar_tutorial()
		
		get_viewport().set_input_as_handled()


func fechar_tutorial() -> void:
	get_tree().paused = false
	Global.lendo_documento = false
	
	queue_free()
