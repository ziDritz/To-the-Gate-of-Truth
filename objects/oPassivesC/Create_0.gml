passives_evs = ds_map_create();

enum E_P {
	ROUND_STATE_INIT,	
	FIGHTING,
	ATTACK,
	ATTACK_SUCCEEDED,
	IN_CLOSE_RANGE,
	TAKING_COLISION_DAMAGE,
	DEALING_FINAL_BLOW,
	ROUND_BEGIN,
	PREPARE_TO_ATTACK
}

///@arg event
///@arg obj
///@arg passive (default, 1, 2)

Passive_Listen_Event = function(event, p){
	if (event != noone) {
		if (!ds_map_exists(passives_evs, event))	var passives = [];
		else										var passives = passives_evs[? event];
		
		array_push(passives, p);
		passives_evs[? event] = passives;
		DM(S(p.name) +" added to passive event "+ S(event));
	}
}


Event_Apply_Passive = function(event, actor) {
	DM("Event passive "+ S(event));
	if (ds_map_exists(passives_evs, event)) {	
		var passives = passives_evs[? event];
		
		for (var i = array_length(passives)-1; i >= 0; i--) {
			var p				= passives[i];
			var actor_condition	= Resolve_Actor_Condition(p.actor_condition, actor, p.owner);
			
			if (p.owner != undefined) && (actor_condition) {	
				//TO DO Convert what/on_who_what....
				var action	= Convert_What(p.what);
				var amount	= p.amount;
				var target	= Resolve_On_Who_What (p.on_who_what, p.owner);
				var range	= Resolve_Range_Restriction(p.owner.tile.range, p.range_restriction);	// remplace owner by "target"
				DM("Passif "+ p.what +"("+ S(p.amount) +") on "+ p.on_who_what +" is ready");
				Apply_Passive(action, amount, target, range);
			}
			else									
				break;//Unlistening_Event(actions_info, action_info);	
		}
	}	
}




Unlistening_Event = function(event, obj_id) {
	if (ds_map_exists(evs, event)) {	
		var actions_info = evs[? event];
		
		for (var i = 0; i < array_length(actions_info); i++) {
			var action_info = actions_info[i];
				
			if (action_info.obj.id == obj_id) {
				array_delete(actions_info, i, 1);
					
				if (array_length(actions_info) == 0)		actions_info	= -1;
				break;
			}
		}
	}
}



Apply_Passive = function (action, amount, target, range) {
	with (target) if range	action(amount);
	DM("Passive applied");
}




