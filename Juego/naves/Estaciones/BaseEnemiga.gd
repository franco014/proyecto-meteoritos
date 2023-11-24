#BaseEnemiga.gd
class_name BaseEnemiga
extends Node2D

##atributos export 
export var hitpoints: float = 30.0
export var orbital:PackedScene = null

##atributos onready 
onready var impacto_sfx: AudioStreamPlayer2D = $ImpactosSFX

##atributos
var esta_destruida:bool = false

##metodos
func _ready() -> void:
	$AnimationPlayer.play(elegir_animacion_aleatoria())

func _process(delta: float) -> void:
	var player_objetivo:Player = DatosJuego.get_player_actual()
	if not player_objetivo:
		return
		
	var dir_player:Vector2 = player_objetivo.global_position - global_position
	var angulo_player: float = rad2deg(dir_player.angle())


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
	Eventos.emit_signal("base_destruida",self , posicion_partes)
	queue_free()

func spawnear_orbital() -> void:
	var pos_spawn:Vector2 = deteccion_cuadrante()
	
	var new_orbital:EnemigoOrbital = orbital.instance()
	new_orbital.crear(
		global_position + pos_spawn,
		self
	)
	Eventos.emit_signal("spawn_orbital",new_orbital)

func deteccion_cuadrante() -> Vector2:
	var player_objetivo:Player = DatosJuego.get_player_actual()
	
	if not player_objetivo:
		return Vector2.ZERO
	
	var dir_player:Vector2 = player_objetivo.global_position - global_position
	var angulo_player:float = rad2deg(dir_player.angle())
	
	if abs(angulo_player) <= 45.0:
		#player entra por la derecha
		return$puntosSpawn/Este.position
		#player entra por la izquierda
	elif abs(angulo_player) > 135.0 and abs(angulo_player) <= 135.0:
		return $puntosSpawn/Oeste.position
		#player entra por arriba o por abajo 
	elif abs(angulo_player) >  45.0 and abs(angulo_player) <= 135.0:
		if sign(angulo_player) > 0:
			#player entra por abajo
			return $puntosSpawn/Sur.position
		else:
			#player entra por arriba
			return $puntosSpawn/Norte.position
			
	return $puntosSpawn/Norte.position
 
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


func _on_VisibilityNotifier2D_screen_entered() -> void:
	$VisibilityNotifier2D.queue_free()
	spawnear_orbital()
