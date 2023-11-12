#nivel.gd
class_name Nivel
extends Node2D

##atributos export
export var expolosion:PackedScene = null


##atributos Onready
onready var contenedor_proyectiles:Node

## metodos
func _ready() -> void:
	conectar_seniales()
	crear_contenedores()

## motodos customs
func conectar_seniales() -> void:
	Eventos.connect("disparo",self,"_on_disparo")
	Eventos.connect("nave_destruida",self,"_on_nave_destruida")

func crear_contenedores() -> void:
	contenedor_proyectiles =Node.new()
	contenedor_proyectiles.name = "contenedorProyectiles"
	add_child(contenedor_proyectiles)

func _on_disparo(proyectil:proyectil) ->void:
	contenedor_proyectiles.add_child(proyectil)

func _on_nave_destruida(posicion:Vector2, num_explosiones:int) -> void:
	for i in range(num_explosiones):
		var new_explosion:Node2D = expolosion.instance()
		new_explosion.global_position = posicion
		add_child(new_explosion)
