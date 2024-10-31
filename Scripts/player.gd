extends CharacterBody2D

@export var grav = 10 # Define a gravidade para o personagem
@export var vel = 150 # Define a velocidade para o personagem
@export var jump_force = 300 # Força de pulo

# RayCast2D para verificar objetos acima do player
@onready var ceiling_check := $CeilingCheck # Certifique-se de que o RayCast2D está presente e ativo

var pushable_above: Pushables = null # Armazena referência ao objeto pushable acima do player

func _ready() -> void:
	$AnimationPlayer.play("player")

func _process(delta): # Executa os processos 60 vezes por segundo
	
	# Aplica gravidade se não estiver no chão
	if !is_on_floor():
		velocity.y += grav
	
	# Movimento horizontal
	if Input.is_action_pressed("ui_right"):
		velocity.x = vel
		$Sprite2D.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -vel
		$Sprite2D.flip_h = true
	else:
		velocity.x = 0
	
	# Verifica se o player pode pular
	if is_on_floor() and Input.is_action_pressed("ui_up"):
		velocity.y = -jump_force # Aplica o pulo diretamente
		
		# Se houver um objeto 'Pushable' acima do player, armazena-o
		if ceiling_check.is_colliding():
			var collider = ceiling_check.get_collider()
			if collider is Pushables:
				pushable_above = collider
	
	# Se há um objeto pushable acima, mova-o junto com o player
	# Se há um objeto pushable acima, mova-o junto com o player
	# Verifica se a caixa pushable ainda está acima do player
	if pushable_above != null:
		if !ceiling_check.is_colliding() or ceiling_check.get_collider() != pushable_above:
			pushable_above = null  # Reseta a referência se a caixa não estiver mais acima
		else:
		# Ajusta a posição da caixa pushable
			pushable_above.position.y = position.y - (pushable_above.get_global_scale().y * 16) # Ajuste 16 para o tamanho desejado
	
	# Move o player
	move_and_slide()

	# Aplica a lógica de colisão com objetos empurráveis
	apply_push_force()

# Função para lidar com objetos empurráveis
func apply_push_force():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider() is Pushables:
			# Empurra o objeto pushable
			collision.get_collider().slide_object(-collision.get_normal())
