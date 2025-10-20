---
title: "UI/UX & Design System - AI Doctor System Flutter Client"
updated: "2024-12-01"
tags: ["ui-ux", "design-system", "flutter", "healthcare"]
summary: "Comprehensive design system and UI/UX guidelines for the AI-first Doctor Management System"
---

# UI/UX & Design System - AI Doctor System Flutter Client

## Design Philosophy

The AI Doctor System follows a human-centered design approach that prioritizes accessibility, clarity, and trust in healthcare contexts. The design system creates a cohesive experience across all platforms while maintaining the flexibility to adapt to different user roles and healthcare scenarios.

## Core Design Principles

### **1. Healthcare-First Design**
- **Trust & Reliability**: Clean, professional interface that instills confidence
- **Accessibility**: WCAG 2.1 AA compliance for users with disabilities
- **Clarity**: Clear information hierarchy and minimal cognitive load
- **Safety**: Prominent error states and confirmation dialogs for critical actions

### **2. AI-Enhanced User Experience**
- **Conversational Interface**: Natural language interactions with AI services
- **Progressive Disclosure**: Information revealed based on user needs and context
- **Intelligent Assistance**: Context-aware suggestions and recommendations
- **Transparent AI**: Clear indication of AI-generated content and confidence levels

### **3. Cross-Platform Consistency**
- **Adaptive Design**: Responsive layouts for mobile, tablet, and desktop
- **Platform Conventions**: Respects iOS and Android design guidelines
- **Consistent Interactions**: Unified gestures and navigation patterns
- **Performance**: Smooth animations and transitions across all devices

## Design System Architecture

### **Component Library Structure**
```dart
lib/
├── core/theme/
│   ├── app_theme.dart              # Main theme configuration
│   ├── color_scheme.dart           # Color palette and variants
│   ├── text_theme.dart             # Typography system
│   ├── spacing_system.dart         # Spacing and layout grid
│   └── component_theme.dart        # Component-specific theming
├── shared/widgets/
│   ├── atoms/                      # Basic building blocks
│   │   ├── buttons/
│   │   ├── inputs/
│   │   ├── text/
│   │   └── icons/
│   ├── molecules/                  # Simple combinations
│   │   ├── form_fields/
│   │   ├── cards/
│   │   └── navigation/
│   ├── organisms/                  # Complex components
│   │   ├── headers/
│   │   ├── lists/
│   │   └── forms/
│   └── templates/                  # Page layouts
│       ├── dashboard_layout.dart
│       ├── chat_layout.dart
│       └── form_layout.dart
```

## Color System

### **Primary Color Palette**
```dart
class AppColors {
  // Healthcare-inspired primary colors
  static const Color primaryBlue = Color(0xFF2563EB);      // Trust, reliability
  static const Color primaryGreen = Color(0xFF059669);     // Health, growth
  static const Color primaryTeal = Color(0xFF0D9488);      // Balance, calm
  
  // Semantic colors
  static const Color success = Color(0xFF10B981);          // Success states
  static const Color warning = Color(0xFFF59E0B);          // Warnings
  static const Color error = Color(0xFFEF4444);            // Errors, critical
  static const Color info = Color(0xFF3B82F6);             // Information
  
  // Neutral colors
  static const Color neutral900 = Color(0xFF111827);       // Primary text
  static const Color neutral800 = Color(0xFF1F2937);       // Secondary text
  static const Color neutral700 = Color(0xFF374151);       // Tertiary text
  static const Color neutral600 = Color(0xFF4B5563);       // Disabled text
  static const Color neutral500 = Color(0xFF6B7280);       // Placeholder text
  static const Color neutral400 = Color(0xFF9CA3AF);       // Borders
  static const Color neutral300 = Color(0xFFD1D5DB);       // Light borders
  static const Color neutral200 = Color(0xFFE5E7EB);       // Dividers
  static const Color neutral100 = Color(0xFFF3F4F6);       // Backgrounds
  static const Color neutral50 = Color(0xFFF9FAFB);        // Light backgrounds
  
  // Healthcare-specific colors
  static const Color medicalRed = Color(0xFFDC2626);       // Emergency, critical
  static const Color medicalOrange = Color(0xFFEA580C);    // Urgent, attention
  static const Color medicalYellow = Color(0xFFCA8A04);    // Caution, moderate
  static const Color medicalBlue = Color(0xFF2563EB);      // Information, stable
  static const Color medicalGreen = Color(0xFF059669);     // Healthy, normal
}

// Color scheme configuration
class AppColorScheme {
  static ColorScheme get lightTheme => const ColorScheme.light(
    primary: AppColors.primaryBlue,
    secondary: AppColors.primaryTeal,
    surface: AppColors.neutral50,
    background: AppColors.neutral100,
    error: AppColors.error,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: AppColors.neutral900,
    onBackground: AppColors.neutral900,
    onError: Colors.white,
  );
  
  static ColorScheme get darkTheme => const ColorScheme.dark(
    primary: AppColors.primaryBlue,
    secondary: AppColors.primaryTeal,
    surface: AppColors.neutral800,
    background: AppColors.neutral900,
    error: AppColors.error,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: AppColors.neutral100,
    onBackground: AppColors.neutral100,
    onError: Colors.white,
  );
}
```

### **Color Usage Guidelines**

#### **Primary Colors**
- **Primary Blue**: Main actions, links, and primary navigation
- **Primary Green**: Success states, healthy indicators, positive actions
- **Primary Teal**: Secondary actions, accents, and highlights

#### **Semantic Colors**
- **Success Green**: Confirmation messages, successful operations
- **Warning Orange**: Caution messages, non-critical alerts
- **Error Red**: Error messages, failed operations, critical alerts
- **Info Blue**: Information messages, help text, tips

#### **Healthcare-Specific Colors**
- **Medical Red**: Emergency situations, critical health alerts
- **Medical Orange**: Urgent but non-emergency situations
- **Medical Yellow**: Moderate health concerns, caution
- **Medical Blue**: Stable health status, routine information
- **Medical Green**: Healthy status, normal results

## Typography System

### **Font Family**
```dart
class AppTextTheme {
  static const String primaryFontFamily = 'Inter';
  static const String secondaryFontFamily = 'Roboto';
  static const String monospaceFontFamily = 'JetBrains Mono';
  
  static TextTheme get textTheme => TextTheme(
    // Display styles for large headings
    displayLarge: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 32,
      fontWeight: FontWeight.bold,
      height: 1.2,
      letterSpacing: -0.5,
    ),
    displayMedium: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 28,
      fontWeight: FontWeight.bold,
      height: 1.3,
      letterSpacing: -0.25,
    ),
    displaySmall: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 1.3,
    ),
    
    // Headline styles for section headers
    headlineLarge: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 1.3,
    ),
    headlineMedium: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    headlineSmall: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    
    // Title styles for card headers
    titleLarge: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    titleMedium: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    titleSmall: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    
    // Body styles for content
    bodyLarge: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 16,
      fontWeight: FontWeight.normal,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 14,
      fontWeight: FontWeight.normal,
      height: 1.5,
    ),
    bodySmall: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 12,
      fontWeight: FontWeight.normal,
      height: 1.5,
    ),
    
    // Label styles for UI elements
    labelLarge: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.4,
    ),
    labelMedium: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.4,
    ),
    labelSmall: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 10,
      fontWeight: FontWeight.w500,
      height: 1.4,
    ),
  );
}
```

### **Typography Usage Guidelines**

#### **Display Styles**
- **Display Large**: App titles, major page headers
- **Display Medium**: Section headers, feature titles
- **Display Small**: Subsection headers, card titles

#### **Headline Styles**
- **Headline Large**: Page titles, major sections
- **Headline Medium**: Section headers, important content
- **Headline Small**: Subsection headers, content blocks

#### **Title Styles**
- **Title Large**: Card headers, form section titles
- **Title Medium**: List item titles, button labels
- **Title Small**: Small headers, metadata labels

#### **Body Styles**
- **Body Large**: Primary content, important information
- **Body Medium**: Secondary content, descriptions
- **Body Small**: Supporting text, captions

#### **Label Styles**
- **Label Large**: Button text, navigation labels
- **Label Medium**: Form labels, small buttons
- **Label Small**: Captions, metadata, fine print

## Spacing System

### **Spacing Scale**
```dart
class AppSpacing {
  // Base spacing unit (8px)
  static const double baseUnit = 8.0;
  
  // Spacing scale
  static const double xs = baseUnit * 0.5;    // 4px
  static const double sm = baseUnit * 1;      // 8px
  static const double md = baseUnit * 2;      // 16px
  static const double lg = baseUnit * 3;      // 24px
  static const double xl = baseUnit * 4;      // 32px
  static const double xxl = baseUnit * 6;     // 48px
  static const double xxxl = baseUnit * 8;    // 64px
  
  // Component-specific spacing
  static const double cardPadding = md;       // 16px
  static const double screenPadding = lg;     // 24px
  static const double sectionSpacing = xl;    // 32px
  static const double pageSpacing = xxl;      // 48px
}
```

### **Layout Grid System**
```dart
class AppLayout {
  // Breakpoints for responsive design
  static const double mobileBreakpoint = 768;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;
  
  // Container widths
  static const double mobileMaxWidth = 480;
  static const double tabletMaxWidth = 768;
  static const double desktopMaxWidth = 1200;
  
  // Grid columns
  static const int mobileColumns = 4;
  static const int tabletColumns = 8;
  static const int desktopColumns = 12;
  
  // Grid gaps
  static const double mobileGap = AppSpacing.md;
  static const double tabletGap = AppSpacing.lg;
  static const double desktopGap = AppSpacing.xl;
}
```

## Component Library

### **Atomic Components**

#### **Buttons**
```dart
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonStyle style;
  final AppButtonSize size;
  final bool isLoading;
  final Widget? icon;
  
  const AppButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.style = AppButtonStyle.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.icon,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: _getButtonStyle(context),
      child: _buildButtonContent(),
    );
  }
  
  ButtonStyle _getButtonStyle(BuildContext context) {
    final theme = Theme.of(context);
    final colors = _getColors(theme);
    
    return ElevatedButton.styleFrom(
      backgroundColor: colors.backgroundColor,
      foregroundColor: colors.foregroundColor,
      elevation: colors.elevation,
      padding: _getPadding(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_getBorderRadius()),
      ),
      minimumSize: Size(0, _getHeight()),
    );
  }
  
  Widget _buildButtonContent() {
    if (isLoading) {
      return SizedBox(
        width: _getIconSize(),
        height: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(_getColors(Theme.of(context)).foregroundColor),
        ),
      );
    }
    
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          SizedBox(width: AppSpacing.sm),
          Text(text),
        ],
      );
    }
    
    return Text(text);
  }
}

enum AppButtonStyle {
  primary,
  secondary,
  outline,
  ghost,
  danger,
}

enum AppButtonSize {
  small,
  medium,
  large,
}
```

#### **Input Fields**
```dart
class AppTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  
  const AppTextField({
    Key? key,
    this.label,
    this.hint,
    this.errorText,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.controller,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
  }) : super(key: key);
  
  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }
  
  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
        ],
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          enabled: widget.enabled,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          validator: widget.validator,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: widget.hint,
            errorText: widget.errorText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            filled: true,
            fillColor: _getFillColor(colorScheme),
            border: _getBorder(colorScheme),
            enabledBorder: _getBorder(colorScheme),
            focusedBorder: _getFocusedBorder(colorScheme),
            errorBorder: _getErrorBorder(colorScheme),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
          ),
        ),
      ],
    );
  }
  
  Color _getFillColor(ColorScheme colorScheme) {
    if (!widget.enabled) return colorScheme.surface;
    if (_isFocused) return colorScheme.primary.withOpacity(0.05);
    return colorScheme.surface;
  }
  
  OutlineInputBorder _getBorder(ColorScheme colorScheme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: colorScheme.outline),
    );
  }
  
  OutlineInputBorder _getFocusedBorder(ColorScheme colorScheme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: colorScheme.primary, width: 2),
    );
  }
  
  OutlineInputBorder _getErrorBorder(ColorScheme colorScheme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: colorScheme.error, width: 2),
    );
  }
}
```

### **Molecular Components**

#### **Cards**
```dart
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  
  const AppCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      margin: margin ?? EdgeInsets.all(AppSpacing.md),
      child: Material(
        elevation: elevation ?? 2,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        color: backgroundColor ?? colorScheme.surface,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          child: Padding(
            padding: padding ?? EdgeInsets.all(AppSpacing.lg),
            child: child,
          ),
        ),
      ),
    );
  }
}
```

#### **Navigation Components**
```dart
class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  
  const AppBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),
        selectedLabelStyle: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: theme.textTheme.labelSmall,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services_outlined),
            activeIcon: Icon(Icons.medical_services),
            label: 'AI Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_outlined),
            activeIcon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
```

## Animations & Motion Principles

### **Animation System**
```dart
class AppAnimations {
  // Duration constants
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  
  // Easing curves
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeIn = Curves.easeIn;
  static const Curve bounce = Curves.bounceOut;
  
  // Custom curves for healthcare context
  static const Curve medicalEase = Curves.easeInOutCubic;
  static const Curve gentleEase = Curves.easeOutQuart;
}

// Fade animation widget
class FadeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final double begin;
  final double end;
  
  const FadeAnimation({
    Key? key,
    required this.child,
    this.duration = AppAnimations.normal,
    this.curve = AppAnimations.easeInOut,
    this.begin = 0.0,
    this.end = 1.0,
  }) : super(key: key);
  
  @override
  State<FadeAnimation> createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: widget.begin,
      end: widget.end,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
    _controller.forward();
  }
  
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// Slide animation widget
class SlideAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final Offset begin;
  final Offset end;
  
  const SlideAnimation({
    Key? key,
    required this.child,
    this.duration = AppAnimations.normal,
    this.curve = AppAnimations.easeInOut,
    this.begin = const Offset(0, 1),
    this.end = Offset.zero,
  }) : super(key: key);
  
  @override
  State<SlideAnimation> createState() => _SlideAnimationState();
}

class _SlideAnimationState extends State<SlideAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: widget.begin,
      end: widget.end,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
    _controller.forward();
  }
  
  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

### **Page Transition Animations**
```dart
class AppPageTransitions {
  static Route<T> createRoute<T extends Object?>(
    Widget page, {
    RouteSettings? settings,
    Duration duration = AppAnimations.normal,
    Curve curve = AppAnimations.easeInOut,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: curve,
            )),
            child: child,
          ),
        );
      },
    );
  }
  
  static Route<T> createSlideRoute<T extends Object?>(
    Widget page, {
    RouteSettings? settings,
    Duration duration = AppAnimations.normal,
    Curve curve = AppAnimations.easeInOut,
    Offset begin = const Offset(1, 0),
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: begin,
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: curve,
          )),
          child: child,
        );
      },
    );
  }
}
```

## Screen Design & Layouts

### **Screen Categories**

#### **1. Authentication Screens**
- **Login Page**: Clean, focused design with prominent login form
- **Registration Page**: Step-by-step registration with progress indicators
- **Forgot Password**: Simple recovery form with clear instructions

#### **2. Dashboard Screens**
- **Main Dashboard**: Overview of appointments, AI services, and quick actions
- **Patient Dashboard**: Personalized health overview and recommendations
- **Doctor Dashboard**: Patient management and consultation tools

#### **3. AI Service Screens**
- **Symptom Checker**: Conversational interface with progress indicators
- **Doctor Recommendations**: Card-based layout with filtering options
- **Booking Assistant**: Step-by-step booking flow with AI assistance

#### **4. Healthcare Management Screens**
- **Appointments List**: Timeline view with filtering and search
- **Appointment Details**: Comprehensive appointment information
- **Medical Records**: Secure document viewer with annotation tools

#### **5. Communication Screens**
- **Chat Interface**: Modern messaging design with AI indicators
- **Notifications**: Categorized notification center
- **Settings**: Organized preference panels

### **Responsive Layout Templates**
```dart
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  
  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppLayout.desktopBreakpoint) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= AppLayout.tabletBreakpoint) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}

class DashboardLayout extends StatelessWidget {
  final Widget content;
  final Widget? sidebar;
  final Widget? header;
  
  const DashboardLayout({
    Key? key,
    required this.content,
    this.sidebar,
    this.header,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (header != null) header!,
          Expanded(
            child: Row(
              children: [
                if (sidebar != null) ...[
                  sidebar!,
                  VerticalDivider(width: 1),
                ],
                Expanded(child: content),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

## Accessibility Guidelines

### **Accessibility Implementation**
```dart
class AccessibleWidget extends StatelessWidget {
  final Widget child;
  final String? semanticsLabel;
  final String? semanticsHint;
  final bool excludeSemantics;
  final bool? enabled;
  
  const AccessibleWidget({
    Key? key,
    required this.child,
    this.semanticsLabel,
    this.semanticsHint,
    this.excludeSemantics = false,
    this.enabled,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      hint: semanticsHint,
      enabled: enabled ?? true,
      excludeSemantics: excludeSemantics,
      child: child,
    );
  }
}

// Accessibility extensions
extension AccessibilityExtensions on Widget {
  Widget accessible({
    String? label,
    String? hint,
    bool? enabled,
  }) {
    return AccessibleWidget(
      semanticsLabel: label,
      semanticsHint: hint,
      enabled: enabled,
      child: this,
    );
  }
  
  Widget withTooltip(String message) {
    return Tooltip(
      message: message,
      child: this,
    );
  }
}
```

### **Accessibility Checklist**
- **Color Contrast**: Minimum 4.5:1 ratio for normal text, 3:1 for large text
- **Touch Targets**: Minimum 44x44 points for interactive elements
- **Screen Reader Support**: Proper semantics labels and hints
- **Keyboard Navigation**: Full keyboard accessibility for web
- **Focus Management**: Clear focus indicators and logical tab order
- **Text Scaling**: Support for up to 200% text scaling
- **Motion Sensitivity**: Respect reduced motion preferences

## Design Handoff Structure

### **Figma Integration**
```dart
// Design tokens from Figma
class DesignTokens {
  // Colors from Figma
  static const Map<String, Color> colors = {
    'primary-50': Color(0xFFEFF6FF),
    'primary-500': Color(0xFF3B82F6),
    'primary-900': Color(0xFF1E3A8A),
    // ... more colors
  };
  
  // Spacing from Figma
  static const Map<String, double> spacing = {
    'xs': 4.0,
    'sm': 8.0,
    'md': 16.0,
    'lg': 24.0,
    'xl': 32.0,
    // ... more spacing
  };
  
  // Typography from Figma
  static const Map<String, TextStyle> typography = {
    'heading-1': TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      height: 1.2,
    ),
    'body-1': TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      height: 1.5,
    ),
    // ... more typography
  };
}
```

### **Component Documentation**
```dart
// Component documentation with examples
class ComponentDocumentation {
  static const Map<String, String> componentDescriptions = {
    'AppButton': 'Primary button component with multiple variants and states',
    'AppTextField': 'Form input component with validation and accessibility support',
    'AppCard': 'Container component for grouping related content',
    // ... more components
  };
  
  static const Map<String, List<String>> componentVariants = {
    'AppButton': ['primary', 'secondary', 'outline', 'ghost', 'danger'],
    'AppTextField': ['default', 'with-label', 'with-icon', 'multiline'],
    'AppCard': ['default', 'elevated', 'outlined', 'filled'],
    // ... more variants
  };
}
```

This comprehensive design system provides a solid foundation for creating a consistent, accessible, and beautiful user experience across the AI Doctor System Flutter client. The system is designed to scale with the application while maintaining healthcare-specific design principles and cross-platform compatibility.
