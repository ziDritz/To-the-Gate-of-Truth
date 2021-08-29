switch (oFightStateC.fight_state) {
	
case F_S.PREPARING:
	switch (oFightStateC.preparing_state) {
		 
	case PREPARING_STATE.PLACING_SEEKERS:
		Display_Stats_Seeker(seekers_to_place[seeker_selected_i]);
		Display_Stats_Weapon(seekers_to_place[seeker_selected_i]);
	break;
		
	case PREPARING_STATE.PLACING_ENEMIES:
		Display_Stats_Eny(enemies_to_place[enemy_selected_i]);
	break;
	}
break;
}
