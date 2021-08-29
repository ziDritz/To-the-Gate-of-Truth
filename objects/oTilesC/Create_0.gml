#region	Tiles
// Init
	// Var/Const
columns	= 8;
rows	= 4;
grid_x	= 0;
grid_y	= 0;

tiles	= array_create(columns, array_create(rows, noone));

tiles_ally		= [];
tiles_enemy		= [];


	// Set up
for (var yy = 0; yy < rows;		yy++) {
for (var xx = 0; xx < columns;	xx++) {
	
	// x,y
	draw	= TilePosToScreen(xx, yy);
	draw_x	= draw[0]; 
	draw_y	= draw[1];
	
	// Range
	var range_init = undefined;
	switch (xx) {
	case 0:				range_init	= "Far";	break;
	case 1: case 2:		range_init	= "Near";	break;
	case 3:				range_init	= "Close";	break;
	case 4:				range_init	= "Close";	break;
	case 5: case 6:		range_init	= "Near";	break;
	case 7:				range_init	= "Far";	break;
	}

	// Side
	enum SD {
	ALLIES,
	ENEMIES
	}
	if (xx <= 3)		var side_init	= SD.ALLIES;
	if (xx > 3)			var side_init	= SD.ENEMIES;
	
		
	var tile_init = {
		name			: string(xx) + ", " + string(yy),
		
		x				: draw_x, 
		y				: draw_y, 
		sprite			: spTile,
		image_index		: 1,
		grid_x			: xx,
		grid_y			: yy, 
		
		range			: range_init,
		side			: side_init,
		unit			: noone,
		
		// For actions
		parent		: noone,
		passable	: true,
		neigbours	: [],
		distance	: -1
	};
	if (tile_init.side == SD.ALLIES)	array_push(tiles_ally,	tile_init);
	if (tile_init.side == SD.ENEMIES)	array_push(tiles_enemy, tile_init);
	
	tiles[xx][yy] = tile_init;
}}


// Tiles' neigbours
for (var yy = 0; yy < rows;		yy++) {
for (var xx = 0; xx < columns;	xx++) {
	
	var tile = tiles[xx][yy];
	if (xx+1 < columns) {
		var tile_neigbour = tiles[xx+1][yy];
		array_push(tile.neigbours, tile_neigbour);
	} 

	
	if (xx-1 >= 0) {
		tile_neigbour = tiles[xx-1][yy];
		array_push(tile.neigbours, tile_neigbour);
	} 

	
	if (yy+1 < rows) {
		tile_neigbour = tiles[xx][yy + 1];
		array_push(tile.neigbours, tile_neigbour);
	} 
	
	if (yy-1 > 0) {
		tile_neigbour = tiles[xx][yy - 1];
		array_push(tile.neigbours, tile_neigbour);
	} 
}}
#endregion
	

#region Step
function Get_Tile_Targeted() {
mouse_grid					= ScreenToTilePos(mouse_x, mouse_y);
mouse_grid_x				= mouse_grid[0];
mouse_grid_y				= mouse_grid[1];
mouse_grid_without_clamp_x	= mouse_grid[2];
mouse_grid_without_clamp_y	= mouse_grid[3];
tile_targeted				= tiles[mouse_grid_x][mouse_grid_y];
}


Placing_Seekers = function() {
	if (mouse_check_button_pressed(mb_left)
		&&	Pointing_Board() == true) {
		tile_selected = tile_targeted;
			
		if (tile_selected.unit == noone	
		&&	tile_selected.side == SD.ALLIES) {
			with (oUnitsC) {
				var seeker_selected			= seekers_to_place[seeker_selected_i];
				
				seeker_selected.tile		= other.tile_selected;
				other.tile_selected.unit	= seeker_selected;
				array_push	(seekers_on_board, seeker_selected);
				array_delete(seekers_to_place, seeker_selected_i, 1);
				array_push	(units_on_board, seeker_selected);
			}
		}
	}
}

Placing_Enemies = function() {
	if (mouse_check_button_pressed(mb_left)
	&&	Pointing_Board()) {
		tile_selected = tile_targeted;
			
		if (tile_selected.unit == noone
		&&  tile_selected.side == SD.ENEMIES) {
			with (oUnitsC) {
				var enemy_selected			= enemies_to_place[seeker_selected_i];
				
				enemy_selected.tile			= other.tile_selected;
				other.tile_selected.unit	= enemy_selected;
				array_push	(enemies_on_board, enemy_selected)
				array_delete(enemies_to_place, enemy_selected_i, 1);
				array_push	(units_on_board, enemy_selected);
			}
		}
	}	
}

Select_Player_Tile = function() {
	if (mouse_check_button_pressed(mb_left)) {
	// Selecting Tile with a unit who performs action
		if (!instance_exists(oActions)) 
		&& (tile_targeted.unit != noone) 
		&& (tile_targeted.unit.side == SD.ALLIES) {
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
		&& (tile_targeted.unit.side == SD.ENEMIES){
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
		&& (tile_targeted.unit.side == SD.ENEMIES) {
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
	&& tile_targeted.side == SD.ALLIES)	{
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
	&& tile_targeted.side == SD.ENEMIES)	{
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