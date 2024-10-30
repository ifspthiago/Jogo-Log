extends Area2D


func _ready():
	$AnimationPlayer.play("Moving_Saw")


func _process(delta: float) -> void:
	pass


func _on_body_entered(body):
	if body.name == 'Player':
		get_tree().reload_current_scene() #reinicia a cena principal
	pass
		
