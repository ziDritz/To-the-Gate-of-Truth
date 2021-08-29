if (keyboard_check_pressed(vk_escape))	{
	Quit_FightMenu(); 
	exit;
}

#region		Selection option

if (keyboard_check_pressed(vk_up))					option_targeted--;
if (keyboard_check_pressed(vk_down))				option_targeted++;

if (option_targeted >= ds_grid_height(fightMenu))	option_targeted = 0;
if (option_targeted < 0)							option_targeted = ds_grid_height(fightMenu)-1;


if (keyboard_check_pressed(vk_enter)) && (tile_selected.unit.action_count > 0) {
		option_selected = fightMenu[# FIGHTMENU_COLUMNS.FUNCTION, option_targeted];
		DM(S(unit_performing.name) +" wants to "+ fightMenu[# FIGHTMENU_COLUMNS.NAME, option_targeted]);
}

#endregion


#region		Actions

switch (option_selected) {

	#region		FIGHTMENU_OPTIONS.MOVE
	case FIGHTMENU_OPTIONS.MOVE:
		var starting_tile	= tile_selected;
		
		is_units_allowed		= false;
		is_tile_center_active	= false;
		is_cross				= false;
		
		if (array_length(active_tiles) == 0)	
			active_tiles		= Set_Active_tiles(starting_tile, unit_performing.action_count, false, false, false, UNITS_NOT_ALLOWED.BLOCK ,false);

		if (mouse_check_button_pressed(mb_left)) { 
			var destination_tile	= oTilesC.tile_targeted;
			
			if (Array_Find_Index(active_tiles, destination_tile) != -1) {		
				if (destination_tile.unit != noone) 
					Swap_Unit(starting_tile, destination_tile, unit_performing);
				else	
					Move_Unit(starting_tile, destination_tile, unit_performing);
			
				unit_performing.action_count	-= destination_tile.distance;
				if (oFightStateC.round_state == R_S.CONSEQUENCES){ 
					oUnitsC.unit_riposting = unit_performing;
					DM(S(oUnitsC.unit_riposting.name) +" is now riposting");
				}	
				Quit_FightMenu();
				exit;
			}
		}
	break;
	#endregion


	#region		FIGHTMENU_OPTIONS.ATTACK
	case FIGHTMENU_OPTIONS.ATTACK:
	
	if (array_length(active_tiles) == 0) {
			var tile_center		= tile_selected;
			
			if (unit_performing.attack_count == 0) {	
				Quit_FightMenu();
				exit;
			}
			
			// Attack range
			switch (unit_performing.side) {
			case SD.ALLIES:
				var weapon			= unit_performing.weapon; 
				var _attack_range	= weapon.range
				
				if !(Resolve_Range_Restriction(tile_center.range, weapon.range_restriction))	{
					Quit_FightMenu();
					exit;
				}
			break;
			
			case SD.ENEMIES:
				var _attack_range =	unit_performing.attack_range;
			break;
			}
		

			// Active tiles
			is_units_allowed		= false;
			is_tile_center_active	= false;
			is_cross				= true;
			
			oPassivesC.Event_Apply_Passive(E_P.PREPARE_TO_ATTACK, unit_performing);
			
			active_tiles	= Set_Active_tiles(tile_center, _attack_range, is_cross, is_tile_center_active, is_units_allowed, UNITS_NOT_ALLOWED.END, true)
		}

		if (mouse_check_button_pressed(mb_left)) {
			var tile_attacked = oTilesC.tile_targeted;
		
			if (Array_Find_Index(active_tiles, tile_attacked) != -1) && (tile_attacked.unit != noone) {
				unit_recieving = tile_attacked.unit;
					
				Unit_Attacks(unit_performing, unit_recieving);
				Check_Element_Death(unit_recieving, tile_attacked);
				unit_performing.action_count--;
				unit_performing.attack_count--;
				
				if (oFightStateC.round_state	== R_S.CONSEQUENCES 
				&& unit_recieving				!= undefined  //if unit dead -> undefined
				&& unit_performing.side			= SD.ENEMIES){ 
					oUnitsC.unit_riposting = unit_performing;
					DM(S(oUnitsC.unit_riposting.name) +" is now riposting");
				}	
				
				Quit_FightMenu();
				exit;
			}
			Quit_FightMenu();
			exit;
		}
	break;
	#endregion
}

#endregion





