import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:igcse_learning_hub/src/shared/presentation/widgets/rounded_icon_button.dart';
import 'package:igcse_learning_hub/src/theme/design_tokens.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _index = 0;

  static const _pages = [
    _OnboardingContent(
      title: 'Practice IGCSE Anywhere',
      description:
          'Access official exam-style practice papers anytime, anywhere.',
    ),
    _OnboardingContent(
      title: 'AI Study Assistant',
      description: 'Get personalised guidance and smart tips powered by AI.',
    ),
    _OnboardingContent(
      title: 'Get Certified Ready',
      description: 'Be confident and fully prepared for your IGCSE exams.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_index < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.push('/auth/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () => context.push('/auth/welcome'),
                  child: const Text('Skip'),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (value) => setState(() => _index = value),
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          page.description,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 80),
                      ],
                    );
                  },
                ),
              ),
              Row(
                children: [
                  _PageIndicator(activeIndex: _index, total: _pages.length),
                  const Spacer(),
                  RoundedIconButton(
                    icon: Icons.arrow_forward_rounded,
                    onPressed: _next,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingContent {
  const _OnboardingContent({required this.title, required this.description});

  final String title;
  final String description;
}



class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.activeIndex, required this.total});

  final int activeIndex;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (index) {
        final isActive = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          margin: const EdgeInsets.only(right: 6),
          height: 8,
          width: isActive ? 18 : 8,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary
                : AppColors.primary.withAlpha(89),
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }
}
