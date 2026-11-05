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
	if Global.is_cookie_locale():
		$HUD/paoIcon.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR;
		$HUD/paoIcon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE;
		$HUD/paoIcon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED;
		$HUD/paoIcon.offset_left = -205.0;
		$HUD/paoIcon.offset_top = 6.0;
		$HUD/paoIcon.offset_right = -75.0;
		$HUD/paoIcon.offset_bottom = 126.0;

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
