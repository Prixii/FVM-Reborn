function map_registry_init(){
	global.maps_map = ds_map_create()
}

function register_map(map_id,map_data){
	ds_map_add(global.maps_map,map_id,map_data)
}

/// @param {String} map_id 
/// @param {Struct} map_data 
function register_or_replace_map(map_id, map_data) {
	if (ds_map_exists(global.maps_map, map_id)) {
		ds_map_replace(global.maps_map, map_id, map_data)
	} else {
		ds_map_add(global.maps_map, map_id, map_data)
	}
}