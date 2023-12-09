extends Node2D
var healingCost = 5
var healingAmount = 50

func _ready():
	$Label2.text = str(healingCost)


func _on_area_2d_area_entered(area):
	if area.name == "PlayerMelee":		
		if Globals.player_health == Globals.player_max_health and Globals.ally_health == Globals.ally_max_health:
			$Title.text = "ТЫ И ТАК ЗДОРОВ"
		else:
			handleHealing()
			

func handleHealing():
	if healingCost > Globals.coins:
		$Title.text = "МАЛО ДЕНЕГ"
	else:
		increaseCost()
		Globals.coins = Globals.coins - healingCost
		Globals.player_health = Globals.player_health + healingAmount			
		Globals.ally_health = Globals.ally_health + healingAmount			
		if Globals.player_health > Globals.player_max_health:
			Globals.player_health = Globals.player_max_health
			Globals.ally_health = Globals.ally_max_health

func increaseCost():	
	healingCost += 3
	$Label2.text = str(healingCost)


func _on_area_2d_area_exited(area):
	if area.name == "PlayerMelee":
		$Title.text = ""
