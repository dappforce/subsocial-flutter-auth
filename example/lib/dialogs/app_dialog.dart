import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

abstract class AppDialog<ActionPayload> {
  final bool hookWidget;
  const AppDialog({this.hookWidget = false});

  Future<void> show(BuildContext context) async {
    return showDialog(
      context: context,
      builder: build,
    );
  }

  @protected
  Widget build(BuildContext context) {
    return HookBuilder(
      builder: (context) {
        final isLoading = useState(false);
        final errorText = useState<String?>(null);

        final content = hookWidget
            ? HookBuilder(
                builder: (context) => buildContent(
                      context,
                      isLoading,
                      errorText,
                    ))
            : buildContent(
                context,
                isLoading,
                errorText,
              );

        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 12),
                content,
                if (errorText.value != null)
                  Text(
                    errorText.value!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }

  String get title;

  @protected
  Widget buildContent(
    BuildContext context,
    ValueNotifier<bool> loadingNotifier,
    ValueNotifier<String?> errorNotifier,
  );
}

class AppDialogActionButton extends HookWidget {
  final VoidCallback action;
  final ValueNotifier<bool> loadingNotifier;
  final String label;

  const AppDialogActionButton({
    Key? key,
    required this.label,
    required this.loadingNotifier,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading = useValueListenable(loadingNotifier);
    return Row(
      children: [
        const Spacer(),
        TextButton.icon(
          onPressed: isLoading ? null : action,
          label: Text(label),
          icon: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const SizedBox(),
        ),
      ],
    );
  }
}
