let token = "pk.eyJ1IjoiYW5vaXJtYXAiLCJhIjoiY2s4NTF5ZzV4MDIzdDNrbDI2OWpqc283NyJ9.2DzTfSxKjGpXYaL8gusDWQ";
let mymap = L.map('mapid').setView([35.829112432244465, 10.643330155593604], 13);
L.tileLayer(`https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=${token}`, {
    attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
    maxZoom: 20,
    id: 'mapbox/streets-v11',
    tileSize: 512,
    zoomOffset: -1,
    accessToken: token
}).addTo(mymap);
var popup = L.popup();

function onMapClick(e) {
    popup
        .setLatLng(e.latlng)
        .setContent("You clicked the map at " + e.latlng.toString())
        .openOn(mymap);
    L.marker.setLatLng(e.latlng).addTo(mymap);
}
var theMarker = {};

mymap.on('click',function(e){
  lat = e.latlng.lat;
  lon = e.latlng.lng;

  console.log("You clicked the mymap at LAT: "+ lat+" and LONG: "+lon );
      //Clear existing marker, 

      if (theMarker != undefined) {
            mymap.removeLayer(theMarker);
      };

  //Add a marker to show where you clicked.
   theMarker = L.marker([lat,lon]).addTo(mymap);  
   console.log(theMarker);
});

function toLatLng(x, y, map) {
    var projected = L.point(y, x).divideBy(6378137);
    return map.options.crs.projection.unproject(projected);
 }
 
 
 var latLng = toLatLng(6693172.2381477, -264291.81938326, mymap);

 window.onload = ( ) => {
     let save = document.getElementById('save');
     save.addEventListener('click', async (e) =>  {
         
        save.innerHTML = "<div class='loader'>Loading...</div>"
         e.preventDefault();
         if(document.getElementById('checkbox').checked){
            let name = document.getElementById('sname').value;
            let description = document.getElementById('sdesc').value;
            let price = document.getElementById('sprice').value;
            let file = document.getElementById("spics").files[0];
            let form = new FormData();
            form.append('photo', file);
            form.append('name', name);
            form.append('description', description);
            form.append('price', price);
            for (var p of form) {
                console.log(p);
              }
            if(name.length > 6 && description.length > 10 && price != "" ){
                await fetch('http://localhost:3000/api/stadium/save',{
                    method: 'POST',
                    headers: {
                        'Accept': 'multipart/form-data'
                    },
                    body: JSON.stringify({data: form}), mode: "cors"
                })  
                .then(res => res.json())
                .then((res) => {
                    console.log(res);
                    save.innerHTML = "<i class='fa fa-check'></i> Save"
                })
                .catch(err =>{ 
                    console.log(err)
                    save.innerHTML = "<i class='fa fa-check'></i> Save"
                })
        }
        }

     });
 }