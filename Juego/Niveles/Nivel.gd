#nivel.gd
class_name Nivel
extends Node2D

##atributos export
export var expolosion:PackedScene = null
export var meteorito:PackedScene = null
export var sector_meteoritos: PackedScene = null
export var tiempo_transicion_camara: int = 1

##atributos Onready
onready var contenedor_proyectiles:Node
onready var contenedor_meteoritos:Node
onready var contenedor_sector_meteoritos:Node
onready var camara_nivel:Camera2D = $CameraNivel

## metodos
func _ready() -> void:
	conectar_seniales()
	crear_contenedores()

## motodos customs
func conectar_seniales() -> void:
	Eventos.connect("disparo",self,"_on_disparo")
	Eventos.connect("nave_destruida",self,"_on_nave_destruida")
	Eventos.connect("spawn_meteoritos",self,"_on_spawn_meteoritos")
	Eventos.connect("nave_en_sector_peligro",self,"_on_nave_en_sector_peligro")

func crear_contenedores() -> void:
	contenedor_proyectiles =Node.new()
	contenedor_proyectiles.name = "contenedorProyectiles"
	add_child(contenedor_proyectiles)
	
	contenedor_meteoritos = Node.new()
	contenedor_meteoritos.name = "contenedorMeteoritos"
	add_child(contenedor_meteoritos)
	
	contenedor_sector_meteoritos = Node.new()
	contenedor_sector_meteoritos.name = "contenedorSectorMeteoritos"
	add_child(contenedor_sector_meteoritos)

func _on_nave_en_sector_peligro(centro_cam:Vector2,tipo_peligro:String,num_peligros:int) -> void:
	if tipo_peligro == "Meteoritos":
		crear_sector_meteoritos(centro_cam,num_peligros)
		
	elif tipo_peligro =="Enemigo":
		pass
	

func crear_sector_meteoritos(centro_camara:Vector2,numero_peligros:int) -> void:
	var new_sector_meteoritos:SectorMeteoritos = sector_meteoritos.instance()
	new_sector_meteoritos.crear(centro_camara,numero_peligros)
	camara_nivel.global_position = centro_camara
	contenedor_sector_meteoritos.add_child(new_sector_meteoritos)
	transicion_camaras(
		$Player/CameraPlayer.global_position,
		camara_nivel.global_position,
		camara_nivel
	)

func transicion_camaras(desde: Vector2,hasta: Vector2, Camara_actual:Camera2D) -> void:
	$TweenCamara.interpolate_property(
		Camara_actual,
		"global_position",
		desde,
		hasta,
		tiempo_transicion_camara,
		$TweenCamara.TRANS_LINEAR,
		$TweenCamara.EASE_IN_OUT
	)
	Camara_actual.current = true
	$TweenCamara.start()

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
