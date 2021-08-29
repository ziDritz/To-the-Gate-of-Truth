switch (oFightStateC.fight_state) {
case F_S.PREPARING:
	Draw_Units(seekers_on_board);
	Draw_Units(keys_on_board);
	Draw_Units(enemies_on_board);
break;

case F_S.ROUND:
	Draw_Units(seekers_on_board);
	Draw_Units(keys_on_board);
	Draw_Units(enemies_on_board);
break;
}