import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import '../logic/welcome_viewmodel.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late WelcomeViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = WelcomeViewModel();
    // Delay init sampai after first frame supaya context aman digunakan
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.init(context);
    });
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WelcomeViewModel>.value(
      value: viewModel,
      child: Consumer<WelcomeViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return Scaffold(
              body: Container(color: AppColors.primary),
            );
          }

          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, Colors.red.shade900],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: vm.pageController,
                        onPageChanged: vm.onPageChanged,
                        itemCount: vm.pages.length,
                        itemBuilder: (ctx, i) {
                          final page = vm.pages[i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset(
                                  page['lottie']!,
                                  height: 250,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 30),
                                Text(
                                  page['title']!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  page['description']!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Colors.white70),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // Page indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        vm.pages.length,
                        (idx) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: vm.currentPage == idx ? 24 : 8,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Get Started button only pada page terakhir
                    vm.currentPage == vm.pages.length - 1
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 40),
                            child: ElevatedButton(
                              onPressed: () => vm.onGetStarted(context),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                'Get Started',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(height: 50),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
