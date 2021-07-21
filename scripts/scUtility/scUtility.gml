/// @desc		Array_Find_Index(id, value)
/// @desc		Check the given array for a value and the position within the list for that value will be returned
/// @param		id {real}				The array to check
/// @param		value {real}			The value to check within the array		
function Array_Find_Index(_array, _value){

	var index_to_return = -1;
		for (var i = 0; i < array_length(_array); i++) {
	
			if (_array[i] == _value) {
				index_to_return = i;
				break;
			}
		}
	return (index_to_return);
}


/// @desc	Convert multiple 1D arrays to a grid, each array is a row
/// @arg	array1, 
/// @arg	array2...,
function Multiple_Arrays_To_Grid(){
	
	// Determine la longueur de la grid (on prend la longueur de l'array le plus grand)
	var arrays_by_length = ds_priority_create()
	for (var i = 0; i < argument_count; i++)	ds_priority_add(arrays_by_length, argument[i], array_length(argument[i]));
	var highest_array_length_value	= array_length(ds_priority_delete_max(arrays_by_length));
	var grid						= ds_grid_create(highest_array_length_value, argument_count);	


	for (var i = 0;		i < argument_count;			i++) {	//nb d'arg = nb de ligne
	for (var xx = 0;	xx < array_length(argument[i]);	xx++) {
			//on sort les valeurs des arg et on les met dans la grid (et oui c'est inversé, et oui ça fait mal à la tête)
			//et c'est d'ailleurs parceque c'est inversé à cette étape qu'on fait appelle à cette fonction
			grid[# xx, i] = argument[i][xx];		
	}}
	ds_priority_destroy(arrays_by_length);
	return grid;
}