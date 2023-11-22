class_name Player
extends NaveBase

## atributos export
export var potencia_motor:int = 18
export var potencia_rotacion:int = 260
export var estela_maxima = 150

#atributos
var empuje:Vector2 = Vector2.ZERO
var dir_rotacion:int = 0

##atributos onready
onready var laser:RayoLaser = $LaserBeam2D setget , get_laser
onready var estela:Estela = $EstelaPositionInicio/Trail2D
onready var motor_sfx:Motor = $motorSFX
onready var escudo:Escudo = $Escudo setget , get_escudo


##setters and getters
func get_laser() -> RayoLaser:
	return laser

func get_escudo() -> Escudo:
	return escudo

##metodos
func _unhandled_input(event: InputEvent) -> void:
	if not esta_input_activo():
		return
	
	#Disparo Rayo
	if event.is_action_pressed("disparo secundario"):
		laser.set_is_casting(true)
	
	if event.is_action_released("disparo secundario"):
		laser.set_is_casting(false)
	
	##Control estela y sonido motor
	if event.is_action_pressed("mover_adelante"):
		estela.set_max_point(estela_maxima)
		motor_sfx.sonido_on()
	elif event.is_action_pressed("mover_atras"):
		estela.set_max_point(0)
		motor_sfx.sonido_on()
		
	if (event.is_action_released("mover_adelante")
		or event.is_action_released("mover_atras")):
			motor_sfx.sonido_off()
	
	##control escudo
	if event.is_action_pressed("escudo") and not escudo.get_esta_activado():
		escudo.activar()


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	apply_central_impulse(empuje.rotated(rotation))
	apply_torque_impulse(dir_rotacion * potencia_rotacion)


func _process(delta: float) -> void:
	player_input()


##metodos customs
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
