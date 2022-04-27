import 'dart:convert';
import 'package:http/http.dart' as http;

/// Retrieves the data from the tree data set for a given list of coordinates.
///
/// Takes [List] of coordinates as param. Void return should be replaced with
/// the JSON that is returned.
void getTreeData(List coordinates) async {
  if (coordinates[0] == coordinates[coordinates.length - 1]) {
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
}
