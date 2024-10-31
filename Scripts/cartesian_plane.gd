extends Node2D

var grid_size: int = 32  # Tamanho dos quadrados da malha
var grid_color: Color = Color(0.1, 0.1, 0.1)  # Cor da malha
var x_axis_color: Color = Color(1, 0, 0)  # Cor do eixo X (vermelho)
var y_axis_color: Color = Color(0, 1, 0)  # Cor do eixo Y (verde)

@export var custom_font: Font  # Usando a nova classe Font

# Define as dimensões da malha
var grid_width: int = 2440  # Largura da malha
var grid_height: int = 700   # Altura da malha

# Posições dos eixos X e Y
var x_axis_position: int = 576  # Posição Y do eixo X
var y_axis_position: int = 960    # Posição X do eixo Y

# Lista de posições personalizadas para desenhar números
var number_positions: Array = [
	Vector2(960, 416),  # Ponto para o número 5 no eixo Y
	Vector2(1088, 576), # Ponto para o número 4 no eixo Y
]

# Lista de números que correspondem às posições
var number_values: Array = [
	5,    # Número para a primeira posição
	4,   # Número para a segunda posição
]

func _ready() -> void:
	if custom_font == null:
		push_error("Nenhuma fonte foi atribuída!")
	queue_redraw()  # Solicita o redesenho da tela quando a cena é carregada

func _draw() -> void:
	draw_grid()  # Desenha a malha e os eixos
	draw_numbers()  # Desenha os números nos pontos específicos

# Função para desenhar a malha
func draw_grid() -> void:
	# Desenha as linhas da malha
	for x in range(0, grid_width, grid_size):
		draw_line(Vector2(x, 0), Vector2(x, grid_height), grid_color)
	for y in range(0, grid_height, grid_size):
		draw_line(Vector2(0, y), Vector2(grid_width, y), grid_color)

	# Desenha os eixos nas posições especificadas
	draw_line(Vector2(y_axis_position, 0), Vector2(y_axis_position, grid_height), y_axis_color)  # Eixo Y
	draw_line(Vector2(0, x_axis_position), Vector2(grid_width, x_axis_position), x_axis_color)  # Eixo X

# Função para desenhar os números em pontos específicos
func draw_numbers() -> void:
	if custom_font == null:
		push_error("Nenhuma fonte foi atribuída!")
		return

	# Verifica se o número de posições e valores são iguais
	if number_positions.size() != number_values.size():
		push_error("O número de posições e valores deve ser igual!")
		return

	# Desenha os números nas posições personalizadas
	for i in range(number_positions.size()):
		var position = number_positions[i]
		var number = str(number_values[i])  # Pega o número correspondente
		draw_string(custom_font, position, number, HORIZONTAL_ALIGNMENT_CENTER)

func _process(delta: float) -> void:
	queue_redraw()  # Redesenha a cada frame
