import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/buttons/p_primary_button.dart';

class EmailVerifiedScreen extends StatefulWidget {
  const EmailVerifiedScreen({super.key});

  @override
  State<EmailVerifiedScreen> createState() => _EmailVerifiedScreenState();
}

class _EmailVerifiedScreenState extends State<EmailVerifiedScreen> {
  PButtonState _buttonState = PButtonState.idle;

  void _continue() {
    if (_buttonState == PButtonState.loading) return;
    setState(() => _buttonState = PButtonState.loading);
    Future<void>.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      context.go(Routes.riskAppetite);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 390),
          child: Stack(
            children: [
              Positioned(
                left: 95,
                top: 166,
                child: SizedBox(
                  key: const ValueKey('email-verified-illustration'),
                  width: 200,
                  height: 200,
                  child: SvgPicture.asset(
                    'assets/images/email-verified-illustration.svg',
                    fit: BoxFit.contain,
                  ),
                ).animate().fadeIn(duration: 260.ms).scale(
                      begin: const Offset(0.88, 0.88),
                      end: const Offset(1, 1),
                      curve: Curves.easeOutBack,
                    ),
              ),
              const Positioned(
                key: ValueKey('email-verified-content'),
                left: 23.5,
                top: 438,
                child: _VerifiedContent(),
              ),
              Positioned(
                key: const ValueKey('email-verified-primary-action'),
                left: 24,
                right: 24,
                top: 707,
                child: PPrimaryButton(
                  label: 'Set up my account',
                  state: _buttonState,
                  onPressed: _continue,
                  height: 44,
                  borderRadius: BorderRadius.circular(40),
                  textStyle: AppTypography.buttonLg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VerifiedContent extends StatelessWidget {
  const _VerifiedContent();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 343,
      child: Column(
        children: [
          SizedBox(
            key: const ValueKey('email-verified-copy'),
            width: 342,
            child: Column(
              children: [
                Text(
                  "You're all set",
                  textAlign: TextAlign.center,
                  style: AppTypography.h2.copyWith(
                    color: AppColors.textHeading,
                    fontFamily: 'Orbitron',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 32 / 24,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 4),
                Text.rich(
                  const TextSpan(
                    children: [
                      TextSpan(text: 'Your email is verified and your '),
                      TextSpan(
                        text: '14-day free trial',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      TextSpan(
                        text:
                            ' is active. Next, set your risk appetite and connect your exchange.',
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textHeading,
                    fontWeight: FontWeight.w400,
                    height: 20 / 14,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            key: const ValueKey('email-verified-trial-callout'),
            width: 343,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE5EEFF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF99BAFF)),
            ),
            child: Text(
              'Explore Poise for 14 days, or up to 10 trades—whichever comes first.',
              textAlign: TextAlign.center,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.brand700,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 18 / 12,
                letterSpacing: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
