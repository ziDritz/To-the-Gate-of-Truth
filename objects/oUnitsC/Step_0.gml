switch (oFightStateC.fight_state) {
	#region		F_S.INIT
	case F_S.INIT:
		seekers_to_place	= [];
		array_copy(seekers_to_place, 0, seekers, 0, array_length(seekers));
		seeker_targeted_i	= 0;
		seeker_selected_i	= 0;
		
		enemies_to_place	= [];
		array_copy(enemies_to_place, 0, enemies, 0, array_length(enemies));
		enemy_targeted_i	= 0;
		enemy_selected_i	= 0;
		
		key_init = {
			hp	: 5,
			sprite	: spKey,
			tile	: undefined
		}
		with (oTilesC) {
			var i					= irandom_range(0, array_length(tiles_ally));
			var tile_selected		= tiles_ally[i];
			
			other.key_init.tile		= tile_selected;
			tile_selected.unit		= other.key_init;
		}
		array_push(keys_on_board, key_init);
		
		#region Set up passives
		for (var i = 0; i < array_length(seekers_to_place); i++) {
			with (seekers_to_place[i]) {
				var e_p_seeker	= Convert_Event(default_passive.when)
				oPassivesC.Passive_Listen_Event(e_p_seeker, self.default_passive);
	
				with (weapon) {
					if (passive_1 != noone) {
						var e_p1_w			= Convert_Event(passive_1.when);
						oPassivesC.Passive_Listen_Event(e_p1_w, self.passive_1);
					}
					if (passive_2 != noone) {
					var e_p2_w			= Convert_Event(passive_2.when);
					oPassivesC.Passive_Listen_Event(e_p2_w, self.passive_2);						
					}				
				}
			}
		}
		
		#endregion
		
		
	break;
	#endregion
	
	#region		F_S.ROUND
	case F_S.ROUND:
		switch (oFightStateC.round_state) {
			#region		R_S.INIT
			case R_S.INIT:
			
			for (var i = 0; i < array_length(seekers_on_board); i++) {
				with (seekers_on_board[i]) {
					action_count			= 2;
					attack_count			= 1;
					
				}
			}
			for (var i = 0; i < array_length(enemies_on_board); i++) {
				with (enemies_on_board[i]) {
					action_count	= 2;
					attack_count	= 1;
				}
			}
			
			unit_riposting = noone;
			
			
			break;
			#endregion
			
			case R_S.PLAYERS:
			break;
			
			case R_S.GM:
			break;
		}
	break;
	#endregion
	
	
}