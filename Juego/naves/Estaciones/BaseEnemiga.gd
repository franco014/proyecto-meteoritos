#BaseEnemiga.gd
class_name BaseEnemiga
extends Node2D

##atributos export 
export var hitpoints: float = 30.0

##atributos onready 
onready var impacto_sfx: AudioStreamPlayer2D = $ImpactosSFX

##atributos
var esta_destruida:bool = false

func _ready() -> void:
	$AnimationPlayer.play(elegir_animacion_aleatoria())


##metodos customs
func recibir_danio(danio:float ) -> void:
	hitpoints -= danio
	
	if hitpoints <= 0 and not esta_destruida:
		esta_destruida = true
		destruir()
		
	impacto_sfx.play() 

func destruir() -> void:
	var posicion_partes = [
		$Sprites/Sprite1.global_position,
		$Sprites/Sprite2.global_position,
		$Sprites/Sprite3.global_position,
		$Sprites/Sprite4.global_position,
		$Sprites/Sprite5.global_position,
		$Sprites/Sprite6.global_position,
		$Sprites/Sprite7.global_position,
		$Sprites/Sprite8.global_position,
		$Sprites/Sprite9.global_position,
		$Sprites/Sprite10.global_position,
		$Sprites/Sprite11.global_position,
		$Sprites/Sprite12.global_position,
		$Sprites/Sprite13.global_position,
		$Sprites/Sprite14.global_position,
	]
	Eventos.emit_signal("base_destruida" , posicion_partes)
	queue_free()

func elegir_animacion_aleatoria() -> String:
	randomize()
	var num_anim:int = $AnimationPlayer.get_animation_list().size() - 1
	var indice_anim_aleatoria:int = randi() % num_anim + 1  
	var lista_animacion:Array = $AnimationPlayer.get_animation_list()
	
	return lista_animacion[indice_anim_aleatoria]

##señales internas
func _on_AreaColision_body_entered(body: Node) -> void:
	if body.has_method("destruir"):
		body.destruir()
