import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/config/language_config.dart';
import '../../core/services/language_service.dart';
import '../../generated/l10n/app_localizations.dart';

class LanguageSelector extends StatefulWidget {
  final bool isFloating;
  final Offset? position;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? accentColor;

  const LanguageSelector({
    super.key,
    this.isFloating = true,
    this.position,
    this.backgroundColor,
    this.textColor,
    this.accentColor,
  });

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final backgroundColor = widget.backgroundColor ?? 
        (isDark ? Colors.grey[900]! : Colors.white);
    final textColor = widget.textColor ?? 
        (isDark ? Colors.white : Colors.black87);
    final accentColor = widget.accentColor ?? 
        theme.primaryColor;

    if (widget.isFloating) {
      return _buildFloatingSelector(
        backgroundColor, 
        textColor, 
        accentColor,
      );
    } else {
      return _buildInlineSelector(
        backgroundColor, 
        textColor, 
        accentColor,
      );
    }
  }

  Widget _buildFloatingSelector(
    Color backgroundColor, 
    Color textColor, 
    Color accentColor,
  ) {
    return Positioned(
      top: widget.position?.dy ?? 100,
      right: widget.position?.dx ?? 20,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: _isExpanded
                    ? _buildExpandedContent(backgroundColor, textColor, accentColor)
                    : _buildCollapsedContent(backgroundColor, textColor, accentColor),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInlineSelector(
    Color backgroundColor, 
    Color textColor, 
    Color accentColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: _buildExpandedContent(backgroundColor, textColor, accentColor),
    );
  }

  Widget _buildCollapsedContent(
    Color backgroundColor, 
    Color textColor, 
    Color accentColor,
  ) {
    return GetBuilder<LanguageService>(
      builder: (languageService) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _toggleExpansion,
            borderRadius: BorderRadius.circular(25),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    languageService.currentLanguage.flag,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    languageService.currentLanguage.code.toUpperCase(),
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: textColor.withOpacity(0.7),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildExpandedContent(
    Color backgroundColor, 
    Color textColor, 
    Color accentColor,
  ) {
    return GetBuilder<LanguageService>(
      builder: (languageService) {
        return Container(
          constraints: const BoxConstraints(
            maxHeight: 400,
            maxWidth: 280,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.language,
                      color: accentColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.selectLanguage,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _toggleExpansion,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.close,
                          color: accentColor,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Language List
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: languageService.supportedLanguages.length,
                  itemBuilder: (context, index) {
                    final language = languageService.supportedLanguages[index];
                    final isSelected = language.code == languageService.currentLanguageCode;
                    
                    return _buildLanguageItem(
                      language,
                      isSelected,
                      backgroundColor,
                      textColor,
                      accentColor,
                      languageService,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageItem(
    SupportedLanguage language,
    bool isSelected,
    Color backgroundColor,
    Color textColor,
    Color accentColor,
    LanguageService languageService,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          await languageService.setLanguage(language);
          if (widget.isFloating) {
            _toggleExpansion();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected 
                ? accentColor.withOpacity(0.1)
                : Colors.transparent,
            border: isSelected
                ? Border(
                    left: BorderSide(
                      color: accentColor,
                      width: 3,
                    ),
                  )
                : null,
          ),
          child: Row(
            children: [
              Text(
                language.flag,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      language.nativeName,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: isSelected 
                            ? FontWeight.w600 
                            : FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      language.name,
                      style: TextStyle(
                        color: textColor.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: accentColor,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
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

  void _showLanguageDialog(BuildContext context, LanguageService languageService) {
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
              final isSelected = language.code == languageService.currentLanguageCode;
              
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
