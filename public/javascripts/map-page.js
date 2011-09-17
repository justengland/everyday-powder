$(document).ready(function() {
/*
 if (GBrowserIsCompatible()) {
    var map = new GMap2(document.getElementById("map_canvas"));
    map.setCenter(new GLatLng(37.4419, -122.1419), 13);
    map.setUIToDefault();
  }
  */
	if (GBrowserIsCompatible()) {
		var map = new GMap2(document.getElementById("mapCanvas"));
		map.addControl(new GSmallMapControl());
		map.setCenter(new GLatLng(39.6612481, -105.8795222), 9);
		map.setUIToDefault();
		
		// add traffic
		var trafficOptions = {incidents:true};
        trafficInfo = new GTrafficOverlay(trafficOptions);
        map.addOverlay(trafficInfo);
		
		// Add ski resorts
		loadMarkers(map);
	}  
});
  
function loadMarkers(map) {
	var resortMarkers = $('.resortMarkers').each(function(index, resortMarker) {		
		// read the markup to define the map
		var lat = $(resortMarker).attr("lat");
		var lng = $(resortMarker).attr("long");
		var name = $(resortMarker).attr("name");
		var resortId = $(resortMarker).attr("resortId");
		
		// use the google api to construct a 
		var gPoint = new GLatLng(lat, lng);
		var marker = createMarker(gPoint, 'test', "<a href='/resorts/" + resortId + "' >" + name + "</a>");
		map.addOverlay(marker)
	});
	
}
function createMarker(point,name,html) {
	// Create our "tiny" marker icon
	var blueIcon = new GIcon(G_DEFAULT_ICON);
	blueIcon.image = "http://www.google.com/intl/en_us/mapfiles/ms/micons/blue-dot.png";
	
	// Set up our GMarkerOptions object
	markerOptions = { icon:blueIcon };
	
	var marker = new GMarker(point, markerOptions);
    GEvent.addListener(marker, "click", function() {
	  	marker.openInfoWindowHtml(html);
	});
	/*
	gmarkers[i] = marker;
	htmls[i] = html;
	side_bar_html += '<a href="javascript:myclick(' + i + ')">' + name + '<\/a><br>';
    i++;
    */
    return marker;
}