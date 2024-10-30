extends Node2D

var grid_size: int = 32  # Tamanho dos quadrados da malha
var grid_color: Color = Color(0.1, 0.1, 0.1)  # Cor da malha
var x_axis_color: Color = Color(1, 0, 0)  # Cor do eixo X (vermelho)
var y_axis_color: Color = Color(0, 1, 0)  # Cor do eixo Y (verde)

@export var custom_font: Font  # Usando a nova classe Font

# Define as dimensões da malha
var grid_width: int = 2440  # Largura da malha
var grid_height: int = 700   # Altura da malha

func _ready() -> void:
	if custom_font == null:
		push_error("Nenhuma fonte foi atribuída!")
	queue_redraw()  # Solicita o redesenho da tela quando a cena é carregada

func _draw() -> void:
	draw_grid()  # Desenha a malha e os eixos
	draw_numbers()  # Desenha os números nos eixos

# Função para desenhar a malha
func draw_grid() -> void:
	# Desenha as linhas da malha
	for x in range(0, grid_width, grid_size):
		draw_line(Vector2(x, 0), Vector2(x, grid_height), grid_color)
	for y in range(0, grid_height, grid_size):
		draw_line(Vector2(0, y), Vector2(grid_width, y), grid_color)

	var center_x = 0
	var center_y = 320
	draw_line(Vector2(center_x, 0), Vector2(center_x, grid_height), y_axis_color)
	draw_line(Vector2(0, center_y), Vector2(grid_width, center_y), x_axis_color)

# Função para desenhar a numeração dos eixos X e Y
func draw_numbers() -> void:
	var center_x = 0
	var center_y = 326

	if custom_font == null:
		push_error("Nenhuma fonte foi atribuída!")
		return

	# Desenha os números no eixo X
	for i in range(-int(grid_width / (2 * grid_size)), int(grid_width / (2 * grid_size)) + 1):
		if i != 0:
			var x_position = center_x + i * grid_size
			draw_string(custom_font, Vector2(x_position, center_y + 55), str(i), HORIZONTAL_ALIGNMENT_CENTER)

	# Desenha os números no eixo Y
	for i in range(-int(grid_height / (2 * grid_size)), int(grid_height / (2 * grid_size)) + 1):
		if i != 0:
			var y_position = center_y - i * grid_size
			draw_string(custom_font, Vector2(center_x + 5, y_position), str(i), HORIZONTAL_ALIGNMENT_CENTER)

func _process(delta: float) -> void:
	queue_redraw()  # Redesenha a cada frame
