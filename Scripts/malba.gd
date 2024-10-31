extends Area2D

# Flag para verificar se o Player está na área
var player_in_area = false

func _on_body_entered(body):
	# Verifica se o corpo que entrou é o 'Player'
	if body.name == "Player":
		player_in_area = true
		$E.visible = true  # Torna o nó S visível

func _on_body_exited(body: Node2D) -> void:
	# Se o Player sair da área, redefine a flag e torna o nó S invisível
	if body.name == "Player":
		player_in_area = false
		$E.visible = false

func _process(delta):
	# Se o Player está na área e a tecla "ui_down" é pressionada, muda de cena
	if player_in_area and Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://Scenes/circular_board.tscn")
