import 'dart:convert';
import 'package:http/http.dart' as http;

/// Retrieves the polygon for a given street address from firestore db.
///
/// Takes street address as param.
/// Returns JSON
void getPolygon(String address) async {
  String requestTarget =
      "https://us-central1-techlauncher-e18ff.cloudfunctions.net/polygonForAddress";
  String key = "street_address";
  String formattedRequest = requestTarget + "?" + key + "=" + address;
  var request = http.Request('POST', Uri.parse(formattedRequest));
  request.body = '''''';
  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  } else {
    print(response.reasonPhrase);
  }
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

/// Private helper function to get http response formatted as a JSON String
Future<String?> _getResponseAsJSON(http.Request request) async {
  http.StreamedResponse response = await request.send();

  // If http status is ok, return response as JSON String
  if (response.statusCode == 200) {
    final String responseString = await response.stream.bytesToString();
    final String responseJSON = json.encode({responseString});
    return responseString;
  }

  // Else, print reason phrase and return null
  print(response.reasonPhrase);
  return null;
}

/// TEST Private helper function to get response as a Map
Future<Map?> _getResponseAsMap(http.Request request) async {
  final response = await request.send();

  // If https status is ok, return response as Map
  if (response.statusCode == 200) {
    print("200");
    final decoded = jsonDecode(response.toString()) as Map;
    final polygon = decoded['Polygon'] as Map;
    return polygon;
  }

  // Else, print reason phrase and return null
  print(response.reasonPhrase);
  return null;
}
