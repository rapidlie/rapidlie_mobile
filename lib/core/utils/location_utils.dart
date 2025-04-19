import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rapidlie/core/utils/autocomplete_predictions.dart';
import 'package:rapidlie/core/utils/autocomplete_response.dart';
import 'package:rapidlie/core/utils/network_utility.dart';


class LocationUtils {
  static Future<List<AutocompletePrediction>> placeAutoComplete(String query) async {
    Uri uri = Uri.https(
      "maps.googleapis.com",
      "maps/api/place/autocomplete/json",
      {"input": query, "key": dotenv.get("API_KEY")},
    );
    String? response = await NetworkUtility.fetchUrl(uri);
    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        return result.predictions!;
      }
    }
    return []; // Return an empty list on failure
  }

  static Future<LatLng?> getLatLong(String placeId) async {
    Uri uri = Uri.https(
      "maps.googleapis.com",
      "maps/api/place/details/json",
      {"place_id": placeId, "key": dotenv.get("API_KEY")},
    );
    String? response = await NetworkUtility.fetchUrl(uri);
    if (response != null) {
      final Map<String, dynamic> data = json.decode(response);
      if (data['status'] == 'OK') {
        final location = data['result']['geometry']['location'];
        return LatLng(location['lat'], location['lng']);
      }
    }
    return null; // Return null on failure
  }
}
