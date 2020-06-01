extends Node

var x_min = 96
var y_min = 151
var x_max = 1821
var y_max = 929
var x_diff = 100
var y_diff = 225
var cardScene = preload('res://Scenes/Card.tscn')

func _ready():
	randomize()
	for i in range(52):
		var newCard = cardScene.instance()
		newCard.init(floor(i / float(13)), i % 13, i)
		newCard.set_name(EnumLookup.shortValue[str(newCard.value)] + " of " + EnumLookup.Suit[newCard.suit as String])
		self.add_child(newCard)
		var newPos = Vector2(x_min + floor((i % 13 * x_diff)), y_min + (floor((i / float(13))) * y_diff))
		newCard.position = newPos
		InputManager._track_object(newCard)
