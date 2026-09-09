import 'package:collection/collection.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/views/config/network.dart';
import 'package:fl_clash/views/config/scripts.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TUNButton extends StatelessWidget {
  const TUNButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    return SizedBox(
      height: getWidgetHeight(1),
      child: CommonCard(
        onPressed: () {
          showSheet(
            context: context,
            builder: (_) {
              return Builder(
                builder: (context) {
                  return AdaptiveSheetScaffold(
                    body: generateListView(
                      generateSection(
                        items: [
                          if (system.isDesktop) const TUNItem(),
                          if (system.isMacOS) const AutoSetSystemDnsItem(),
                          const TunStackItem(),
                        ],
                      ),
                    ),
                    title: appLocalizations.tun,
                  );
                },
              );
            },
          );
        },
        info: Info(
          label: appLocalizations.tun,
          iconData: Icons.stacked_line_chart,
        ),
        child: Container(
          padding: baseInfoEdgeInsets.copyWith(top: 4, bottom: 8, right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: TooltipText(
                  text: Text(
                    appLocalizations.options,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.adjustSize(-2).toLight,
                  ),
                ),
              ),
              Consumer(
                builder: (_, ref, _) {
                  final enable = ref.watch(
                    patchClashConfigProvider.select(
                      (state) => state.tun.enable,
                    ),
                  );
                  return Switch(
                    value: enable,
                    onChanged: (value) {
                      ref
                          .read(patchClashConfigProvider.notifier)
                          .update((state) => state.copyWith.tun(enable: value));
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SystemProxyButton extends StatelessWidget {
  const SystemProxyButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    return SizedBox(
      height: getWidgetHeight(1),
      child: CommonCard(
        onPressed: () {
          showSheet(
            context: context,
            builder: (_) {
              return AdaptiveSheetScaffold(
                body: generateListView(
                  generateSection(
                    items: [const SystemProxyItem(), const BypassDomainItem()],
                  ),
                ),
                title: appLocalizations.systemProxy,
              );
            },
          );
        },
        info: Info(
          label: appLocalizations.systemProxy,
          iconData: Icons.shuffle,
        ),
        child: Container(
          padding: baseInfoEdgeInsets.copyWith(top: 4, bottom: 8, right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: TooltipText(
                  text: Text(
                    appLocalizations.options,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.adjustSize(-2).toLight,
                  ),
                ),
              ),
              Consumer(
                builder: (_, ref, _) {
                  final systemProxy = ref.watch(
                    networkSettingProvider.select((state) => state.systemProxy),
                  );
                  return Switch(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: systemProxy,
                    onChanged: (value) {
                      ref
                          .read(networkSettingProvider.notifier)
                          .update(
                            (state) => state.copyWith(systemProxy: value),
                          );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VpnButton extends StatelessWidget {
  const VpnButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    return SizedBox(
      height: getWidgetHeight(1),
      child: CommonCard(
        onPressed: () {
          showSheet(
            context: context,
            builder: (_) {
              return AdaptiveSheetScaffold(
                body: generateListView(
                  generateSection(
                    items: [
                      const VPNItem(),
                      const VpnSystemProxyItem(),
                      const TunStackItem(),
                    ],
                  ),
                ),
                title: 'VPN',
              );
            },
          );
        },
        info: const Info(label: 'VPN', iconData: Icons.stacked_line_chart),
        child: Container(
          padding: baseInfoEdgeInsets.copyWith(top: 4, bottom: 8, right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: TooltipText(
                  text: Text(
                    appLocalizations.options,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.adjustSize(-2).toLight,
                  ),
                ),
              ),
              Consumer(
                builder: (_, ref, _) {
                  final enable = ref.watch(
                    vpnSettingProvider.select((state) => state.enable),
                  );
                  return Switch(
                    value: enable,
                    onChanged: (value) {
                      ref
                          .read(vpnSettingProvider.notifier)
                          .update((state) => state.copyWith(enable: value));
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScriptButton extends StatelessWidget {
  const ScriptButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    return SizedBox(
      height: getWidgetHeight(1),
      child: CommonCard(
        onPressed: () {
          showSheet(
            context: context,
            builder: (_) {
              return const _ScriptSheet();
            },
          );
        },
        info: Info(
          label: appLocalizations.script,
          iconData: Icons.rocket,
        ),
        child: Container(
          padding: baseInfoEdgeInsets.copyWith(top: 4, bottom: 8, right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: Consumer(
                  builder: (_, ref, _) {
                    final currentProfile = ref.watch(currentProfileProvider);
                    final isScript =
                        currentProfile?.overwriteType == OverwriteType.script;
                    final scripts = ref.watch(scriptsProvider).value ?? [];
                    final currentScript = scripts.firstWhereOrNull(
                      (script) => script.id == currentProfile?.scriptId,
                    );
                    final String title;
                    if (isScript) {
                      if (currentScript != null) {
                        title = currentScript.label;
                      } else if (scripts.isEmpty) {
                        title =
                            appLocalizations.nullTip(appLocalizations.script);
                      } else {
                        title = appLocalizations.none;
                      }
                    } else {
                      title = appLocalizations.options;
                    }
                    return TooltipText(
                      text: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(
                          context,
                        ).textTheme.titleSmall?.adjustSize(-2).toLight,
                      ),
                    );
                  },
                ),
              ),
              Consumer(
                builder: (_, ref, _) {
                  final currentProfile = ref.watch(currentProfileProvider);
                  final isScript =
                      currentProfile?.overwriteType == OverwriteType.script;
                  return Switch(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: isScript,
                    onChanged: currentProfile == null
                        ? null
                        : (value) {
                            final scripts =
                                ref.read(scriptsProvider).value ?? [];
                            ref.read(profilesProvider.notifier).updateProfile(
                              currentProfile.id,
                              (state) => state.copyWith(
                                overwriteType: value
                                    ? OverwriteType.script
                                    : OverwriteType.standard,
                                scriptId: value
                                    ? (state.scriptId ??
                                        (scripts.isNotEmpty
                                            ? scripts.first.id
                                            : null))
                                    : state.scriptId,
                              ),
                            );
                            ref
                                .read(setupActionProvider.notifier)
                                .autoApplyProfile();
                          },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScriptSheet extends ConsumerWidget {
  const _ScriptSheet();

  void _handleToggle(WidgetRef ref, int profileId, bool enable) {
    final scripts = ref.read(scriptsProvider).value ?? [];
    ref.read(profilesProvider.notifier).updateProfile(profileId, (state) {
      return state.copyWith(
        overwriteType: enable ? OverwriteType.script : OverwriteType.standard,
        scriptId: enable
            ? (state.scriptId ??
                (scripts.isNotEmpty ? scripts.first.id : null))
            : state.scriptId,
      );
    });
    ref.read(setupActionProvider.notifier).autoApplyProfile();
  }

  void _handleChangeScript(WidgetRef ref, int profileId, int? scriptId) {
    ref.read(profilesProvider.notifier).updateProfile(profileId, (state) {
      return state.copyWith(
        scriptId: scriptId,
        overwriteType:
            scriptId != null ? OverwriteType.script : state.overwriteType,
      );
    });
    ref.read(setupActionProvider.notifier).autoApplyProfile();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = context.appLocalizations;
    final currentProfile = ref.watch(currentProfileProvider);
    if (currentProfile == null) {
      return AdaptiveSheetScaffold(
        body: Center(
          child: Text(appLocalizations.nullTip(appLocalizations.profile)),
        ),
        title: appLocalizations.script,
      );
    }
    final isScript = currentProfile.overwriteType == OverwriteType.script;
    final scripts = ref.watch(scriptsProvider).value ?? [];
    return AdaptiveSheetScaffold(
      body: RadioGroup<int?>(
        groupValue: currentProfile.scriptId,
        onChanged: (value) {
          _handleChangeScript(ref, currentProfile.id, value);
        },
        child: generateListView([
          ...generateSection(
            items: [
              ListItem.toggle(
                leading: const Icon(Icons.rocket),
                title: Text(appLocalizations.script),
                subtitle: Text(appLocalizations.scriptModeDesc),
                value: isScript,
                onChanged: (value) {
                  _handleToggle(ref, currentProfile.id, value);
                },
              ),
            ],
          ),
          if (scripts.isEmpty)
            ...generateSection(
              title: appLocalizations.overrideScript,
              items: [
                ListItem(
                  title: Text(
                    appLocalizations.nullTip(appLocalizations.script),
                    style: TextStyle(
                      color: context.colorScheme.onSurfaceVariant.opacity80,
                    ),
                  ),
                ),
              ],
            ),
          if (scripts.isNotEmpty)
            ...generateSection(
              title: appLocalizations.overrideScript,
              items: [
                ListItem<int?>.radio(
                  value: null,
                  title: Text(appLocalizations.none),
                  onTap: () {
                    _handleChangeScript(ref, currentProfile.id, null);
                  },
                ),
                for (final script in scripts)
                  ListItem<int?>.radio(
                    value: script.id,
                    title: Text(script.label),
                    onTap: () {
                      final nextId = currentProfile.scriptId == script.id
                          ? null
                          : script.id;
                      _handleChangeScript(ref, currentProfile.id, nextId);
                    },
                  ),
              ],
            ),
          ...generateSection(
            items: [
              ListItem(
                leading: const Icon(Icons.code),
                title: Text(appLocalizations.goToConfigureScript),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  BaseNavigator.push(context, const ScriptsView());
                },
              ),
            ],
          ),
        ]),
      ),
      title: appLocalizations.script,
    );
  }
}
