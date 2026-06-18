extends Area2D

var ja_ativado := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Coelho" and not ja_ativado:
		ja_ativado = true
		
		Global.posicao_checkpoint = global_position
		Global.usar_checkpoint = true
		
		print("Checkpoint global salvo!")
