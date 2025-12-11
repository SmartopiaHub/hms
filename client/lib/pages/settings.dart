// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'package:flutter/material.dart';
import '../widgets/notification_settings.dart';
import 'user_list_page.dart';
import 'server_settings.dart';
import 'admin_settings.dart';
import 'base.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends PageBaseState<SettingsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  String get pageTitle => localizations.settings;

  @override
  Widget? buildBottomNavigationBar(BuildContext context) {
    if(!isMobile) return null;
    return BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                  _tabController.animateTo(index);
                });
              },
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.dns),
                  label: localizations.serverSettings,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.notifications),
                  label: localizations.notificationSettings,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.people),
                  label: localizations.users,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.admin_panel_settings),
                  label: localizations.admin,
                ),
              ],
            );
  }

  @override
  Widget buildContent(BuildContext context) {
    final mobile = isMobile;
    
    return SizedBox(
      height: screenSize.height,
      width: screenSize.width,
      child: Column(
        children: [
          if (!mobile)
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: localizations.serverSettings),
                Tab(text: localizations.notificationSettings),
                Tab(text: localizations.users),
                Tab(text: localizations.admin),
              ],
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                SingleChildScrollView(child: ServerSettingsPage()),
                NotificationSettingsWidget(),
                ListUserPage(),
                AdminSettingsPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
