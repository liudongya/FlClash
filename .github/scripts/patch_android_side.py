#!/usr/bin/env python3
"""Patch the selected upstream release at build time, without renaming Kotlin packages."""

from pathlib import Path
import sys

ANDROID_ID = 'app.routelight.mobile'
RELEASE_REPOSITORY = 'liudongya/FlClash'


def replace_exact(path: Path, before: str, after: str) -> None:
    original = path.read_text(encoding='utf-8')
    occurrences = original.count(before)
    if occurrences != 1:
        raise RuntimeError(
            f'{path}: expected exactly one instance of {before!r}, found {occurrences}; '
            'upstream layout may have changed'
        )
    path.write_text(original.replace(before, after, 1), encoding='utf-8')


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit('Usage: patch_android_side.py UPSTREAM_ROOT')
    root = Path(sys.argv[1]).resolve()
    replace_exact(
        root / 'android/app/build.gradle.kts',
        'applicationId = "com.follow.clash"',
        f'applicationId = "{ANDROID_ID}"',
    )
    replace_exact(
        root / 'lib/common/constant.dart',
        "const repository = 'chen08209/FlClash';",
        f"const repository = '{RELEASE_REPOSITORY}';",
    )
    replace_exact(
        root / 'android/common/src/main/res/values/strings.xml',
        '<string name="app_name">FlClash</string>',
        '<string name="app_name">FlClash Side</string>',
    )
    # This independently installed Android flavor starts without the first-run
    # disclaimer screen. Leave the statement accessible in Tools, and do not
    # falsify a persisted user-consent record.
    replace_exact(
        root / 'lib/bootstrap.dart',
        '  Future<bool> _handlerDisclaimer() async {\n'
        '    final acceptedVersion = _container.read(',
        '  Future<bool> _handlerDisclaimer() async {\n'
        '    if (system.isAndroid) {\n'
        '      return true;\n'
        '    }\n'
        '    final acceptedVersion = _container.read(',
    )
    # Keep namespace, Kotlin packages and `const packageName` unchanged: they
    # identify classes / Dart <-> Kotlin channels, not the installed Android ID.
    print(f'Android applicationId: {ANDROID_ID}')
    print(f'In-app update repository: {RELEASE_REPOSITORY}')


if __name__ == '__main__':
    main()
