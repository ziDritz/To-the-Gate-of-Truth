if debug_mode	show_debug_overlay(true);
else			show_debug_overlay(false);

seekers = [];

#region		Loading and Converting Data

//Load data into a grid 
//Enum to access columns
//Empty cells = -1
//Cells containing numbers as string are converted into reals

#region		Default Passives' Stats

default_passives_stats = Csv_To_Grid("Passives.csv", true, "$");

enum P_S {
	NAME, DESCRIPTION_FR, DESCRIPTION_ENG, WHEN, ACTOR_CONDITION, RANGE_RESTRICTION, WHAT, AMOUNT,  ON_WHO_WHAT,  ZONE, 
	CONTEXT
}

for (var yy = 1; yy < ds_grid_height(default_passives_stats); yy++) {
for (var xx = 0; xx < ds_grid_width(default_passives_stats); xx++) {
	var cell_selected	= default_passives_stats[# xx, yy]
	if (cell_selected == "")						
		cell_selected = -1;
	else {
		switch (xx) {
		case P_S.AMOUNT:					cell_selected = real(cell_selected);	break;
		}
	}
	default_passives_stats[# xx, yy] = cell_selected;
}}

#endregion

#region		Default Weapons Stats

default_weapons_stats = Csv_To_Grid("Weapons.csv", true, "$");

enum W_S {
	NAME, DESCRIPTION_ENG, DAMAGE, ATTRIBUT, RANGE, RANGE_RESTRICTION, PASSIVE_1, PASSIVE_2, ZONE, CONTEXT
}

for (var yy = 1; yy < ds_grid_height(default_weapons_stats); yy++) {
for (var xx = 0; xx < ds_grid_width(default_weapons_stats); xx++) {
	cell_selected	= default_weapons_stats[# xx, yy]
	if (cell_selected == "")						
		cell_selected = -1;
	else {
		switch (xx) {
		case W_S.DAMAGE:				cell_selected = real(cell_selected);	break;
		}
	}
	default_weapons_stats[# xx, yy] = cell_selected;
}}
#endregion

#region		Default Seekers' Stats

default_seekers_stats = Csv_To_Grid("Seekers.csv", true, "$");

enum S_S {
	NAME, TRIUMVIRAT, CLASS, CONFIDENCE, PRESENCE, AURA, UNSPEAKABLE, DEFAULT_PASSIVE, PASSIVE_1, PASSIVE_2, DEFAULT_WEAPON
}

for (var yy = 1; yy < ds_grid_height(default_seekers_stats); yy++) {
for (var xx = 0; xx < ds_grid_width(default_seekers_stats); xx++) {
	cell_selected = default_seekers_stats[# xx, yy];
	if (cell_selected == "")						
		cell_selected = -1;
	else {
		switch (xx) {
		case S_S.TRIUMVIRAT:	cell_selected = real(cell_selected);	break;
		case S_S.CONFIDENCE:	cell_selected = real(cell_selected);	break;
		case S_S.PRESENCE:		cell_selected = real(cell_selected);	break;
		case S_S.AURA:			cell_selected = real(cell_selected);	break;
		case S_S.UNSPEAKABLE:	cell_selected = real(cell_selected);	break;
		}
	}
	default_seekers_stats[# xx, yy] = cell_selected;
}}
	

#endregion

#region		Default Enemies' Stats

default_enemies_stats = Csv_To_Grid("Enemies.csv", true, "$");

enum E_S {
	NAME, DESCRIPTION_FR, DESCRIPTION_ENG, TYPE, HEALTH, ATTACK_DAMAGE, ATTACK_RANGE, ACTIVE, PASSIVE_1, PASSIVE_2, DEFAULT_BEHAVIOR, ZONE
}

for (var yy = 1; yy < ds_grid_height(default_enemies_stats); yy++) {
	for (var xx = 0; xx < ds_grid_width(default_enemies_stats); xx++) {
		cell_selected	= default_enemies_stats[# xx, yy];
		if (cell_selected == "")						
			cell_selected = -1;
		else {
			switch (xx) {
			case E_S.HEALTH:			cell_selected = real(cell_selected);	break;
			case E_S.ATTACK_DAMAGE:		cell_selected = real(cell_selected);	break;
			}
		}
		default_enemies_stats[# xx, yy] = cell_selected;
}}
	
#endregion

#endregion

#region		Constructors

//Construct_X :
//X set to noone by default
//find X's stats with his name (loop in column name)
//use constructor with default stats (row)

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

Construct_Passive = function(passive_name) {

	if (passive_name == -1) return noone;
												
	for (var yy = 0; yy < ds_grid_height(default_passives_stats); yy++)	{
		if (default_passives_stats[# P_S.NAME, yy] == passive_name)	{
			var passive = new Passive (
				noone,
			
				default_passives_stats[# P_S.NAME				, yy],
				default_passives_stats[# P_S.DESCRIPTION_FR		, yy],
				default_passives_stats[# P_S.DESCRIPTION_ENG	, yy],
				default_passives_stats[# P_S.ACTOR_CONDITION	, yy],
				default_passives_stats[# P_S.WHAT				, yy],
				default_passives_stats[# P_S.AMOUNT				, yy],
				default_passives_stats[# P_S.WHEN				, yy],
				default_passives_stats[# P_S.ON_WHO_WHAT		, yy],
				default_passives_stats[# P_S.RANGE_RESTRICTION	, yy],
				default_passives_stats[# P_S.ZONE				, yy],
				default_passives_stats[# P_S.CONTEXT			, yy],
			);	 
			return	passive;
			break;
		}
	}

}

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
	
	Display_Stats = function() {
	
		var shift_y		= font_get_size(fDefault) * 3;
		var xx			= display_get_gui_width() - 32;
		var yy			= 0;
		draw_set_halign(fa_right);
		
		var i = 0;
		
		draw_text(xx, yy + shift_y * i++, string(name 				) + " : name");
		draw_text(xx, yy + shift_y * i++, string(damage 			) + " : damage");
		draw_text(xx, yy + shift_y * i++, string(attribut 			) + " : attribut");
		draw_text(xx, yy + shift_y * i++, string(range				) + " : range");
		draw_text(xx, yy + shift_y * i++, string(range_restriction	) +	" : range_restriction");
		if (passive_1 != noone)
		draw_text(xx, yy + shift_y * i++, string(passive_1.name		) + " : passive_1");
		else 
		draw_text(xx, yy + shift_y * i++,							"noone : passive_1");
		if (passive_2 != noone)
		draw_text(xx, yy + shift_y * i++, string(passive_2.name		) + " : passive_2");
		else 
		draw_text(xx, yy + shift_y * i++,							 "noone : passive_2");
		draw_text(xx, yy + shift_y * i++, string(zone 				) + " : zone");
		draw_text(xx, yy + shift_y * i++, string(context 			) + " : context");
																						  		
		draw_text(xx, yy + shift_y * i++, string(sprite				) + " : sprite");
		draw_text(xx, yy + shift_y * i++, string(image_index		) + " : image_index");
	}
}
	
Construct_Weapon = function(weapon_name) {
	
	if (weapon_name == -1) return noone;
											
	for (var yy = 0; yy < ds_grid_height(default_weapons_stats); yy++)	{
		if (default_weapons_stats[# W_S.NAME, yy] == weapon_name)	{
			
			var passive_1 = Construct_Passive(default_weapons_stats[# W_S.PASSIVE_1	, yy])
			var passive_2 = Construct_Passive(default_weapons_stats[# W_S.PASSIVE_2	, yy])
			
			var weapon = new Weapon (
				noone,
			
				default_weapons_stats[# W_S.NAME				, yy],
				default_weapons_stats[# W_S.DESCRIPTION_ENG		, yy],
				default_weapons_stats[# W_S.DAMAGE				, yy],
				default_weapons_stats[# W_S.ATTRIBUT			, yy],
				default_weapons_stats[# W_S.RANGE				, yy],
				default_weapons_stats[# W_S.RANGE_RESTRICTION	, yy],
				passive_1,
				passive_2,
				default_weapons_stats[# W_S.ZONE				, yy],
				default_weapons_stats[# W_S.CONTEXT				, yy],
				
				-1,
				-1
			);	 
			return	weapon;
			break;
		}	
	}
}
			
Seeker = function () constructor {
	var i = 0;
	
	name				= argument[i++];
	triumvirat 			= argument[i++];
	class 				= argument[i++];
	confidence 			= argument[i++];	
	shield				= argument[i++];	
	presence			= argument[i++];	
	aura				= argument[i++];
	unspeakable 		= argument[i++];	
	hope 				= argument[i++];
	default_passive 	= argument[i++];	
	passive_1 			= argument[i++];	
	passive_2 			= argument[i++];
	weapon				= argument[i++];
	
	tile				= argument[i++];
	side				= argument[i++];
	action_count		= argument[i++];
	attack_count		= argument[i++];	
	
	sprite_index		= argument[i++];
	image_index			= argument[i++];
	x					= argument[i++];
	y					= argument[i++];
	
	fight_menu = [{
		displayed_text : "Move",
		action : "MOVE"
	},
	{
		displayed_text : "Attack",
		action: "ATTACK"
	}];
		
	doAction			= function(action){DM("coucou les actions"); DM(action);}
	Display_Stats		= function() {
	
		draw_set_halign(fa_left);
		var shift_y			= font_get_size(fDefault) * 3;
		var xx				= 32;
		var yy				= 0;
		var i				= 0;
		
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
											 			  
											 			  
		if (tile != noone) {	 			  
		draw_text(xx, yy + shift_y * i++, "tile : "						+ string(tile.name				));
		}										 			  
		draw_text(xx, yy + shift_y * i++, "side : "						+ string(side					));
		draw_text(xx, yy + shift_y * i++, "action_count : "				+ string(action_count			));
		draw_text(xx, yy + shift_y * i++, "attack_count : "				+ string(attack_count			));
	}
		
	s_m					= new SnowState("Idle");
	
	s_m
		.event_set_default_function("Draw_Self", function() { 
			draw_sprite(sprite_index, image_index, x, y)
		})
		.add("Idle")
		.add("Choosing Action", {
			enter: function () {
				
				}
		})
		.add("Preparing Action")
		.add("Doing Action"); 
		
}
	
Construct_Seeker = function(seeker_name) {
	
	if (seeker_name == -1)	return noone;		
	
	for (var yy = 0; yy < ds_grid_height(default_seekers_stats); yy++)	{
		if (default_seekers_stats[# W_S.NAME, yy] == seeker_name)	{
			
			var default_passive = Construct_Passive(default_seekers_stats[# S_S.DEFAULT_PASSIVE, yy]);
			var default_weapon	= Construct_Weapon(default_seekers_stats[# S_S.DEFAULT_WEAPON, yy]);
			
			var seeker = new Seeker (
			
				default_seekers_stats[# S_S.NAME				, yy],				
				default_seekers_stats[# S_S.TRIUMVIRAT				, yy],
				default_seekers_stats[# S_S.CLASS				, yy],				
				default_seekers_stats[# S_S.CONFIDENCE				, yy],
				0,
				default_seekers_stats[# S_S.PRESENCE				, yy],
				default_seekers_stats[# S_S.AURA				, yy],
				default_seekers_stats[# S_S.UNSPEAKABLE				, yy],
				0,
				default_passive,
				noone,
				noone,
				default_weapon,
									
				noone,				
				"Players",				
				2,		
				1,		
				
				spSeeker,				
				0,		
				0,
				0
			);	 
			return seeker;
			break;
		}
	}
	
	
}
	
Enemy = function () constructor {
	var i = 0;
	
	name				= argument[i++];
	description_fr		= argument[i++];	
	description_eng		= argument[i++];
	type				= argument[i++];
	hp					= argument[i++];
	shield				= argument[i++];
	attack_damage		= argument[i++];	
	attack_range		= argument[i++];
	active				= argument[i++];	
	passive_1			= argument[i++];	
	passive_2			= argument[i++];	
	default_behavior	= argument[i++];
	zone				= argument[i++];
					 		   
	tile				= argument[i++];
	side				= argument[i++];
	action_count		= argument[i++];
	attack_count		= argument[i++];
	
	sprite_index		= argument[i++];
	image_index			= argument[i++];
	x					= argument[i++];
	y					= argument[i++];
	

	Display_Stats		= function() {
	
		draw_set_halign(fa_left);
		var shift_y			= font_get_size(fDefault) * 3;
		var xx				= 32;
		var yy				= 0;
		var i				= 0;
	
		draw_text(xx, yy + shift_y * i++, "name : "					+ string(name			));
		draw_text(xx, yy + shift_y * i++, "type : "					+ string(type			));
		draw_text(xx, yy + shift_y * i++, "hp : "					+ string(hp			));
		draw_text(xx, yy + shift_y * i++, "attack_damage : "		+ string(attack_damage	));
		draw_text(xx, yy + shift_y * i++, "attack_range : "			+ string(attack_range	));
		draw_text(xx, yy + shift_y * i++, "active : "				+ string(active			));
		draw_text(xx, yy + shift_y * i++, "passive_1 : "			+ string(passive_1		));
		draw_text(xx, yy + shift_y * i++, "passive_2 : "			+ string(passive_2		));
		draw_text(xx, yy + shift_y * i++, "default_behavior : "		+ string(default_behavior));
		draw_text(xx, yy + shift_y * i++, "zone : "					+ string(zone			));
			
		if (tile != noone) {
			draw_text(xx, yy + shift_y * i++, "tile : "			+ string(tile.name	));
		}
		draw_text(xx, yy + shift_y * i++, "side : "				+ string(side				));
		draw_text(xx, yy + shift_y * i++, "action_count : "		+ string(action_count		));
		draw_text(xx, yy + shift_y * i++, "attack_count : "		+ string(attack_count		));
		
	}	
	
	s_m					= new SnowState("Idle");
	
	s_m
		.event_set_default_function("Draw_Self", function() { 
			draw_sprite(sprite_index, image_index, x, y)
		})
		.add("Idle", {
			enter: function () {
				DM("Entering Idle");
			}
		})
		.add("Choosing Action", {
			enter: function () {
			
				},
			
			Draw_Menu: function () {
				DM("Displaying action to choose from");	
			}
		})
		.add("Preparing Action")
		.add("Doing Action"); 
	
}

Construct_Enemy = function(enemy_name) {
	
	if (enemy_name == -1)	return noone;
									
	for (var yy = 0; yy < ds_grid_height(default_enemies_stats); yy++)	{
		if (default_enemies_stats[# W_S.NAME, yy] == enemy_name)	{
			
			var passive_1 = Construct_Passive(default_enemies_stats[# E_S.PASSIVE_1, yy]);
			var passive_2 = Construct_Passive(default_enemies_stats[# E_S.PASSIVE_2, yy]);
			
			var enemy = new Enemy (

				default_enemies_stats[# E_S.NAME				, yy],				
				default_enemies_stats[# E_S.DESCRIPTION_FR		, yy],
				default_enemies_stats[# E_S.DESCRIPTION_ENG		, yy],				
				default_enemies_stats[# E_S.TYPE				, yy],
				default_enemies_stats[# E_S.HEALTH				, yy],
				0,
				default_enemies_stats[# E_S.ATTACK_DAMAGE		, yy],
				default_enemies_stats[# E_S.ATTACK_RANGE		, yy],
				default_enemies_stats[# E_S.ACTIVE				, yy],
				passive_1,
				passive_2,
				default_enemies_stats[# E_S.DEFAULT_BEHAVIOR	, yy],
				default_enemies_stats[# E_S.ZONE				, yy],
									
				noone,				
				"GM",				
				2,		
				1,		
				
				spEny,				
				0,		
				0,
				0
			);	 
			return	enemy;
			break;
		}
	}
}

#endregion

#region		State Machine 

s_m = new SnowState("Main Menu");

s_m
	.add("Main Menu", {
		enter: function() {
			room_goto(rMainMenu);
		}
	})
	.add("Seekers Creation", {
		enter: function() {
			room_goto(rSeekersCreation);
		}
	})
	.add("World", {
		enter: function() {
			room_goto(rWorld);
		}
	})
	.add("Fight", {
		enter: function() {
			room_goto(rFight);
		}
	});

#endregion
