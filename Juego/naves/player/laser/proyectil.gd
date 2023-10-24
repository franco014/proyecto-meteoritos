#proyectil.gd
class_name proyectil
extends Area2D

##atributos
var velocidad:Vector2 = Vector2.ZERO
var danio:float

##metodos
func crear(pos: Vector2, dir: float,vel: float,danio_p: int):
	position = pos
	rotation = dir
	velocidad = Vector2(vel,0).rotated(dir)
	danio = danio_p

func _physics_process(delta: float) -> void:
	position += velocidad*delta
