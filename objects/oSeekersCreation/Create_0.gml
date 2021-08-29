seekers_to_choose	= [];
seekers_targeted	= [];

triumvirat_i		= 1;
triumvirat_min		= 1;
triumvirat_max		= 1;

// Populate seekers_to_choose
with (MAIN) {

	var height = ds_grid_height(default_seekers_stats);
	
	for (var yy = 0; yy < height; yy++) {
		
		var seeker_name = default_seekers_stats[# S_S.NAME, yy];
		var seeker		= Construct_Seeker(seeker_name);
					
		with (other) array_push(seekers_to_choose, seeker);
	}
}


Display_Stats_Seeker = function(unit_targeted, xx) {
	
	draw_set_halign(fa_left);
	var shift_y		= font_get_size(fDefault) * 3;
	var yy			= 0;
	var i			= 0;
	
	with (unit_targeted) {
	draw_text(xx, yy + shift_y * i++, "name : "						+ string(name 				));
	draw_text(xx, yy + shift_y * i++, "class : "					+ string(class 				));
	draw_text(xx, yy + shift_y * i++, "triumvirat : "				+ string(triumvirat 			));
	draw_text(xx, yy + shift_y * i++, "confidence : "				+ string(confidence 			));
	draw_text(xx, yy + shift_y * i++, "presence : "					+ string(presence				));
	draw_text(xx, yy + shift_y * i++, "shield : "					+ string(shield				));
	draw_text(xx, yy + shift_y * i++, "aura : "						+ string(aura					));
	draw_text(xx, yy + shift_y * i++, "unspeakable : "				+ string(unspeakable 			));
	draw_text(xx, yy + shift_y * i++, "hope : "						+ string(hope 				));
	draw_text(xx, yy + shift_y * i++, "default_passive : "			+ string(default_passive.name ));
	if (passive_1 == noone)
	draw_text(xx, yy + shift_y * i++, "passive_1 : noone ");
	else 
	draw_text(xx, yy + shift_y * i++, "passive_1 : "				+ string(passive_1.name 		));
	if (passive_2	== noone)
	draw_text(xx, yy + shift_y * i++, "passive_2 : noone ");	
	else 
	draw_text(xx, yy + shift_y * i++, "passive_2 : "				+ string(passive_2.name 		));
	draw_text(xx, yy + shift_y * i++, "default_weapon : "			+ string(weapon.name 			));
										 			  
	}									 					
}