extends StaticBody2D

enum Suit {
	HEARTS,
	DIAMONDS,
	CLUBS,
	SPADES
}

enum Value {
	ACE,
	TWO,
	THREE,
	FOUR,
	FIVE,
	SIX,
	SEVEN,
	EIGHT,
	NINE,
	TEN,
	JACK,
	QUEEN,
	KING
}

export var suit = Suit.CLUBS

export var value = Value.ACE

func _ready():
	pass


func _on_Card_mouse_entered():
	$Sprite.modulate = Color(0,0,0)
	



func _on_Card_mouse_exited():
	$Sprite.modulate = Color(1,1,1)


func _on_Card_input_event(viewport, event, shape_idx):
	print(event)
