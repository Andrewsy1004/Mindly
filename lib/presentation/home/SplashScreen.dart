import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mindly/shared/shared.dart';

class SplashScreen extends StatefulWidget {
  static const name = 'splash-screen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Controladores de animación
  late final AnimationController _mainController;
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _rippleController;

  // Animaciones
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _logoRotate;
  late final Animation<Offset> _logoSlide;
  late final Animation<double> _backgroundFade;
  late final Animation<double> _ripple;

  // Estado de las letras
  final String appName = "Mindly";
  final List<double> _letterOpacities = [];
  final List<double> _letterScales = [];
  final List<Color> _letterColors = [];
  int _currentLetterIndex = 0;
  Timer? _letterTimer;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initLetters();
    _startSequence();
  }

  void _initAnimations() {
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Configurar animaciones
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _logoRotate = Tween<double>(begin: -0.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOutBack),
      ),
    );

    _logoSlide = Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _logoController,
            curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
          ),
        );

    _backgroundFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_mainController);
    _ripple = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );
  }

  void _initLetters() {
    _letterOpacities.addAll(List.filled(appName.length, 0.0));
    _letterScales.addAll(List.filled(appName.length, 0.5));

    _letterColors.addAll(
      List.generate(appName.length, (index) {
        final hue = (index * 30.0) % 360;
        return HSLColor.fromAHSL(1.0, hue, 0.3, 0.9).toColor();
      }),
    );
  }

  void _startSequence() async {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;

    // Secuencia de animaciones
    _rippleController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();
    _startLetterAnimation();

    // Navegar después de las animaciones
    await Future.delayed(const Duration(milliseconds: 3500));
    if (!mounted) return;

    _navigateToNext();
  }

  void _startLetterAnimation() {
    _letterTimer = Timer.periodic(const Duration(milliseconds: 120), (timer) {
      if (_currentLetterIndex < appName.length && mounted) {
        setState(() {
          _letterOpacities[_currentLetterIndex] = 1.0;
          _letterScales[_currentLetterIndex] = 1.0;
          _currentLetterIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _navigateToNext() async {
    if (!mounted) return;

    _letterTimer?.cancel();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    final isLoggedIn = await KeyValueStorageServices().isUserLoggedIn();

    if (isLoggedIn) {
      context.go('/home/0'); // Ya está logueado, va al home
    } else {
      context.go('/signup'); // No está logueado, va al signup
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _logoController.dispose();
    _textController.dispose();
    _rippleController.dispose();
    _letterTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([_mainController, _rippleController]),
        builder: (context, child) {
          return Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                    Colors.blue.shade900,
                    Colors.purple.shade700,
                    _backgroundFade.value * 0.3,
                  )!,
                  Color.lerp(
                    Colors.blue.shade700,
                    Colors.blue.shade500,
                    _backgroundFade.value * 0.5,
                  )!,
                  Color.lerp(
                    Colors.blue.shade500,
                    Colors.cyan.shade300,
                    _backgroundFade.value * 0.4,
                  )!,
                ],
              ),
            ),
            child: Stack(
              children: [
                // Efecto ripple de fondo
                Positioned.fill(
                  child: CustomPaint(painter: RipplePainter(_ripple.value)),
                ),

                // Contenido principal
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo animado
                      AnimatedBuilder(
                        animation: _logoController,
                        builder: (context, child) {
                          return SlideTransition(
                            position: _logoSlide,
                            child: Transform.rotate(
                              angle: _logoRotate.value * math.pi,
                              child: Transform.scale(
                                scale: _logoScale.value,
                                child: FadeTransition(
                                  opacity: _logoFade,
                                  child: _buildLogo(),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 40),

                      // Texto animado
                      AnimatedBuilder(
                        animation: _textController,
                        builder: (context, child) {
                          return FadeTransition(
                            opacity: _textController,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(appName.length, (index) {
                                return _buildLetter(index);
                              }),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 60),

                      // Indicador de carga
                      _buildLoader(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(80),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(80),
        child: Image.asset(
          'assets/icon.png',
          width: 160,
          height: 160,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(80),
              ),
              child: const Icon(Icons.psychology, size: 80, color: Colors.blue),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLetter(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.elasticOut,
      transform: Matrix4.identity()
        ..scale(_letterScales[index])
        ..rotateZ(_letterOpacities[index] == 1.0 ? 0 : -0.1),
      child: AnimatedOpacity(
        opacity: _letterOpacities[index],
        duration: const Duration(milliseconds: 300),
        child: Text(
          appName[index],
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 2.0,
            shadows: [
              Shadow(
                color: _letterColors[index].withOpacity(0.6),
                blurRadius: 10,
                offset: const Offset(2, 2),
              ),
              const Shadow(
                color: Colors.black26,
                blurRadius: 20,
                offset: Offset(4, 4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoader() {
    return FadeTransition(
      opacity: _textController,
      child: SizedBox(
        width: 30,
        height: 30,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.white.withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}

class RipplePainter extends CustomPainter {
  final double progress;

  RipplePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.max(size.width, size.height) * 0.6;

    for (int i = 0; i < 3; i++) {
      final radius = maxRadius * progress * (1.0 - i * 0.3);
      final opacity = (1.0 - progress) * (0.1 - i * 0.02);

      if (radius > 0 && opacity > 0) {
        final paint = Paint()
          ..color = Colors.white.withOpacity(opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;

        canvas.drawCircle(center, radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(RipplePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
