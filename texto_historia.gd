extends Area2D

@export_multiline var mensagem: String = "Digite o texto flutuante aqui..."

@onready var label: Label = $Label

var ja_ativou := false

func _ready() -> void:
	label.text = mensagem
	
	label.visible_ratio = 0.0
	
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Coelho" and not ja_ativou:
		ja_ativou = true
		animar_texto()


func animar_texto() -> void:
	Global.lendo_historia = true
	
	var tween = create_tween()
	var tempo_de_animacao = float(mensagem.length()) * 0.05
	
	tween.tween_property(label, "visible_ratio", 1.0, tempo_de_animacao)
	
	tween.tween_interval(2.0)
	
	tween.tween_callback(liberar_jogador)


func liberar_jogador() -> void:
	Global.lendo_historia = false
	
	#some o texto da tela vv
	# label.hide()
