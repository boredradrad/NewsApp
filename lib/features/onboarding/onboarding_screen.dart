import 'package:flutter/material.dart';
import 'package:news_app/core/constants/storage_key.dart';
import 'package:news_app/features/auth/sign_in_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/models/on_boarding_data_model.dart';
import '../../core/services/preferences_manager.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  /// TODO-Done : Task - Create Model For This List
  final List<OnBoardingDataModel> onboardingData = [
    OnBoardingDataModel(image : 'assets/images/onboarding1.png',
      title: 'Update for new features',
      desc: "You deserve the best experience possible. That's why we've added new features and services to our app. Update now and see for yourself.",
    ),
    OnBoardingDataModel(image : 'assets/images/onboarding2.png',
      title: 'Update for new features',
      desc: "You deserve the best experience possible. That's why we've added new features and services to our app. Update now and see for yourself.",
    ),
    OnBoardingDataModel(image : 'assets/images/onboarding3.png',
      title: 'Update for new features',
      desc: "You deserve the best experience possible. That's why we've added new features and services to our app. Update now and see for yourself.",
    ),
  ];

  void _onNext() {
    if (_currentPage < onboardingData.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  Future<void> _finishOnboarding() async {
    /// TODO-Done : Task - Use Preference Manager And don't use hard coded values like [onboarding_complete]
    await PreferencesManager().setBool(StorageKey.isBoardingComplete, true);
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return SignInScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// TODO-Done : Task - Use from theme data
      appBar: AppBar(
        /// TODO-Done : Task - Add This values on theme data
        actions: [
          if (_currentPage < onboardingData.length - 1)
            TextButton(
              onPressed: _finishOnboarding,
              child: const Text(
                'Skip',
                style: TextStyle(color: Color(0xFFD32F2F), fontSize: 18),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: onboardingData.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                final data = onboardingData[index];
                return Column(
                  children: [
                    const SizedBox(height: 16),

                    /// TODO-Done : Task - Use This From Model
                    Image.asset(data.image!, height: 320, fit: BoxFit.contain),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        /// TODO-Done : Task - Use This From Model
                        data.title!,
                        textAlign: TextAlign.center,

                        /// TODO-Done : Task - Add This To Theme Data
                        style:Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        /// TODO-Done : Task - Use This From Model
                        data.desc!,
                        textAlign: TextAlign.center,

                        /// TODO-Done : Task - Add This To Theme Data
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              onboardingData.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 24),
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color:
                      _currentPage == index
                          ? const Color(0xFFC53030)
                          : Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                /// TODO-Done : Task - Add This To Theme Data
                onPressed: _onNext,
                child: Text(
                  _currentPage == onboardingData.length - 1 ? 'Get Started' : 'Next',
                  style: Theme.of(context).textTheme.headlineSmall
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
