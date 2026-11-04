extends Area2D

#variaveis
@export var speed = 1.5;
var vida = 3;

#nodes
@onready var hud = $"../HUD"
@onready var player = get_node("../playerShak");
@onready var parent = get_node("..");
@onready var paoIten = preload("res://nodes/paoIten.tscn");
@onready var drogaIten = preload("res://nodes/drogaIten.tscn");
@onready var porta = $"../porta";

#funções na inicialização
func _ready() -> void:
	#teste se instaciamos o player corretamente
	if !(player is CharacterBody2D):
		OS.alert("não pegou o player");
		queue_free();

#funções atualizadas de física
func _physics_process(_delta: float) -> void:
	#movimento de perseguir o player
	if player.position.x > position.x:
		position.x+=speed;
	else:
		position.x -= speed;
		
	if player.position.y > position.y:
		position.y+=speed;
	else:
		position.y -= speed;

#delimitando a area
	# Get the screen size
	var screen_size = get_viewport_rect().size
	
	# Clamp the position
	# clamp(value, min, max)
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

#tempo de dropar item
func _on_drop_item_timeout() -> void:
	randomize();
	#dropa pao
	if (randi_range(0,1)):
		parent.add_child(paoIten.instantiate());
	#dropa drogas
	else:
		parent.add_child(drogaIten.instantiate());
	$dropItem2.play(0.48);

#detecta colisao e aciona o takeHit no player
func _on_body_entered(body: Node2D) -> void:
	if (body.name == "playerShak"):
		body.takeHit();
		
#toma hit do inimigo
func takeHit():
	vida-=1;
	hud.attHud();
	if vida <= 0:
		hud.morreuInimigo();
		porta.abrindo();
		$morto.play(0.58);
		queue_free();
	else:
		$takehit.play(0.87);
		
