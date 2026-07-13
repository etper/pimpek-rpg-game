extends RefCounted
class_name Battler

var name := ""

var max_hp := 1
var hp := 1

var attack := 1
var defense := 0

func take_damage(amount: int):
	hp = max(0, hp - amount)

func is_dead() -> bool:
	return hp <= 0

func attack_target(target: Battler):
	var damage = max(1, attack - target.defense)
	target.take_damage(damage)
