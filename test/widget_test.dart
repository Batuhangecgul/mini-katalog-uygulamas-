import 'package:flutter_test/flutter_test.dart';

import 'package:mini_katalog_uygulamasi/main.dart';

void main() {
  testWidgets('Home screen renders main title', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Mini Katalog Uygulamasi'), findsOneWidget);
    expect(find.text('Urun veya kategori ara'), findsOneWidget);
  });
}
