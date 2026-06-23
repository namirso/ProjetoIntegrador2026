extends Area2D

@export_multiline var texto_do_documento: String = "Escreva o conteúdo do documento aqui..."
@export_multiline var autor_do_documento: String = "Autor ..."

@export var e_documento_chave := false

@onready var prompt_ler: Label = $Label
@onready var ui_documento: CanvasLayer = $CanvasLayer
@onready var texto_ui: Label = $CanvasLayer/Texto
@onready var autor_ui: Label = $CanvasLayer/Texto2

var jogador_na_area := false
var lendo := false

func _ready() -> void:
	prompt_ler.hide()
	ui_documento.hide()
	
	texto_ui.text = texto_do_documento
	autor_ui.text = autor_do_documento
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Coelho" and not lendo:
		jogador_na_area = true
		prompt_ler.show()


func _on_body_exited(body: Node2D) -> void:
	if body.name == "Coelho":
		jogador_na_area = false
		prompt_ler.hide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interagir"):
		if jogador_na_area and not lendo:
			abrir_documento()
		elif lendo:
			fechar_documento()
			
	elif event.is_action_pressed("ui_cancel") and lendo:
		fechar_documento()


func abrir_documento() -> void:
	lendo = true
	Global.lendo_documento = true
	
	if e_documento_chave:
		Global.caixa_luz_liberada = true
	
	prompt_ler.hide()
	ui_documento.show()
	get_tree().paused = true


func fechar_documento() -> void:
	lendo = false
	Global.lendo_documento = false
	
	ui_documento.hide()
	
	if jogador_na_area:
		prompt_ler.show()
		
	get_tree().paused = false
