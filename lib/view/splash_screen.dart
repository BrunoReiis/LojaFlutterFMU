import 'package:flutter/material.dart';
import 'package:lojaflutter/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:lojaflutter/view/main_screen.dart';
import 'package:lojaflutter/view/onboarding_screen.dart';
import 'package:lojaflutter/view/signin_screen.dart';
import 'package:lojaflutter/view/widgets/nexus_logo.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final AuthController authControler = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    // Navigate on auth after 2.5 seconds
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (authControler.isFirstTime) {
        Get.off(() => OnboardingScreen());
      } else if (authControler.isLoggedIn) {
        Get.off(() => MainScreen());
      } else {
        Get.off(() => SigninScreen());
      }
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF7C3AED), // Roxo principal
              Color(0xFF6D28D9), // Roxo mais escuro
              Color(0xFF5B21B6), // Roxo ainda mais escuro
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated background blobs
            Positioned(
              top: -100,
              right: -100,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 2000),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(50 * (1 - value), -50 * (1 - value)),
                    child: Opacity(
                      opacity: (1 - value) * 0.3,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              left: -50,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 2200),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(-50 * (1 - value), 50 * (1 - value)),
                    child: Opacity(
                      opacity: (1 - value) * 0.3,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),
            ),

            // Main Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with glow effect
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.8, end: 1.0),
                    duration: const Duration(milliseconds: 1200),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Opacity(
                          opacity: value,
                          child: Container(
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const NexusLogo(
                              size: 56,
                              color: Color(0xFF7C3AED),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),

                  // Brand Text with staggered animation
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 1400),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        const Text(
                          'Nexus',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Store',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 36,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),

                  // Loading indicator
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 1600),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: child,
                      );
                    },
                    child: SizedBox(
                      width: 8,
                      height: 8,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withValues(alpha: 0.7),
                        ),
                        strokeWidth: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom tagline
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 1800),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 10 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: Column(
                  children: [
                    Text(
                      'Created by NexusInc',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 15,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 40,
                      height: 1.5,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

