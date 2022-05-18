import 'dart:convert';
import 'package:http/http.dart' as http;

/// Retrieves the polygon for a given street address from firestore db.
///
/// Takes street address as param.
/// Returns JSON
Future<List?> getPolygon(String address) async {
  // Compose the request
  String requestTarget =
      "https://us-central1-techlauncher-e18ff.cloudfunctions.net/polygonForAddress";
  String key = "street_address";
  String formattedRequest = requestTarget + "?" + key + "=" + address;
  var request = http.Request('POST', Uri.parse(formattedRequest));

  // Send request and store response as 'response'
  final response = await request.send();

  // If status 200 OK
  if (response.statusCode == 200) {
    String responseString = await response.stream.bytesToString();
    final decoded = jsonDecode(responseString);
    final Map polygon = decoded['Polygon'];

    // Extract just the values from polygon
    // These are the coordinate pairs to be passed to the Haizea API
    List values = [];
    polygon.forEach((key, value) {
      values.add(value);
    });
    return values;
  }

  // If status not OK, print reason phrase and return null
  // TODO: implement graceful error handling e.g. show message to user
  print(response.reasonPhrase);
  return null;
}

/// Retrieves the data from the tree data set for a given list of coordinates.
///
/// Takes [List] of coordinates as param. Void return should be replaced with
/// the JSON that is returned.
void getTreeData(List coordinates) async {
  print("gets to here");
  var headers = {'Content-Type': 'application/json'};
  var request = http.Request(
      'POST',
      Uri.parse(
          'https://australia-southeast1-wald-1526877012527.cloudfunctions.net/tree-change-drill'));
  request.body = json.encode({
    "layer_name": "wcf",
    "vector": {
      "type": "Feature",
      "properties": {},
      "geometry": {
        "type": "Polygon",
        "coordinates": [coordinates]
      }
    }
  });
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  } else {
    print(response.reasonPhrase);
  }
}
