extends Area2D

class_name Column

var Helper = load("res://Scripts/Helper.gd").new()

export (String, "STOCK", "WASTE", "TABLEAU", "FOUNDATION") var columnType = Helper.Enums.Column_Type.STOCK setget _set_Column_Type, _get_Column_Type
var cards = Node.new()
var cardArray: Array

func _set_Column_Type(newVal): columnType = newVal
func _get_Column_Type(): return columnType

func _ready():
	cards.name = "Cards"
	self.add_child(cards)
	cardArray.resize(20)

func _actually_add_cards(card):
	cardArray.append(card)
	cards.add_child(card)
	if(card.child_card != null):
		_actually_add_cards(card.child_card)

func _add_card(card):
	if(cardArray.size() == 0):
		cardArray.append(card)
		cards.add_child(card)
	else:
		var parent = cardArray[cardArray.size() - 1]
		if(Helper.try_to_pair_cards(card, parent)):
			Helper.pair_cards(card, parent)
