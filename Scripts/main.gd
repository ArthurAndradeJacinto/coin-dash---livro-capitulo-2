extends Node2D;

@export var powerup_scene : PackedScene

@export var playtime = 30;

var level = 1;
var score = 0;
var time_left = 0;
var screensize = Vector2.ZERO; 
var playing = false; #Aqui o jogo ainda não começou e todas as variáveis ficam no seu estado inicial.


func spawn_coins():
	$LevelSound.play();
	for i in level + 4: #vai spawnar a quantidade de moedas.
		var c = coin_scene.instantiate(); #Cria uma cópia da moeda.
		add_child(c); #faz a moeda virar um nó filho do Node2d.
		c.screensize = screensize; #Dá o tamanho da tela pra moeda.
		c.position = Vector2(randi_range(0, screensize.x),
		randi_range(0, screensize.y)); #Vai spawnar a moeda em um local aleatório na tela.


func new_game():
	playing = true; #Aqui o jogo começa.
	level = 1;
	score = 0;
	time_left = playtime; #O tempo restante vira o tempo máximo de jogo.
	$Player.start();  #Vai iniciar o player e deixa-lo pronto, mas invisível.
	$Player.show();  #Agora fica visível
	$Game_Timer.start(); #Começa o contador
	spawn_coins(); #spawna as moedas em locais aleatórios do mapa.
	$HUD.update_score(score);
	$HUD.update_time(time_left);

func game_over():
	playing = false #Para o jogo.
	$Game_Timer.stop() #Para o Timer de main.
	get_tree().call_group("coins", "queue_free") #Arrebata todas as moedas.
	$HUD.show_game_over() #Mostra a tela de game over.
	$Player.die() #player executa o comando de morte.
	$EndSound.play();


func _ready() -> void:
	screensize = get_viewport().get_visible_rect().size;  #screensize = tamanho da tela.
	$Player.screensize = screensize; #Dá o tamanho da tela pro player.
	$Player.hide(); #Esconde o player.


func _process(delta: float) -> void:
	if playing and get_tree().get_nodes_in_group("coins").size() == 1: #Se o jogo estiver funcionando e não tiver nenhuma moeda na tela...
		level += 1; #Aumenta o level em 1.
		time_left += 5; #Aumenta o temporizador em +5
		spawn_coins(); #Spawna as moedas de novo.


func _on_game_timer_timeout() -> void: #Quando o temporizador de main chegar a 0.
	time_left -= 1; #Diminui o time_left em 1.
	$HUD.update_time(time_left); #Muda o tempo para o time_leeft já diminuido.
	
	if time_left <= 0: #Quando time_left for 0 ou menos, vai dar game over.
		game_over();


func _on_player_hurt() -> void:
	game_over(); 


func _on_player_pickup(type):
	match type:
		"coin":
			score += 1; #Aumenta o score.
			$HUD.update_score(score); #mostra o score já aumentado.
			$CoinSound.play();
		
		"powerup":
			$PowerupSound.play();
			time_left += 5;
			$HUD.update_timer(time_left);

func _on_hud_start_game() -> void:
	new_game(); #Quando o botão for clicado, começa o jogo.
