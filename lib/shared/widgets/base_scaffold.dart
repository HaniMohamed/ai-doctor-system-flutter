import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/language_service.dart';
import '../../core/config/language_config.dart';
import '../../generated/l10n/app_localizations.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showAppBar;
  final bool showLanguageSelector;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final bool resizeToAvoidBottomInset;
  final bool extendBody;
  final bool extendBodyBehindAppBar;

  const BaseScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.showAppBar = true,
    this.showLanguageSelector = true,
    this.backgroundColor,
    this.bottom,
    this.drawer,
    this.endDrawer,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.resizeToAvoidBottomInset = true,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: title != null ? Text(title!) : null,
              actions: [
                if (actions != null) ...actions!,
                if (showLanguageSelector)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: _buildLanguageButton(context),
                  ),
              ],
              bottom: bottom,
            )
          : null,
      body: Stack(
        children: [
          body,
          if (showLanguageSelector && !showAppBar)
            Positioned(
              top: MediaQuery.of(context).padding.top + 20,
              right: 20,
              child: FloatingLanguageButton(),
            ),
        ],
      ),
      floatingActionButton: floatingActionButton,
      drawer: drawer,
      endDrawer: endDrawer,
      bottomNavigationBar: bottomNavigationBar,
      bottomSheet: bottomSheet,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
    );
  }

  Widget _buildLanguageButton(BuildContext context) {
    return GetBuilder<LanguageService>(
      builder: (languageService) {
        return PopupMenuButton<SupportedLanguage>(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  languageService.currentLanguage.flag,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 4),
                Text(
                  languageService.currentLanguage.code.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          onSelected: (SupportedLanguage language) async {
            await languageService.setLanguage(language);
          },
          itemBuilder: (context) {
            return languageService.supportedLanguages.map((language) {
              return PopupMenuItem<SupportedLanguage>(
                value: language,
                child: Row(
                  children: [
                    Text(
                      language.flag,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            language.nativeName,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            language.name,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (language.code == languageService.currentLanguageCode)
                      Icon(
                        Icons.check,
                        color: Theme.of(context).primaryColor,
                        size: 16,
                      ),
                  ],
                ),
              );
            }).toList();
          },
        );
      },
    );
  }
}

class FloatingLanguageButton extends StatelessWidget {
  final Offset? position;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? accentColor;

  const FloatingLanguageButton({
    super.key,
    this.position,
    this.backgroundColor,
    this.textColor,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguageService>(
      builder: (languageService) {
        return GestureDetector(
          onTap: () {
            _showLanguageDialog(context, languageService);
          },
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: backgroundColor ?? Theme.of(context).primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: Text(
                languageService.currentLanguage.flag,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLanguageDialog(
      BuildContext context, LanguageService languageService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.selectLanguage),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: languageService.supportedLanguages.length,
            itemBuilder: (context, index) {
              final language = languageService.supportedLanguages[index];
              final isSelected =
                  language.code == languageService.currentLanguageCode;

              return ListTile(
                leading: Text(
                  language.flag,
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text(language.nativeName),
                subtitle: Text(language.name),
                trailing: isSelected
                    ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                    : null,
                onTap: () async {
                  await languageService.setLanguage(language);
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
