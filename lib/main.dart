import 'package:agmotest_banking/di/injector.dart';
import 'package:agmotest_banking/routes/appRouter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupInjector();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final goRouter = ref.watch(goRouterProvider);
    final sessionManagerNotifier = ref.read(sessionStateNotifier.notifier);
    final sessionStateForDisplay = ref.watch(sessionStateNotifier);

    return Listener(
      onPointerDown: (_) {
        sessionManagerNotifier.resetInactivityTimer();
      },
      onPointerSignal: (_) {
        sessionManagerNotifier.resetInactivityTimer();
      },
      onPointerMove: (_) {
        sessionManagerNotifier.resetInactivityTimer();
      },
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp.router(
            title: 'Flutter Clean Auth GetIt & Riverpod',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                titleTextStyle: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
                actionsIconTheme: const IconThemeData(color: Colors.white),
              ),
            ),
            routerConfig: goRouter,
            builder: (context, router) {
              return Stack(
                children: [
                  router!,
                  if (sessionStateForDisplay.currentRoute != '/login' &&
                      sessionStateForDisplay.inactivityRemainingSeconds > 0)
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 5,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'Session: ${sessionStateForDisplay.inactivityRemainingSeconds}s',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
