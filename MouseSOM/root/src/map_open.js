$(document).on("click",".map_select", function(e){    
    window.location.assign("[% c.secure_uri_for('/maps/map/') %]" + this.name);
})
