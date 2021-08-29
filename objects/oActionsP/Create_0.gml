
option_targeted	= 0;
option_selected = -1;

//Pages
enum FIGHTMENU_COLUMNS {
	NAME, FUNCTION, IS_ENABLE
}

enum FIGHTMENU_OPTIONS {
	MOVE,
	ATTACK
	
}

fightMenu = Multiple_Arrays_To_Grid(
	["MOVE",		FIGHTMENU_OPTIONS.MOVE],
	["ATTACK",		FIGHTMENU_OPTIONS.ATTACK]
);

tile_selected	= -1;

active_tiles	= [];


function Swap_Unit(starting_tile, destination_tile, unit_moving){
	with (starting_tile) {
		unit		= destination_tile.unit;
		unit.tile	= starting_tile;
	}
	with (destination_tile) {
		unit				= unit_moving;
		unit.tile			= destination_tile;
		unit.action_count	-= destination_tile.distance;
	}
}

function Move_Unit(starting_tile, destination_tile, unit_moving){
	with (starting_tile) {
		unit				= noone	
	}
	with (destination_tile) {
		unit				= unit_moving;
		unit.tile			= destination_tile;
		unit.action_count	-= destination_tile.distance;
	}
}


function Ally_Attacks (unit_attacking, unit_attacked) {
	
	// unit_attacking.weapon.attribut contains attribut beginning with an upper-case, ex : "Presence"
	// We want to access "presence" in unit_attacking so we lower the word
	var attack_attribut		= unit_attacking.weapon.attribut; // Presence
	var attack_attribut_l	= string_lower(attack_attribut); // presence
	var attribut_value		= unit_attacking[$ attack_attribut_l] // unit_attacking.presence
						
	// Attack consequences
	var attack_attempt = Attempt_To_Attack(attribut_value);
	switch (attack_attempt) {
	case "Failed & Consequences":	
		oFightStateC.round_state = ROUND_STATE.CONSEQUENCES
		show_debug_message(attack_attempt)	
	break;
							
	case "Succeded & Consequences":	
		oFightStateC.round_state = ROUND_STATE.CONSEQUENCES
		if (unit_attacked.side == SIDE.ALLIES)	unit_attacked.confidence	-= unit_attacking.weapon.damage;
		if (unit_attacked.side == SIDE.ENEMIES) unit_attacked.health		-= unit_attacking.weapon.damage;
		show_debug_message(attack_attempt)
														
	break;
							
	case "Succeded":				
		if (unit_attacked.side == SIDE.ALLIES)	unit_attacked.confidence	-= unit_attacking.weapon.damage;
		if (unit_attacked.side == SIDE.ENEMIES) unit_attacked.health		-= unit_attacking.weapon.damage;
		show_debug_message(attack_attempt)
	break;		
	}
}

function Eny_Attacks (unit_attacking, unit_attacked) {
	unit_attacked.confidence -= unit_attacking.attack_damage;
}

function Check_Ally_Death (unit_attacked, tile_attacked){
	if (unit_attacked.confidence <= 0) {
		var unit_index		= Array_Find_Index(oUnitsC.seekers_on_board, unit_attacked);
		array_delete(oUnitsC.seekers_on_board, unit_index, 1);
		delete tile_attacked.unit;
		tile_attacked.unit = noone;
	}
}

function Check_Eny_Death (unit_attacked, tile_attacked) {
	if (unit_attacked.health <= 0) {
		var unit_index		= Array_Find_Index(oUnitsC.enemies_on_board, unit_attacked);
		array_delete(oUnitsC.enemies_on_board, unit_index, 1);
		delete tile_attacked.unit;
		tile_attacked.unit = noone;
	}	
}
		




