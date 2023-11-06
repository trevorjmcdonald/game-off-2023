class_name WeightedTableItem

var value: Variant
var weight: int = 1

func _init(item_value: Variant, item_weight: int) -> void:
    value = item_value
    weight = item_weight