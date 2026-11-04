extends Area2D

#Outros nodes
@onready var player = get_node("../playerShak");

#variaveis
var dir = Vector2();
var speed = 10;

#funções na inicialização
func _ready() -> void:
	#teste se instaciamos o player corretamente
	if !(player is CharacterBody2D):
		OS.alert("não pegou o player");
		queue_free();
		
	#posição inicial do tiro relacionada ao Player com o ajuste de posição
	position = player.position;
	position.y += 20;
	position.x += -5;
	
	#direção do tiro em relação ao player
	dir = player.lastDir;
	
	#rotacionar o sprite para ajeitar em relação a direção
	if (dir.y!=0):
		if (dir.x == 0):
			rotate(rad_to_deg(90));
		elif ((dir.x*dir.y)<0):
			rotate(rad_to_deg(-135));
		elif ((dir.x*dir.y)>0):
			rotate(rad_to_deg(135));

	
	
	
#funções não físicas por frame
func  _physics_process(_delta: float) -> void:
	position = (position + (dir*speed));

#desaparece automa
func _on_kill_atack_timeout() -> void:
	queue_free();


#se acertar o inimigo
func _on_area_entered(area: Area2D) -> void:
	if area.name == "iniJoao":
		area.takeHit();
		queue_free();
