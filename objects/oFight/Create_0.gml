s_m = new SnowState("Init")

s_m
.event_set_default_function("Draw_Tiles", function() {
		
	if (array_length(tiles) > 0) {
		// Draw Tiles
		with (t)	Draw_Self();
		
		// Draw Cursor
		if (t == tile_mouse) && (tile_mouse != noone)		
			draw_sprite(spCursor, 0, tile_mouse.x, tile_mouse.y);	
	}	
})
	
.event_set_default_function("Get_Tile_Mouse", function() {
		
	if (variable_instance_exists(id, "Get_Tile_Mouse")) {
		Get_Tile_Mouse();
	}
	
})

.event_set_default_function("GUI", function() {
		
	draw_set_halign(fa_left);
	draw_text(display_get_gui_width() / 2, 0, s_m.get_current_state());
	
})
	
.event_set_default_function("Draw", function() {})

.add("Init", {
	enter: function () {
		
		#region	Tiles

		#region Variables
		
		#macro isom_width	sprite_get_width(spIsomRef)
		#macro isom_height	sprite_get_height(spIsomRef)
		
		grid_x			= 0;
		grid_y			= 0;
		free_grid_x		= 0;
		free_grid_y		= 0;
		screen_x		= 0;
		screen_y		= 0;
		tile_mouse		= noone;
		t				= noone;
		
		#endregion
		
		#region	Methods
		
		//Screen_To_Tile_Pos = function(xx, yy){
		
		//	free_grid_x = floor((xx / isom_width) + (yy / isom_height));
		//	free_grid_y = floor((yy / isom_height) - (xx / isom_width));
		//	//Empêche les coordonnées de sortir de la grille (on pourra pas avoir grid_x = 12 si on a que 8 collones)
		//	grid_x = clamp(free_grid_x, 0, columns-1);
		//	grid_y = clamp(free_grid_y, 0, rows-1);
		
		//}
		
		Set_Tile_Pos_To_Screen = function(xx, yy){
			
			screen_x = (xx - yy) * (isom_width / 2);
			screen_y = (xx + yy) * (isom_height / 2);
		
		}

			
		Get_Tile_Mouse = function() {
			
			var _mouse_free_grid_x = floor((mouse_x / isom_width) + (mouse_y / isom_height));
			var _mouse_free_grid_y = floor((mouse_y / isom_height) - (mouse_x / isom_width));
			//Empêche les coordonnées de sortir de la grille (on pourra pas avoir grid_x = 12 si on a que 8 collones)
			var _mouse_grid_x = clamp(_mouse_free_grid_x, 0, columns-1);
			var _mouse_grid_y = clamp(_mouse_free_grid_y, 0, rows-1);
			
			tile_mouse				= tiles[_mouse_grid_x][_mouse_grid_y];

		}
		
		#endregion
			
		#region Conditions
						
		Pointing_Board = function() {
			if	(grid_x == free_grid_x) 
			&&	(grid_y == free_grid_y)
				return true;
			else
				return false;
		}
		
		Clicking_On_Tile = function() { 	
			if	mouse_check_button_pressed(mb_left)
			&&	Pointing_Board()
				return true;
			else
				return false;
		}
			
		#endregion
		
		#region Tiles init
		
		columns			= 8;
		rows			= 4;
		tiles			= array_create(columns, array_create(rows, noone));
		tiles_ally		= [];
		tiles_enemy		= [];
		
		
		for (var yy = 0; yy < rows;		yy++) {
		for (var xx = 0; xx < columns;	xx++) {
			
			// x,y
			Set_Tile_Pos_To_Screen(xx, yy);
		
			// Range
			var range_init = -1;
			switch (xx) {
			case 0:				range_init	= "Far";	break;
			case 1: case 2:		range_init	= "Near";	break;
			case 3:				range_init	= "Close";	break;
			case 4:				range_init	= "Close";	break;
			case 5: case 6:		range_init	= "Near";	break;
			case 7:				range_init	= "Far";	break;
			}
		
			if (xx <= 3)		var side_init	= "Players";
			if (xx > 3)			var side_init	= "GM";
			
			// Sprite
			if	(side_init	== "Players")	var img_i = 1;	
			if  (side_init	== "GM")		var img_i = 2;
			
			// Instanciation
			var tile_init = {
				name			: string(xx) + ", " + string(yy),
				
				grid_x			: xx,
				grid_y			: yy, 
				range			: range_init,
				side			: side_init,
				unit			: noone,
				
				// For actions
				parent		: noone,
				passable	: true,
				neigbours	: [],
				distance	: -1,
				
				sprite_index		: spTile,
				image_index			: img_i,
				x					: screen_x,
				y					: screen_y,
									
				Draw_Self			: function() {
					draw_sprite(sprite_index, image_index, x, y)
				}				
				
			};
			if (tile_init.side == "Players")	array_push(tiles_ally,	tile_init);
			if (tile_init.side == "GM")			array_push(tiles_enemy, tile_init);
			
			tiles[xx][yy] = tile_init;
		}}
		
		
		// Tiles' neigbours
		for (var yy = 0; yy < rows;		yy++) {
		for (var xx = 0; xx < columns;	xx++) {
			
			var tile = tiles[xx][yy];
			if (xx+1 < columns) {
				var tile_neigbour = tiles[xx+1][yy];
				array_push(tile.neigbours, tile_neigbour);
			} 
		
			
			if (xx-1 >= 0) {
				tile_neigbour = tiles[xx-1][yy];
				array_push(tile.neigbours, tile_neigbour);
			} 
		
			
			if (yy+1 < rows) {
				tile_neigbour = tiles[xx][yy + 1];
				array_push(tile.neigbours, tile_neigbour);
			} 
			
			if (yy-1 > 0) {
				tile_neigbour = tiles[xx][yy - 1];
				array_push(tile.neigbours, tile_neigbour);
			} 
		}}
			
		#endregion
				
		#endregion
		
		#region	Units
			
		#region Variables
		
		level_enemies		= [];
		
		#endregion
		
		#region	Methods
					
		Display_Stats_Eny = function(unit_targeted) {
	
			var shift_y			= font_get_size(fDefault) * 3;
			var xx	= 32;
			var yy	= display_get_gui_height();
			
			var i = 0;
			
			with (unit_targeted) {
				draw_text(xx, yy - shift_y * i++, "name : "					+ string(name			));
				draw_text(xx, yy - shift_y * i++, "description_fr : "		+ string(description_fr	));
				draw_text(xx, yy - shift_y * i++, "description_eng : "		+ string(description_eng	));
				draw_text(xx, yy - shift_y * i++, "type : "					+ string(type			));
				draw_text(xx, yy - shift_y * i++, "hp : "				+ string(hp			));
				draw_text(xx, yy - shift_y * i++, "attack_damage : "					+ string(attack_damage	));
				draw_text(xx, yy - shift_y * i++, "attack_range : "			+ string(attack_range	));
				draw_text(xx, yy - shift_y * i++, "active : "				+ string(active			));
				draw_text(xx, yy - shift_y * i++, "passive_1 : "			+ string(passive_1		));
				draw_text(xx, yy - shift_y * i++, "passive_2 : "					+ string(passive_2		));
				draw_text(xx, yy - shift_y * i++, "default_behavior : "		+ string(default_behavior));
				draw_text(xx, yy - shift_y * i++, "zone : "					+ string(zone			));
																  
				if (tile != noone) {				  
				draw_text(xx, yy - shift_y * i++, "tile.grid_x: "				+ string(tile.grid_x	));
				draw_text(xx, yy - shift_y * i++, "tile.grid_y: "				+ string(tile.grid_y	));
				}												  
				draw_text(xx, yy - shift_y * i++, "sprite : "				+ string(sprite			));
				draw_text(xx, yy - shift_y * i++, "image_index : "			+ string(image_index		));
				draw_text(xx, yy - shift_y * i++, "side : "					+ string(side				));
				draw_text(xx, yy - shift_y * i++, "action_count : "			+ string(action_count		));
				draw_text(xx, yy - shift_y * i++, "attack_count : "			+ string(attack_count		));
			}
		}
		
		#endregion
		
		#region Conditions 
		
		Clicking_On_Unit = function() {
			if	Clicking_On_Tile()
			&&	(tile_mouse.unit != noone)
				return true;
			else
				return false;
		}
		
		#endregion
		
		#region Units init
			
		// Creation enemies + level_enemies
		var _grid = MAIN.default_enemies_stats;
		
		for (var yy = 0; yy < ds_grid_height(_grid); yy++) {
			if (_grid[# E_S.ZONE, yy] == "A (ress & buff)") && (array_length(level_enemies) < 3) {
				var e = MAIN.Construct_Enemy(_grid[# E_S.NAME, yy]);
				array_push(level_enemies, e);
			}
		}
		
		#endregion

		#endregion
		
		#region Camera
		
		var camera_x = (isom_width / 2) - (camera_get_view_width(view_camera[0]) / 2);
		var camera_y = -(camera_get_view_width(view_camera[0]) / 4);
		camera_set_view_pos(view_camera[0], camera_x, camera_y);
		
		#endregion
		
	},
	step: function () {
		s_m.change("Step Card");
	}
})

.add("Preparing")
	
	.add_child("Preparing", "Step Card", {
		enter: function() {
			s_m.change("Placing Units");
		}
	})
	.add_child("Preparing", "Placing Units", {
		enter: function () {
			seekers_on_board	= [];
			enemies_on_board	= [];
			units_on_board		= [];
						
			seekers_to_place	= [];
			enemies_to_place	= [];
			array_copy(seekers_to_place, 0, MAIN.seekers, 0, array_length(MAIN.seekers)); 
			array_copy(enemies_to_place, 0, level_enemies,0, 3);
			
			units_to_place		= seekers_to_place;	
			array_to_push		= seekers_on_board;
			
			placing_side		= "Players";
			i					= 0;
		},
		
		step: function () {
			
			s_m.inherit();
			
			// Unit index
			if (keyboard_check_pressed(vk_left)) {
				if (i == 0)		i = 2;
				else			i--;
			}
			
			if (keyboard_check_pressed(vk_right)) {
				if (i == 2)		i = 0;
				else			i++;
			}						
			
			
			// Left click
			if	Clicking_On_Tile()
			&&	(tile_mouse.unit == noone) {
				
				// Place unit + Tile.unit + on board
				if 	(tile_mouse.side == placing_side) {
					var host_tile	= tiles[tile_mouse.grid_x][tile_mouse.grid_y];
					var u			= units_to_place[i];
						
					Set_Tile_Pos_To_Screen(host_tile.grid_x, host_tile.grid_y);
					u.tile				= host_tile;
					u.x					= screen_x;
					u.y					= screen_y;
					host_tile.unit		= u;
					
					array_push	(array_to_push, u);
					array_push	(units_on_board, u);					
					array_delete(units_to_place, i, 1);
				}
				
				// Check if all seeker placed, if yes -> placing enies
				if (array_length(seekers_to_place) == 0) {	
					placing_side	= "GM";
					units_to_place	= enemies_to_place;
					array_to_push	= enemies_on_board;
				}
				
				// End placing units -> Player's Turn
				if (array_length(enemies_to_place) == 0) {	
					s_m.change("Players' Turn");
				}
				
			}	
		},
			
		GUI: function() {
			s_m.inherit();
			
			// Draw stats unit to place
			if (array_length(units_to_place) > 0) {
				
				var u = units_to_place[i];
				
				u.Display_Stats();
				
				// If unit has weapon
				if (variable_struct_exists(u, "weapon"))
					u.weapon.Display_Stats();
			}
				
		},
		
		Draw_Need_All_Tiles: function() {
			// Transparent Unit
			if (Pointing_Board
			&& t = tile_mouse) {
				// Prevent Crash
				if (tile_mouse != noone)
				&& (array_length(units_to_place) > 0) {	
					if (tile_mouse.side == placing_side) {
						Set_Tile_Pos_To_Screen(t.grid_x, t.grid_y);
						draw_sprite_ext(units_to_place[i].sprite_index, 0, screen_x, screen_y, 1, 1, 0, c_white, 0.5);
					}
				}
			}
			
		}
	})
		
.add("Round", {
	enter: function () {
		performing_side			= "Players";
		unit_performing			= noone;
		unit_riposting			= noone;
		option_targeted			= 0;
		
		Select_Unit_Performing			= function() {
			if	Clicking_On_Unit()
			&&	(unit_performing == noone)
			&&	(tile_mouse.unit.side == performing_side) {
				if (performing_side == "Players")	s_m.change("Players Choosing Action");
				if (performing_side == "GM")		s_m.change("GM Choosing Action");
				unit_performing		=	tile_mouse.unit;
				DM("Unit "+ S(unit_performing.name)+ " is choosing an action");
				
			}
		}
		
		// TODO : move code to a cleaner place
		Choosing_Action = function() {
		
			if (keyboard_check_pressed(vk_escape))	{
				s_m.change(get_previous_state()); 
				exit;
			}
			
			#region		Selection option
			
			if (keyboard_check_pressed(vk_up))					option_targeted--;
			if (keyboard_check_pressed(vk_down))				option_targeted++;
			
			if (option_targeted >= array_length(unit_performing.fight_menu))		option_targeted = 0;
			if (option_targeted < 0)							option_targeted = array_length(unit_performing.fight_menu)-1;
			
			
			//if (keyboard_check_pressed(vk_enter)) && (unit_performing.action_count > 0) {
					
				
			//		option_selected = unit_performing.fight_menu[option_targeted].action;
			//		unit_performing.doAction(option_selected);
			//		DM(S(unit_performing.name) +" wants to "+ fightMenu[# FIGHTMENU_COLUMNS.NAME, option_targeted]);
			//}
			
			#endregion
			
		}
		
	},
	
	step: function() {
		Select_Unit_Performing();
	}
})

	.add_child("Round", "Players' Turn")
		.add_child("Players' Turn", "Players Choosing Action", {
			step : function(){
				Choosing_Action();
			},
			Draw: function() {
			DM("Draw Action Menu");
			#region		Draw fightMenu

			var u_x = unit_performing.x; 
			var u_y = unit_performing.y;
			var y_offset = 16;
			var x_offset = 16;
			var x_offset_fromChar = 90;
			var x_offset_fromItems = 25;
			var array_height = array_length(unit_performing.fight_menu);
			var start_x = u_x - x_offset_fromChar;
			//fonction de ouf pour déterminer la position du premier item du menu
			var start_y = u_y - (((array_height-1)/2) * y_offset);  
			
			//Draw items
			draw_set_halign(fa_left);
			draw_set_valign(fa_middle);
			var c = c_black;
			
			for (var yy = 0; yy < array_height; yy++) {
				var txt_x = start_x;
				var txt_y = start_y + (yy*y_offset);
				c = c_black;
				
					
				//item sélectionné
				if (yy == option_targeted) {
					c = c_orange;
					txt_x = start_x - x_offset_fromItems;
				}
					
				draw_set_color(c);
				draw_text(txt_x, txt_y, unit_performing.fight_menu[yy].displayed_text);
			}
			
			#endregion	
			
			}
		})
	.add_child("Round", "GM's Turn")
		.add_child("GM's Turn", "GM Choosing action")
	.add_child("Round", "Consequences")
	
.add("Check end condition")

.add("End");

