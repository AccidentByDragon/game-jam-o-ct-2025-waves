extends ProgressBar

var parent
var max_value_amount
var min_value_amount

func _ready():
	parent = get_parent()
	max_value_amount = parent.health_max
	min_value_amount = parent.health_min
	value = parent.health

func _process(delta: float) -> void:
	value = parent.health
	if parent.health != max_value_amount:
		visible = true
		if parent.health == min_value_amount:
			visible = false
	else:
		visible = false
