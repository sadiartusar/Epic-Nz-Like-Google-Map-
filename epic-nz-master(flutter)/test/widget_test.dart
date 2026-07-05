import 'package:epic_nz/app.dart';
import 'package:epic_nz/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() async{
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    const String testRoute = AppRoutes.onboarding;
    await tester.pumpWidget( EpicNzApp(initialRoute: testRoute));

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
