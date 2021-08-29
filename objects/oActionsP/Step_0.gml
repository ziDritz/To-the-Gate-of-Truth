if (keyboard_check_pressed(vk_escape))	{
	Quit_FightMenu(); 
	exit;
}

#region		Selection option

if (keyboard_check_pressed(vk_up))		option_targeted--;
if (keyboard_check_pressed(vk_down))	option_targeted++;

if (option_targeted >= ds_grid_height(fightMenu))	option_targeted = 0;
if (option_targeted < 0)							option_targeted = ds_grid_height(fightMenu)-1;


if (keyboard_check_pressed(vk_enter)) && (tile_selected.unit.action_count > 0) {
		option_selected = fightMenu[# FIGHTMENU_COLUMNS.FUNCTION, option_targeted];
}

#endregion


#region		Actions

switch (option_selected) {

	#region		FIGHTMENU_OPTIONS.MOVE
	case FIGHTMENU_OPTIONS.MOVE:
		var starting_tile	= tile_selected;
		var unit_moving		= tile_selected.unit;
		
		if (array_length(active_tiles) == 0)	
			active_tiles		= Set_Active_tiles(starting_tile, unit_moving.action_count, false, false, false, UNITS_NOT_ALLOWED.BLOCK ,false);

		if (mouse_check_button_pressed(mb_left)) { 
			var destination_tile	= oTilesC.tile_targeted;
			
			if (Array_Find_Index(active_tiles, destination_tile) != -1) {		
				if (destination_tile.unit != noone) 
					Swap_Unit(starting_tile, destination_tile, unit_moving);
				else	
					Move_Unit(starting_tile, destination_tile, unit_moving);
			
					
				if (oFightStateC.round_state == ROUND_STATE.CONSEQUENCES) && (unit_moving.side == SIDE.ENEMIES){ 
					oUnitsC.unit_riposting = unit_moving;
				}	
				Quit_FightMenu();
				exit;
			}
		}
	break;
	#endregion


	#region		FIGHTMENU_OPTIONS.ATTACK
	case FIGHTMENU_OPTIONS.ATTACK:
		var tile_center		= tile_selected;
		var unit_attacking	= tile_selected.unit;
		
		if (unit_attacking.side == SIDE.ALLIES) {
			var weapon			= unit_attacking.weapon; 
			var _attack_range	= weapon.range
			
			if !(Resolve_Range_Restriction(tile_center.range, weapon.range_restriction))	{
				Quit_FightMenu();
				exit;
			}
		}
		
		if (unit_attacking.side == SIDE.ENEMIES) {
			var _attack_range =	unit_attacking.attack_range;
		}
		
		// active tiles
		if (array_length(active_tiles) == 0)
			active_tiles	= Set_Active_tiles(tile_center, _attack_range, true, false, false, UNITS_NOT_ALLOWED.END, true)

		if (mouse_check_button_pressed(mb_left)) {
			var tile_attacked = oTilesC.tile_targeted;
		
			if (Array_Find_Index(active_tiles, tile_attacked) != -1) && (tile_attacked.unit != noone) {
				var unit_attacked = tile_attacked.unit;
					
				switch (unit_attacking.side) {
				case SIDE.ALLIES:
					Ally_Attacks (unit_attacking, unit_attacked);
					if (unit_attacked.side == SIDE.ENEMIES)		Check_Eny_Death(unit_attacked, tile_attacked);
					if (unit_attacked.side == SIDE.ALLIES)		Check_Ally_Death(unit_attacked, tile_attacked);
				break;

				case SIDE.ENEMIES:
					Eny_Attacks (unit_attacking, unit_attacked)
					if (unit_attacked.side == SIDE.ENEMIES)		Check_Eny_Death(unit_attacked, tile_attacked);
					if (unit_attacked.side == SIDE.ALLIES)		Check_Ally_Death(unit_attacked, tile_attacked);
					
					if (oFightStateC.round_state == ROUND_STATE.CONSEQUENCES) oUnitsC.unit_riposting = unit_attacking;
				break;
				}	
				unit_attacking.action_count--;
				unit_attacking.attack_count--;
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





