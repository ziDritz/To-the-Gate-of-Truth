/// @desc oFightStateController

enum F_S {
	INIT,
	PREPARING,
	ROUND,
	CHECK_CONDITION,
	END,
	last
}
fight_state = 0;

enum PREPARING_STATE {
	STEP_CARD,
	PLACING_KEYS,
	PLACING_SEEKERS,
	PLACING_ENEMIES
}
preparing_state = 0;

enum R_S {
	INIT,
	PLAYERS,
	GM,
	CONSEQUENCES
}
round_state		= 0;
end_turn		= false
		
players_victory = undefined;

	
// Default fight_state switch
//switch (oFightStateC.fight_state) {
//#region		F_S.INIT
//case F_S.INIT:
//break;
//#endregion
	
//#region		F_S.PREPARING
//case F_S.PREPARING:
//	switch (oFightStateC.preparing_state) {
//	case PREPARING_STATE.STEP_CARD:
//	break;
		
//	case PREPARING_STATE.PLACING_KEYS:
//	break;
		
//	case PREPARING_STATE.PLACING_SEEKERS:
//	break;
		
//	case PREPARING_STATE.PLACING_ENEMIES:
//	break;
//	}
//break;
//#endregion
	
//#region		F_S.ROUND
//case F_S.ROUND:
//	switch (oFightStateC.round_state) {
//		#region		R_S.INIT
//		case R_S.INIT:
//		break;
//		#endregion
			
//		#region		R_S.PLAYERS
//		case R_S.PLAYERS:
//		break;
//		#endregion
			
//		#region		R_S.GM
//		case R_S.GM:
//		break;
//		#endregion
//	}
//break;
//#endregion
	
//#region		F_S.CHECK_CONDITION
//case F_S.CHECK_CONDITION:
//break;
//#endregion
	
//#region		F_S.END
//case F_S.END:
//break;
//#endregion
//}





