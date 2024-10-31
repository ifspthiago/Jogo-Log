extends Area2D

@export var expected_id: int = 4 # ID que estamos esperando
signal area1_activated

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body is Pushables:
		if body.id == expected_id:
			print("Objeto com ID", body.id, "entrou na área e foi reconhecido!")
			emit_signal("area1_activated")
		else:
			print("Objeto com ID", body.id, "entrou na área, mas não é o correto.")
