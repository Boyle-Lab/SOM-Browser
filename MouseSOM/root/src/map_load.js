function loadSvgMap(mapId) {

    return jQuery.ajax({
        url: "[% c.uri_for('/maps/update_map/') %]" + mapId,
        success: function(result) {
            if(result.isOk == false) {
                alert("Bad response from server: " + result.message);
            } else {
                // Simply return the result
            }
        },
        error: function(result, status, errorThrown) {
            alert("Map retrieval failed: " + status + " " + result.status);
        },
        async: true,
        dataType: 'text',
        cache: false
    });
}

function loadSvgContent(mapUrl, target) {
    return jQuery.ajax({
	url: mapUrl,
        success: function(result) {
            if(result.isOk == false) {
                alert("Bad response from server: " + result.message);
            } else {
                target.html(result);
            }
	},
        error: function(result, status, errorThrown) {
            alert("Map retrieval failed: " + status + " " + result.status);
        },
        async: true,
        dataType: 'text',
        cache: false
    });
}
