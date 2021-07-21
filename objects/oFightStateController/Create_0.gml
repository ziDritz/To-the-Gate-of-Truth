/// @desc



enum FIGHT_STATE {
	INIT,
	ROUND,
	CHECK_CONDITION,
	END,
	last
}
fight_state = 0;


enum ROUND_STATE {
	INIT,
	PLAYERS,
	GM
}
end_turn		= false
round_state		= 0;
	
	
players_victory = undefined;
