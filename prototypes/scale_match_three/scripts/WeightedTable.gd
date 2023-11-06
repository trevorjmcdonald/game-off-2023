class_name WeightedTable

var items: Array[WeightedTableItem] = []

func add_item(item: Variant, weight: int) -> void:
    items.append(WeightedTableItem.new(item, weight))

func get_item() -> Variant:
    if items.size() == 0:
        return null

    var total_weight = 0
    for item in items:
        total_weight += item.weight
    var random = randi() % total_weight
    for item in items:
        random -= item.weight
        if random < 0:
            return item.value
    return items[items.size() - 1].value