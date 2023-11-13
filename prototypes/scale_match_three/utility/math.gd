extends Node
class_name MathUtils

# https://github.com/Unity-Technologies/UnityCsReference/blob/d0e1a5b25e8d3c8e1b4e6baf0073032d97254a0c/Runtime/Export/Math/Mathf.cs#L309
static func smooth_damp(
	current: float,
	target: float,
	current_velocity: float,
	smooth_time: float,
	delta: float,
	max_speed: float = INF) -> SmoothDampResult:

	smooth_time = maxf(smooth_time, 0.0001)
	var omega := 2.0 / smooth_time

	var x := omega * delta
	var ex := 1.0 / (1.0 + x + 0.48 * pow(x, 2) + 0.235 * pow(x, 3))
	var change := current - target
	var original_to := target

	var max_change := max_speed * smooth_time
	change = clampf(change, -max_change, max_change)
	target = current - change

	var temp := (current_velocity + omega * change) * delta
	current_velocity = (current_velocity - omega * temp) * ex
	var output := target + (change + temp) * ex

	if ((original_to - current > 0) == (output > original_to)):
		output = original_to
		current_velocity = (output - original_to) / delta

	var result := SmoothDampResult.new()
	result.velocity = current_velocity
	result.output = output

	return result
