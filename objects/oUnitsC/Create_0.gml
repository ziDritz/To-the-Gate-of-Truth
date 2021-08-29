/// @desc oUnitsController


seekers				= [];
array_copy(seekers, 0, oSeekerCreator.seekers, 0, array_length(oSeekerCreator.seekers));
enemies				= [];
array_copy(enemies, 0, oSeekerCreator.enemies, 0, array_length(oSeekerCreator.enemies));

seekers_on_board	= [];
keys_on_board		= [];
enemies_on_board	= [];
units_on_board		= [];

unit_riposting		= noone;



Draw_Units = function(unit_array) {
	for (var i = 0; i < array_length(unit_array); i++) {
		var unit_selected = unit_array[i];
		with (unit_selected) {
			draw	= TilePosToScreen(tile.grid_x, tile.grid_y);
			draw_x	= draw[0]; 
			draw_y	= draw[1]; 
			draw_sprite(sprite, 0, draw_x, draw_y);
		}
	}
}


Display_Stats_Seeker = function(unit_targeted) {
	
	draw_set_halign(fa_left);
	var shift_y			= font_get_size(fDefault) * 3;
	var show_stats_x	= 32;
	var show_stats_y	= 0;
	var i				= 0;

	draw_text(show_stats_x, show_stats_y + shift_y * i++, "name : "						+ string(unit_targeted.name 				));
	draw_text(show_stats_x, show_stats_y + shift_y * i++, "class : "					+ string(unit_targeted.class 				));
	draw_text(show_stats_x, show_stats_y + shift_y * i++, "triumvirat : "				+ string(unit_targeted.triumvirat 			));
	draw_text(show_stats_x, show_stats_y + shift_y * i++, "confidence : "				+ string(unit_targeted.confidence 			));
	draw_text(show_stats_x, show_stats_y + shift_y * i++, "presence : "					+ string(unit_targeted.presence				));
	draw_text(show_stats_x, show_stats_y + shift_y * i++, "shield : "					+ string(unit_targeted.shield				));
	draw_text(show_stats_x, show_stats_y + shift_y * i++, "aura : "						+ string(unit_targeted.aura					));
	draw_text(show_stats_x, show_stats_y + shift_y * i++, "unspeakable : "				+ string(unit_targeted.unspeakable 			));
	draw_text(show_stats_x, show_stats_y + shift_y * i++, "hope : "						+ string(unit_targeted.hope 				));
	draw_text(show_stats_x, show_stats_y + shift_y * i++, "default_passive : "			+ string(unit_targeted.default_passive.name ));
	//if (unit_targeted.passive_1 != noone)
	//draw_text(show_stats_x, show_stats_y + shift_y * i++, "passive_1 : "				+ string(unit_targeted.passive_1.name 		));
	//if (unit_targeted.passive_2 != noone)
	//draw_text(show_stats_x, show_stats_y + shift_y * i++, "passive_2 : "				+ string(unit_targeted.passive_2.name 		));
	draw_text(show_stats_x, show_stats_y + shift_y * i++, "default_weapon : "			+ string(unit_targeted.weapon.name 			));
										 			  
										 			  
if (unit_targeted.tile != noone) {	 			  
	draw_text(show_stats_x, show_stats_y + shift_y * i++, "tile.grid_x: "				+ string(unit_targeted.tile.grid_x			));
	draw_text(show_stats_x, show_stats_y + shift_y * i++, "tile.grid_y: "				+ string(unit_targeted.tile.grid_y			));
}										 			  
	draw_text(show_stats_x, show_stats_y + shift_y * i++, "sprite : "					+ string(unit_targeted.sprite				));
	draw_text(show_stats_x, show_stats_y + shift_y * i++, "image_index : "				+ string(unit_targeted.image_index			));
	draw_text(show_stats_x, show_stats_y + shift_y * i++, "side : "						+ string(unit_targeted.side					));
	draw_text(show_stats_x, show_stats_y + shift_y * i++, "action_count : "				+ string(unit_targeted.action_count			));
	draw_text(show_stats_x, show_stats_y + shift_y * i++, "attack_count : "				+ string(unit_targeted.attack_count			));
	
}
	

Display_Stats_Weapon = function(unit_targeted) {
	
	var weapon = unit_targeted.weapon;

	
	var shift_y			= font_get_size(fDefault) * 3;
	var show_stats_x	= display_get_gui_width() - 32;
	var show_stats_y	= 0;
	draw_set_halign(fa_right);
	
	var i = 0;
	
	draw_text(show_stats_x, show_stats_y + shift_y * i++, string(weapon.name 				) + " : name");
	draw_text(show_stats_x, show_stats_y + shift_y * i++, string(weapon.description_eng 	) + " : description_eng");
	draw_text(show_stats_x, show_stats_y + shift_y * i++, string(weapon.damage 				) + " : damage");
	draw_text(show_stats_x, show_stats_y + shift_y * i++, string(weapon.attribut 			) + " : attribut");
	draw_text(show_stats_x, show_stats_y + shift_y * i++, string(weapon.range				) + " : range");
	draw_text(show_stats_x, show_stats_y + shift_y * i++, string(weapon.range_restriction	) +	" : range_restriction");
	if (weapon.passive_1 != noone)
	draw_text(show_stats_x, show_stats_y + shift_y * i++, string(weapon.passive_1.name 			) + " : passive_1");
	else 
	draw_text(show_stats_x, show_stats_y + shift_y * i++, string(weapon.passive_1) + " : passive_1");
	if (weapon.passive_2 != noone)
	draw_text(show_stats_x, show_stats_y + shift_y * i++, string(weapon.passive_2.name			) + " : passive_2");
	else 
	draw_text(show_stats_x, show_stats_y + shift_y * i++, string(weapon.passive_2) + " : passive_2");
	draw_text(show_stats_x, show_stats_y + shift_y * i++, string(weapon.zone 				) + " : zone");
	draw_text(show_stats_x, show_stats_y + shift_y * i++, string(weapon.context 			) + " : context");
																							  		
	draw_text(show_stats_x, show_stats_y + shift_y * i++, string(weapon.sprite		) + " : sprite");
	draw_text(show_stats_x, show_stats_y + shift_y * i++, string(weapon.image_index			) + " : image_index");
}
	
	
Display_Stats_Key = function(unit_targeted) {
	
	var unit_targeted_variables = variable_struct_get_names(unit_targeted);
	
	var shift_y			= font_get_size(fDefault) * 3;
	var show_stats_x	= 32;
	var show_stats_y	= display_get_gui_height();
	
	var i = array_length(unit_targeted_variables);
	
	draw_text(show_stats_x, show_stats_y - shift_y * i--, "hp : "	+ string(unit_targeted.hp	));
	draw_text(show_stats_x, show_stats_y - shift_y * i--, "sprite : "	+ string(unit_targeted.sprite	));
if (unit_targeted.tile != noone) {
	draw_text(show_stats_x, show_stats_y - shift_y * i--, "tile.grid_x: "				+ string(unit_targeted.tile.grid_x			));
	draw_text(show_stats_x, show_stats_y - shift_y * i--, "tile.grid_y: "				+ string(unit_targeted.tile.grid_y			));
}
}


Display_Stats_Eny = function(unit_targeted) {
	
	var unit_targeted_variables = variable_struct_get_names(unit_targeted);
	
	var shift_y			= font_get_size(fDefault) * 3;
	var show_stats_x	= 32;
	var show_stats_y	= display_get_gui_height();
	
	var i = array_length(unit_targeted_variables);
	
	draw_text(show_stats_x, show_stats_y - shift_y * i--, "name : "					+ string(unit_targeted.name			));
	draw_text(show_stats_x, show_stats_y - shift_y * i--, "description_fr : "		+ string(unit_targeted.description_fr	));
	draw_text(show_stats_x, show_stats_y - shift_y * i--, "description_eng : "		+ string(unit_targeted.description_eng	));
	draw_text(show_stats_x, show_stats_y - shift_y * i--, "type : "					+ string(unit_targeted.type			));
	draw_text(show_stats_x, show_stats_y - shift_y * i--, "hp : "				+ string(unit_targeted.hp			));
	draw_text(show_stats_x, show_stats_y - shift_y * i--, "attack_damage : "					+ string(unit_targeted.attack_damage	));
	draw_text(show_stats_x, show_stats_y - shift_y * i--, "attack_range : "			+ string(unit_targeted.attack_range	));
	draw_text(show_stats_x, show_stats_y - shift_y * i--, "active : "				+ string(unit_targeted.active			));
	draw_text(show_stats_x, show_stats_y - shift_y * i--, "passive_1 : "			+ string(unit_targeted.passive_1		));
	draw_text(show_stats_x, show_stats_y - shift_y * i--, "passive_2 : "					+ string(unit_targeted.passive_2		));
	draw_text(show_stats_x, show_stats_y - shift_y * i--, "default_behavior : "		+ string(unit_targeted.default_behavior));
	draw_text(show_stats_x, show_stats_y - shift_y * i--, "zone : "					+ string(unit_targeted.zone			));
	
if (unit_targeted.tile != noone) {
	draw_text(show_stats_x, show_stats_y - shift_y * i--, "tile.grid_x: "				+ string(unit_targeted.tile.grid_x	));
	draw_text(show_stats_x, show_stats_y - shift_y * i--, "tile.grid_y: "				+ string(unit_targeted.tile.grid_y	));
}
	draw_text(show_stats_x, show_stats_y - shift_y * i--, "sprite : "				+ string(unit_targeted.sprite			));
	draw_text(show_stats_x, show_stats_y - shift_y * i--, "image_index : "			+ string(unit_targeted.image_index		));
	draw_text(show_stats_x, show_stats_y - shift_y * i--, "side : "					+ string(unit_targeted.side				));
	draw_text(show_stats_x, show_stats_y - shift_y * i--, "action_count : "			+ string(unit_targeted.action_count		));
	draw_text(show_stats_x, show_stats_y - shift_y * i--, "attack_count : "			+ string(unit_targeted.attack_count		));

}
	
	
	

