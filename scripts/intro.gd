extends Control

@export_multiline var historia: Array[String] = [
	"Há muito tempo, em uma floresta distante...",
	"Um pequeno coelho descobriu algo extraordinário.",
	"Mas o perigo esitava à espreita nos laboratórios...",
	"Agora, a jornada começa!"
]

@onready var label_texto: Label = $Label 
var frase_atual := 0
var tween: Tween

var tempo_pressionado := 0.0
const TEMPO_PARA_PULAR_TUDO := 1.0 

func _ready() -> void:
	label_texto.modulate.a = 0.0
	mostrar_proxima_frase()


func _process(delta: float) -> void:
	if Input.is_action_pressed("interagir"):
		tempo_pressionado += delta
		
		if tempo_pressionado >= TEMPO_PARA_PULAR_TUDO:
			set_process(false) 
			
			if tween:
				tween.kill() 
				
			iniciar_jogo()
	else:
		tempo_pressionado = 0.0


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interagir"):
		pular_frase()


func mostrar_proxima_frase() -> void:
	if frase_atual < historia.size():
		label_texto.text = historia[frase_atual]
		
		tween = create_tween()
		tween.tween_property(label_texto, "modulate:a", 1.0, 1.5) 
		tween.tween_interval(2.0)
		tween.tween_property(label_texto, "modulate:a", 0.0, 1.5)
		
		tween.finished.connect(_ao_terminar_animacao)
	else:
		iniciar_jogo()


func _ao_terminar_animacao() -> void:
	frase_atual += 1
	mostrar_proxima_frase()


func pular_frase() -> void:
	if tween:
		tween.kill()
	
	frase_atual += 1
	
	if frase_atual < historia.size():
		label_texto.modulate.a = 0.0
		mostrar_proxima_frase()
	else:
		iniciar_jogo()


func iniciar_jogo() -> void:
	Global.proxima_fase_path = "res://cenas/fases/floresta.tscn"
	get_tree().change_scene_to_file("res://cenas/tela_carregamento.tscn")
