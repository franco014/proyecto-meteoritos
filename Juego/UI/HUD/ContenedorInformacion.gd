#contenedorInformacion.gd
class_name ContenedorInformacion
extends NinePatchRect

##atributo export 
export var auto_ocultar:bool = false setget set_auto_ocultar

var esta_activo:bool =true setget set_esta_activo

##setters and getters
func set_auto_ocultar(se_oculta:bool) -> void:
	auto_ocultar = se_oculta

func set_esta_activo(valor:bool) -> void:
	esta_activo = valor


##atributos onready
onready var texto_contenedor:Label = $Label
onready var auto_ocultar_timer:Timer = $AutoOcultarTimer
onready var animaciones:AnimationPlayer = $AnimationPlayer	


##metodos
func mostrar() -> void:
	if esta_activo:
		$AnimationPlayer.play("mostrar")

func ocultar() -> void:
	if not esta_activo:
		animaciones.stop()
	$AnimationPlayer.play("ocultar")

func mostrar_suavizado() -> void:
	if not esta_activo:
		return
	$AnimationPlayer.play("mostrar_suavizado")
	if auto_ocultar:
		auto_ocultar_timer.start()

func ocultar_suavizado() -> void:
	if esta_activo:
		$AnimationPlayer.play("ocultar_suavizado ") 

func modificar_texto(text: String) -> void:
	texto_contenedor.text = text


func _on_AutoOcultarTimer_timeout() -> void:
	ocultar_suavizado()
