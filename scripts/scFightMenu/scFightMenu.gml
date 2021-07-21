/// @function		Set_Active_Nodes(node_center, range, is_actor_allowed, actors_block, active_nodes)
/// @desc			Generate a node_parent_neigbours that contains all the nodes that can be used for mouvement, attacking...
/// @param			node_center				{real}		The instance_id of the node_parent_neigbour that we want to calculate from (eg caracter pos for movement, attack landing for AOE)
/// @param			range					{real}		The distance from the node_center that we want to check for nodes to add to node_parent_neigbours
/// @param			is_cross				{boolean}	
/// @param			is_node_center_active	{boolean}	
/// @param			is_actor_allowed		{boolean}	
/// @param			is_side_allowed			{boolean}	
/// @param			active_nodes			{real}		Index of the node_parent_neigbours that will store the instance_id of active nodes
function Set_Active_Nodes(){
	
	var node_center				= argument[0];
	var range					= argument[1];
	var is_cross				= argument[2];
	var	is_node_center_active	= argument[3];
	var is_actor_allowed		= argument[4];
	var is_side_allowed			= argument[5];
	var active_nodes			= argument[6];
	
	var nodes_pending			= ds_priority_create();
	var nodes_checked			= ds_list_create();
	ds_list_clear(active_nodes);
	
	//On met la node de départ dans les nodes_pending
	tile_start_side = oTilesController.tiles[# node_center.grid_x, node_center.grid_y].side;
	node_center.distance = 0;
	ds_priority_add(nodes_pending, node_center, node_center.distance);
	if (is_node_center_active == true)	ds_list_add(active_nodes, node_center);
	ds_list_add(nodes_checked, node_center);
	
	while (ds_priority_size(nodes_pending) > 0) {
		//On sort la node la plus proche des nodes_pending... (1st time c'est la node_center)
		var node_parent = ds_priority_delete_min(nodes_pending);
		var tile_parent = oTilesController.tiles[# node_parent.grid_x, node_parent.grid_y];
		
		if (	(node_parent.distance < range)
			&&
				((is_actor_allowed == false && tile_parent.unit == noone)
			||	(is_actor_allowed == false &&	node_parent == node_center)
			||	(is_actor_allowed == true))){
			// On prend un neigbour
			for (var i = 0; i < array_length(node_parent.neigbours); i++) {
				node_parent_neigbour = node_parent.neigbours[i];
				// Si la neigbour n'est pas encore checké
				// Si la distance du neigbour est différent de -1 ?
				if (ds_list_find_index(nodes_checked, node_parent_neigbour) == -1) {	
					var tile_parent_neigbour = oTilesController.tiles[# node_parent_neigbour.grid_x, node_parent_neigbour.grid_y];
					
					if (	((is_side_allowed == true)
						||	(is_side_allowed == false) && (tile_start_side == tile_parent_neigbour.side))
						&&
							((is_cross == false)
						||	(is_cross == true) && (node_parent_neigbour.grid_x == node_center.grid_x || node_parent_neigbour.grid_y == node_center.grid_y))
						){
						// || (actors_block && actor_grid[# node_parent_neigbour.grid_x, node_parent_neigbour.grid_y] != noone)
						// la node devient le parent du neigbour
						node_parent_neigbour.parent = node_parent;
						// le voisin est + éloigné de 1 que la node
						node_parent_neigbour.distance = node_parent.distance + 1;
						// on la rajoute dans les nodes actives, pending, checked
						ds_list_add(active_nodes, node_parent_neigbour);
						ds_priority_add(nodes_pending, node_parent_neigbour, node_parent_neigbour.distance);	
					}
					ds_list_add(nodes_checked, node_parent_neigbour);
				}
			}
		}
	}
	ds_list_destroy(nodes_checked);
	ds_priority_destroy(nodes_pending);
}


function Quit_FightMenu() {
	oTilesController.is_tile_selected	= false;
	tile_selected						= -1;
	instance_destroy();
}