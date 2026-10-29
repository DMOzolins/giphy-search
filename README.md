# giphy_search

A new Flutter project.

## Flutter version

- Flutter 3.47.7
- Dart 3.13.5

## How to run

flutter pub get
flutter run --dart-define=GIPHY_API_KEY=*key*

## Tests

flutter test

## Sources

- Fetch data from the internet: https://docs.flutter.dev/cookbook/networking/fetch-data
- JSON and serialization: https://docs.flutter.dev/data-and-backend/serialization/json
- Mock dependencies (passing `http.Client` to the API class): https://docs.flutter.dev/cookbook/testing/unit/mocking
- `MockClient` from the http package: https://pub.dev/documentation/http/latest/testing/
- Send data to a new screen: https://docs.flutter.dev/cookbook/navigation/passing-data
- Update the UI based on orientation: https://docs.flutter.dev/cookbook/design/orientation
- Handle changes to a text field: https://docs.flutter.dev/cookbook/forms/text-field-changes
- Debounce example in the Autocomplete docs: https://api.flutter.dev/flutter/material/Autocomplete-class.html
- Infinite list example (loading more when scrolling): https://github.com/felangel/bloc/blob/master/examples/flutter_infinite_list/lib/posts/view/posts_list.dart
- Image loading and error builders: https://api.flutter.dev/flutter/widgets/Image/loadingBuilder.html
- Unit testing and widget testing: https://docs.flutter.dev/cookbook/testing/unit/introduction and https://docs.flutter.dev/cookbook/testing/widget/introduction
- Giphy API: https://developers.giphy.com/docs/api/