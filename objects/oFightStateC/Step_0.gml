/// @desc
	

switch (fight_state) {
#region		F_S.INIT
case F_S.INIT:
	fight_state = F_S.PREPARING;
break;
#endregion
	
#region		F_S.PREPARING
case F_S.PREPARING:
	switch (preparing_state) {
	case PREPARING_STATE.STEP_CARD:
		preparing_state = PREPARING_STATE.PLACING_KEYS;
	break;
		
	case PREPARING_STATE.PLACING_KEYS:
		preparing_state = PREPARING_STATE.PLACING_SEEKERS;
	break;
		
	case PREPARING_STATE.PLACING_SEEKERS:
		if (array_length(oUnitsC.seekers_to_place) == 0)	preparing_state = PREPARING_STATE.PLACING_ENEMIES; 	
	break;
		
	case PREPARING_STATE.PLACING_ENEMIES:
		if (array_length(oUnitsC.enemies_to_place) == 0)	fight_state = F_S.ROUND; 
	break;
	}

		
break;
#endregion
	
#region		F_S.ROUND
case F_S.ROUND:
	if (array_length(oUnitsC.seekers)	== 0
	||	array_length(oUnitsC.enemies)	== 0)
		fight_state = F_S.CHECK_CONDITION;
			
	if (keyboard_check_pressed(ord("T")))	end_turn = true;
	switch (round_state) {
		#region		R_S.INIT
		case R_S.INIT:
			end_turn		= false
			round_state		= R_S.PLAYERS;
			/////////////////////////////////
			oPassivesC.Event_Apply_Passive(E_P.ROUND_BEGIN);
		break;
		#endregion
			
		#region		R_S.PLAYERS
		case R_S.PLAYERS:
			//Si player attack -> un ennemy peut attack ET/OU se déplacer (round_state = R_S.GM;)	
			if (end_turn == true)	{
				round_state		= R_S.GM;
				end_turn		= false
			}
		break;
		#endregion
			
		#region		R_S.GM
		case R_S.GM:
			//Changement de strat
			if (end_turn == true)	{
				round_state		= R_S.INIT;
				end_turn		= false
			}
		break;
		#endregion
		
		case R_S.CONSEQUENCES:
			if (end_turn == true)	{
					round_state		= R_S.PLAYERS;
					end_turn		= false
					with (oUnitsC) {
						if (unit_riposting != noone)	
							unit_riposting.action_count = 2;
						unit_riposting = noone;
					}
			}
		break;
	}
break;
#endregion
	
#region		F_S.CHECK_CONDITION
case F_S.CHECK_CONDITION:
	round_state		= R_S.INIT;
	if		(array_length(oTilesC.oUnitsC.enemies) <= 0) {
		players_victory = true;
		fight_state		= F_S.END
	}
	else if (array_length(oTilesC.oUnitsC.seekers) <= 0) {
		players_victory = false;
		fight_state		= F_S.END
	}
	else {
		fight_state		= F_S.ROUND;
	}
		// Si une clé meurt -> perdu
break;
#endregion
	
#region		F_S.END
case F_S.END:
	// Marchand
break;
#endregion
}


