if (array_length(seekers_targeted) == 0) {
	
	var l = array_length(seekers_to_choose);
	for (var i = 0; i < l; i++) {
		
		var s = seekers_to_choose[i]
		
		if (s != noone) && (s.triumvirat == triumvirat_i)	array_push(seekers_targeted, s)
	}
}


switch (keyboard_key) {
case vk_nokey: 
break; 

case vk_left:
	if (triumvirat_i == triumvirat_min)		triumvirat_i = triumvirat_max;
	else									triumvirat_i--;
	array_resize(seekers_targeted, 0);
break;

case vk_right:
	if (triumvirat_i == triumvirat_max)		triumvirat_i = triumvirat_min;
	else									triumvirat_i++;
	array_resize(seekers_targeted, 0);
break;

case vk_enter:
	with (MAIN) {
		seekers = other.seekers_targeted;
		s_m.change("World");	
	}
break;
}




	

