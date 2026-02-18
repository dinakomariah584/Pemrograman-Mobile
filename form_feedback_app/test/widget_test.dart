// test/widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:form_feedback_app/main.dart'; // Pastikan path import benar

void main() {
  testWidgets('Feedback form shows name and submit button', (WidgetTester tester) async {
    // Bangun aplikasi utama kita dan picu frame.
    // PERBAIKAN: Ganti 'MyApp' dengan 'FormFeedbackApp'
    await tester.pumpWidget(const FormFeedbackApp()); 

    // Verifikasi bahwa ada label input "Nama Anda".
    expect(find.text('Nama Anda'), findsOneWidget);

    // Verifikasi bahwa tombol 'Kirim Feedback' ada.
    expect(find.widgetWithText(ElevatedButton, 'Kirim Feedback'), findsOneWidget);
  });
}