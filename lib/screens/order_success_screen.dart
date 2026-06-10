import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';

class OrderSuccessScreen extends StatefulWidget {
  const OrderSuccessScreen({super.key});

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  int _trackingStep = 0;
  Timer? _timer;

  final List<Map<String, dynamic>> _steps = [
    {'title': 'Order Placed', 'subtitle': 'We have received your order', 'icon': Icons.assignment_turned_in_rounded},
    {'title': 'Preparing Food', 'subtitle': 'The chef is preparing your dish', 'icon': Icons.cookie_rounded},
    {'title': 'Out for Delivery', 'subtitle': 'Driver is heading your way', 'icon': Icons.delivery_dining_rounded},
    {'title': 'Arrived', 'subtitle': 'Enjoy your meal!', 'icon': Icons.sports_motorsports_rounded},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CartProvider>(context, listen: false).clearCart();
    });
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_trackingStep < 3) {
        setState(() => _trackingStep++);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    bool isWide = !Responsive.isMobile(context);
    double hPad = Responsive.horizontalPadding(context);
    double fs = Responsive.fontScale(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Status', style: TextStyle(fontSize: 20 * fs)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () =>
              Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: Responsive.maxContentWidth(context)),
          child: isWide
              // ── WIDE: Two-column layout ──
              ? Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: hPad, vertical: 24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left: success badge + map
                      Expanded(
                        child: Column(
                          children: [
                            _buildSuccessBadge(context, fs),
                            const SizedBox(height: 24),
                            _buildMapTracker(context, isDark, fs),
                          ],
                        ),
                      ),
                      const SizedBox(width: 48),
                      // Right: tracker timeline + back button
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Order Status',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                          fontSize: 20 * fs,
                                          fontWeight: FontWeight.bold)),
                              const SizedBox(height: 20),
                              _buildTimeline(context, isDark, fs),
                              const SizedBox(height: 24),
                              _buildBackButton(context, isDark, fs),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              // ── MOBILE: Stacked ──
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        _buildSuccessBadge(context, fs),
                        const SizedBox(height: 24),
                        _buildMapTracker(context, isDark, fs),
                        const SizedBox(height: 32),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Order Status',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                      fontSize: 18 * fs,
                                      fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 16),
                        _buildTimeline(context, isDark, fs),
                        const SizedBox(height: 20),
                        _buildBackButton(context, isDark, fs),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildSuccessBadge(BuildContext context, double fs) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 120, height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.secondaryColor.withValues(alpha: 0.12),
              ),
            ),
            Container(
              width: 90, height: 90,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF34D399), Color(0xFF059669)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 50),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text('Order Placed Successfully!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: 22 * fs, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('Your order #GG-8742 is on its way to you.',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 13 * fs)),
      ],
    );
  }

  Widget _buildMapTracker(BuildContext context, bool isDark, double fs) {
    return Container(
      height: 160,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.getShadow(context),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              child: CustomPaint(
                painter: MapMockupPainter(
                    progress: _trackingStep / 3.0, isDark: isDark),
              ),
            ),
          ),
          Positioned(
            top: 8, left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.directions_bike_rounded,
                      color: AppTheme.primaryColor, size: 14),
                  const SizedBox(width: 4),
                  Text('Live Tracker',
                      style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 10 * fs,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 8, right: 8,
            child: Text(
              _trackingStep == 3 ? 'Arrived!' : 'Est. 20-30 mins',
              style: TextStyle(
                  fontSize: 11 * fs,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(BuildContext context, bool isDark, double fs) {
    return Column(
      children: List.generate(_steps.length, (index) {
        final step = _steps[index];
        final bool isCompleted = index <= _trackingStep;
        final bool isActive = index == _trackingStep;

        return IntrinsicHeight(
          child: Row(
            children: [
              Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? AppTheme.primaryColor
                          : (isDark
                              ? Colors.white.withValues(alpha: 0.06)
                              : Colors.black.withValues(alpha: 0.05)),
                      boxShadow: isCompleted
                          ? [
                              BoxShadow(
                                color: AppTheme.primaryColor
                                    .withValues(alpha: 0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              )
                            ]
                          : null,
                    ),
                    child: Icon(step['icon'],
                        color: isCompleted ? Colors.white : Colors.grey,
                        size: 18),
                  ),
                  if (index < _steps.length - 1)
                    Expanded(
                      child: Container(
                        width: 2,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        color: isCompleted
                            ? AppTheme.primaryColor
                            : (isDark ? Colors.white10 : Colors.black12),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(step['title'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15 * fs,
                              color: isCompleted
                                  ? (isDark ? Colors.white : Colors.black87)
                                  : Colors.grey)),
                      const SizedBox(height: 4),
                      Text(step['subtitle'],
                          style: TextStyle(
                              fontSize: 12 * fs,
                              color: isCompleted
                                  ? (isActive
                                      ? AppTheme.primaryColor
                                      : (isDark
                                          ? AppTheme.darkTextSecondary
                                          : AppTheme.lightTextSecondary))
                                  : Colors.grey[400])),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBackButton(
      BuildContext context, bool isDark, double fs) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(
            color: isDark
                ? Colors.white10
                : Colors.black.withValues(alpha: 0.06),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text('Back to Home',
              style: TextStyle(
                color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16 * fs,
              )),
        ),
      ),
    );
  }
}

class MapMockupPainter extends CustomPainter {
  final double progress;
  final bool isDark;

  MapMockupPainter({required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final streetPaint = Paint()
      ..color = isDark
          ? Colors.white.withValues(alpha: 0.08)
          : Colors.black.withValues(alpha: 0.06)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final activeRoutePaint = Paint()
      ..color = AppTheme.primaryColor
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width * 0.15, size.height * 0.7);
    path.cubicTo(
      size.width * 0.35, size.height * 0.8,
      size.width * 0.45, size.height * 0.2,
      size.width * 0.6, size.height * 0.35,
    );
    path.lineTo(size.width * 0.85, size.height * 0.45);

    canvas.drawPath(path, streetPaint);

    final pathMetrics = path.computeMetrics();
    if (pathMetrics.isNotEmpty) {
      final metric = pathMetrics.first;
      final extractPath =
          metric.extractPath(0.0, metric.length * progress);
      canvas.drawPath(extractPath, activeRoutePaint);

      final tangent =
          metric.getTangentForOffset(metric.length * progress);
      if (tangent != null) {
        final position = tangent.position;
        canvas.drawCircle(
            position,
            16,
            Paint()
              ..color = AppTheme.primaryColor.withValues(alpha: 0.25)
              ..style = PaintingStyle.fill);
        canvas.drawCircle(
            position,
            8,
            Paint()
              ..color = AppTheme.primaryColor
              ..style = PaintingStyle.fill);
      }
    }

    canvas.drawCircle(
        Offset(size.width * 0.15, size.height * 0.7),
        6,
        Paint()
          ..color = AppTheme.secondaryColor
          ..style = PaintingStyle.fill);
    canvas.drawCircle(
        Offset(size.width * 0.85, size.height * 0.45),
        6,
        Paint()
          ..color = AppTheme.accentColor
          ..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant MapMockupPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.isDark != isDark;
}
