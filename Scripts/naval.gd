extends Node2D

const NUM_RINGS = 3  # Número de anéis no tabuleiro
const CELLS_PER_RING = [12, 12, 12]  # Número de células em cada anel
const RING_RADIUS_STEP = 100  # Distância entre os anéis

var grid = []  # Armazena o estado de cada célula
var center_offset = Vector2()  # Posição central do tabuleiro
var game_over = false  # Variável de controle para o fim do jogo

func _ready():
	# Calcula a posição central da tela
	center_offset = get_viewport_rect().size / 2
	
	# Inicializa o grid com o estado das células
	for ring in range(NUM_RINGS):
		var cells_in_ring = []
		for i in range(CELLS_PER_RING[ring]):
			cells_in_ring.append(0)  # 0 = célula vazia
		grid.append(cells_in_ring)
	
	# Posiciona navios
	place_ships()
	
	# Desenha o tabuleiro circular
	queue_redraw()  # Chama o _draw() para desenhar o tabuleiro

func _draw():
	# Define o tamanho e as cores das células
	var cell_radius = 10
	
	for ring in range(NUM_RINGS):
		var radius = RING_RADIUS_STEP * (ring + 1)
		var cells_in_ring = CELLS_PER_RING[ring]
		
		# Desenha o contorno do anel
		draw_circle(center_offset, radius, Color(1, 1, 1), false)  # Branco para contorno do anel
		
		for i in range(cells_in_ring):
			var angle = deg_to_rad((360 / cells_in_ring) * i)
			var cell_position = Vector2(cos(angle), sin(angle)) * radius + center_offset
			
			# Desenha cada célula como um círculo no tabuleiro
			var color = Color(1, 1, 1)  # Branco para célula vazia
			if grid[ring][i] == 1:
				color = Color(1, 1, 1)  # Azul para célula com navio
			elif grid[ring][i] == 2:
				color = Color(0, 0, 1)  # Verde para célula atingida sem navio (água)
			elif grid[ring][i] == 3:
				color = Color(1, 0, 0)  # Vermelho para célula de navio atingido
			draw_circle(cell_position, cell_radius, color)
			
			draw_line(center_offset, cell_position, Color(1, 1, 1), 1)

func _input(event):
	# Detecta cliques do mouse, mas só permite ataques se o jogo não acabou
	if not game_over and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mouse_pos = event.position - center_offset  # Ajusta a posição em relação ao centro do tabuleiro
		var ring_and_cell = get_cell_from_position(mouse_pos)
		var ring = ring_and_cell[0]
		var cell_index = ring_and_cell[1]
		
		if ring != -1 and cell_index != -1:
			attack(ring, cell_index)  # Executa ataque na célula clicada
			if check_all_ships_sunk():  # Verifica se todos os navios foram afundados
				game_over = true
				print("Jogo Finalizado: Todos os navios foram afundados!")

func get_cell_from_position(mouse_pos):
	# Calcula em qual anel e célula o clique ocorreu
	var distance_from_center = mouse_pos.length()
	
	# Determina o anel clicado
	var ring = -1
	for i in range(NUM_RINGS):
		var min_radius = RING_RADIUS_STEP * i
		var max_radius = RING_RADIUS_STEP * (i + 1)
		if distance_from_center >= min_radius and distance_from_center < max_radius:
			ring = i
			break
	
	if ring == -1:
		return [-1, -1]  # Fora dos anéis

	# Calcula o índice da célula dentro do anel
	var angle = atan2(mouse_pos.y, mouse_pos.x)
	var cells_in_ring = CELLS_PER_RING[ring]
	var cell_index = int(round(angle / (2 * PI) * cells_in_ring)) % cells_in_ring
	
	return [ring, cell_index]

func attack(ring, cell_index):
	# Simula um ataque em uma célula
	if grid[ring][cell_index] == 0:
		grid[ring][cell_index] = 2  # 2 = tiro na água
		print("Tiro na água")
	elif grid[ring][cell_index] == 1:
		grid[ring][cell_index] = 3  # 3 = navio acertado
		print("Navio atingido")
		check_ship_sunk(ring, cell_index)
	queue_redraw()  # Atualiza o desenho após o ataque

func check_ship_sunk(ring, cell_index):
	print("Verificando se o navio foi afundado...")
	var ship_cells = get_connected_ship_cells(ring, cell_index)
	var all_cells_hit = true
	for cell in ship_cells:
		if grid[ring][cell] != 3:  # Se alguma célula do navio não foi atingida
			all_cells_hit = false
			break
	
	if all_cells_hit:
		print("Navio afundado!")
	else:
		print("Navio ainda está intacto.")

func get_connected_ship_cells(ring, cell_index):
	var cells_in_ring = CELLS_PER_RING[ring]
	var visited = []
	var to_visit = [cell_index]
	
	while to_visit.size() > 0:
		var current_cell = to_visit.pop_front()
		if current_cell in visited:
			continue
		visited.append(current_cell)
		
		var left = (current_cell - 1 + cells_in_ring) % cells_in_ring
		var right = (current_cell + 1) % cells_in_ring
		
		if grid[ring][left] in [1, 3] and left not in visited:
			to_visit.append(left)
		if grid[ring][right] in [1, 3] and right not in visited:
			to_visit.append(right)
	
	return visited  # Retorna todas as células conectadas do navio

# Função para verificar se todos os navios foram afundados
func check_all_ships_sunk():
	for ring in grid:
		for cell in ring:
			if cell == 1:  # Ainda há uma célula com navio não atingido
				return false
	return true  # Todos os navios foram afundados

# Função para posicionar os navios aleatoriamente
func place_ships():
	for ring in range(NUM_RINGS):
		var num_ships = randi() % 3 + 1  # Coloca de 1 a 3 navios por anel
		var cells_in_ring = CELLS_PER_RING[ring]
		
		for ship_index in range(num_ships):
			var ship_length = randi() % 2 + 1  # Navios de 1 ou 2 células
			var start_cell = randi() % cells_in_ring
			
			for j in range(ship_length):
				var cell = (start_cell + j) % cells_in_ring
				grid[ring][cell] = 1  # Marca a célula como ocupada pelo navio
