// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child presentation_layer.widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:movies/repositories/user_repository.dart';

void main() {
  test('API Call', () async {
    final UserRepository user = new UserRepository();
    var call =
        await user.authenticate(username: "testmanaam", password: "test");
    // final GetMovies movies = new GetMovies();
    // var body =
    //     await movies.getSearchMovies(userRepository: user, searchString: "test");
    // // expect(body, []);
  });
}
