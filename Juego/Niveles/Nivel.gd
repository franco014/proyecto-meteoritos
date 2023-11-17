#nivel.gd
class_name Nivel
extends Node2D

##atributos export
export var expolosion:PackedScene = null
export var meteorito:PackedScene = null

##atributos Onready
onready var contenedor_proyectiles:Node
onready var contenedor_meteoritos:Node

## metodos
func _ready() -> void:
	conectar_seniales()
	crear_contenedores()

## motodos customs
func conectar_seniales() -> void:
	Eventos.connect("disparo",self,"_on_disparo")
	Eventos.connect("nave_destruida",self,"_on_nave_destruida")
	Eventos.connect("spawn_meteoritos",self,"_on_spawn_meteoritos")

func crear_contenedores() -> void:
	contenedor_proyectiles =Node.new()
	contenedor_proyectiles.name = "contenedorProyectiles"
	add_child(contenedor_proyectiles)
	
	contenedor_meteoritos = Node.new()
	contenedor_meteoritos.name = "contenedorMeteoritos"
	add_child(contenedor_meteoritos)
	


##conectar señales externas
func _on_disparo(proyectil:proyectil) ->void:
	contenedor_proyectiles.add_child(proyectil)

func _on_nave_destruida(posicion:Vector2, num_explosiones:int) -> void:
	for i in range(num_explosiones):
		var new_explosion:Node2D = expolosion.instance()
		new_explosion.global_position = posicion
		add_child(new_explosion)

func _on_spawn_meteoritos(pos_spawn: Vector2,dir_meteorito:Vector2, tamanio: float) -> void:
	var new_meteorito:Meteorito = meteorito.instance()
	new_meteorito.crear(
		pos_spawn,
		dir_meteorito,
		tamanio
	)
	contenedor_meteoritos.add_child(new_meteorito)
