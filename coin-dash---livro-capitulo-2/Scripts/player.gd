extends Area2D;

signal pickup;
signal hurt;

@export var speed = 350;
var direction = Vector2.ZERO;  #esse Vector2.ZERO vai fazer ele m dar a direção que o boneco vai.
var screensize = Vector2(480, 720); #Já esse aqui só são dois valores, um x e um y.


func start():
	set_process(true); #avisa ao player que o jogo começou e inicia o process, permitindo que se mova.
	position = screensize / 2; #determina a posição inicial do jogador como o meio da tela.
	$AnimatedSprite2D.animation = "idle"; #faz o jogador começar com a animação de parado.
func die(): 
	$AnimatedSprite2D.animation = "hurt"; #Troca a animação para a de morte.
	set_process(false); #faz o boneco parar de poder fazr suas funções.


func _ready() -> void: # essa função inicia quando o jogo inicia.
	pass


func _process(delta: float) -> void:  #Já essa roda a todo momento, a cada frame.
	#region movimentação_do_personagem;
	
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down");  #vai dar uma direção pro direction.
	position += direction * speed * delta; #vaii mudar a posição, adicionando uma variação de posição (velocidade) a uma direction.
	
	position.x = clamp(position.x, 0, screensize.x); # limita o boneco de sair da tela no eixo X. 
	position.y = clamp(position.y, 0, screensize.y); # limita o boneco de sair da tela no eixo Y. 
	
	#endregion


	#region animações_do_personagem;
	
	if (direction.length() > 0):
		$AnimatedSprite2D.animation = "run";
	
	else:
		$AnimatedSprite2D.animation = "idle";
	
	if (direction.x != 0):
		$AnimatedSprite2D.flip_h = direction.x < 0;
		
	#endregion




func _on_area_entered(area: Area2D) -> void: #quando algo entrar na hitbox do player, esse algo vai se chamar area,
	if (area.is_in_group("coins")): #se essa area for do grupo das moedas.
		area.pickuped(); #vai pegar a moeda.
		pickup.emit(); #e vai emitir um sinal falando que pegou a moeda.

	if (area.is_in_group("obstacles")): #Agora se essa area for do grupo dos obstáculos,
		hurt.emit(); #o prsonagem vai trocar para a animação de dano,
		die() # e vai morrer.
