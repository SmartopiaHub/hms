// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'base.dart';
import '../widgets/login_card.dart';
import 'package:flutter/material.dart';



class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends PageBaseState<SignInPage> with SingleTickerProviderStateMixin {


  @override
  Widget buildContent(BuildContext context) {
    return Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: LoginCard(),
                      ),
                    ),
                  ),
                );  
 
  }

}