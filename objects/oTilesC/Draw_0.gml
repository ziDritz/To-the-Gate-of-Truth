

		
// On check toutes les tiles...
for (var yy = 0; yy < rows; yy++) {
for (var xx = 0; xx < columns; xx++) {
		
	tile	= tiles[xx][yy];
	draw	= TilePosToScreen(xx, yy);
	draw_x	= draw[0]; 
	draw_y	= draw[1];

#region		Draw tile
	with (tile)	{
		if (side = SD.PLAYERS)		draw_sprite(sprite, 1, x, y);
		if (side = SD.GM)	draw_sprite(sprite, 2, x, y);
	}
#endregion

	switch (oFightStateC.fight_state) {
		case F_S.PREPARING: Switch_State_Execute(draw_preparing_states, oFightStateC.preparing_state, xx, yy);		break;
	
		case F_S.ROUND:		Draw_Active_Tiles(xx, yy);															break;
	}
	
	//Draw Cursor
	if (xx == mouse_grid_x && yy == mouse_grid_y)		draw_sprite(spCursor, 0, draw[0], draw[1]);	
	
}}

	


