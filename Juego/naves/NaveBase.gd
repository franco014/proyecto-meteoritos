#NaveBase.gd
class_name NaveBase
extends RigidBody2D

##Enums
enum ESTADO{SPAWN,VIVO,INVENCIBLE,MUERTO}


## atributos export
export var hitpoints: float = 20.0

## atributos
var estado_actual:int = ESTADO.SPAWN

## atributos Onready
onready var canion:Canion = $canion
onready var colisionador:CollisionShape2D = $CollisionShape2D
onready var sonidoa_danio:AudioStreamPlayer = $sonidoDanio

##Metodos
func _ready() -> void:
	controlador_estados(estado_actual)


##Metodos custom
func controlador_estados(nuevo_estado:int) -> void:
	match nuevo_estado:
		ESTADO.SPAWN:
			colisionador.set_deferred("disabled",true)
			canion.set_puede_disparar(false)
		ESTADO.VIVO:
			colisionador.set_deferred("disabled",false)
			canion.set_puede_disparar(true)
		ESTADO.INVENCIBLE:
			colisionador.set_deferred("disabled",true)
		ESTADO.MUERTO:
			colisionador.set_deferred("disabled",true)
			canion.set_puede_disparar(false)
			Eventos.emit_signal("nave_destruida",self,global_position,3)
			queue_free()
			
		_:
			printerr("Error de estado")
	estado_actual = nuevo_estado


func destruir():
	controlador_estados(ESTADO.MUERTO)

func recibir_danio(danio: float) -> void:
	hitpoints -= danio
	sonidoa_danio.play()
	if hitpoints <= 0.0:
		destruir()


##señales internas
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "spawn":
		controlador_estados(ESTADO.VIVO)




func _on_Player_body_entered(body: Node) -> void:
	if body is Meteorito:
		body.destruir()
		destruir()
