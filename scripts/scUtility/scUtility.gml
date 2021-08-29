/// @desc		Array_Find_Index(id, value)
/// @desc		Check the given array for a value and the position within the list for that value will be returned
/// @param		id {real}				The array to check
/// @param		value {real}			The value to check within the array		
function Array_Find_Index(_array, _value){

	var index_to_return = -1;
		var a_len	= array_length(_array)
		for (var i = 0; i < a_len; i++) {
	
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
	
	
///	@function		String_Spliter(str, delimiter)
///	@desc			The delimiter is where the string will be split. 
///					No delimiter at beginning nor at the end of the string.
///					If needed the string is converted to a real number
///	@arg			{String}	str
///	@arg			{String}	delimiter				
function String_Spliter(){
	var _string			= argument[0];
	var delimiter		= argument[1];
	var array			= [];
	
	while (string_length(_string) != 0) {
		var delimiter_pos = string_pos(delimiter, _string);	
		if (delimiter_pos != 0) {
																		
			var string_part	= string_copy(_string, 1, delimiter_pos - 1);	
			array_push (array, string_part);
			_string			= string_delete(_string, 1, delimiter_pos);						
		}
		else {
			var string_part = string_copy(_string, 1, string_length(_string));
			array_push(array, string_part);
			_string			= string_delete(_string, 1, string_length(_string));
		}
	}
	return array;
}


/// @desc csv_to_grid
/// @param file
/// @param force_strings
/// @param cell_delimiter
/// @param string_delimiter
/// @param mac_newline
//  
//  CAUTION: Please ensure your files are in UTF-8 encoding.
//  
//  You may pass <undefined> to use the default value for optional arguments.
//  arg0   string   Filename for the source UTF-8 CSV file
//  arg1   bool     Whether to force all cells to be a string. Defaults to false
//  arg2   string   The delimiter used to separate cells. Defaults to a comma
//  arg3   string   The delimiter used to define strings in the CSV file. Defaults to a double-quote
//  arg4   bool     Newline compatibility mode for Mac (0A). Defaults to Windows standard newline (0D,0A)
//  
//  (c) Juju Adams 26th May 2017
//  @jujuadams

function Csv_To_Grid () {
	//Handle arguments
	if ( argument_count < 1 ) or ( argument_count > 5 ) {
		show_error( "Incorrect number of arguments (" + string( argument_count ) + ")", false );
		return undefined;
	}

	var _filename         = argument[0];
	var _force_strings    = false;
	var _cell_delimiter   = chr(44); //comma
	var _string_delimiter = chr(34); //double-quote
	var _newline_alt      = false;

	if ( argument_count >= 2 ) and ( !is_undefined( argument[1] ) ) _force_strings    = argument[1];
	if ( argument_count >= 3 ) and ( !is_undefined( argument[2] ) ) _cell_delimiter   = argument[2];
	if ( argument_count >= 4 ) and ( !is_undefined( argument[3] ) ) _string_delimiter = argument[3];
	if ( argument_count >= 5 ) and ( !is_undefined( argument[4] ) ) _newline_alt      = argument[4];

	//Check for silliness...
	if ( string_length( _cell_delimiter ) != 1 ) or ( string_length( _string_delimiter ) != 1 ) {
		show_error( "Delimiters must be one character", false );
		return undefined;
	}

	//More variables...
	var _cell_delimiter_ord  = ord( _cell_delimiter  );
	var _string_delimiter_ord = ord( _string_delimiter );

	var _sheet_width  = 0;
	var _sheet_height = 1;
	var _max_width    = 0;

	var _prev_val   = 0;
	var _val        = 0;
	var _str        = "";
	var _in_string  = false;
	var _is_decimal = !_force_strings;
	var _grid       = ds_grid_create( 1, 1 ); _grid[# 0, 0 ] = "";

	//Load CSV file as a buffer
	var _buffer = buffer_load( _filename );
	var _size = buffer_get_size( _buffer );
	buffer_seek( _buffer, buffer_seek_start, 0 );

	//Handle byte order marks from some UTF-8 encoders (EF BB BF at the start of the file)
	var _bom_a = buffer_read( _buffer, buffer_u8 );
	var _bom_b = buffer_read( _buffer, buffer_u8 );
	var _bom_c = buffer_read( _buffer, buffer_u8 );
	if !( ( _bom_a == 239 ) and ( _bom_b == 187 ) and ( _bom_c == 191 ) ) {
		show_debug_message( "CAUTION: csv_to_grid: " + _filename + ": CSV file might not be UTF-8 encoded (no BOM)" );
		buffer_seek( _buffer, buffer_seek_start, 0 );
	} else {
		_size -= 3;
	}

	//Iterate over the buffer
	for( var _i = 0; _i < _size; _i++ ) {

		_prev_val = _val;
		var _val = buffer_read( _buffer, buffer_u8 );

		//Handle UTF-8 encoding
		if ( ( _val & 224 ) == 192 ) { //two-byte

			_val  = (                              _val & 31 ) <<  6;
			_val += ( buffer_read( _buffer, buffer_u8 ) & 63 );
			_i++;

		} else if ( ( _val & 240 ) == 224 ) { //three-byte

			_val  = (                              _val & 15 ) << 12;
			_val += ( buffer_read( _buffer, buffer_u8 ) & 63 ) <<  6;
			_val +=   buffer_read( _buffer, buffer_u8 ) & 63;
			_i += 2;

		} else if ( ( _val & 248 ) == 240 ) { //four-byte

			_val  = (                              _val &  7 ) << 18;
			_val += ( buffer_read( _buffer, buffer_u8 ) & 63 ) << 12;
			_val += ( buffer_read( _buffer, buffer_u8 ) & 63 ) <<  6;
			_val +=   buffer_read( _buffer, buffer_u8 ) & 63;
			_i += 3;

		}

		//If we've found a string delimiter
		if ( _val == _string_delimiter_ord ) {

			//This definitely isn't a decimal number!
			_is_decimal = false;

			//If we're in a string...
			if ( _in_string ) {

				//If the next character is a string delimiter itself, skip this character
				if ( buffer_peek( _buffer, buffer_tell( _buffer ), buffer_u8 ) == _string_delimiter_ord ) continue;

				//If the previous character is a string delimiter itself, add the string delimiter to the working string
				if ( _prev_val == _string_delimiter_ord ) {
				    _str += _string_delimiter;
				    continue;
				}

			}

			//Toggle "we're in a string" behaviour
			_in_string = !_in_string;
			continue;

		}
    
		if ( _newline_alt ) {
			var _newline = ( _val == 10 );
		} else {
			var _newline = ( _prev_val == 13 ) and ( _val == 10 );
        
			//If we've found a newline and we're in a string, skip over the chr(10) character
			if ( _in_string ) and ( _newline ) continue;
		}

		//If we've found a new cell
		if ( ( _val == _cell_delimiter_ord ) or ( _newline ) ) and ( !_in_string ) {

			_sheet_width++;

			//If this cell is now longer than the maximum width of the grid, expand the grid
			if ( _sheet_width > _max_width ) {

				_max_width = _sheet_width;
				ds_grid_resize( _grid, _max_width, _sheet_height );

				//Clear cells vertically above to overwrite the default 0-value
				if ( _sheet_height >= 2 ) ds_grid_set_region( _grid, _max_width-1, 0, _max_width-1, _sheet_height-2, "" );

			}

			//Write the working string to a grid cell
			if ( _is_decimal )
	                {
	                    if (_str == "") _str = 0; else _str = real( _str );
	                }
                
			_grid[# _sheet_width-1, _sheet_height-1 ] = _str;

			_str = "";
			_in_string = false;
			_is_decimal = !_force_strings;

			//A newline outside of a string triggers a new line... unsurprisingly
			if ( _newline ) {

				//Clear cells horizontally to overwrite the default 0-value
				if ( _sheet_width < _max_width ) ds_grid_set_region( _grid, _sheet_width, _sheet_height-1, _max_width-1, _sheet_height-1, "" );

				_sheet_width = 0;
				_sheet_height++;
				ds_grid_resize( _grid, _max_width, _sheet_height );
			}

			continue;

		}

		//Check if we've read a "\n" dual-character
		if ( _prev_val == 92 ) and ( _val == 110 ) {
			_str = string_delete( _str, string_length( _str ), 1 ) + chr(13);
			continue;
		}
    
		//No newlines should appear outside of a string delimited cell
		if ( ( _val == 10 ) or ( _val == 13 ) ) and ( !_in_string ) continue;
    
		//Check if this character is outside valid decimal character range
		if ( _val != 45 ) and ( _val != 46 ) and ( ( _val < 48 ) or ( _val > 57 ) ) _is_decimal = false;

		//Finally add this character to the working string!
		_str += chr( _val );

	}

	//Catch hanging work string on end-of-file
	if ( _str != "" ) {
	
		_sheet_width++;
	
		if ( _sheet_width > _max_width ) {
			_max_width = _sheet_width;
			ds_grid_resize( _grid, _max_width, _sheet_height );
			if ( _sheet_height >= 2 ) ds_grid_set_region( _grid, _max_width-1, 0, _max_width-1, _sheet_height-2, "" );
		}
	
		if ( _is_decimal ) _str = real( _str );
		_grid[# _sheet_width-1, _sheet_height-1 ] = _str;
	
	}

	//If the last character was a newline then we'll have an erroneous extra row at the bottom
	if ( _newline ) ds_grid_resize( _grid, _max_width, _sheet_height-1 );

	buffer_delete( _buffer );
	return _grid;
}
	
	

///@arg stats_array
///@arg i
///@arg arg1,arg2,...

function Switch_State_Execute (states_array, index) {
	
	if (states_array[index] != 0) {
		
		var args_len	= argument_count - 2;	// 2 because we have states_array & i before accessing arguments for the function to run
		var func_args	= [];
		
		for (var i = 0; i < args_len; i++) {
			var func_arg = argument[i + 2]; 
			array_push(func_args, func_arg);
		}
			
		var val = Method_Execute(states_array[index], func_args)
		return val;
	}
	else exit; 
}
	

/// @arg method
/// @arg args_array
function Method_Execute(vmethod, a) {
 
	var len = array_length(a);
	var val;
 
	switch(len){
	    case 0:  val = vmethod(); break;
	    case 1:  val = vmethod(a[0]); break;
	    case 2:  val = vmethod(a[0], a[1]); break;
	    case 3:  val = vmethod(a[0], a[1], a[2]); break;
	    case 4:  val = vmethod(a[0], a[1], a[2], a[3]); break;
	    case 5:  val = vmethod(a[0], a[1], a[2], a[3], a[4]); break;
	    case 6:  val = vmethod(a[0], a[1], a[2], a[3], a[4], a[5]); break;
	    case 7:  val = vmethod(a[0], a[1], a[2], a[3], a[4], a[5], a[6]); break;
	    case 8:  val = vmethod(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7]); break;
	    case 9:  val = vmethod(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8]); break;
	    case 10: val = vmethod(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9]); break;
	    case 11: val = vmethod(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10]); break;
	    case 12: val = vmethod(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11]); break;
	    case 13: val = vmethod(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12]); break;
	    case 14: val = vmethod(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13]); break;
	    case 15: val = vmethod(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], a[14]); break;
	    case 16: val = vmethod(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], a[14], a[15]); break;
	}
 
	return val;

}
	
	
function DM(_string) {
	if debug_mode
		show_debug_message(_string)
}

function S(_string) {
	return string(_string);	
}