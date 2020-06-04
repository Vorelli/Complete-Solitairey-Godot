extends Node

enum Column_Type {
	STOCK,
	WASTE,
	TABLEAU,
	FOUNDATION
}

var objects_being_tracked: Array = []
var objects_being_hovered: Array = []
var object_being_hovered: Area2D = null

func _physics_process(_delta):
	if(object_being_hovered != null && object_being_hovered.dragging):
		#checks if obj being hovered is card then makes it follow
		object_being_hovered.follow()

func _track_object(object):
	object.connect("mouse_entered", self, "_on_object_entered", [object])
	object.connect("mouse_exited", self, "_on_object_exited", [object])
	object.connect("dropped_on_object", self, "_object_dropped_on_object")

#cards can be hovered, dragged, dropped on

#columns do nothing when hovered, dragged, dropped
#(can be dropped on)
#WON'T BE TRACKED
#no need to account for them here
#with regards to entering and being dropped

#stock can be hovered, clicked
#cannot be dragged, dropped, dropped on

#hover events
func _card_stock_waste_hover_start(card):
	card._on_hover_start()
func _card_stock_waste_hover_end(card):
	card._on_hover_end()

#card events
func _card_click_start(card): card._on_click_start()
func _card_click_end(card):
	card._on_click_end()
	checkForHover()

#stock events
func _stock_click_start(stock):
	stock._on_click_start()
func _stock_click_end(stock):
	stock._on_click_end()

func _hover_end(object):
	match Helper._object_type(object):
		"Stock": continue
		"Card":
			_card_stock_waste_hover_end(object)

func _hover_start(object):
	match Helper._object_type(object):
		"Stock": continue
		"Card": 
			_card_stock_waste_hover_start(object)

func checkForHover():
	if(_is_card_and_is_being_dragged(object_being_hovered)):
		return #a card is being dragged. dont check
	var highest_object
	if(objects_being_hovered.size() > 0): highest_object = objects_being_hovered[0]
	else:
		highest_object = null
	for i in range(1, objects_being_hovered.size()):
		if(objects_being_hovered[i].z_index > highest_object.z_index):
			_hover_end(highest_object)
			highest_object = objects_being_hovered[i]
		else:
			_hover_end(objects_being_hovered[i])
	object_being_hovered = highest_object
	if(highest_object != null): _hover_start(highest_object)

func _on_object_entered(object):
	match Helper._object_type(object):
		"Stock": continue
		"Card": #need to check if card is in the waste pile and if it's the top card
			if(_is_card_waste_and_not_topmost(object)):
				#if the card is in the waste column, and is not the topmost card...
				pass
			else:#topmost card in waste column and otherwise (including the stock)
				if(!object in objects_being_hovered && !object.isHidden):
					objects_being_hovered.append(object)
	checkForHover()

func _on_object_exited(object):
	match Helper._object_type(object):
		"Stock": continue
		"Card":
			if(object == object_being_hovered && object.dragging):
				return #dont stop the card being hovered if it's being dragged
			_hover_end(object)
			var pos = objects_being_hovered.find(object)
			if(pos != -1):
				objects_being_hovered.remove(pos)
	checkForHover()

func _is_card_and_is_being_dragged(object) -> bool:
	var object_exists = object != null
	var object_is_a_card = object_exists && "parent_card" in object
	var card_is_being_dragged = object_is_a_card && object.dragging
	return card_is_being_dragged

func _is_card_waste_and_not_topmost(card) -> bool:
	var card_has_column = card.column != null
	var card_in_waste = card_has_column && card.column.columnType == Column_Type.WASTE
	var card_top_most = card_in_waste && card == card.column.cardArray[card.column.cardArray.size()-1];
	return card_top_most

func _input(event):
	if(event.is_action_pressed("click")):
		#handle the click on the hovered node
		if(object_being_hovered != null):
			match Helper._object_type(object_being_hovered):
				"Stock":
					_stock_click_start(object_being_hovered)
				"Card":
					_card_click_start(object_being_hovered)
		#if(cardBeingHovered != null): _Drag_Card_Start(cardBeingHovered)
	if(event.is_action_released("click")):
		if(object_being_hovered != null):
			match Helper._object_type(object_being_hovered):
				"Stock":
					_stock_click_end(object_being_hovered)
				"Card":
					_card_click_end(object_being_hovered)
		checkForHover()
		#if(cardBeingHovered != null): _Drag_Card_End(cardBeingHovered)

func _object_dropped_on_object(childObject, parentObject):
	#   TODO:
	#   check if parentObject is stock
	#   also make sure childObject is a card. Must be a card!
	if "columnType" in parentObject:
		Helper.card_dropped_on_column(childObject, parentObject)
		#object is a column
	elif "cards" in parentObject:
		#object is the stock
		pass
	else:
		#should be a card??
		if Helper.try_to_pair_cards(childObject, parentObject):
			Helper.pair_cards(childObject, parentObject)
	childObject._reset_position()
