
var xx = 32;

var l = array_length(seekers_targeted);
for (var i = 0; i < l; i++) {
	
	Display_Stats_Seeker(seekers_targeted[i], xx)
	xx += 32 + string_width("default_passive : " + string(seekers_targeted[i].default_passive.name ));
}
