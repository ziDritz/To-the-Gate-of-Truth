
	

#region Step

Select_Player_Tile = function() {
	if (mouse_check_button_pressed(mb_left)) {
	// Selecting Tile with a unit who performs action
		if (!instance_exists(oActions)) 
		&& (tile_targeted.unit != noone) 
		&& (tile_targeted.unit.side == SD.PLAYERS) {
			with (instance_create_layer(0, 0, "UI", oActions))	{ 
				tile_selected	= other.tile_targeted;
				unit_performing = other.tile_targeted.unit;
			}
		}
	}	
}

Select_Gm_Tile = function() {
	if (mouse_check_button_pressed(mb_left)) {
	// Selecting Tile with a unit who performs action
		if (!instance_exists(oActions)) 
		&& (tile_targeted.unit != noone) 
		&& (tile_targeted.unit.side == SD.GM){
			with (instance_create_layer(0, 0, "UI", oActions))	{ 
				tile_selected	= other.tile_targeted;
				unit_performing = other.tile_targeted.unit;
			}
		}
	}
}
	
Select_Gm_Tile_consequences = function() {
	if (mouse_check_button_pressed(mb_left)) {
	// Selecting Tile with a unit who performs action
		if (!instance_exists(oActions)) 
		&& (oUnitsC.unit_riposting == noone || tile_targeted.unit == oUnitsC.unit_riposting) 
		&& (tile_targeted.unit != noone) 
		&& (tile_targeted.unit.side == SD.GM) {
			with (instance_create_layer(0, 0, "UI", oActions))	{ 
				tile_selected	= other.tile_targeted;
				unit_performing = other.tile_targeted.unit;
			}
		}
	}
}
	

preparing_states[PREPARING_STATE.PLACING_SEEKERS]	= Placing_Seekers;
preparing_states[PREPARING_STATE.PLACING_ENEMIES]	= Placing_Enemies;

round_states[R_S.PLAYERS]					= Select_Player_Tile;
round_states[R_S.GM]						= Select_Gm_Tile;
round_states[R_S.CONSEQUENCES]				= Select_Gm_Tile_consequences;
#endregion


#region Draw
Draw_Placing_Seekers = function(xx, yy) {
	if (Pointing_Board()
	&& mouse_grid_x == xx 
	&& mouse_grid_y == yy
	&& tile_targeted.side == SD.PLAYERS)	{
		with (oUnitsC) {
			if (array_length(seekers_to_place) != 0) {	
				draw_sprite_ext(seekers_to_place[seeker_targeted_i].sprite, 0, other.draw_x, other.draw_y, 1, 1, 0, c_white, 0.5);
			}
		}
	}
}

Draw_Placing_Enemies = function(xx, yy) {
	if (Pointing_Board()
	&& mouse_grid_x == xx 
	&& mouse_grid_y == yy
	&& tile_targeted.side == SD.GM)	{
		with (oUnitsC) {
			if (array_length(enemies_to_place) != 0) { 
				draw_sprite_ext(enemies_to_place[enemy_targeted_i].sprite, 0, other.draw_x, other.draw_y, 1, 1, 0, c_white, 0.5);
			}
		}
	}
}


Draw_Active_Tiles = function(xx, yy) {
	if (variable_instance_exists(oActions, "active_tiles")) {
		// Draw Active tiles
		var node = tiles[xx][yy];
			
		if (Array_Find_Index(oActions.active_tiles, node) != -1)	draw_sprite(spNode, 0, node.x, node.y);
	}	
}
	

fight_states_draw[F_S.ROUND]					= Draw_Active_Tiles;

draw_preparing_states[PREPARING_STATE.PLACING_SEEKERS]	= Draw_Placing_Seekers;
draw_preparing_states[PREPARING_STATE.PLACING_ENEMIES]	= Draw_Placing_Enemies;
#endregion


#region Draw GUI
Display_Stats_Units = function() {
	if (Pointing_Board() 
	&&	tile_targeted.unit != noone) {
		with (oUnitsC) {
			if		(Array_Find_Index(seekers_on_board, other.tile_targeted.unit) != -1) {	
				unit_targeted	= seekers_on_board[Array_Find_Index(seekers_on_board, other.tile_targeted.unit)];
				Display_Stats_Seeker(unit_targeted);
				Display_Stats_Weapon(unit_targeted);
			}
			else if (Array_Find_Index(enemies_on_board, other.tile_targeted.unit) != -1) {
				unit_targeted	= enemies_on_board[Array_Find_Index(enemies_on_board, other.tile_targeted.unit)];
				Display_Stats_Eny(unit_targeted);
			}
			else if (Array_Find_Index(keys_on_board, other.tile_targeted.unit) != -1) {
				unit_targeted	= keys_on_board[Array_Find_Index(keys_on_board, other.tile_targeted.unit)];
				Display_Stats_Key(unit_targeted);
			}
		}			
	}
}
	
fight_states_draw_g[F_S.ROUND]				= Display_Stats_Units;
#endregion