
	
Get_Tile_Targeted();

switch (oFightStateC.fight_state) {
case F_S.PREPARING:	Switch_State_Execute(preparing_states, oFightStateC.preparing_state);	break;

case F_S.ROUND:		Switch_State_Execute(round_states, oFightStateC.round_state);			break;
}




