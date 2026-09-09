import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/theme.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/dashboard/widgets/quick_options.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProviderContainer container;
  late Profile initialProfile;
  late AppLocalizations appLocalizations;
  final script = Script(
    id: 101,
    label: 'test-script',
    lastUpdateTime: DateTime(2025),
  );

  setUp(() async {
    appLocalizations = await AppLocalizations.load(const Locale('en'));
    initialProfile = Profile.normal().copyWith(
      id: 1,
      overwriteType: OverwriteType.standard,
      scriptId: null,
    );
    container = ProviderContainer(
      overrides: [
        currentProfileIdProvider.overrideWithBuild((_, _) => initialProfile.id),
        profilesProvider.overrideWith(() => _TestProfiles([initialProfile])),
        scriptsProvider.overrideWith(
          () => _TestScripts([script]),
        ),
      ],
    );
    globalState.container = container;
  });

  tearDown(() {
    container.dispose();
  });

  testWidgets('ScriptButton toggles script overwrite on and off', (
    tester,
  ) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const _TestApp(child: ScriptButton()),
      ),
    );
    await tester.pumpAndSettle();

    final switchFinder = find.byType(Switch);
    expect(switchFinder, findsOneWidget);
    expect(tester.widget<Switch>(switchFinder).value, false);

    await tester.tap(switchFinder);
    await tester.pumpAndSettle();

    final updatedProfile = container.read(currentProfileProvider);
    expect(updatedProfile?.overwriteType, OverwriteType.script);
    expect(updatedProfile?.scriptId, script.id);
    expect(tester.widget<Switch>(switchFinder).value, true);
    expect(find.text('test-script'), findsOneWidget);

    await tester.tap(switchFinder);
    await tester.pumpAndSettle();

    final revertedProfile = container.read(currentProfileProvider);
    expect(revertedProfile?.overwriteType, OverwriteType.standard);
    expect(tester.widget<Switch>(switchFinder).value, false);
  });

  testWidgets('ScriptButton opens sheet and selects script', (tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const _TestApp(child: ScriptButton()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(CommonCard));
    await tester.pumpAndSettle();

    expect(find.text('test-script'), findsOneWidget);

    await tester.tap(find.text('test-script'));
    await tester.pumpAndSettle();

    final profileAfterRadio = container.read(currentProfileProvider);
    expect(profileAfterRadio?.overwriteType, OverwriteType.script);
    expect(profileAfterRadio?.scriptId, script.id);

    final noneText = find.text(appLocalizations.none);
    expect(noneText, findsOneWidget);

    await tester.tap(noneText);
    await tester.pumpAndSettle();

    final profileAfterNone = container.read(currentProfileProvider);
    expect(profileAfterNone?.scriptId, null);
    expect(find.text(appLocalizations.none), findsWidgets);
  });

  testWidgets('ScriptButton shows empty script tip when no scripts exist', (
    tester,
  ) async {
    final emptyContainer = ProviderContainer(
      overrides: [
        currentProfileIdProvider.overrideWithBuild((_, _) => initialProfile.id),
        profilesProvider.overrideWith(() => _TestProfiles([initialProfile])),
        scriptsProvider.overrideWith(() => _TestScripts([])),
      ],
    );
    addTearDown(emptyContainer.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: emptyContainer,
        child: const _TestApp(child: ScriptButton()),
      ),
    );
    await tester.pumpAndSettle();

    final switchFinder = find.byType(Switch);
    await tester.tap(switchFinder);
    await tester.pumpAndSettle();

    expect(
      find.text(appLocalizations.nullTip(appLocalizations.script)),
      findsOneWidget,
    );
  });
}

class _TestScripts extends Scripts {
  final List<Script> initial;

  _TestScripts(this.initial);

  @override
  Stream<List<Script>> build() => Stream.value(initial);
}

class _TestProfiles extends Profiles {
  final List<Profile> initial;

  _TestProfiles(this.initial);

  @override
  List<Profile> build() => initial;

  @override
  void updateProfile(
    int profileId,
    Profile Function(Profile profile) builder,
  ) {
    final index = state.indexWhere((element) => element.id == profileId);
    if (index == -1) return;
    final next = List<Profile>.from(state);
    next[index] = builder(state[index]);
    state = next;
  }
}

class _TestApp extends StatelessWidget {
  final Widget child;

  const _TestApp({required this.child});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: globalState.navigatorKey,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.delegate.supportedLocales,
      builder: (context, child) {
        globalState.measure = Measure.of(context, 1);
        globalState.theme = CommonTheme.of(context, 1);
        return child!;
      },
      home: Scaffold(body: Center(child: child)),
    );
  }
}
