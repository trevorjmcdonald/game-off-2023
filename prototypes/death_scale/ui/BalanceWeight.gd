extends Label

@export var balance: Balance

func _process(_delta: float) -> void:
	if balance:
		text = str(balance.calculate_total_mass())
