/// @desc
function ScreenToTilePos(){

// !!! Mettre l'origine sur "Top Center" sinon les hit box seront décalés
var xx = argument[0];
var yy = argument[1];

var grid_x = floor((xx / isom_width) + (yy / isom_height));
var grid_y = floor((yy / isom_height) - (xx / isom_width));

var grid_without_clamp_x = grid_x;
var grid_without_clamp_y = grid_y;

//Empêche les coordonnées de sortir de la grille (on pourra pas avoir grid_x = 12 si on a que 8 collones)
grid_x = clamp(grid_x, 0, oTilesController.columns-1);
grid_y = clamp(grid_y, 0, oTilesController.rows-1);

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