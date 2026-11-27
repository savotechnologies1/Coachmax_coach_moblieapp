import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:coachmax_coach/core/theme/app_theme.dart';
import 'package:coachmax_coach/core/theme/brand_colors.dart';
import 'package:coachmax_coach/shared/widgets/app_button.dart';
import 'package:coachmax_coach/shared/widgets/app_bottom_navigation.dart';
import 'package:coachmax_coach/ui/auth/sign_in_screen.dart';
import 'package:coachmax_coach/ui/auth/login_screen.dart';
import 'package:coachmax_coach/ui/dashboard/home_tab_screen.dart';
import 'package:coachmax_coach/bloc/home/home_cubit.dart';
import 'package:coachmax_coach/bloc/home/home_state.dart';
import 'package:coachmax_coach/bloc/profile/profile_cubit.dart';
import 'package:coachmax_coach/bloc/profile/profile_state.dart';
import 'package:coachmax_coach/dto/classes_response_dto.dart';
import 'package:coachmax_coach/dto/my_profile_response_dto.dart';
import 'package:coachmax_coach/utils/component/primary_button.dart';

const previewKey = ValueKey('preview');
Widget host(Widget child, {double scale = 1}) => MaterialApp(
  theme: AppTheme.light,
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
    child: child!,
  ),
  home: RepaintBoundary(key: previewKey, child: child),
);

Future<void> size(WidgetTester tester, Size value) async {
  tester.view.physicalSize = value;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> preview(WidgetTester tester, String name) async {
  await tester.runAsync(() async {
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(previewKey),
    );
    final image = await boundary.toImage(pixelRatio: 2);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final folder = Directory(
      Directory.systemTemp.path + '/coachmax-brand-previews',
    );
    folder.createSync(recursive: true);
    File(
      folder.path + '/' + name + '.png',
    ).writeAsBytesSync(bytes!.buffer.asUint8List());
    image.dispose();
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final font = FontLoader('Outfit')
      ..addFont(rootBundle.load('assets/fonts/Outfit-Variable.ttf'));
    await font.load();
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
  });

  testWidgets(
    'Sign-in validates before submit and toggles password visibility',
    (tester) async {
      await size(tester, const Size(390, 844));
      await tester.pumpWidget(host(const SignInScreen()));
      await tester.pumpAndSettle();
      await preview(tester, 'sign-in');
      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();
      expect(find.text('Enter your email address.'), findsOneWidget);
      expect(find.text('Enter your password.'), findsOneWidget);
      await tester.enterText(find.byType(TextFormField).first, 'invalid');
      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();
      expect(find.text('Enter a valid email address.'), findsOneWidget);
      await tester.tap(find.byTooltip('Show password'));
      await tester.pump();
      expect(find.byTooltip('Hide password'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Entry and sign-in remain usable on a narrow phone with large text',
    (tester) async {
      await size(tester, const Size(320, 568));
      await tester.pumpWidget(host(const LoginScreen(), scale: 1.5));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(find.text('Get started'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Get started'));
      await tester.pumpAndSettle();
      expect(find.text('Welcome back.'), findsOneWidget);
      await tester.ensureVisible(find.text('Sign in'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Loading button prevents duplicate taps and legacy button renders supplied icon',
    (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        host(
          Scaffold(
            body: Column(
              children: [
                AppButton(
                  label: 'Saving',
                  isLoading: true,
                  onPressed: () => taps++,
                ),
                PrimaryButton(
                  text: 'Continue',
                  icons: const Icon(Icons.check),
                  onClicked: () => taps++,
                ),
              ],
            ),
          ),
        ),
      );
      await tester.tap(find.text('Saving'), warnIfMissed: false);
      expect(taps, 0);
      expect(find.byIcon(Icons.check), findsOneWidget);
      await tester.tap(find.text('Continue'));
      expect(taps, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Navigation labels, selected semantics, and destination callbacks',
    (tester) async {
      await size(tester, const Size(320, 568));
      var selected = 0;
      await tester.pumpWidget(
        host(
          Scaffold(
            bottomNavigationBar: AppBottomNavigation(
              index: 0,
              onChanged: (index) => selected = index,
            ),
          ),
          scale: 1.5,
        ),
      );
      await tester.tap(find.text('Messages'));
      expect(selected, 2);
      expect(find.text('Today'), findsOneWidget);
      expect(find.bySemanticsLabel('Today'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  for (final scale in [1.0, 1.5]) {
    testWidgets('Dashboard layout at text scale $scale', (tester) async {
      await size(
        tester,
        scale == 1 ? const Size(390, 844) : const Size(320, 568),
      );
      final home = HomeCubit()
        ..emit(
          HomeLoaded([
            ClassDataDto(
              className: 'U12 Development',
              location: 'Riverside Training Ground',
              startTime: '4:30 PM',
              endTime: '5:30 PM',
              dayOfWeek: DateFormat(
                'EEEE',
              ).format(DateTime.now()).toUpperCase(),
              totalPlayers: 18,
              capacity: 24,
            ),
          ]),
        );
      final profile = ProfileCubit()
        ..emit(ProfileLoaded(ProfileDataDto(name: 'Alex')));
      addTearDown(home.close);
      addTearDown(profile.close);
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<HomeCubit>.value(value: home),
            BlocProvider<ProfileCubit>.value(value: profile),
          ],
          child: host(
            Scaffold(
              body: const HomeTabScreen(),
              bottomNavigationBar: AppBottomNavigation(
                index: 0,
                onChanged: (_) {},
              ),
            ),
            scale: scale,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('SESSION SPOTLIGHT'), findsOneWidget);
      if (scale == 1) await preview(tester, 'dashboard');
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  test('Text and action color pairs meet normal-text contrast', () {
    double contrast(Color a, Color b) {
      final first = a.computeLuminance();
      final second = b.computeLuminance();
      return (first > second
          ? (first + .05) / (second + .05)
          : (second + .05) / (first + .05));
    }

    for (final color in [
      BrandColors.text,
      BrandColors.textMuted,
      BrandColors.primary,
      BrandColors.error,
      BrandColors.successText,
      BrandColors.warning,
    ]) {
      expect(contrast(color, BrandColors.surface), greaterThanOrEqualTo(4.5));
    }
    expect(
      contrast(BrandColors.onNavyAccent, BrandColors.navy),
      greaterThanOrEqualTo(4.5),
    );
  });

  test('Literal asset references resolve and screen colors use tokens', () {
    for (final file
        in Directory('lib')
            .listSync(recursive: true)
            .whereType<File>()
            .where((f) => f.path.endsWith('.dart'))) {
      final source = file.readAsStringSync();
      for (final match in RegExp(
        r'''['"](assets/[^'"]+)['"]''',
      ).allMatches(source)) {
        expect(
          File(match.group(1)!).existsSync(),
          isTrue,
          reason: '${file.path}: ${match.group(1)}',
        );
      }
      if (file.path.replaceAll('\\', '/').contains('/ui/')) {
        expect(
          RegExp(r'Color\(\s*0x').hasMatch(source),
          isFalse,
          reason: file.path,
        );
      }
    }
  });
}
