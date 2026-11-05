extends CanvasLayer

#nodes
@onready var healthbar = $HUD/healthBarShak;
@onready var enemybar = $HUD/healthBarJoao;
@onready var player = $"../playerShak";
@onready var enemy = $"../iniJoao";
@onready var paos = $HUD/lblPao;
#funções de início
func _ready() -> void:
	$HUD/x.hide();
	$HUD/paoIcon.texture = Global.get_ammo_texture();

#atualiza a hud
func attHud():
	if player:
		paos.text = str(player.paos);
		healthbar.value = player.vida;
	if enemy:
		enemybar.value = enemy.vida;

#função que altera o inimigo pra morto
func morreuInimigo():
	$HUD/x.show(); 
