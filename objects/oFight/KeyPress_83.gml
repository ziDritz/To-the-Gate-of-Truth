/// @desc	Save

current_game_state = s_m.get_current_state();

var variables_infos	= [];
var names			= variable_instance_get_names(id);
var names_count		= variable_instance_names_count(id);

for (var i = 0; i < names_count; i++) {

	var n = names[i];
	var str4_to_check = string_copy(n, 1, 4);
	var str5_to_check = string_copy(n, 1, 5);
	var str7_to_check = string_copy(n, 1, 7);
	
	if (str4_to_check	!= "tile")
	&& (str4_to_check	!= "unit")	
	&& (str5_to_check	!= "units") 
	&& (str5_to_check	!= "tiles")
	&& (str7_to_check	!= "enemies")
	&& (str7_to_check	!= "seekers")
	&& (n				!= "t")
	&& (n				!= "array_to_push")
	&& (n				!= "s_m")
	&& (n				!= "level_enemies")
	{
	
		var v	= variable_instance_get(id, names[i]);

		if (is_struct(v)) { 
			if variable_struct_exists(v, "name")	{
				DM(names[i]);
				DM(v.name);
			}
		}
		else {
			DM(names[i]);
		}

		var infos = {
			name : names[i],
			value : v
		}
		
		array_push(variables_infos, infos) 
		
	}
	
}


	var str		= json_stringify(variables_infos);
	var buffer	= buffer_create(string_byte_length(str)+1, buffer_fixed, 1);
	buffer_write(buffer, buffer_string, str);
	buffer_save(buffer, "Misc_var.save");
	buffer_delete(buffer);

	DM("Miscellaneous variables saved " + str);

