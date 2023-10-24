#Player.gd
class_name Player
extends RigidBody2D

# atributos export
export var potencia_motor:int = 20
export var potencia_rotacion:int = 280

# atributos
var empuje:Vector2 = Vector2.ZERO
var dir_rotacion:int = 0

## atributos Onready
onready var canion:Canion = $canion

##Metodos
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	apply_central_impulse(empuje.rotated(rotation))
	apply_torque_impulse(dir_rotacion * potencia_rotacion)


func _process(delta: float) -> void:
	player_input()

##Metodos custom
func player_input() -> void:
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
