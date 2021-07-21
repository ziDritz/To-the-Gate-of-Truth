

#region		Code phases

enum code {
	init,
	step
}

global.code_phase = code.init;

#endregion 

#region		Variables

gui_width			= display_get_gui_width();
gui_height			= display_get_gui_height();
#macro isom_width	sprite_get_width(spIsomRef)
#macro isom_height	sprite_get_height(spIsomRef)

#endregion

#region		Sprites init
if (global.code_phase == code.init) {
	global.sprites_units = [];
	array_insert(global.sprites_units, SIDE.PLAYER, spPlayer);
	array_insert(global.sprites_units, SIDE.GM, spEny);
}
#endregion

#region		Tiles
// Init
	// Var/Const
columns	= 8;
rows	= 4;
grid_x	= 0;
grid_y	= 0;
tiles	= ds_grid_create(columns, rows);

	// Set up
for (var yy = 0; yy < rows;		yy++) {
for (var xx = 0; xx < columns;	xx++) {
			
	draw	= TilePosToScreen(xx, yy);
	draw_x	= draw[0]; 
	draw_y	= draw[1]; 
	if ( xx <= 3 )	var side_init = SIDE.PLAYER;
	if ( xx > 3 )	var side_init = SIDE.GM;
		
	var tile_init = {
		x				: draw_x, 
		y				: draw_y, 
		sprite			: spTile,
		image_index		: 1,
		grid_x			: xx, 
		grid_y			: yy, 
		
		side			: side_init,
		unit			: noone
	};
	tiles[# xx, yy] = tile_init;
}}

	#endregion

#region		Units

gm_units		= [];
players_units	= [];

#region		Side	
enum SIDE {
	PLAYER,
	GM
}
#endregion
	
#endregion

#region		Actions

is_tile_selected = false;

#endregion





