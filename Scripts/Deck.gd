extends Area2D

var cards: Array
var card = preload("res://Scenes/Card.tscn")
var x_min = 96
var y_min = 151
var x_max = 1821
var y_max = 929
var dragging = false

func _init():
	cards = Array()
	cards.resize(52)
	for i in range(52):
		cards[i] = card.instance()
		cards[i].value = i % 13
		cards[i].suit = i / int(13)
		cards[i].set_name(EnumLookup.shortValue[str(cards[i].value)] + " of " + EnumLookup.Suit[cards[i].suit as String])
		
func _ready():
	randomize()
	shuffle(123)
	#connect("mouse_exited", self, "_on_drag_off")
	
func enter():
	$Sprite.modulate = Color(0.9, 0.9, 0.9)
	
func exit():
	$Sprite.modulate = Color(1, 1, 1)
	if(dragging):
		_on_drag_off()

func shuffle(genSeed):
	if(typeof(genSeed) == TYPE_STRING):
		genSeed = genSeed.hash()
	seed(genSeed)
	for i in range(cards.size()):
		var newLoc = randi() % (cards.size() - i) + i
		var temp = cards[newLoc]
		cards[newLoc] = cards[i]
		cards[i] = temp
	print(EnumLookup.Value[str(cards[0].value)] + " of " + EnumLookup.Suit[str(cards[0].suit)])
	
func _update_label():
	$Label.text = str(cards.size())
	
func _on_drag_off():
	if(cards.size() > 0):
		dragging = false
		var draggingCard = cards.pop_front()
		if(!find_node("Cards")):
			var cards = Node.new()
			cards.name = "Cards"
			add_child(cards)
		Cards.add_child(draggingCard)
		draggingCard.position = get_viewport().get_mouse_position()
		Cards._Track_Card(draggingCard)
		draggingCard._on_Drag_Start()
	_update_label()


func _on_Deck_input_event(viewport, event, shape_idx):
	if(event.is_action_pressed("click")):
		dragging = true
	if(event.is_action_released("click")):
		dragging = false
