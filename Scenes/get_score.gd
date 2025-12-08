extends RichTextLabel

func _ready() -> void:
	set_text("previous high score: " + str(Global.high_score) + " your previous score: " + str(Global.previous_score))
