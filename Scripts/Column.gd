extends Area2D

class_name Column

enum Column_Type {
	STOCK,
	WASTE,
	TABLEAU,
	FOUNDATION
}

export (String, "STOCK", "WASTE", "TABLEAU", "FOUNDATION") var columnType = Column_Type.STOCK setget _set_Column_Type, _get_Column_Type
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
