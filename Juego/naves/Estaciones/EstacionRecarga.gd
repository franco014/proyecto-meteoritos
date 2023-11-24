#EstacionRecarga.gd
class_name EstacionRecarga
extends Node2D

##atributo export
export var energia:float = 6.0
export var radio_energia_entregada:float = 0.05

##atributos
var nave_player:Player = null
var player_en_zona:bool = false

##atributo onready 
onready var carga_sfx:AudioStreamPlayer = $SonidoRecarga


##metodos
func _unhandled_input(event: InputEvent) -> void:
	if not puede_recargar(event):
		return
	
	controlar_energia()
	
	if event.is_action("recargarEscudo"):
		nave_player.get_escudo().controlar_energia(radio_energia_entregada)
	elif event.is_action("RecargarLaser"):
		nave_player.get_laser().controlar_energia(radio_energia_entregada)

##metodosCustoms
func puede_recargar(event: InputEvent) -> bool:
	var hay_input = event.is_action("recargarEscudo") or event.is_action("RecargarLaser")
	if hay_input and player_en_zona and energia > 0.0:
		if !carga_sfx.playing:
			carga_sfx.play()
		return true
	return false

func controlar_energia() -> void:
	energia -=radio_energia_entregada
	if energia <= 0.0:
		$SonidoSinEnergia.play()
	

##señales internas
func _on_AreaColision_body_entered(body: Node) -> void:
	if body.has_method("destruir"):
		body.destruir()


func _on_AreaDeRecarga_body_entered(body: Node) -> void:
	if body is Player:
		player_en_zona = true
		nave_player = body
	
	
	


func _on_AreaDeRecarga_body_exited(body: Node) -> void:
	if body is Player:
		player_en_zona = false
