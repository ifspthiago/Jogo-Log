extends Area2D

signal player_on_stairs  # Sinal para notificar quando o player está na escada

func _on_body_entered(body):
	if body.name == "Player":
		emit_signal("player_on_stairs", true)  # Notifica que o player está na escada

func _on_body_exited(body):
	if body.name == "Player":
		emit_signal("player_on_stairs", false)  # Notifica que o player saiu da escada
