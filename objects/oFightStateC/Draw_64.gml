
#region		Draw Fight State
switch (fight_state) {
case F_S.INIT:
	fight_state_text = "Initialization";
break;

case F_S.PREPARING:
	fight_state_text = "Preparing";
	switch (preparing_state) {
	case PREPARING_STATE.STEP_CARD:
		preparing_state_text = "Choose a step card";
	break;
	case PREPARING_STATE.PLACING_KEYS:
		preparing_state_text = "Placing keys";
	break;
	case PREPARING_STATE.PLACING_SEEKERS:
		preparing_state_text = "Placing seekers";
	break;
	case PREPARING_STATE.PLACING_ENEMIES:
		preparing_state_text = "Placing enemies";
	break;
	}
	draw_text(display_get_gui_width() / 2, font_get_size(fDefault), preparing_state_text);
break;

case F_S.ROUND:
	fight_state_text = "Round";
	switch (round_state) {
	case R_S.INIT:
		
		round_state_text = "Initialazing";
	break;
	case R_S.PLAYERS:
		round_state_text = "Player's Turn";
	break;
	case R_S.GM:
		round_state_text = "GM's Turn";
	break;
	case R_S.CONSEQUENCES:
		round_state_text = "Consequences";
	break;
	}
	draw_set_halign(fa_right);
	draw_text(display_get_gui_width() / 2, font_get_size(fDefault), round_state_text);
break;

case F_S.CHECK_CONDITION:
	fight_state_text = "Condition checking";
break;

case F_S.END:
	fight_state_text = "End";
break;

#endregion
}

draw_set_halign(fa_left);
draw_text(display_get_gui_width() / 2, 0, fight_state_text);


