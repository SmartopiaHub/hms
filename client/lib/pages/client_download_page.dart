// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../server.dart';
import 'package:url_launcher/url_launcher.dart';
import 'base.dart';
import '../widgets/card.dart';

class ClientDownloadPage extends StatefulWidget {
  const ClientDownloadPage({super.key});

  @override
  State<ClientDownloadPage> createState() => _ClientDownloadPageState();
}

class _ClientDownloadPageState extends PageBaseState<ClientDownloadPage> {
  
  Widget _buildDownloadCard({
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    required String url,
  }) {
    return buildCard(
      context,
      blur: 20,
      color: Colors.white.withAlpha(50),
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: iconColor.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 48,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.download),
              label: Text(localizations.downloadClients),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: iconColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final serverUrl = await getServerUrl();
                final uri = Uri.parse('$serverUrl$url');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
              },
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget buildContent(BuildContext context) {
    if (!kIsWeb) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Downloads are only available on the web version',
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              localizations.downloadClients,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              locale.languageCode == 'zh' 
                ? '下载适用于您设备的客户端应用程序'
                : 'Download the client application for your device',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            if (isWideScreen || isTablet)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildDownloadCard(
                      title: 'Android',
                      description: locale.languageCode == 'zh'
                          ? '适用于安卓手机和平板电脑'
                          : 'For Android phones and tablets',
                      icon: Icons.android,
                      iconColor: const Color(0xFF3DDC84),
                      url: '/clients/android',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDownloadCard(
                      title: 'macOS',
                      description: locale.languageCode == 'zh'
                          ? '适用于苹果电脑'
                          : 'For Mac computers',
                      icon: Icons.apple,
                      iconColor: const Color(0xFF000000),
                      url: '/clients/macos',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDownloadCard(
                      title: 'Windows',
                      description: locale.languageCode == 'zh'
                          ? '适用于Windows电脑'
                          : 'For Windows computers',
                      icon: Icons.window,
                      iconColor: const Color(0xFF0078D4),
                      url: '/clients/smartopia_learning_windows_latest.zip',
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  _buildDownloadCard(
                    title: 'Android',
                    description: locale.languageCode == 'zh'
                        ? '适用于安卓手机和平板电脑'
                        : 'For Android phones and tablets',
                    icon: Icons.android,
                    iconColor: const Color(0xFF3DDC84),
                    url: '/clients/smartopia_learning_android_latest.apk',
                  ),
                  const SizedBox(height: 16),
                  _buildDownloadCard(
                    title: 'macOS',
                    description: locale.languageCode == 'zh'
                        ? '适用于苹果电脑'
                        : 'For Mac computers',
                    icon: Icons.apple,
                    iconColor: const Color(0xFF000000),
                    url: '/clients/smartopia_learning_macos_latest.dmg',
                  ),
                  const SizedBox(height: 16),
                  _buildDownloadCard(
                    title: 'Windows',
                    description: locale.languageCode == 'zh'
                        ? '适用于Windows电脑'
                        : 'For Windows computers',
                    icon: Icons.window,
                    iconColor: const Color(0xFF0078D4),
                    url: '/clients/smartopia_learning_windows_latest.zip',
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
