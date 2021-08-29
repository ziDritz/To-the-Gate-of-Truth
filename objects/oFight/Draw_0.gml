for (var yy = 0; yy < rows;		yy++) {
for (var xx = 0; xx < columns;	xx++) {
	t = tiles[xx][yy];
	s_m.Draw_Tiles();				
	s_m.Draw_Need_All_Tiles();
}}


// Draw Units on Board	
if (variable_instance_exists(id, "units_on_board")) {
	for (var i = 0; i < array_length(units_on_board); i++) {
		var u = units_on_board[i];	
		with (u)	s_m.Draw_Self();
	}
}