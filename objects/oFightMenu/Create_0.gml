
option_targeted	= 0;
option_selected = -1;

//Pages
enum FIGHTMENU_COLUMNS {
	NAME, FUNCTION, IS_ENABLE
}

enum FIGHTMENU_OPTIONS {
	MOVE,
	ATTACK
	
}

fightMenu = Multiple_Arrays_To_Grid(
	["MOVE",		FIGHTMENU_OPTIONS.MOVE],
	["ATTACK",		FIGHTMENU_OPTIONS.ATTACK]
);

tile_selected = -1;


#region		Nodes

active_nodes	= ds_list_create();
nodes			= ds_grid_create(oTilesController.columns, oTilesController.rows);

	// Set up
for (var yy = 0; yy < oTilesController.rows;		yy++) {
for (var xx = 0; xx < oTilesController.columns;		xx++) {	

	draw	= TilePosToScreen(xx, yy);
	draw_x	= draw[0]; 
	draw_y	= draw[1]; 

	var node = {
		x			: draw_x,
		y			: draw_y,
		grid_x		: xx,	
		grid_y		: yy,	
		parent		: noone,
		passable	: true,
		neigbours	: [],
		distance	: -1
	};
	nodes[# xx, yy] = node;
}}

	// Nodes' Neigbors
for (var yy = 0; yy < oTilesController.rows;		yy++) {		
for (var xx = 0; xx < oTilesController.columns;		xx++) {
	node = nodes[# xx, yy];
	var node_neigbour = nodes[# xx+1, yy];
	if (node_neigbour != undefined)						array_push(node.neigbours, node_neigbour);
	node_neigbour = nodes[# xx-1, yy];
	if (node_neigbour != undefined)						array_push(node.neigbours, node_neigbour);
	node_neigbour = nodes[# xx, yy + 1];
	if (node_neigbour != undefined)						array_push(node.neigbours, node_neigbour);
	node_neigbour = nodes[# xx, yy - 1];
	if (node_neigbour != undefined)						array_push(node.neigbours, node_neigbour);
}}

#endregion



