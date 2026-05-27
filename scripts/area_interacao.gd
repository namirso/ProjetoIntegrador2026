extends Area2D

@export var texto_da_interacao: String = "[ E ] para interagir"

@onready var prompt_texto: Label = $Label
var jogador_na_area := false

func _ready() -> void:
	prompt_texto.text = texto_da_interacao
	
	prompt_texto.hide()
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Coelho":
		jogador_na_area = true
		prompt_texto.show()


func _on_body_exited(body: Node2D) -> void:
	if body.name == "Coelho":
		jogador_na_area = false
		prompt_texto.hide()


func _unhandled_input(event: InputEvent) -> void:
	if jogador_na_area and event.is_action_pressed("interagir"):
		print("Você interagiu com o objeto!")
