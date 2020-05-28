extends Area2D

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
var wasPressed = false
var cursorPositionOffset: Vector2
var cardsInVicinity: Array

func _ready():
	pass

func _on_Card_mouse_entered():
	$Sprite.modulate = Color(0.9,0.9,0.9)
	

func _on_Card_mouse_exited():
	$Sprite.modulate = Color(1,1,1)

func _on_Card_input_event(viewport, event, shape_idx):
	if event.is_pressed() && !self.wasPressed:
		#clicked
		self.cursorPositionOffset = viewport.get_mouse_position() - self.position
		wasPressed = true
	if(wasPressed && !Input.is_mouse_button_pressed(1)):
		wasPressed = false
		print(cardsInVicinity)

func _process(delta):
	if wasPressed:
		self.position = get_viewport().get_mouse_position() - cursorPositionOffset


func _on_Card_area_entered(area):
	if(wasPressed && !area in self.cardsInVicinity):
		self.cardsInVicinity.append(area)


func _on_Card_area_exited(area):
	if(wasPressed):
		cardsInVicinity.remove(cardsInVicinity.find(area))
