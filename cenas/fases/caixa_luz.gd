extends Area2D

@onready var sprite_animado: AnimatedSprite2D = $CaixaLuzSprite
@onready var switch_on = $CaixaDeLuzSwitchOn 

@onready var ui_quiz: CanvasLayer = $UIQuiz
@onready var texto_pergunta: Label = $UIQuiz/Panel/TextoPergunta
@onready var texto_feedback: Label = $UIQuiz/Panel/Feedback
@onready var container_botoes: VBoxContainer = $UIQuiz/Panel/VBoxContainer

var jogador_na_area := false
var caixa_ligada := false
var bloqueado_animando := false

var banco_de_questoes = [
	{
		"pergunta": "Animais que crescem em laboratório \nsão mais frágeis e menos resistentes \ncomparado a animais da natureza.",
		"opcoes": ["Verdadeiro", "Falso"],
		"resposta_correta": 0
	},
	{
		"pergunta": "Cientistas usam animais em testes \npois isso faz bem para os animais.",
		"opcoes": ["Verdadeiro", "Falso"],
		"resposta_correta": 1
	},
	{
		"pergunta": "Os testes científicos em animais são prejudiciais \ne devem ser interrompidos para sempre.",
		"opcoes": ["Verdadeiro", "Falso"],
		"resposta_correta": 0
	}
]

var pergunta_atual := 0
var acertos := 0
var quiz_ativo := false


func _ready() -> void:
	switch_on.hide()
	ui_quiz.hide()
	texto_feedback.hide()
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	sprite_animado.animation_finished.connect(_ao_terminar_animacao)
	
	var indice = 0
	for botao in container_botoes.get_children():
		if botao is Button:
			botao.pressed.connect(_on_opcao_escolhida.bind(indice))
			botao.focus_mode = Control.FOCUS_NONE
			indice += 1


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Coelho":
		jogador_na_area = true


func _on_body_exited(body: Node2D) -> void:
	if body.name == "Coelho":
		jogador_na_area = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interagir") and jogador_na_area and not bloqueado_animando and not quiz_ativo:
		if Global.caixa_luz_liberada:
			alternar_caixa()


func alternar_caixa() -> void:
	bloqueado_animando = true 
	
	if not caixa_ligada:
		caixa_ligada = true
		sprite_animado.play("idle")
		switch_on.show()


func _ao_terminar_animacao() -> void:
	bloqueado_animando = false
	
	if caixa_ligada and not quiz_ativo:
		iniciar_quiz()


func iniciar_quiz() -> void:
	quiz_ativo = true
	pergunta_atual = 0
	acertos = 0
	
	Global.lendo_historia = true 
	
	ui_quiz.show()
	carregar_pergunta()


func carregar_pergunta() -> void:
	texto_feedback.hide()
	container_botoes.show()
	
	var dados_da_pergunta = banco_de_questoes[pergunta_atual]
	texto_pergunta.text = dados_da_pergunta["pergunta"]
	
	var botoes = container_botoes.get_children()
	var quantidade_opcoes = dados_da_pergunta["opcoes"].size()
	
	for i in range(botoes.size()):
		if i < quantidade_opcoes:
			botoes[i].text = dados_da_pergunta["opcoes"][i]
			botoes[i].disabled = false
			botoes[i].show() 
		else:
			botoes[i].hide()


func _on_opcao_escolhida(indice_escolhido: int) -> void:
	for botao in container_botoes.get_children():
		botao.disabled = true
		
	var resposta_certa = banco_de_questoes[pergunta_atual]["resposta_correta"]
	
	container_botoes.hide()
	texto_feedback.show()
	
	if indice_escolhido == resposta_certa:
		acertos += 1
		texto_feedback.text = "Alternativa correta!"
		texto_feedback.modulate = Color.GREEN
	else:
		texto_feedback.text = "Erro no protocolo!"
		texto_feedback.modulate = Color.RED
		
	await get_tree().create_timer(1.5).timeout
	avancar_quiz()


func avancar_quiz() -> void:
	pergunta_atual += 1
	
	if pergunta_atual < banco_de_questoes.size():
		carregar_pergunta()
	else:
		finalizar_quiz()


func finalizar_quiz() -> void:
	container_botoes.hide()
	texto_feedback.show()
	
	if acertos == banco_de_questoes.size():
		texto_feedback.modulate = Color.WHITE
		texto_pergunta.text = "A caixa de luz foi desligada!"
		texto_feedback.text = "Os animais foram libertados com sucesso!"
		
		await get_tree().create_timer(2.0).timeout
		
		Global.lendo_historia = false
		ui_quiz.hide()
		
		get_tree().change_scene_to_file("res://cenas/final.tscn")
		
		
	else:
		texto_feedback.modulate = Color.RED
		texto_pergunta.text = "Falha crítica."
		texto_feedback.text = "Protocolo de segurança ativado.\nReiniciando a área..."
		
		await get_tree().create_timer(3.0).timeout
		
		Global.usar_checkpoint = false
		Global.lendo_historia = false
		Global.caixa_luz_liberada = false
		get_tree().reload_current_scene()
