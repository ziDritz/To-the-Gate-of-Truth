/// @desc
#macro isom_width	sprite_get_width(spIsomRef)
#macro isom_height	sprite_get_height(spIsomRef)

function ScreenToTilePos(){

// !!! Mettre l'origine sur "Top Center" sinon les hit box seront décalés
var xx = argument[0];
var yy = argument[1];

var grid_x = floor((xx / isom_width) + (yy / isom_height));
var grid_y = floor((yy / isom_height) - (xx / isom_width));

var grid_without_clamp_x = grid_x;
var grid_without_clamp_y = grid_y;

//Empêche les coordonnées de sortir de la grille (on pourra pas avoir grid_x = 12 si on a que 8 collones)
grid_x = clamp(grid_x, 0, oTilesC.columns-1);
grid_y = clamp(grid_y, 0, oTilesC.rows-1);

return [grid_x, grid_y, grid_without_clamp_x, grid_without_clamp_y]

}


/// @desc
function TilePosToScreen(){
	
var xx = argument[0];
var yy = argument[1];
	
var draw_x = (xx - yy) * (isom_width / 2);
var draw_y = (xx + yy) * (isom_height / 2);
	
return [draw_x, draw_y];

}
	
function Pointing_Board() {
	if (	oTilesC.mouse_grid_without_clamp_x == oTilesC.mouse_grid_x
		&&	oTilesC.mouse_grid_without_clamp_y == oTilesC.mouse_grid_y)	return true;
	else																return false;
}
	
