extends Area2D

class_name Column

export(Enums.Column_Type) var columnType = Enums.Column_Type.TABLEAU
var cards = Node.new()
var cardArray: Array

func _set_Column_Type(newVal): columnType = newVal
func _get_Column_Type(): return columnType

func _ready():
	cards.name = "Cards"
	self.add_child(cards)
	cardArray.resize(20)
	print(columnType)

func _add_card(card):
	cardArray.append(card)
	cards.add_child(card)
	if(card.child_card != null):
		_add_card(card.child_card)

func _remove_cards(card):
	var cardIndex = self.cardArray.find(card)

	for _i in range(cardArray.size(), cardIndex, -1):
		var toBeDeleted = cardArray.pop_back()
		cards.remove_child(toBeDeleted)
