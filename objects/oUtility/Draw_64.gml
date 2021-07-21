

item_height = font_get_size(fDefault);
debug_x = 0;
							
draw_set_font(fDefault)
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);


if variable_instance_exists(oTilesController, "tile_selected") debug[3] = "tile_selected: " + string(oTilesController.tile_selected);
debug[2] = "players_victory: " + string(oFightStateController.players_victory);
debug[1] = "mouse_grid_x: " + string(oTilesController.mouse_grid_x);
debug[0] = "mouse_grid_y: " + string(oTilesController.mouse_grid_y);
debug_count = array_length(debug)
debug_y = item_height * (debug_count-1) * 1.5;	//position du bas du texte	
	
	
for (var i = debug_count-1; i >= 0; i--){
	var txt = debug[i];
	var xx = debug_x
	var yy = debug_y - (item_height * i * 1.5);	//interligne de 0.5
	draw_text(xx, yy, txt);
}
