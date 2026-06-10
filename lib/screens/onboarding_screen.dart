import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    bool isWide = !Responsive.isMobile(context);
    double hPad = Responsive.horizontalPadding(context);
    double fs = Responsive.fontScale(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background decorative circles
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryColor.withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -120,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.accentColor.withValues(alpha: 0.08),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth(context)),
                child: isWide
                    // ── TABLET / DESKTOP: Side-by-side layout ──
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 40),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Left: Illustration
                            Expanded(child: _buildIllustration(context)),
                            const SizedBox(width: 60),
                            // Right: Text + Button
                            Expanded(child: _buildContent(context, isDark, fs)),
                          ],
                        ),
                      )
                    // ── MOBILE: Vertical stacked layout ──
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              const SizedBox(height: 40),
                              _buildIllustration(context),
                              const SizedBox(height: 40),
                              _buildContent(context, isDark, fs),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration(BuildContext context) {
    double size = Responsive.isMobile(context) ? 180 : 220;
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size + 80,
            height: size + 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.primaryColor.withValues(alpha: 0.18),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Container(
            width: size + 40,
            height: size + 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.primaryColor.withValues(alpha: 0.15),
                width: 2,
              ),
            ),
          ),
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppTheme.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Icon(Icons.restaurant_menu_rounded,
                size: size * 0.46, color: Colors.white),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: _floatingIcon(Icons.local_pizza_rounded, AppTheme.accentColor),
          ),
          Positioned(
            bottom: 30,
            left: 15,
            child: _floatingIcon(Icons.lunch_dining_rounded, Colors.orangeAccent),
          ),
          Positioned(
            bottom: 50,
            right: 20,
            child: _floatingIcon(Icons.local_drink_rounded, AppTheme.secondaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDark, double fs) {
    bool isWide = !Responsive.isMobile(context);
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: isWide ? 32 : 24, vertical: isWide ? 40 : 32),
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.darkCard.withValues(alpha: 0.75)
            : Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(AppTheme.radiusExtraLarge),
        boxShadow: AppTheme.getShadow(context),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.03),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          // Tag
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'WELCOME TO GOURMETGO',
              style: TextStyle(
                fontSize: 10 * fs,
                letterSpacing: 1.5,
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            'Fast Delivery,\nDelicious Taste.',
            textAlign: isWide ? TextAlign.left : TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 28 * fs,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                ),
          ),
          const SizedBox(height: 12),

          // Description
          Text(
            'Discover your favorite food from premium local restaurants, prepared fresh and delivered right away.',
            textAlign: isWide ? TextAlign.left : TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 13 * fs,
                  height: 1.6,
                ),
          ),
          const SizedBox(height: 28),

          // Button
          GestureDetector(
            onTap: () => Navigator.pushReplacementNamed(context, '/home'),
            child: Container(
              width: isWide ? 260 : double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius:
                    BorderRadius.circular(AppTheme.radiusMedium),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Get Started',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontSize: 16 * fs,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded,
                        color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _floatingIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Icon(icon, color: color, size: 16),
    );
  }
}
