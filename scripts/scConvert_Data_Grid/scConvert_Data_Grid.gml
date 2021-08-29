


function Resolve_Range_Restriction (range_tile, range_restriction) {
	switch (range_restriction) {
	case range_tile:											return true;	break;	
	//"Far" "Near" "Close"
	
	case "N/C":
		if (range_tile == "Near") || (range_tile == "Close")	return true;	break;
																																						
	case "F/N":																	
		if (range_tile == "Far") || (range_tile == "Near")		return true;	break;
																				
	case "F/C":																	
		if (range_tile == "Far") || (range_tile == "Close")		return true;	break;
																				
	case "!C":																	
		if (range_tile != "Close")								return true;	break;
																		
	case "!N":															
		if (range_tile != "Near")								return true;	break;
																		
	case "!F":															
		if (range_tile != "Far")								return true;	break;
		
	case -1:													return true;	break;
	}																			
}	


#region Passive

function Convert_Event(when_grid) {
	switch (when_grid) {
	case "fighting":					return	E_P.FIGHTING				;	break;
	case "attack succeeded":			return	E_P.ATTACK_SUCCEEDED		;	break;
	case "taking collision damage":		return	E_P.TAKING_COLISION_DAMAGE;	break;
	case "kill unit":					return	E_P.DEALING_FINAL_BLOW	;	break;
	case "round begin":					return	E_P.ROUND_BEGIN			;	break;
	case "prepare to attack":			return	E_P.PREPARE_TO_ATTACK		;	break;

	}
}

function Resolve_Actor_Condition(actor_condition_grid, actor, owner) {
	switch(actor_condition_grid) {
		case -1:			return true;
		case "owner":		return (actor == owner);
	}
}

function Convert_What(what_grid) {
	switch(what_grid) {
	case noone:									return noone				break;	
	case "Hope Generation per Damage (X)":									break;	
	case "Shield (X)":							return Shield;				break;
	case "Push":								return Push;				break;
	case "Ignore Collision":												break;
	case "Hope Generation (X)":												break;
	case "Pa boost":														break;
	case "Leap":								return Leap;				break;
	default:									return noone				break;
	}
}



function Resolve_On_Who_What(on_who_what_grid, owner) {
	switch (on_who_what_grid){
	case noone:									return noone;				break;
	case "owner":								return owner;				break;
	case "an element":							
		if (oActions.unit_recieving != noone)
			return oActions.unit_recieving;
		break;
	case "oActionsC":							return oActions;			break;
	default:									return false;				break;
	}
}

#endregion


#region Weapons

function Convert_Attribut(attribut_grid) {
	switch (attribut_grid) {
	case "Presence":				return "presence";				break;
	case "Aura":					return "aura";					break;
	case "Unspeakable":				return "unspeakable";			break;
	}
}

#endregion




