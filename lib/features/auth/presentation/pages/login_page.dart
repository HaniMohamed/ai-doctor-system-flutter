import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../generated/l10n/app_localizations.dart';
import '../../../../shared/widgets/base_scaffold.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return BaseScaffold(
      title: AppLocalizations.of(context)!.login,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.email,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.password,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Obx(() => controller.isLoading.value
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      controller.login(
                        emailController.text,
                        passwordController.text,
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.login),
                  )),
            const SizedBox(height: 16),
            Obx(() => controller.errorMessage.value.isNotEmpty
                ? Text(
                    controller.errorMessage.value,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  )
                : const SizedBox()),
          ],
        ),
      ),
    );
  }
}
