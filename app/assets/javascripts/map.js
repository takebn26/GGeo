let map;
let marker;
let listItems = document.getElementsByClassName('list__item');

function initMap() {

  let japan = { lat: 35.652832, lng: 139.839478 };
  map = new google.maps.Map(
    document.getElementById('map'), {
      zoom: 8,
      center: japan,
      backgroundColor: 'green'
    }
  );

  getLocations(map);
}

function getLocations(map) {
  let req = new XMLHttpRequest(),
    method = 'GET',
    url = '../locations';

  // Promise使いたいよなあ
  req.onreadystatechange = function() {
    if (req.readyState === 4 && req.status === 200) {
      let locations = JSON.parse(req.responseText).loc;

      locations.forEach(function(val) {
        addMarker(map, val)
      });
    }
  };

  req.open(method, url, true);
  req.setRequestHeader('X-CSRF-Token', 'AAAAAAAAAA');
  req.setRequestHeader('Accept', 'application/json');
  req.send();
}

function addMarker(map, location) {
  marker = new google.maps.Marker({
    id: location.id,
    position: {
      lat: location.latitude,
      lng: location.longitude
    },
    draggable: true,
    animation: google.maps.Animation.DROP,
    map: map
  });

  marker.addListener('dragend', function() {
    for (let i = 0; i <= listItems.length - 1; i++) {
      let item = listItems.item(i);

      if (matchId(this, item)) {
        saveLocation(this, item);
      }
    }
  });

  marker.addListener('position_changed', function() {
    for (let i = 0; i <= listItems.length - 1; i++) {
      let item = listItems.item(i);

      if (matchId(this, item)) {
        rewriteLatLng(this, item);
      }
    }
  });
}

function saveLocation(marker, item) {
  let address = item.children[1].getElementsByTagName('span').item(0);

  let req = new XMLHttpRequest(),
    method = 'PATCH',
    url = `../locations/${ marker.id }`;

  req.onreadystatechange = function() {
    if (req.readyState === 4 && req.status === 200) {
      var location = JSON.parse(req.responseText);

      console.log(location);
      address.innerText = location.address
    }
  };

  let fd = new FormData();
  fd.append('lat', marker.getPosition().lat());
  fd.append('lng', marker.getPosition().lng());

  req.open(method, url, true);
  req.setRequestHeader('X-CSRF-Token', 'AAAAAAAAAA');
  req.setRequestHeader('Accept', 'application/json');
  req.send(fd);
}

function rewriteLatLng(marker, item) {
  let latitude = item.children[2].getElementsByTagName('span').item(0);
  let longitude = item.children[3].getElementsByTagName('span').item(0);

  latitude.innerText = marker.getPosition().lat();
  longitude.innerText = marker.getPosition().lng();
}

let matchId = function(marker, item) {
  return parseInt(item.dataset.buildingId) === marker.id
};
