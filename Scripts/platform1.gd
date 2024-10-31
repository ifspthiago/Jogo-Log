extends Node2D

const wait_duration = 1.0
@onready var platform = $platform as AnimatableBody2D
@export var move_speed = 4.0
@export var distance = 792
@export var move_horizontal = true

var follow = Vector2.ZERO
var platform_center = 16
var area1_activated = false
var area2_activated = false

func _ready():
	platform.visible = false
	platform.collision_layer = 0
	platform.collision_mask = 0
	move_platform()
	var area1 = get_node("Table_f(x)")
	var area2 = get_node("Table_x")
	if area1 and area2:
		# Conecta os sinais das áreas usando Callable
		area1.connect("area1_activated", Callable(self, "_on_area1_activated"))
		area2.connect("area2_activated", Callable(self, "_on_area2_activated"))
	else:
		print("Erro: Area1 ou Area2 não está disponível")

func _on_area1_activated():
	area1_activated = true
	check_areas()

func _on_area2_activated():
	area2_activated = true
	check_areas()

func check_areas():
	if area1_activated and area2_activated:
		platform.visible = true
		platform.collision_layer = 1
		platform.collision_mask = 1

func _physics_process(delta):
	platform.position = platform.position.lerp(follow, 0.1)

func move_platform():
	var move_direction = (Vector2.RIGHT + Vector2.UP).normalized() * distance
	var duration = move_direction.length() / float(move_speed * platform_center)
	var platform_tween = create_tween()
	platform_tween.set_loops().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	platform_tween.tween_property(self, "follow", move_direction, duration).set_delay(wait_duration * 2)
	platform_tween.tween_property(self, "follow", Vector2.ZERO, duration).set_delay(duration + wait_duration)
