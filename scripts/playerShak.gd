extends CharacterBody2D

#variáveis

@export var speed = 250;
var facingDir = Vector2();
var dir = Vector2();
var lastDir = Vector2(1,0);
var hurtCoolDown  = false;
var isDead = false;
var paos = 0;
var vida: int:
	get:
		return Global.vidas
	set(valor):
		Global.vidas = valor;

#Carregando outros nodes

@onready var parent = get_node("..");
@onready var novoPao = preload("res://nodes/paoAtack.tscn");
@onready var deadSprite = preload("res://sprites/shakira/ai/player_dead.png");
#@onready var anim = $AnimatedSprite2D
@onready var anim = $AnimationPlayer
@onready var hud = $"../HUD"

#função de início
func _ready() -> void:
	hud.attHud();
	anim.play("idle");

#função atualizada com os fps relacionadas a física
func _physics_process(_delta):
	if isDead:
		velocity = Vector2.ZERO;
		move_and_slide();
		return;
	
	#Reseta o dir pra não andar pra sempre
	dir = Vector2();
	#Andar e trocar de sprite:
	if Input.is_action_pressed("ui_left"):
		dir.x = -1;
		lastDir = dir;
	if Input.is_action_pressed("ui_right"):
		dir.x = 1;
		lastDir = dir;
	if Input.is_action_pressed("ui_up"):
		dir.y = -1;
		lastDir = dir;
	if Input.is_action_pressed("ui_down"):
		dir.y = 1;
		lastDir = dir;
	
	#Troca de sprite
	if (dir.x == 0 && dir.y== 0):
		anim.play("idle");
	else:
		anim.play("walking");
		if lastDir.x<0 && $Sprite2D.scale.x>0:
			$Sprite2D.scale.x*=-1;
		elif  lastDir.x>=0 && $Sprite2D.scale.x<0:
			$Sprite2D.scale.x*=-1;
		#anim.play("walking");
		#if (dir.x<0):
			#anim.flip_h = true;
		#else: anim.flip_h = false;
		
	#se eu tomei dano eu ando mais rapido pelo tempo do cool down
	if (hurtCoolDown):velocity = dir*(speed+300);
	else: velocity = dir*speed;
	
	#Andar acontece.
	move_and_slide();
	
	#delimitando a area
	# Get the screen size
	var screen_size = get_viewport_rect().size
	
	# Clamp the position
	# clamp(value, min, max)
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	#Atira Pão
	if Input.is_action_just_pressed("Atack"):
		if (paos > 0):
			$atack.play(0.8);
			paos-=1;
			hud.attHud();
			parent.add_child(novoPao.instantiate());
			

#processos fora das fisicas
func _process(_delta: float) -> void:
	pass;

	
#funcao que adiciona pao no script de iten
func addPao():
	paos+=1;
	hud.attHud();

#funcao que tira vida quando bate com o inimigo ou droga, muda a cor pra vermelho e começa o cooldown
func takeHit():
	if isDead:
		return;
	if(!hurtCoolDown):
		vida-=1;
		modulate = Color.RED;
		$coolDownTimer.start();
		hurtCoolDown = true;
		hud.attHud();
		if (vida <= 0): 
			die();
		else:
			$hit.play(0.9);
		
		#OS.alert("player = "+str(vida)+"/n global = "+str(Global.vidas));

#Funcao de morte: trava movimento, troca a sprite para morta e deita na horizontal
func die() -> void:
	isDead = true;
	$morteTimer.start();
	$morte.play(0.49);
	anim.stop();
	modulate = Color.WHITE;
	$coolDownTimer.stop();
	hurtCoolDown = true;
	$CollisionShape2D.set_deferred("disabled", true);
	$Sprite2D.texture = deadSprite;
	
	# Deita o personagem na horizontal como se estivesse morto
	var target_rot = deg_to_rad(90.0) if $Sprite2D.scale.x > 0 else deg_to_rad(-90.0);
	var tween = create_tween();
	tween.set_parallel(true);
	tween.tween_property($Sprite2D, "rotation", target_rot, 0.25).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT);
	tween.tween_property($Sprite2D, "position:y", 18.0, 0.25).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT);

#Timer depois do hit
func _on_cool_down_timer_timeout() -> void:
	if not isDead:
		modulate = Color.WHITE;
		hurtCoolDown = false;

#get de teste de pao
func getPao():
	return paos;


func _on_morte_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://nodes/shakira_morreu.tscn");
