evs = ds_map_create();

enum E {};

///@arg event
///@arg obj
///@arg methodv 
///@arg arg1...

Listening_Event = function(event, obj, methodv){
	// Getting listeners
	if (!ds_map_exists(evs, event))	var actions_info = [];
	else							var actions_info = evs[? event];

	// Set up new listener
	var args = []
		
	for (var i = 0; i < argument_count - 3; i++) {
		args[i] = argument[i+3];
	}

	var new_action_info = {
		obj			: obj,
		methodv		: methodv,
		args		: args
	};
	
	// New listener added to listeners
	array_push(actions_info, new_action_info);
	evs[? event] = actions_info;
}


Fire_Event = function(event) {
	show_message("event fired");
	if (ds_map_exists(evs, event)) {	
		var actions_info = evs[? event];
		
		for (var i = array_length(actions_info)-1; i >= 0; i--) {
			var action_info	= actions_info[i];

			if (action_info.obj != undefined){		
				with(action_info.obj) Method_Execute(action_info.methodv,action_info.args);
				show_message("Method_Execute");}
			else									
				Unlistening_Event(actions_info, action_info);	
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

