

		
// On check toutes les tiles...
for (var yy = 0; yy < rows; yy++) {
for (var xx = 0; xx < columns; xx++) {
		
	var tile = tiles[# xx, yy];
	draw	= TilePosToScreen(xx, yy);
	draw_x	= draw[0]; 
	draw_y	= draw[1];
	
		
#region		Draw tile
	with (tile)	{
		if (tile.side = SIDE.PLAYER)	draw_sprite(sprite, 1, x, y);
		if (tile.side = SIDE.GM)	draw_sprite(sprite, 2, x, y);
	}
#endregion


switch (oFightStateController.fight_state) {
	#region		FIGHT_STATE.INIT
	case FIGHT_STATE.INIT:
		if (mouse_grid_without_clamp_x == mouse_grid_x 
		&& mouse_grid_without_clamp_y == mouse_grid_y
		&& mouse_grid_x == xx 
		&& mouse_grid_y == yy)	{
				draw_sprite_ext(global.sprites_units[tile.side], 0, draw_x, draw_y, 1, 1, 0, c_white, 0.5);
		}
	break;
	#endregion
	
	#region		FIGHT_STATE.ROUND
	case FIGHT_STATE.ROUND:
		if (variable_instance_exists(oFightMenu, "active_nodes")) {
			// Draw Active Nodes
			var node = oFightMenu.nodes[# xx, yy];
			if (ds_list_find_index(oFightMenu.active_nodes, node) != -1)	draw_sprite(spNode, 0, node.x, node.y);
		}
	break;
	#endregion
}

#region		Draw Units
	if (tile.unit != noone)	draw_sprite(global.sprites_units[tile.unit.side], 0, tile.x, tile.y);
#endregion
	
#region		Draw Cursor
		if (xx == mouse_grid_x && yy == mouse_grid_y)		draw_sprite(spCursor, 0, draw[0], draw[1]);	
#endregion	
	
}}



