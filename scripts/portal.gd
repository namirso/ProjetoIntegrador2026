extends Area2D

@export var caminho_proxima_fase: String = "res://cenas/fase2.tscn"

@onready var ui_quiz: CanvasLayer = $UIQuiz
@onready var texto_pergunta: Label = $UIQuiz/Panel/TextoPergunta
@onready var texto_feedback: Label = $UIQuiz/Panel/Feedback
@onready var container_botoes: VBoxContainer = $UIQuiz/Panel/VBoxContainer

var banco_de_questoes = [
	{
		"pergunta": "Como são chamados animais que vivem livres na natureza?",
		"opcoes": ["Animais em Cativeiro", "Animais Silvestres", "Animais Domésticos"],
		"resposta_correta": 1
	},
	{
		"pergunta": "Por viverem livres e superando obstáculos, \nos animais da natureza crescem de qual maneira?",
		"opcoes": ["Fracos e com medo", "Magros e doentes", "Fortes e Sagazes"],
		"resposta_correta": 2
	},
	{
		"pergunta": "Qual o maior predador de animais livres?",
		"opcoes": [ "Os leões", "Os tubarões", "O ser humano"],
		"resposta_correta": 2
	}
]

var pergunta_atual := 0
var acertos := 0
var quiz_ativo := false

func _ready() -> void:
	ui_quiz.hide()
	texto_feedback.hide()
	
	body_entered.connect(_on_body_entered)
	
	var indice = 0
	for botao in container_botoes.get_children():
		if botao is Button:
			botao.pressed.connect(_on_opcao_escolhida.bind(indice))
			botao.focus_mode = Control.FOCUS_NONE
			indice += 1


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Coelho" and not quiz_ativo:
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
	for i in range(botoes.size()):
		botoes[i].text = dados_da_pergunta["opcoes"][i]
		botoes[i].disabled = false


func _on_opcao_escolhida(indice_escolhido: int) -> void:
	for botao in container_botoes.get_children():
		botao.disabled = true
		
	var resposta_certa = banco_de_questoes[pergunta_atual]["resposta_correta"]
	
	container_botoes.hide()
	texto_feedback.show()
	
	if indice_escolhido == resposta_certa:
		acertos += 1
		texto_feedback.text = "Resposta Correta!"
		texto_feedback.modulate = Color.GREEN
	else:
		texto_feedback.text = "Resposta Incorreta!"
		texto_feedback.modulate = Color.RED
		
	await get_tree().create_timer(1).timeout
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
	
	if acertos >= 2:
		texto_feedback.modulate = Color.WHITE
		texto_pergunta.text = "Você acertou " + str(acertos) + " de 3!\n"
		texto_feedback.text = "E conseguiu entrar no laboratório."
		
		await get_tree().create_timer(2.0).timeout
		Global.lendo_historia = false
		
		Global.usar_checkpoint = false
		get_tree().change_scene_to_file(caminho_proxima_fase)
		
	else:
		texto_feedback.modulate = Color.RED
		texto_pergunta.text = "Você acertou apenas " + str(acertos) + " de 3."
		texto_feedback.text = "Tente novamente observando os trechos de informação!\nReiniciando a fase do início..."
		
		await get_tree().create_timer(3.0).timeout
		
		Global.usar_checkpoint = false
		
		Global.lendo_historia = false
		
		get_tree().change_scene_to_file("res://cenas/intro.tscn")
