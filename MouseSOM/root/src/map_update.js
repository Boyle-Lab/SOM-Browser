[% PROCESS "highlight_neuron.js" -%]
[% PROCESS "map_load.js" -%]

$(document).on("click",".map_select", function(e){

    var urlParts = document.location.href.split(/[\/?]+/g);
    var neuronId = null;
    var params_str = null;
    if (urlParts.length >= 6) {
	neuronId = urlParts[5].replace(/#/, "");
	params_str = urlParts[6];
    }
    
    var mapId = Number(this.name);

    if (mapId >= 100 && mapId < 200 && params_str != null) {
	// Gene expression maps. Get the normalization type from the URL params.
	params = params_str.split(/&/g);
	norm = params[2].split(/=/g)[1];
	if (norm == "tpm") {
	    // do nothing
	} else if (norm == "bnorm") {
	    mapId += 100;
	} else if (norm == "qnorm") {
	    mapId += 700;
	}
    }

    $.when(loadSvgMap(mapId)).done(function(mapUrl) {
        $.when(loadSvgContent(mapUrl, $("#som_map"))).done(function(a) {
	    if (neuronId != null) {
                var svg = $("svg")[0];
		var map= svg.id;
		highlightNeuron(neuronId, map);
	    }
        });
    });

    $("#map_info_block").load("[% c.secure_uri_for('/maps/get_map_info/') %]" + mapId);

    if (neuronId != null) {
	var newUrl;
	if (params_str != null) {
	    newUrl = "[% c.secure_uri_for('/maps/neuron/') %]" + mapId + '/' + neuronId + '?' + params_str;
	} else {
	    newUrl = "[% c.secure_uri_for('/maps/neuron/') %]" + mapId + '/' + neuronId;
	}
	var titleParts = document.title.split(/:/g);
	var newTitle = titleParts[0] + ": Map " + mapId + ", Pattern " + neuronId;
//	console.log(newTitle);
	var state = { url: newUrl, title: newTitle, loadTag: true };
	document.title = newTitle;
	window.history.pushState(state, "", newUrl);
    } else {
	var newUrl;
	if (params_str != null) {
	    newUrl= "[% c.secure_uri_for('/maps/map/') %]" + mapId + '?' + params_str;
	} else {
	    newUrl= "[% c.secure_uri_for('/maps/map/') %]" + mapId;
	}
	var titleParts = document.title.split(/:/g);
	var newTitle = titleParts[0] + ": Map " + mapId;
	var state = { url: newUrl, title: newTitle, loadTag: true };
	document.title = newTitle;
	window.history.pushState(state, "", newUrl);
    }
})
