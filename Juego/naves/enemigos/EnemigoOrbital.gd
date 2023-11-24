#EnemigoOrbital.gd
class_name EnemigoOrbital
extends EnemigoBase

##atributos export 
export var rango_maximo_ataque: float = 1400.0

##atributos 
var base_duenia: Node2D


##constructor
func crear(pos:Vector2, duenia:Node2D) -> void:
	global_position = pos 
	base_duenia = duenia

##metodos
func _ready() -> void:
	Eventos.connect("base_destruida",self, "_on_base_destruida")
	canion.set_esta_disparando(true)

##metodos customs
func rotar_hacia_player( ) -> void:
	.rotar_hacia_player()
	if dir_player.length() > rango_maximo_ataque:
		canion.set_esta_disparando(false)
	else:
		canion.set_esta_disparando(true)
	

##señales externas
func _on_base_destruida(base:Node2D, _pos) -> void:
	if base == base_duenia:
		destruir()

