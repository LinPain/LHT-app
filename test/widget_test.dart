import 'package:flutter_test/flutter_test.dart';
import 'package:hong_tra_le_gia/main.dart';

void main() {
  testWidgets('main app opens its primary navigation', (tester) async {
    await tester.pumpWidget(const HongTraLeGiaApp());
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Trang chủ'), findsOneWidget);
    expect(find.text('Đặt món'), findsWidgets);
    expect(find.text('Đơn hàng'), findsWidgets);
  });
}
