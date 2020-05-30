extends Node

var Enums = load("res://Scripts/Enums.gd").new()

func _is_red(card) -> bool:
	return true if card.suit == Enums.Suit.DIAMONDS || card.suit == Enums.Suit.HEARTS else false

func try_to_pair_cards(child, parent) -> bool:
	var sameChild = parent.child_card == child
	var parentIsHidden = parent.isHidden
	var parentContainerStock = parent.columnType == Enums.Column_Type.STOCK
	var defaultRules = sameChild || parentIsHidden || parentContainerStock
	if(defaultRules): return true
	var noChild = parent.child_card == null
		
	match parent.columnType:
		Enums.Column_Type.STOCK:
			pass
		Enums.Column_Type.WASTE:
			pass
		Enums.Column_Type.TABLEAU:
			var newChildValueOneLess = int(parent.value) - 1 == int(child.value)
			var oppositeColor = !_is_red(parent) == _is_red(child)
			return noChild && newChildValueOneLess && oppositeColor
		Enums.Column_Type.FOUNDATION:
			var newChildValueOneMore = int(parent.value) + 1 == int(child)
			var sameSuit = parent.suit == child.suit
			return noChild && newChildValueOneMore && sameSuit
	return false
	
func pair_cards(child, parent):
	pass
