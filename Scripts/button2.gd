extends Button

# Referência ao nó do plano cartesiano (vai ser mostrado e escondido)
@onready var cartesian_plane2 = get_node("../CartesianPlane2")

func _on_pressed():
	# Mostra ou esconde o plano cartesiano
	cartesian_plane2.visible = !cartesian_plane2.visible
	pass # Replace with function body.
