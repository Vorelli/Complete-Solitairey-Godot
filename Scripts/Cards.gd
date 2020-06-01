extends Node

var cardsBeingHovered: Array
var cardBeingHovered: Area2D

""" 
var cardScene = preload('res://Scenes/Card.tscn')
var x_min = 96
var y_min = 151
var x_max = 1821
var y_max = 929
var x_diff = 100
var y_diff = 225
func _ready():
	randomize()
	for i in range(52):
		var newCard = cardScene.instance()
		newCard.init(floor(i / float(13)), i % 13, i)
		newCard.set_name(EnumLookup.shortValue[str(newCard.value)] + " of " + EnumLookup.Suit[newCard.suit as String])
		self.add_child(newCard)
		var newPos = Vector2(x_min + floor((i % 13 * x_diff)), y_min + (floor((i / float(13))) * y_diff))
		newCard.position = newPos
		_Track_Card(newCard)
"""
		
func _physics_process(_delta):
	if(cardBeingHovered != null && cardBeingHovered.dragging):
		cardBeingHovered.follow()

func _Track_Card(card):
	card.connect("mouse_entered", self, "_on_Card_entered", [card])
	card.connect("mouse_exited", self, "_on_Card_exited", [card])
	card.connect("dropped_on_object", self, "_card_dropped_on_object")
	
func _Drag_Card_Start(card):
	card._on_Drag_Start()

func _Drag_Card_End(card):
	card._on_Drag_End()
	checkForHoverCard()
	
func _Card_Start_Hover(card):
	card._on_Hover_Start()
	cardBeingHovered = card
		
func checkForHoverCard():
	if(cardBeingHovered != null && cardBeingHovered.dragging):
		return; #Dont check which card is being hovered if one is being dragged
		
	var highestCard = cardsBeingHovered[0]
	for i in range(1, cardsBeingHovered.size()):
		if(cardsBeingHovered[i].z_index > highestCard.z_index):
			highestCard._on_Hover_End()
			highestCard = cardsBeingHovered[i]
		else:
			cardsBeingHovered[i]._on_Hover_End()
	_Card_Start_Hover(highestCard)
		
func _on_Card_entered(card):
	if(!card in cardsBeingHovered && !card.isHidden):
		cardsBeingHovered.append(card);
	else: #If a card is already in the list or IS HIDDEN, move on... It can't be hovered.
		checkForHoverCard()
		
	if(cardsBeingHovered.size() == 1):
		_Card_Start_Hover(card)
	else:
		checkForHoverCard()
	
func _on_Card_exited(card):
	if(card.dragging):
		return
	cardsBeingHovered.remove(cardsBeingHovered.find(card))
	card._on_Hover_End()
	if(cardsBeingHovered.size() > 0):
		checkForHoverCard()
	else:
		cardBeingHovered = null
		
func _input(event):
	if(event.is_action_pressed("click")):
		if(cardBeingHovered != null): _Drag_Card_Start(cardBeingHovered)
	if(event.is_action_released("click")):
		if(cardBeingHovered != null): _Drag_Card_End(cardBeingHovered)
		
func _card_dropped_on_object(child, object):
	if "columnType" in object:
		Helper.card_dropped_on_column(child, object)
		#object is a column
	else:
		#should be a card??
		if Helper.try_to_pair_cards(child, object):
			Helper.pair_cards(child, object)
		else:
			#can not be placed on 'object'
			child.position = child.origin_position


func _on_Timer_timeout():
	print("triggered")
	if(cardBeingHovered != null):
		cardBeingHovered.isHidden = true
