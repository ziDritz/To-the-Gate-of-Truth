if (ds_exists(fightMenu, ds_type_grid))			ds_grid_destroy(fightMenu);
if (ds_exists(nodes, ds_type_list))				ds_grid_destroy(nodes);
if (ds_exists(active_nodes, ds_type_list))		ds_list_destroy(active_nodes);
