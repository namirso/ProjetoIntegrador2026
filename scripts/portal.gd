extends Area2D

@export var caminho_proxima_fase: String

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.get("ativo") != null:
		
		Global.proxima_fase_path = caminho_proxima_fase
		
		get_tree().call_deferred("change_scene_to_file", "res://cenas/tela_carregamento.tscn")
