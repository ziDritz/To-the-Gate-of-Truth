#region		Draw fightMenu

var tile_x = tile_selected.x; 
var tile_y = tile_selected.y;
var y_offset = 16;
var x_offset = 16;
var x_offset_fromCar = 90;
var x_offset_fromItems = 25;
var array_height = ds_grid_height(fightMenu);
var start_x = tile_x - x_offset_fromCar;
//fonction de ouf pour déterminer la position du premier item du menu
var start_y = tile_y - (((array_height-1)/2) * y_offset);  

//Draw items
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
var c = c_black;

for (var yy = 0; yy < array_height; yy++) {
	var txt_x = start_x;
	var txt_y = start_y + (yy*y_offset);
	c = c_black;
	
		
	//item sélectionné
	if (yy == option_targeted) {
		c = c_orange;
		txt_x = start_x - x_offset_fromItems;
	}
	
	if (fightMenu[# FIGHTMENU_COLUMNS.NAME, yy] == "ATTACK") && (tile_selected.unit.attack_count == 0)	c = c_grey;
		
	draw_set_color(c);
	draw_text(txt_x, txt_y, fightMenu[# FIGHTMENU_COLUMNS.NAME, yy]);
}

#endregion



