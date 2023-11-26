#BarraSalud.gd
class_name BarraSalud
extends ProgressBar


##atributos export
export var siempre_visible:bool = false

##atributos onready 
onready var tweem_visibilidad:Tween = $TweenVisibilidad

##Metodos
func _ready() -> void:
	
	modulate = Color(1,1,1,siempre_visible)

##Metodos customs
func set_valores(hitpoints: float) -> void:
	max_value = hitpoints
	value = hitpoints

func set_hitpoint_actual(hitpoints: float) -> void:
	value = hitpoints

func controlar_barra(hitpoint_nave:float, mostrar:bool) -> void:
	value = hitpoint_nave
	
	if not tweem_visibilidad.is_active() and modulate.a != int(mostrar):
		tweem_visibilidad.interpolate_property(
			self,
			"modulate",
			Color(1,1,1,not mostrar),
			Color(1,1,1,mostrar),
			1.0,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN_OUT
		)
		tweem_visibilidad.start()

##Señales internas
func _on_TweenVisibilidad_tween_all_completed() -> void:
	if modulate.a == 1.0:
		controlar_barra(value,false)
