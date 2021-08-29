
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

unit_performing = noone;
tile_selected	= noone;

active_tiles	= [];


is_units_allowed = false;


Swap_Unit = function(starting_tile, destination_tile, unit_moving){
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

Move_Unit = function(starting_tile, destination_tile, unit_moving){
	with (starting_tile) {
		unit				= noone	
	}
	with (destination_tile) {
		unit				= unit_moving;
		unit.tile			= destination_tile;
	}
}



Unit_Attacks = function(unit_performing, unit_recieving) {
	if (unit_performing.side == SD.PLAYERS)	Ally_Attacks(unit_performing, unit_recieving);
	if (unit_performing.side == SD.GM)	Eny_Attacks(unit_performing, unit_recieving);
}

Ally_Attacks = function(unit_performing, unit_recieving) {
	
	var attack_attribut	= Convert_Attribut(unit_performing.weapon.attribut);
	var attribut_value	= unit_performing[$ attack_attribut]
						
	// Attack consequences
	var attack_attempt = Attempt_To_Attack(attribut_value);
	DM(attack_attempt);
	
	switch (attack_attempt) {
	case "Failed & Consequences":	
		oFightStateC.round_state = R_S.CONSEQUENCES
	break;
							
	case "Succeded & Consequences":	
		oFightStateC.round_state = R_S.CONSEQUENCES
		Apply_Damage(unit_recieving, unit_performing.weapon.damage);
		oPassivesC.Event_Apply_Passive(E_P.ATTACK_SUCCEEDED, unit_performing);
	break;
							
	case "Succeded":	
		Apply_Damage(unit_recieving, unit_performing.weapon.damage);
		oPassivesC.Event_Apply_Passive(E_P.ATTACK_SUCCEEDED, unit_performing);
	break;		
	}
}

Eny_Attacks = function(unit_performing, unit_recieving) {
	Apply_Damage(unit_recieving, unit_performing.attack_damage);
}

Apply_Damage = function(unit_recieving, damage) {
	if (unit_recieving.side == SD.PLAYERS)		unit_recieving.confidence	-= damage;	
	if (unit_recieving.side == SD.GM)	unit_recieving.hp			-= damage;	
	DM(string(unit_recieving.name) +" takes "+ string(damage) +" damage(s)");
}

// TODO : Move method to oUnits
Check_Element_Death = function(unit_recieving, tile_attacked) {
	if (unit_recieving.side == SD.GM)	Check_Eny_Death(unit_recieving, tile_attacked);
	if (unit_recieving.side == SD.PLAYERS)		Check_Ally_Death(unit_recieving, tile_attacked);
}

// TODO : Move method to oUnits
Check_Ally_Death = function(unit_recieving, tile_attacked){
	if (unit_recieving.confidence <= 0) {
		var unit_index		= Array_Find_Index(oUnitsC.seekers_on_board, unit_recieving);
		array_delete(oUnitsC.seekers_on_board, unit_index, 1);
		delete tile_attacked.unit;
		tile_attacked.unit = noone;
	}
}

// TODO : Move method to oUnits
Check_Eny_Death = function(unit_recieving, tile_attacked) {
	if (unit_recieving.hp <= 0) {
		var unit_index		= Array_Find_Index(oUnitsC.enemies_on_board, unit_recieving);
		array_delete(oUnitsC.enemies_on_board, unit_index, 1);
		delete tile_attacked.unit;
		tile_attacked.unit = noone;
		if (oUnitsC.unit_riposting == undefined)	oUnitsC.unit_riposting = noone
	}	
}
		



/// @desc			Generate a node_parent_neigbours that contains all the tiles that can be used for mouvement, attacking...
/// @param			tile_center				{real}		The instance_id of the node_parent_neigbour that we want to calculate from (eg caracter pos for movement, attack landing for AOE)
/// @param			range					{real}		The distance from the  that we want to check for tiles to add to node_parent_neigbours
/// @param			is_cross				{boolean}	
/// @param			is_tile_center_active	{boolean}	
/// @param			is_units_allowed		{boolean}
/// @param			units_not_allowed_type	{const}
/// @param			is_side_allowed			{boolean}

Set_Active_tiles = function(_tile_center, _range, _is_cross, _is_tile_center_active, _is_units_allowed, _units_not_allowed_type, _is_side_allowed) {

	tile_center				= _tile_center				;
	range 					= _range 					;
	is_cross 				= _is_cross 				;
	is_tile_center_active 	= _is_tile_center_active 	;
	is_units_allowed 		= _is_units_allowed 		;
	units_not_allowed_type	= _units_not_allowed_type	;
	is_side_allowed 		= _is_side_allowed 			;

	active_tiles			= [];
	tiles_parent			= ds_priority_create();

	//On met la node de départ dans les tiles_parents
	tile_center.distance	= 0;
	ds_priority_add(tiles_parent, tile_center, tile_center.distance);
	if (is_tile_center_active == true)	array_push(active_tiles, tile_center);
	
	// Main loop
	while (ds_priority_size(tiles_parent) > 0) {
		//On sort la node la plus proche du centre (1st time c'est la )
		var tile_parent = ds_priority_delete_min(tiles_parent);

		// On prend un neigbour
		for (var i = 0; i < array_length(tile_parent.neigbours); i++) {
			tile_neigbour = tile_parent.neigbours[i];
			// Si la neigbour n'est pas encore checké
			if (tile_neigbour.distance == -1) {
				tile_neigbour.parent	= tile_parent;
				tile_neigbour.distance	= tile_parent.distance + 1;
					
				if (	Resolve_Is_Side_Allowed()
					&&	Resolve_Is_Cross()
					&&	Resolve_Is_Units_Allowed()) {
						ds_priority_add	(tiles_parent, tile_neigbour, tile_neigbour.distance);
						
						if (Resolve_Range())	
							array_push		(active_tiles, tile_neigbour);			
				}
			}
		}
	}
	ds_priority_destroy(tiles_parent);
	return active_tiles;
}


Resolve_Range = function() {
	
	switch(range) {
	case "Close": case "Near": case "Far":
		if (range == tile_neigbour.range)										return true;	break;
	
	case "N/C":
		if (tile_neigbour.range == "Near") || (tile_neigbour.range == "Close")	return true;	break;
			
	case "F/N":
		if (tile_neigbour.range == "Far") || (tile_neigbour.range == "Near")	return true;	break;
					
	case "F/C":
		if (tile_neigbour.range == "Far") || (tile_neigbour.range == "Close")	return true;	break;
					
	case "!C":
		if (tile_neigbour.range != "Close")										return true;	break;
																	
	case "!N":														
		if (tile_neigbour.range != "Near")										return true;	break;
																	
	case "!F":														
		if (tile_neigbour.range != "Far")										return true;	break;
																	
	case 1: case 2: case 3:											
		if (tile_neigbour.distance <= range)									return true;	break;					
																	
	case "Max":														
																				return true;	break;
																				
	case -1:																	
																				return true;	break
	}
}
	
	
Resolve_Is_Units_Allowed = function() {
	
	enum UNITS_NOT_ALLOWED {
		BLOCK, END	
	}

	switch (is_units_allowed) {
	case false: 
		if		(tile_neigbour.unit	== noone) {			
			return true;	
			break;
		}
		else if	(tile_neigbour		== tile_center)		{
			return true;	
			break;
		}
		else if (units_not_allowed_type == UNITS_NOT_ALLOWED.BLOCK) {
			return false;	
			break;
		}
		else if (units_not_allowed_type == UNITS_NOT_ALLOWED.END) && Resolve_Range() {
			array_push(active_tiles, tile_neigbour);
			return false;	
			break;
		}
		else {
			return false;	
			break;
		}
		
	case true:											
		return true;	
		break;
	}		
}


Resolve_Is_Side_Allowed = function() {
	
	if	(is_side_allowed == true) {
		return true;
		exit;
	}
	else if	(is_side_allowed == false) && (tile_center.side == tile_neigbour.side) {
		return true;
		exit;
	}
	else {
		return false;
		exit;
	}
}
	
	
Resolve_Is_Cross = function () {
	if		(is_cross == false) {
		return true;
		exit;
	}
	else if	(is_cross == true) 
		&& (tile_neigbour.grid_x == tile_center.grid_x || tile_neigbour.grid_y == tile_center.grid_y) {
		return true;
		exit;
	}
	else {
		return false;
		exit;
	}
}


Attempt_To_Attack = function(dice_count) {
	var attack_attempt = undefined;
	var dices = ds_list_create();
	
	repeat (dice_count)		ds_list_add(dices, irandom_range(1,6));
	ds_list_sort(dices, false);
	
	var higher_dice = dices[|0];
	
	if (higher_dice == 1 || higher_dice == 2)	attack_attempt	= "Failed & Consequences";
	if (higher_dice == 3 || higher_dice == 4)	attack_attempt	= "Succeded & Consequences";
	if (higher_dice == 5 || higher_dice == 6)	attack_attempt	= "Succeded";
	
	ds_list_destroy(dices);
	
	return attack_attempt;
}


Quit_FightMenu = function() {
	with (oTilesC) {
		for (var yy = 0; yy < rows;		yy++) {
		for (var xx = 0; xx < columns;	xx++) {	
			var tile_reseting = tiles[xx][yy];
			with (tile_reseting) {
				parent		= noone;
				passable	= true;
				distance	= -1	
			}
		}}
	}
	unit_performing	= noone;
	tile_selected	= noone;
	array_resize(active_tiles, 0);
	instance_destroy();
}




	
	
Shield = function(amount) {
	shield += amount;
}

Push = function(amount) {
	var unit_recieving		= self;
	var unit_performing		= oActions.unit_performing;
	
	var start_g_x			= unit_recieving.tile.grid_x;
	var start_g_y			= unit_recieving.tile.grid_y;
	
	var direction_x			= sign(start_g_x - unit_performing.tile.grid_x);
	var mouvement_x			= amount * direction_x;
	var destination_g_x		= start_g_x + mouvement_x;
	
	var direction_y			= sign(start_g_y - unit_performing.tile.grid_y);
	var mouvement_y			= amount * direction_y;
	var destination_g_y		= start_g_y + mouvement_y;
	
	var destination_tile	= oTilesC.tiles[destination_g_x][destination_g_y];

	// If next to the board's end or the opposite side
	if (destination_tile == undefined) || (unit_recieving.side != destination_tile.side)	{
		DM("Tile " +S(destination_tile.name)+ " is blocked by the board or side");	
		oActions.Apply_Damage(unit_recieving, 1);
	}
	
	// If something to stop unit_recieving
	else if (destination_tile.unit != noone) {
		DM("Tile " +S(destination_tile.name)+ " is blocked by "+ S(destination_tile.unit.name));	
		oActions.Apply_Damage(unit_recieving, 1);
		oActions.Apply_Damage(destination_tile.unit, 1);
	}

		// If nothing to stop unit_recieving
	else {
		DM(S(unit_recieving.name) +" is pushed");
		oActions.Move_Unit(unit_recieving.tile, destination_tile, unit_recieving);
	}

}

Leap = function(){
	is_units_allowed = true;
	DM("Next move can leap");
}

