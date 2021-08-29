
Construct_Passive = function(passive_name) {
	var passive_init;
	if (passive_name == -1)
		passive_init = noone;
	else {											
		for (var yyy = 0; yyy < ds_grid_height(passives_stats); yyy++)	{
			if (passives_stats[# P_S.NAME, yyy] == passive_name)	{
				passive_init = new Passive (
					noone,
				
					passives_stats[# P_S.NAME				, yyy],
					passives_stats[# P_S.DESCRIPTION_FR		, yyy],
					passives_stats[# P_S.DESCRIPTION_ENG	, yyy],
					passives_stats[# P_S.ACTOR_CONDITION	, yyy],
					passives_stats[# P_S.WHAT				, yyy],
					passives_stats[# P_S.AMOUNT				, yyy],
					passives_stats[# P_S.WHEN				, yyy],
					passives_stats[# P_S.ON_WHO_WHAT		, yyy],
					passives_stats[# P_S.RANGE_RESTRICTION	, yyy],
					passives_stats[# P_S.ZONE				, yyy],
					passives_stats[# P_S.CONTEXT			, yyy],
				);	 
				break;
			}
		}
	}
	return	passive_init;
}



#region		Loading & Converting Passives' Stats

passives_stats = Csv_To_Grid("Passives.csv", true, "$");
enum P_S {
	NAME, DESCRIPTION_FR, DESCRIPTION_ENG, WHEN, ACTOR_CONDITION, RANGE_RESTRICTION, WHAT, AMOUNT,  ON_WHO_WHAT,  ZONE, 
	CONTEXT
}

for (var yy = 1; yy < ds_grid_height(passives_stats); yy++) {
for (var xx = 0; xx < ds_grid_width(passives_stats); xx++) {
	var cell_selected	= passives_stats[# xx, yy]
	// Si il y a des délimiteurs (";") on split la string
	if (string_pos(";", cell_selected) != 0)		cell_selected = String_Spliter(cell_selected, ";");
	// Si la case est vide on le dit
	if (cell_selected == "")						
		cell_selected = -1;
	else {
		switch (xx) {
		// csv contains strings, so we convert them into number if needed
		case P_S.AMOUNT:					cell_selected = real(cell_selected);	break;
		}
	}
	passives_stats[# xx, yy] = cell_selected;
}}

#endregion

#region		Passive Constructor

Passive = function () constructor {
	var i = 0;
	owner				= argument[i++];
						
	name				= argument[i++];
	description_fr		= argument[i++];	
	description_eng		= argument[i++];	
	actor_condition		= argument[i++];	
	what				= argument[i++];
	amount				= argument[i++];	
	when				= argument[i++];
	on_who_what			= argument[i++];	
	range_restriction	= argument[i++];	
	zone				= argument[i++];
	context				= argument[i++];	
};

#endregion


#region		Loading & Converting Default Weapons Stats

weapons_stats = Csv_To_Grid("Weapons.csv", true, "$");
enum W_S {
	NAME, DESCRIPTION_ENG, DAMAGE, ATTRIBUT, RANGE, RANGE_RESTRICTION, 
	PASSIVE_1, PASSIVE_2, ZONE, CONTEXT
}

for (var yy = 1; yy < ds_grid_height(weapons_stats); yy++) {
for (var xx = 0; xx < ds_grid_width(weapons_stats); xx++) {
	cell_selected	= weapons_stats[# xx, yy]
	// Si il y a des délimiteurs (";") on split la string
	if (string_pos(";", cell_selected) != 0)		cell_selected = String_Spliter(cell_selected, ";");
	if (cell_selected == "")						
		cell_selected = -1;
	else {
	switch (xx) {
			// csv contains strings, so we convert them into number if needed
			case W_S.DAMAGE:				cell_selected = real(cell_selected);	break;
		}
	}
	weapons_stats[# xx, yy] = cell_selected;
}}
#endregion

#region		Weapons Constructor

Weapon = function () constructor {
	var i = 0;
	
	owner				= argument[i++];	
			
	name				= argument[i++];
	description_eng 	= argument[i++];
	damage 				= argument[i++];	
	attribut 			= argument[i++];	
	range				= argument[i++];	
	range_restriction	= argument[i++];	
	passive_1 			= argument[i++];	
	passive_2			= argument[i++];	
	zone 				= argument[i++];	
	context 			= argument[i++];
					
	sprite				= argument[i++];	
	image_index			= argument[i++];	
}

#endregion


#region		Loading & Converting Seekers' Stats

seekers_stats_init = Csv_To_Grid("Seekers.csv", true, "$");
enum S_S {
	NAME, CLASS, TRIUMVIRAT, CONFIDENCE, PRESENCE, AURA, UNSPEAKABLE, DEFAULT_PASSIVE, PASSIVE_1, PASSIVE_2, DEFAULT_WEAPON
}


for (var yy = 1; yy < ds_grid_height(seekers_stats_init); yy++) {
for (var xx = 0; xx < ds_grid_width(seekers_stats_init); xx++) {
	cell_selected = seekers_stats_init[# xx, yy];
	// Si il y a des délimiteurs (";") on split la string
	if (string_pos(";", cell_selected) != 0)		cell_selected = String_Spliter(cell_selected, ";");
	// Si la case est vide on le dit
	if (cell_selected == "")						
		cell_selected = -1;
	else {
		switch (xx) {
		// csv contains strings, so we convert them into number if needed
		case S_S.TRIUMVIRAT:	cell_selected = real(cell_selected);	break;
		case S_S.CONFIDENCE:	cell_selected = real(cell_selected);	break;
		case S_S.PRESENCE:		cell_selected = real(cell_selected);	break;
		case S_S.AURA:			cell_selected = real(cell_selected);	break;
		case S_S.UNSPEAKABLE:	cell_selected = real(cell_selected);	break;
		}
	}
	seekers_stats_init[# xx, yy] = cell_selected;
}}
	

#endregion

#region		Seekers Creation

seekers = [];

for (var yy = 0; yy < ds_grid_height(seekers_stats_init); yy++) {
	if (seekers_stats_init[# S_S.TRIUMVIRAT, yy] == 1) {	// Triumvirat has to be choosen by players
		
		
		#region seeker default weapon
		
		var weapon_to_find			= seekers_stats_init[# S_S.DEFAULT_WEAPON, yy];
		if (weapon_to_find == -1)
			weapon_init = noone;
		else {
			for (var yyy = 0; yyy < ds_grid_height(weapons_stats); yyy++)	{
				if (weapons_stats[# W_S.NAME, yyy] = weapon_to_find)	{
					
					var w_passive_1_name = weapons_stats[# W_S.PASSIVE_1, yyy];
					var w_passive_1_init = Construct_Passive(w_passive_1_name);
					
					var w_passive_2_name = weapons_stats[# W_S.PASSIVE_2, yyy];
					var w_passive_2_init = Construct_Passive(w_passive_2_name);
					
					var weapon_init = new Weapon (
						noone,
						
						weapons_stats[# W_S.NAME				, yyy],
						weapons_stats[# W_S.DESCRIPTION_ENG		, yyy],
						weapons_stats[# W_S.DAMAGE				, yyy],
						weapons_stats[# W_S.ATTRIBUT			, yyy],
						weapons_stats[# W_S.RANGE				, yyy],
						weapons_stats[# W_S.RANGE_RESTRICTION	, yyy],
						w_passive_1_init,									 
						w_passive_2_init,									 
						weapons_stats[# W_S.ZONE				, yyy],
						weapons_stats[# W_S.CONTEXT				, yyy],
							
						-1,
						-1,
					);
					break;
				}
			}
		}
		
		#endregion
		
		var default_passive_name = seekers_stats_init[# S_S.DEFAULT_PASSIVE, yy];
		var default_passive_init = Construct_Passive(default_passive_name);

		
		var seeker_init = {
			name					: seekers_stats_init[# S_S.NAME,			yy],
			class 					: seekers_stats_init[# S_S.CLASS,			yy],
			triumvirat 				: seekers_stats_init[# S_S.TRIUMVIRAT,		yy],
/* Health */confidence 				: seekers_stats_init[# S_S.CONFIDENCE,		yy],
			shield					: 0,
			presence				: seekers_stats_init[# S_S.PRESENCE,		yy],
			aura					: seekers_stats_init[# S_S.AURA,			yy],
			unspeakable 			: seekers_stats_init[# S_S.UNSPEAKABLE,		yy],
			hope 					: 0,
			default_passive 		: default_passive_init,//function
			passive_1 				: noone,
			passive_2 				: noone,
			weapon					: weapon_init,			
			
			tile					: noone,
			sprite					: spSeeker,
			image_index				: 0,
			side					: 0,	// side player
			action_count			: 2,
			attack_count			: 1
		}
		
		if (seeker_init.weapon != noone)			seeker_init.weapon.owner				= seeker_init;
		if (seeker_init.weapon.passive_1 != noone)	seeker_init.weapon.passive_1.owner		= seeker_init;
		if (seeker_init.weapon.passive_2 != noone)	seeker_init.weapon.passive_2.owner		= seeker_init;
		if (seeker_init.default_passive != noone)	seeker_init.default_passive.owner		= seeker_init;
		
		array_push(seekers, seeker_init);
	}
}

#endregion


// To change : Enies has to be load before during world loading
#region		Loading & Converting Enemies' Stats

enemies_stats = Csv_To_Grid("Enemies.csv", true, "$");
enum E_S {
	NAME, DESCRIPTION_FR, DESCRIPTION_ENG, TYPE, HEALTH, ATTACK_DAMAGE, ATTACK_RANGE, 
	ACTIVE, PASSIVE_1, PASSIVE_2, DEFAULT_BEHAVIOR, ZONE
}


for (var yy = 1; yy < ds_grid_height(enemies_stats); yy++) {
	for (var xx = 0; xx < ds_grid_width(enemies_stats); xx++) {
		cell_selected	= enemies_stats[# xx, yy];
		// Si il y a des délimiteurs (";") on split la string
		if (string_pos(";", cell_selected) != 0)		cell_selected = String_Spliter(cell_selected, ";");
		// Si la case est vide on le dit
		if (cell_selected == "")						
			cell_selected = -1;
		else {
			switch (xx) {
			// csv contains strings, so we convert them into number if needed
			case E_S.HEALTH:			cell_selected = real(cell_selected);	break;
			case E_S.ATTACK_DAMAGE:		cell_selected = real(cell_selected);	break;
			}
		}
		enemies_stats[# xx, yy] = cell_selected;
}}
	

#endregion


#region		Enemies Constructor

enemies = []

Ennemy = function () constructor {
	var i = 0;
	
	name				= argument[i++];
	description_fr		= argument[i++];	
	description_eng		= argument[i++];
	type				= argument[i++];
	hp					= argument[i++];	
	attack_damage		= argument[i++];	
	attack_range		= argument[i++];
	active				= argument[i++];	
	passive_1			= argument[i++];	
	passive_2			= argument[i++];	
	default_behavior	= argument[i++];
	zone				= argument[i++];
					 		   
	tile				= argument[i++];
	sprite				= argument[i++];	
	image_index			= argument[i++];
	side				= argument[i++];
	action_count		= argument[i++];
	attack_count		= argument[i++];
}




for (var yy = 0; yy < ds_grid_height(enemies_stats); yy++) {
	if (enemies_stats[# E_S.ZONE, yy] == "A (ress & buff)") {	
		var eny_init = new Ennemy (
			enemies_stats[# E_S.NAME				, yy],
			enemies_stats[# E_S.DESCRIPTION_FR		, yy],
			enemies_stats[# E_S.DESCRIPTION_ENG		, yy],
			enemies_stats[# E_S.TYPE				, yy],
			enemies_stats[# E_S.HEALTH				, yy],
			enemies_stats[# E_S.ATTACK_DAMAGE		, yy],
			enemies_stats[# E_S.ATTACK_RANGE		, yy],
			enemies_stats[# E_S.ACTIVE				, yy],
			enemies_stats[# E_S.PASSIVE_1			, yy],
			enemies_stats[# E_S.PASSIVE_2			, yy],
			enemies_stats[# E_S.DEFAULT_BEHAVIOR	, yy],
			enemies_stats[# E_S.ZONE				, yy],//function
			
			noone,
			spEny,
			0,
			1,	// side eny
			2,
			1
		)
		array_push(enemies, eny_init);
	}
}
#endregion


