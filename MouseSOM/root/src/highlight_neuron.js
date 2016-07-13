function highlightNeuron(id, map) {
    var hexId = "hex " + id + "_" + map;
//    console.log(hexId);
    $svg = $(document.getElementById(map));
    $el = $(document.getElementById(hexId), $svg);
    if (map) {
        var sel_id = "selected_" + map;
    } else {
        var sel_id = "selected_default";
    }
    $sel = $(document.getElementById(sel_id), $svg);
    $sel.css('stroke', '#00FF00');
    $sel.css('stroke-width','1.25');
    $sel.attr('d', $el.attr('d'));
}
