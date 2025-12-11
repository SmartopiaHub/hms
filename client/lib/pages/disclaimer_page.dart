// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'package:flutter/material.dart';
import '../pages/base.dart';

class DisclaimerPage extends StatelessPageBase {
  const DisclaimerPage({super.key});

  @override
  Widget buildContent(BuildContext context) {
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';
    return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isEnglish) ..._buildEnglishContent(context) else ..._buildChineseContent(context),
              ],
            ),
          ),
        ),
    );
  }

  List<Widget> _buildEnglishContent(BuildContext context) {
    return [
      const Text(
        'Terms of Service & Disclaimer',
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 24),
      
      const Text(
        '1. Acceptance of Terms',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      const Text(
        'By accessing and using Smartopia Homework Management System ("the Service"), you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use the Service.',
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
      const SizedBox(height: 20),
      
      const Text(
        '2. Service Description',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      const Text(
        'The Service provides homework management tools for educational purposes. We strive to maintain service availability but do not guarantee uninterrupted or error-free operation.',
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
      const SizedBox(height: 20),
      
      const Text(
        '3. User Responsibilities',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      const Text(
        '• You are responsible for maintaining the confidentiality of your account credentials.\n'
        '• You agree to use the Service only for lawful educational purposes.\n'
        '• You are solely responsible for all content you upload or submit through the Service.\n'
        '• You must not attempt to gain unauthorized access to any part of the Service.',
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
      const SizedBox(height: 20),
      
      const Text(
        '4. Disclaimer of Warranties',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      const Text(
        'THE SERVICE IS PROVIDED "AS IS" WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED. WE DO NOT WARRANT THAT THE SERVICE WILL BE UNINTERRUPTED, SECURE, OR ERROR-FREE. USE OF THE SERVICE IS AT YOUR OWN RISK.',
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
      const SizedBox(height: 20),
      
      const Text(
        '5. Limitation of Liability',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      const Text(
        'TO THE MAXIMUM EXTENT PERMITTED BY LAW, WE SHALL NOT BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR PUNITIVE DAMAGES, INCLUDING LOSS OF DATA, LOSS OF PROFITS, OR BUSINESS INTERRUPTION.',
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
      const SizedBox(height: 20),
      const Text(
        '6. Third-Party Services & Content',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      const Text(
        'The Service may contain links to third-party websites or services. We are not responsible for the content, privacy practices, or availability of these third-party resources.',
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
      const SizedBox(height: 20),
      const Text(
        '7. Service Availability',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      const Text(
        'We strive to keep the Service available but do not guarantee continuous, uninterrupted access. Maintenance, updates, or technical issues may result in temporary unavailability.',
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
      const SizedBox(height: 20),
      
      const Text(
        '6. Data Backup',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      const Text(
        'You are responsible for maintaining backups of your data. We are not responsible for any loss of data that may occur while using the Service.',
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
      const SizedBox(height: 32),
      
      const Divider(),
      const SizedBox(height: 32),
      
      const Text(
        'Privacy Policy',
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 24),
      
      const Text(
        '1. Information We Collect',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      const Text(
        'We collect the following information:\n'
        '• Account information (username, email if provided)\n'
        '• Homework and task data that you create\n'
        '• Usage data and interaction logs\n'
        '• Device information (for mobile and desktop apps)',
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
      const SizedBox(height: 20),
      
      const Text(
        '2. How We Use Your Information',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      const Text(
        'Your information is used to:\n'
        '• Provide and maintain the Service\n'
        '• Improve user experience and Service functionality\n'
        '• Send notifications related to your tasks and assignments\n'
        '• Analyze usage patterns to enhance the Service',
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
      const SizedBox(height: 20),
      
      const Text(
        '3. Data Storage and Security',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      const Text(
        'We implement reasonable security measures to protect your data. However, no method of transmission over the internet or electronic storage is 100% secure. We cannot guarantee absolute security.',
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
      const SizedBox(height: 20),
      
      const Text(
        '4. Data Sharing',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      const Text(
        'We do not sell, trade, or rent your personal information to third parties. Data may be shared within your family account (between parents and children) as part of the Service\'s core functionality.',
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
      const SizedBox(height: 20),
      
      
      const Text(
        '5. Cookies and Tracking',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      const Text(
        'We use local storage and cookies to maintain your session and preferences. You can control cookie settings through your browser, but this may affect Service functionality.',
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
      const SizedBox(height: 20),
      
      const Text(
        '6. Children\'s Privacy',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      const Text(
        'The Service is designed for use by families including children. Parents or guardians are responsible for supervising their children\'s use of the Service and managing their accounts.',
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
      const SizedBox(height: 20),
      
      const Text(
        '7. Changes to Privacy Policy',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      const Text(
        'We may update this Privacy Policy from time to time. Continued use of the Service after changes constitutes acceptance of the updated policy.',
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
      const SizedBox(height: 32),
      
      const Text(
        'Last Updated: December 8, 2025',
        style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.black54),
      ),
      const SizedBox(height: 24),
    ];
  }

  List<Widget> _buildChineseContent(BuildContext context) {
    return [
      const Text(
        '服务条款与免责声明',
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 24),
      
      const Text(
        '一、接受条款',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      const Text(
        '通过访问和使用智学作业管理系统（"本服务"），您同意受这些服务条款的约束。如果您不同意这些条款，请不要使用本服务。',
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
      const SizedBox(height: 20),
      
      const Text(
        '二、服务说明',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      const Text(
        '本服务为教育目的提供作业管理工具。我们努力维持服务的可用性，但不保证服务不会中断或无错误运行。',
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
      const SizedBox(height: 20),
      
      const Text(
        '三、用户责任',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      const Text(
        '• 您有责任保护您的账户凭据的机密性。\n'
        '• 您同意仅将本服务用于合法的教育目的。\n'
        '• 您对通过本服务上传或提交的所有内容负全部责任。\n'
        '• 您不得试图未经授权访问本服务的任何部分。',
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
      const SizedBox(height: 20),
      
      const Text(
        '四、免责声明',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      const Text(
        '本服务按"原样"提供，不提供任何明示或暗示的保证。我们不保证服务不会中断、安全或无错误。使用本服务的风险由您自行承担。',
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
      const SizedBox(height: 20),
      
      const Text(
        '五、责任限制',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      const Text(
        '在法律允许的最大范围内，我们不对任何间接、附带、特殊、后果性或惩罚性损害负责，包括数据丢失、利润损失或业务中断。',
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
      const SizedBox(height: 20),
      const Text(
        '六、第三方服务与内容',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      const Text(
        '本服务可能包含指向第三方网站或服务的链接。我们不对这些第三方资源的内容、隐私政策或可用性负责。',
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
      const SizedBox(height: 20),
      const Text(
        '七、服务可用性',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      const Text(
        '我们努力保持服务的可用性，但不保证持续、不间断访问。维护、更新或技术问题可能导致服务暂时不可用。',
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
      const SizedBox(height: 20),
      
      const Text(
        '六、数据备份',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      const Text(
        '您有责任维护数据备份。我们不对使用本服务期间可能发生的任何数据丢失负责。',
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
      const SizedBox(height: 32),
      
      const Divider(),
      const SizedBox(height: 32),
      
      const Text(
        '隐私政策',
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 24),
      
      const Text(
        '一、我们收集的信息',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      const Text(
        '我们收集以下信息：\n'
        '• 账户信息（用户名、电子邮件（如果提供））\n'
        '• 您创建的作业和任务数据\n'
        '• 使用数据和交互日志\n'
        '• 设备信息（用于移动和桌面应用）',
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
      const SizedBox(height: 20),
      
      const Text(
        '二、我们如何使用您的信息',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      const Text(
        '您的信息用于：\n'
        '• 提供和维护服务\n'
        '• 改善用户体验和服务功能\n'
        '• 发送与您的任务和作业相关的通知\n'
        '• 分析使用模式以增强服务',
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
      const SizedBox(height: 20),
      
      const Text(
        '三、数据存储和安全',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      const Text(
        '我们采取合理的安全措施来保护您的数据。但是，没有任何通过互联网传输或电子存储的方法是100%安全的。我们不能保证绝对的安全性。',
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
      const SizedBox(height: 20),
      
      const Text(
        '四、数据共享',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      const Text(
        '我们不会向第三方出售、交易或出租您的个人信息。作为服务核心功能的一部分，数据可能会在您的家庭账户内（父母和子女之间）共享。',
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
      const SizedBox(height: 20),
      
      
      const Text(
        '五、Cookie和跟踪',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      const Text(
        '我们使用本地存储和Cookie来维护您的会话和偏好设置。您可以通过浏览器控制Cookie设置，但这可能会影响服务功能。',
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
      const SizedBox(height: 20),
      
      const Text(
        '六、儿童隐私',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      const Text(
        '本服务专为包括儿童在内的家庭使用而设计。父母或监护人负责监督其子女使用本服务并管理其账户。',
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
      const SizedBox(height: 20),
      
      const Text(
        '七、隐私政策变更',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      const Text(
        '我们可能会不时更新本隐私政策。更改后继续使用本服务即表示接受更新后的政策。',
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
      const SizedBox(height: 32),
      
      const Text(
        '最后更新：2025年12月8日',
        style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.black54),
      ),
      const SizedBox(height: 24),
    ];
  }
}
