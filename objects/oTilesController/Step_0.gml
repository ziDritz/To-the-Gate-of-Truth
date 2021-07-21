
#region		Camera
// Init
if (global.code_phase == code.init) {
	camera_x = (isom_width / 2) - (camera_get_view_width(view_camera[0]) / 2);
	camera_y = -(camera_get_view_width(view_camera[0]) / 4);
}
	
// Step
if (keyboard_check(ord("Q"))) camera_x -=5;
if (keyboard_check(ord("D"))) camera_x +=5;
if (keyboard_check(ord("Z"))) camera_y -=5;
if (keyboard_check(ord("S"))) camera_y +=5;
camera_set_view_pos(view_camera[0], camera_x, camera_y);
#endregion
	
#region		Targeting tile with mouse
mouse_grid					= ScreenToTilePos(mouse_x, mouse_y);
mouse_grid_x				= mouse_grid[0];
mouse_grid_y				= mouse_grid[1];
mouse_grid_without_clamp_x	= mouse_grid[2];
mouse_grid_without_clamp_y	= mouse_grid[3];
tile_targeted				= tiles[# mouse_grid_x, mouse_grid_y];
#endregion 

switch (oFightStateController.fight_state) {
	#region		FIGHT_STATE.INIT
	case FIGHT_STATE.INIT:
	//choix step card (récmpense)
	//placement random des keys
	#region		Placing units
		if (mouse_check_button_pressed(mb_left)
		// Si on vise le board
		&& mouse_grid_without_clamp_x == mouse_grid_x
		&& mouse_grid_without_clamp_y == mouse_grid_y) {
			tile_selected	= tile_targeted;
			
			if (tile_selected.unit == noone) {
				var unit_init = {
					sprite_index	: global.sprites_units[tile_selected.side],
					image_index		: 0,
					side			: tile_selected.side,
					action_count	: 2,
					attack_count	: 1
				};
				if (oFightStateController.round_state == ROUND_STATE.PLAYERS
				&&	tile_selected.side = SIDE.PLAYER) {
					array_push(players_units,unit_init);
					tile_selected.unit = unit_init;
				}
				if (oFightStateController.round_state == ROUND_STATE.GM
				&& tile_selected.side = SIDE.GM) {
					array_push(gm_units,unit_init);
					tile_selected.unit = unit_init;
				}
			}
		}
	#endregion
	break;
	#endregion
	
	#region		FIGHT_STATE.ROUND
	case FIGHT_STATE.ROUND:
		switch (oFightStateController.round_state) {
			#region		ROUND_STATE.INIT
			case ROUND_STATE.INIT:
				for (var i = 0; i < array_length(players_units); i++) {
					players_units[i].action_count	= 2;
					players_units[i].attack_count	= 1;
				}
				for (var i = 0; i < array_length(gm_units); i++) {
					gm_units[i].action_count	= 2;
					gm_units[i].attack_count	= 1;
				}
				
			break;
			#endregion
			
			#region		ROUND_STATE.PLAYERS			
			case ROUND_STATE.PLAYERS:
				if (mouse_check_button_pressed(mb_left)) {
				// Selecting Tile with a unit who performs action
					if (is_tile_selected == false) 
					&& (tile_targeted.unit != noone) 
					&& (tile_targeted.unit.side == SIDE.PLAYER) {
						is_tile_selected = true;
						with (instance_create_depth(0, 0, -10, oFightMenu))	{ 
							tile_selected	= other.tile_targeted;
						}
					}
				}
			break;
			#endregion
			
			#region		ROUND_STATE.GM
			case ROUND_STATE.GM:
				if (mouse_check_button_pressed(mb_left)) {
				// Selecting Tile with a unit who performs action
					if (is_tile_selected == false) 
					&& (tile_targeted.unit != noone) 
					&& (tile_targeted.unit.side == SIDE.GM)
					&& (tile_targeted.unit.action_count > 0) {
						is_tile_selected = true;
						with (instance_create_depth(0, 0, -10, oFightMenu))	{ 
							tile_selected	= other.tile_targeted;
						}
					}
				}
			break;
			#endregion
		}
	break;
	#endregion
}



