#SectorMeteoritos.gd
class_name SectorMeteoritos
extends Node2D

##atributos export
export var cantidad_meteoritos:int = 10
export var intervalo_spawn: float = 1.2

##atributos
var spawners: Array

##Metodos
func _ready() -> void:
	$Timer.wait_time = intervalo_spawn
	almacenar_spawner()
	conectar_seniales_detectores()
	

##constructor
func crear(pos:Vector2,meteoritos:int) -> void:
	global_position = pos 
	cantidad_meteoritos = meteoritos

##metodos customs
func almacenar_spawner() -> void:
	for spawner in $Spawner.get_children():
		spawners.append(spawner)

func conectar_seniales_detectores() -> void:
	for detector in $DetectoresFueraZona.get_children():
		detector.connect("body_entered",self,"_on_detector_body_entered")

func spawner_aleatorio() -> int:
	randomize()
	return randi() % spawners.size()

##señales internas
func _on_Timer_timeout() -> void:
	if cantidad_meteoritos == 0:
		$Timer.stop()
		return
		
	spawners[spawner_aleatorio()].spawnear_meteorito()
	cantidad_meteoritos -= 1

func _on_detector_body_entered(body:Node) -> void:
	body.set_esta_en_sector(false)
