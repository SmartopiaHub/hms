// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'base.dart';
import '../l10n/app_localizations.dart';

class HelperPage extends StatelessPageBase {
  const HelperPage({super.key});

  @override
  Widget buildContent(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
          //padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.school,
                          size: 80,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          localizations.appTitle,
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          localizations.appDescription,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Introduction
                  _buildSection(
                    context,
                    icon: Icons.info_outline,
                    title: localizations.helperWhatIsThis,
                    content: localizations.helperIntroduction,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // For Parents Section
                  _buildGuideSection(
                    context,
                    icon: Icons.people,
                    iconColor: Colors.blue,
                    title: localizations.helperForParents,
                    steps: [
                      _GuideStep(
                        icon: Icons.person_add,
                        title: localizations.helperParentStep1Title,
                        description: localizations.helperParentStep1Desc,
                      ),
                      _GuideStep(
                        icon: Icons.assignment,
                        title: localizations.helperParentStep2Title,
                        description: localizations.helperParentStep2Desc,
                      ),
                      _GuideStep(
                        icon: Icons.schedule,
                        title: localizations.helperParentStep3Title,
                        description: localizations.helperParentStep3Desc,
                      ),
                      _GuideStep(
                        icon: Icons.notifications,
                        title: localizations.helperParentStep4Title,
                        description: localizations.helperParentStep4Desc,
                      ),
                      _GuideStep(
                        icon: Icons.grade,
                        title: localizations.helperParentStep5Title,
                        description: localizations.helperParentStep5Desc,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // For Children Section
                  _buildGuideSection(
                    context,
                    icon: Icons.child_care,
                    iconColor: Colors.green,
                    title: localizations.helperForChildren,
                    steps: [
                      _GuideStep(
                        icon: Icons.login,
                        title: localizations.helperChildStep1Title,
                        description: localizations.helperChildStep1Desc,
                      ),
                      _GuideStep(
                        icon: Icons.list,
                        title: localizations.helperChildStep2Title,
                        description: localizations.helperChildStep2Desc,
                      ),
                      _GuideStep(
                        icon: Icons.upload_file,
                        title: localizations.helperChildStep3Title,
                        description: localizations.helperChildStep3Desc,
                      ),
                      _GuideStep(
                        icon: Icons.check_circle,
                        title: localizations.helperChildStep4Title,
                        description: localizations.helperChildStep4Desc,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Key Features
                  _buildSection(
                    context,
                    icon: Icons.star,
                    title: localizations.helperKeyFeatures,
                    content: '',
                    child: Column(
                      children: [
                        _buildFeatureItem(
                          context,
                          Icons.repeat,
                          localizations.helperFeature1,
                        ),
                        _buildFeatureItem(
                          context,
                          Icons.cloud,
                          localizations.helperFeature2,
                        ),
                        _buildFeatureItem(
                          context,
                          Icons.devices,
                          localizations.helperFeature3,
                        ),
                        _buildFeatureItem(
                          context,
                          Icons.language,
                          localizations.helperFeature4,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Footer
                  Center(
                    child: Text(
                      localizations.helperFooter,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
    );
  }
  
  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
    Widget? child,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: BlurryContainer(
        blur: 20,
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withAlpha(180),
        child: Padding(
          padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary, size: 28),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (content.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                content,
                style: theme.textTheme.bodyLarge,
              ),
            ],
            if (child != null) ...[
              const SizedBox(height: 16),
              child,
            ],
          ],
        ),
      ),
      )
    );
  }
  
  Widget _buildGuideSection(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required List<_GuideStep> steps,
  }) {
    final theme = Theme.of(context);
    
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 18),
      child: BlurryContainer(
      blur: 20,
      borderRadius: BorderRadius.circular(16),
      color: Colors.white.withAlpha(180),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 28),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ...steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < steps.length - 1 ? 20 : 0,
                ),
                child: _buildStepItem(context, index + 1, step),
              );
            }).toList(),
          ],
        ),
      ),
    ),
    );
  }
  
  Widget _buildStepItem(BuildContext context, int number, _GuideStep step) {
    final theme = Theme.of(context);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(step.icon, size: 20, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      step.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                step.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildFeatureItem(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.secondary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}

class _GuideStep {
  final IconData icon;
  final String title;
  final String description;
  
  const _GuideStep({
    required this.icon,
    required this.title,
    required this.description,
  });
}
