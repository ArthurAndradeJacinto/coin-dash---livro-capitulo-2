extends CanvasLayer;

signal start_game;


func update_score(value):
	$MarginContainer/Score.text = str(value); #vai mudar o texto do score para um novo score.


func update_time(value):
	$MarginContainer/Time.text = str(value); #vai mudar o texto do time para um novo time.


func show_message(text):
	$Message.text = text; #O texto de message vai virar um novo text.
	$Message.show(); #E ele vai aparecer na tela.
	$Timer.start(); #Ele vai startar o timer de 2 segundos.


func show_game_over():
	show_message("Game-over");
	await $Timer.timeout;
	$StartButton.show();
	$Message.text = "Coin Dash!"
	$Message.show();


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	$Message.hide(); #Quando o timer acabar, ele vai sumir com a mensagem.


func _on_start_button_pressed() -> void:
	$StartButton.hide();
	$Message.hide();
	start_game.emit();
