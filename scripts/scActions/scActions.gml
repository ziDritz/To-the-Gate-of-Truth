function Shield(amount) {
	shield += amount;
}

function Push(amount) {
	var unit_recieving		= self;
	var unit_performing		= oActions.unit_performing;
	
	var start_g_x			= unit_recieving.tile.grid_x;
	var start_g_y			= unit_recieving.tile.grid_y;
	
	var direction_x			= sign(start_g_x - unit_performing.tile.grid_x);
	var mouvement_x			= amount * direction_x;
	var destination_g_x		= start_g_x + mouvement_x;
	
	var direction_y			= sign(start_g_y - unit_performing.tile.grid_y);
	var mouvement_y			= amount * direction_y;
	var destination_g_y		= start_g_y + mouvement_y;
	
	var destination_tile	= oTilesC.tiles[destination_g_x][destination_g_y];

	// If next to the board's end or the opposite side
	if (destination_tile == undefined) || (unit_recieving.side != destination_tile.side)	{
		DM("Tile " +S(destination_tile.name)+ " is blocked by the board or side");	
		oActions.Apply_Damage(unit_recieving, 1);
	}
	
	// If something to stop unit_recieving
	else if (destination_tile.unit != noone) {
		DM("Tile " +S(destination_tile.name)+ " is blocked by "+ S(destination_tile.unit.name));	
		oActions.Apply_Damage(unit_recieving, 1);
		oActions.Apply_Damage(destination_tile.unit, 1);
	}

		// If nothing to stop unit_recieving
	else {
		DM(S(unit_recieving.name) +" is pushed");
		oActions.Move_Unit(unit_recieving.tile, destination_tile, unit_recieving);
	}

}

function Leap(){
	is_units_allowed = true;
	DM("Next move can leap");
}
