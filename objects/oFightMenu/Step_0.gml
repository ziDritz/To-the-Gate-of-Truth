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

mouse_grid_x = oTilesController.mouse_grid_x;
mouse_grid_y = oTilesController.mouse_grid_y;

switch (option_selected) {

	#region		FIGHTMENU_OPTIONS.MOVE
	case FIGHTMENU_OPTIONS.MOVE:
		var node_center		= nodes[# tile_selected.grid_x, tile_selected.grid_y];
		Set_Active_Nodes(node_center, 1, true, false, false, false, active_nodes);
		
		

		if (mouse_check_button_pressed(mb_left)) {
			for (var i = 0; i < ds_list_size(active_nodes); i++) {
			var node = active_nodes[|i];
			show_debug_message((string(node.grid_x) + string(node.grid_y)));
			}
			var node_move		= nodes[# mouse_grid_x, mouse_grid_y];
			show_debug_message((string(node_move.grid_x) + string(node_move.grid_y)));
			
			if (ds_list_find_index(active_nodes, node_move) != -1) {
				var tile_move	= oTilesController.tiles[# mouse_grid_x, mouse_grid_y];
				var unit_moving = tile_selected.unit;
				
				with (tile_selected) {
					unit = noone;	
				}
				
				with (tile_move) {
					unit = unit_moving;
					unit.action_count--;
				}
			
				unit_moving = {
					grid_x	: mouse_grid_x,
					grid_y	: mouse_grid_y
				};
				Quit_FightMenu();
				exit;
			}
			else {
				Quit_FightMenu();
				exit;
			}
		}
	break;
	#endregion

	#region		FIGHTMENU_OPTIONS.ATTACK
	case FIGHTMENU_OPTIONS.ATTACK:
		var node_center		= nodes[# tile_selected.grid_x, tile_selected.grid_y];
		var unit_attacking	= tile_selected.unit;
		Set_Active_Nodes(node_center, 7, true, false, false, true, active_nodes);
		
		if (mouse_check_button_pressed(mb_left)) {
			var node_attacked = nodes[# mouse_grid_x, mouse_grid_y];
		
			if (ds_list_find_index(active_nodes, node_attacked)) {
				var tile_attacked = oTilesController.tiles[# mouse_grid_x, mouse_grid_y];
				
				if (tile_attacked.unit != noone)	{
					if (tile_attacked.side == SIDE.PLAYER) {
						var players_units	= oTilesController.players_units;
						var unit_index		= Array_Find_Index(players_units, tile_attacked.unit);
						array_delete(players_units, unit_index, 1);
					}
					if (tile_attacked.side == SIDE.GM) {
						var gm_units		= oTilesController.gm_units;
						var unit_index		= Array_Find_Index(gm_units, tile_attacked.unit);
						array_delete(gm_units, unit_index, 1);
					}
					delete tile_attacked.unit;
					tile_attacked.unit = noone;
					unit_attacking.action_count--;
					unit_attacking.attack_count--;
					Quit_FightMenu();
					exit;
				}
			}
			Quit_FightMenu();
			exit;
		}
	break;
	#endregion
}

#endregion





