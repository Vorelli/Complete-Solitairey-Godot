extends Area2D

var cards: Array
var click_in_progress

func _on_click_start():
    click_in_progress = true

func _on_click_end():
    if(click_in_progress):
        #TODO: make stock put cards into waste...
        pass

func _on_hover_start():
    $Sprite.modulate = Color(0.9, 0.9, 0.9)

func _on_hover_end():
    $Sprite.modulate = Color(1, 1, 1)
    click_in_progress = false