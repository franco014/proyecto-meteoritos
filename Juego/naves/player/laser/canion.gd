#canion.gd
class_name Canion
extends Node2D

## atributos export
export var proyectil:PackedScene = null
export var cadencia_disparo:float = 0.8
export var velocidad_proyectil:float = 100
export var danio_proyectil:int = 1

##atributos Onready
onready var timer_enfriamiento:Timer = $timerEnfriamiento
onready var disparoSFX:AudioStreamPlayer2D = $DisparosSFX
onready var esta_enfriado:bool = true
onready var esta_disparando:bool = false setget set_esta_disparando

##atributos
var puntos_disparos:Array = []

##setter y getters
func set_esta_disparando(disparando:bool) -> void:
	esta_disparando = disparando


## metodos
func _ready() -> void:
	almacenar_puntos_disparo()
	timer_enfriamiento.wait_time = cadencia_disparo

func _process(delta: float) -> void:
	if esta_disparando and esta_enfriado:
		disparar()

##metodosCustoms
func almacenar_puntos_disparo() -> void:
	for nodo in get_children():
		if nodo is Position2D:
			puntos_disparos.append(nodo)

func disparar() -> void:
	esta_enfriado = false
	disparoSFX.play()
	timer_enfriamiento.start()
	for punto_disparo in puntos_disparos:
		var new_proyectil:proyectil = proyectil.instance()
		new_proyectil.crear(
			punto_disparo.global_position,
			get_owner().rotation,
			velocidad_proyectil,
			danio_proyectil
			)
	print("pew pew")
	



func _on_timerEnfriamiento_timeout() -> void:
	esta_enfriado = true
