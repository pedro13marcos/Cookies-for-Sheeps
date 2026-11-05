extends Control

#variaveis de confirmação
var oldLang = "null";
var oldLayout = "null"
var oldResIndex: int = 1
var oldFullscreen: bool = false


#inicio
func  _ready() -> void:
	#seta a lingua apartir do configurado
	TranslationServer.set_locale(Global.language);
	#setar o botao no iniciar
	$"Options Menu".hide();
	$MenuContainer/Jogar.grab_focus();
	if Global.checkSave():
		$MenuContainer/Continuar.show();
	else:
		$MenuContainer/Continuar.hide();
	pass;

#ao selecionar jogar
func _on_jogar_button_up() -> void:
	get_tree().change_scene_to_file("res://nodes/cutscene_inicial.tscn");
	
#ao selecionar sair
func _on_sair_button_up() -> void:
	get_tree().quit();

#ao selecionar continuar
func _on_continuar_button_up() -> void:
	Global.load_game();

#Abre para mostrar o idioma quando abre o menu e o layout de controle
func _on_options_button_up() -> void:
	#variaveis de confirmação
	oldLang = TranslationServer.get_locale();
	oldLayout = Global.layout;
	oldResIndex = Global.resolution_index;
	oldFullscreen = Global.fullscreen;

	$MenuContainer.hide();
	$"Options Menu".show();
	if (TranslationServer.get_locale().begins_with("pt")):
		$"Options Menu/optionsContainer/MenuButton".selected = 0;
	elif(TranslationServer.get_locale().begins_with("es")):
		$"Options Menu/optionsContainer/MenuButton".selected = 1;
	else: $"Options Menu/optionsContainer/MenuButton".selected = 2;

	$"Options Menu/optionsContainer/MenuResolution".selected = clampi(Global.resolution_index, 0, Global.RESOLUTIONS.size() - 1);
	$"Options Menu/optionsContainer/MenuFullscreen".selected = 1 if Global.fullscreen else 0;
	$"Options Menu/optionsContainer/MenuButton".grab_focus();
		

#Botao de voltar (Cancelar)
func _on_voltar_button_up() -> void:
	#Restaurando as configurações anteriores caso cancele
	TranslationServer.set_locale(oldLang);
	Global.language = oldLang;
	Global.layout = oldLayout;
	Global.resolution_index = oldResIndex;
	Global.fullscreen = oldFullscreen;
	Global.apply_display_settings();
	#Voltando para a tela anterior
	$"Options Menu".hide();
	$MenuContainer.show();
	$MenuContainer/Options.grab_focus();

#Botao de salvar
func _on_salvar_button_up() -> void:
	#Salvando as variaveis no Global para save
	Global.language = TranslationServer.get_locale();
	Global.layout = "auto";
	Global.apply_display_settings();
	#Salvando as configurações em arquivo
	Global.save_config();
	#Voltando para a tela anterior
	$"Options Menu".hide();
	$MenuContainer.show();
	$MenuContainer/Options.grab_focus();

#Muda o idioma pelo menu
func _on_menu_button_item_selected(index: int) -> void:
	match(index):
		0:
			TranslationServer.set_locale("pt");
		1:
			TranslationServer.set_locale("es");
		2:
			TranslationServer.set_locale("en");
	pass;

func _on_menu_resolution_item_selected(index: int) -> void:
	Global.resolution_index = clampi(index, 0, Global.RESOLUTIONS.size() - 1);
	if Global.fullscreen:
		Global.fullscreen = false;
		$"Options Menu/optionsContainer/MenuFullscreen".selected = 0;
	Global.apply_display_settings();

func _on_menu_fullscreen_item_selected(index: int) -> void:
	Global.fullscreen = (index == 1);
	Global.apply_display_settings();
