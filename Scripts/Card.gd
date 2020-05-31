extends Area2D

var Enums = preload("res://Scripts/Enums.gd")
var EnumLookup = preload("res://Scripts/EnumLookup.gd")

export (String, "HEARTS", "DIAMONDS", "CLUBS", "SPADES") var suit = Enums.Suit.CLUBS setget _suit_set, _suit_get
func _suit_set(newVal):
	suit = newVal
	refresh()
func _suit_get(): return suit

export (String, "ACE", "TWO", "THREE", "FOUR", "FIVE", "SIX", "SEVEN", "EIGHT", "NINE", "TEN", "JACK", "QUEEN", "KING") var value = Enums.Value.ACE setget _value_set, _value_get
func _value_set(newVal):
	value = newVal
	refresh()
func _value_get(): return value

export var isHidden = false setget _isHidden_set, _isHidden_get
func _isHidden_set(newVal):
	isHidden = newVal
	refresh()
func _isHidden_get(): return isHidden

var column = null setget _set_Column, _get_Column
func _set_Column(newVal):
	column = newVal
	refresh()
func _get_Column(): return column
	
var parent_card: Area2D = null setget _set_parent_card, _get_parent_card
func _set_parent_card(newVal):
	parent_card = newVal
	refresh()
func _get_parent_card(): return parent_card

var child_card: Area2D = null setget _set_child_card, _get_child_card
func _set_child_card(newVal):
	child_card = newVal
	refresh()
func _get_child_card(): return child_card

const BACK_OF_CARD = "res://Cards/deck_3_large.png"
var areasInVicinity: Array
var dragging = false
var cursorPositionOffset: Vector2
var _z_index
signal dropped_on_object(object)

func _on_Hover_Start(): $Sprite.modulate = Color(0.9,0.9,0.9)
func _on_Hover_End(): 	$Sprite.modulate = Color(1.0,1.0,1.0)

func init(suit, value, z_index):
	self.suit = suit
	self.value = value
	self._z_index = z_index
	self.z_index = z_index

func _on_Drag_Start():
	self.cursorPositionOffset = get_viewport().get_mouse_position() - position;
	_z_index = self.z_index
	z_index = 100
	dragging = true; 

func _on_Drag_End(): 
	dragging = false
	z_index = _z_index
	var closestObject = _get_closest_nearby_object()
	if(closestObject != null):
		emit_signal("dropped_on_object", self, closestObject)
	
func _get_closest_nearby_object():
	if(areasInVicinity.size() == 0): return null
	var closest = areasInVicinity[0]
	var cachedDistance = position.distance_to(closest.position)
	for objectArea in areasInVicinity:
		var tempDistance = position.distance_to(objectArea.position)
		if(tempDistance < cachedDistance):
			closest = objectArea
			cachedDistance = tempDistance
	return closest
		

# warning-ignore:unused_argument
func follow():
	self.position = get_viewport().get_mouse_position() - cursorPositionOffset

func _on_Card_area_entered(area):
	if(dragging && !area in self.areasInVicinity): self.areasInVicinity.append(area)

func _on_Card_area_exited(area):
	if(dragging): areasInVicinity.remove(areasInVicinity.find(area))
		
func refresh():
	var cardString = "res://Cards/card_b_" + EnumLookup.Suit[str(suit)].to_lower()[0] + EnumLookup.shortValue[str(value)] + "_large.png"
	$Sprite.texture = load(cardString if !self.isHidden else BACK_OF_CARD)
	


