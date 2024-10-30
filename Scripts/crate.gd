extends CharacterBody2D
class_name Pushables

const push_speed = 250.0 #define velocidade

var gravity = 10 #define gravidade

var id: int #id da caixa
var sprite_path: String #caminho do sprite

func _ready():
	var sprite = $Sprite
	sprite.texture = load(sprite_path) #carrega a textura do sprite


func _physics_process(delta):
	velocity.y += gravity
	
	move_and_slide()
	apply_push_force()
	
	velocity.x = 0 #zera o movimento lateral

	
func slide_object(direction):
	velocity.x = int(direction.x) * push_speed

func apply_push_force():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider() is Pushables:
			# Empurra o objeto pushable
			collision.get_collider().slide_object(-collision.get_normal())
