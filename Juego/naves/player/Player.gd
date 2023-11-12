#Player.gd
class_name Player
extends RigidBody2D

##Enums
enum ESTADO{SPAWN,VIVO,INVENCIBLE,MUERTO}


## atributos export
export var potencia_motor:int = 20
export var potencia_rotacion:int = 280
export var estela_maxima = 150
export var hitpoints: float = 15.0

## atributos
var empuje:Vector2 = Vector2.ZERO
var dir_rotacion:int = 0
var estado_actual:int = ESTADO.SPAWN

## atributos Onready
onready var canion:Canion = $canion
onready var laser:RayoLaser = $LaserBeam2D
onready var estela:Estela = $EstelaPositionInicio/Trail2D
onready var motor_sfx:Motor = $motorSFX
onready var colisionador:CollisionShape2D = $CollisionShape2D
onready var sonidoa_danio:AudioStreamPlayer = $sonidoDanio

##Metodos
func _ready() -> void:
	controlador_estados(estado_actual)



func _unhandled_input(event: InputEvent) -> void:
	if not esta_input_activo():
		return
	
	#Disparo Rayo
	if event.is_action_pressed("disparo secundario"):
		laser.set_is_casting(true)
	
	if event.is_action_released("disparo secundario"):
		laser.set_is_casting(false)
		
	if event.is_action_pressed("mover_adelante"):
		estela.set_max_point(estela_maxima)
		motor_sfx.sonido_on()
	elif event.is_action_pressed("mover_atras"):
		estela.set_max_point(0)
		motor_sfx.sonido_on()
		
	if (event.is_action_released("mover_adelante")
		or event.is_action_released("mover_atras")):
			motor_sfx.sonido_off()

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	apply_central_impulse(empuje.rotated(rotation))
	apply_torque_impulse(dir_rotacion * potencia_rotacion)


func _process(delta: float) -> void:
	player_input()



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
			canion.set_puede_disparar(true)
			Eventos.emit_signal("nave_destruida",global_position,3)
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


func esta_input_activo() -> bool:
	if estado_actual in [ESTADO.MUERTO,ESTADO.SPAWN]:
		return false
	
	return true

func player_input() -> void:
	if not esta_input_activo():
		return
	
	#empuje
	empuje = Vector2.ZERO
	if Input.is_action_pressed("mover_adelante"):
		empuje = Vector2(potencia_motor,0)
	elif Input.is_action_pressed("mover_atras"):
		empuje = Vector2(-potencia_motor,0)

	#rotacion
	dir_rotacion = 0
	if Input.is_action_pressed("rotar_horario"):
		dir_rotacion += 1
	elif Input.is_action_pressed("rotar_antihorario"):
		dir_rotacion -= 1
		
	#disparo
	if Input.is_action_pressed("disparo principal"):
		canion.set_esta_disparando(true)
		
	if Input.is_action_just_released("disparo principal"):
		canion.set_esta_disparando(false)


##señales internas
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "spawn":
		controlador_estados(ESTADO.VIVO)

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()






