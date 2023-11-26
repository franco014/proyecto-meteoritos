##EnemigoInterceptor.gd
class_name EnemigoInterceptor
extends EnemigoBase

##enums
enum ESTADO_IA {IDLE, ATACANDOQ, ATACANDOP, PERSECUSION}

##atributos export
export var potencia_max: float = 800.0

##atributos
var estado_ia_actual:int = ESTADO_IA.IDLE
var potencia_actual: float = 0.0

##metodos
func _ready() -> void:
	Eventos.emit_signal("minimapa_objeto_creado")
	$CollisionShape2D.set_deferred("disabled", false)


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	linear_velocity += dir_player.normalized() * potencia_actual * state.get_step()
	
	linear_velocity.x = clamp(linear_velocity.x, -potencia_max, potencia_max)
	linear_velocity.y = clamp(linear_velocity.x, -potencia_max, potencia_max)

##metodos customs
func controlar_estado_ia(nuevo_estado: int ) -> void:
	match nuevo_estado:
		ESTADO_IA.IDLE:
			canion.set_esta_disparando(false)
			potencia_actual = 0.0
		ESTADO_IA.ATACANDOQ:
			canion.set_esta_disparando(true)
			potencia_actual = 0.0
		ESTADO_IA.ATACANDOP:
			canion.set_esta_disparando(true)
			potencia_actual = potencia_max
		ESTADO_IA.PERSECUSION:
			canion.set_esta_disparando(false)
			potencia_actual = potencia_max
		_:
			printerr("Error de estado")
	
	estado_ia_actual = nuevo_estado

##señales internas
func _on_AreaDisparo_body_entered(body: Node) -> void:
	controlar_estado_ia(ESTADO_IA.ATACANDOP)


func _on_AreaDisparo_body_exited(body: Node) -> void:
	controlar_estado_ia(ESTADO_IA.PERSECUSION)


func _on_AreaDeteccion_body_entered(body: Node) -> void:
	controlar_estado_ia(ESTADO_IA.ATACANDOQ)


func _on_AreaDeteccion_body_exited(body: Node) -> void:
	controlar_estado_ia(ESTADO_IA.ATACANDOP)
