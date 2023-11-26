#ReleDeMasa.gd
class_name ReleMasa
extends Node2D

onready var colisionador:CollisionShape2D = $Area2D/CollisionPolygon2D


##metodos
func _ready() -> void:
	Eventos.emit_signal("minimapa_objeto_creado")

##metodos customs
func atraer_jugador(body: Node) -> void:
	$Tween.interpolate_property(
		body,
		"global_position",
		body.global_position,
		global_position,
		1.0,
		Tween.TRANS_CIRC,
		Tween.EASE_IN
	)
	
	$Tween.start()


##señales internas
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "spawn":
		$AnimationPlayer.play("activada")
		colisionador.set_deferred("disabled",false)


func _on_Area2D_body_entered(body: Node) -> void:
	colisionador.set_deferred("disabled", true)
	$AnimationPlayer.play("super_activada")
	body.desactivar_controles()
	atraer_jugador(body)


func _on_Tween_tween_all_completed() -> void:
	Eventos.emit_signal("nivel_completado")
