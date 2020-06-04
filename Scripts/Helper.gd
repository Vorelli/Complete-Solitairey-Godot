extends Node

func _is_red(card) -> bool:
	return true if card.suit == Enums.Suit.DIAMONDS || card.suit == Enums.Suit.HEARTS else false

func try_to_pair_cards(child, parent) -> bool:
	var sameChild = parent.child_card == child
	var parentIsHidden = parent.isHidden
	var parentContainerStock = false if parent.column == null else parent.column.columnType == Enums.Column_Type.STOCK
	var defaultRules = sameChild || parentIsHidden || parentContainerStock
	if(defaultRules): return true
	var noChild = parent.child_card == null
		
	match parent.column.columnType:	
		Enums.Column_Type.TABLEAU:
			var newChildValueOneLess = int(parent.value) - 1 == int(child.value)
			var oppositeColor = !_is_red(parent) == _is_red(child)
			return noChild && newChildValueOneLess && oppositeColor
		Enums.Column_Type.FOUNDATION:
			var newChildValueOneMore = int(parent.value) + 1 == int(child)
			var sameSuit = parent.suit == child.suit
			return noChild && newChildValueOneMore && sameSuit
		Enums.Column_Type.STOCK:
			continue
		Enums.Column_Type.WASTE:
			continue
		_:
			return false
	return false
	
func pair_cards(child, parent):
	if(child.parent_card != null):
		child.parent_card.child_card = null
	if(child.column != null):
		child.column._remove_card(child)
	parent.child_card = child
	child.parent_card = parent
	child.column = parent.column
	parent.column._add_card(child)

func card_dropped_on_column(card, column):
	match int(column.columnType):
		Enums.Column_Type.STOCK:#shouldn't be possible ?
			pass
		Enums.Column_Type.WASTE:#not important :P
			pass
		Enums.Column_Type.TABLEAU:#tableau
			print("tableau")
		Enums.Column_Type.FOUNDATION:#foundation
			print("foundation")
		_:
			print("unknown")
	pass


func _object_type(object) -> String:
	if("columnType" in object):
		#object is a column
		return "Column"
	elif("cards" in object):
		#object is the stock
		return "Stock"
	else:
		#object is a card
		return "Card"
