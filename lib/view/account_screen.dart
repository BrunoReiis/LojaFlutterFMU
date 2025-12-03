import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lojaflutter/view/wishlist_screen.dart';
import 'package:lojaflutter/controllers/auth_controller.dart';
import 'package:lojaflutter/view/signin_screen.dart';
import 'package:lojaflutter/view/admin_panel.dart';
import 'package:lojaflutter/view/settings_screen.dart';
import 'package:lojaflutter/view/help_support_screen.dart';
import 'dart:convert';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Minha Conta',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : Colors.black,
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Obx(() => CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: authController.userData?.photoBase64 != null && authController.userData!.photoBase64!.isNotEmpty
                      ? MemoryImage(base64Decode(authController.userData!.photoBase64!))
                      : null,
                  child: authController.userData?.photoBase64 == null || authController.userData!.photoBase64!.isEmpty
                      ? Text(
                          (authController.userData?.name ?? 'U')[0].toUpperCase(),
                          style: const TextStyle(fontSize: 36),
                        )
                      : null,
                )),
                const SizedBox(height: 16),
                Obx(() => Text(
                  authController.userData?.name ?? authController.firebaseUser?.displayName ?? 'Usuário',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                const SizedBox(height: 4),
                Obx(() => Text(
                  authController.userData?.email ?? authController.firebaseUser?.email ?? 'email@exemplo.com',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 15,
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Divider(thickness: 1.2),
          const SizedBox(height: 20),
          _buildOption(
            context,
            icon: Icons.shopping_bag_outlined,
            title: 'Meus Pedidos',
            onTap: () {},
          ),
          if (authController.userData?.isAdmin == true)
            _buildOption(
              context,
              icon: Icons.admin_panel_settings,
              title: 'Admin Dashboard',
              onTap: () => Get.to(() => const AdminDashboard()),
            ),
          _buildOption(
            context,
            icon: Icons.favorite_outline,
            title: 'Wishlist',
            onTap: () {
              Get.to(() => const WishlistScreen());
            },
          ),
          _buildOption(
            context,
            icon: Icons.settings_outlined,
            title: 'Configurações',
            onTap: () => Get.to(() => const SettingsScreen()),
          ),
          _buildOption(
            context,
            icon: Icons.help_outline,
            title: 'Ajuda e Suporte',
            onTap: () => Get.to(() => const HelpSupportScreen()),
          ),
          const SizedBox(height: 30),
          Center(
            child: TextButton.icon(
              onPressed: () => _handleLogout(authController, context),
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              label: const Text(
                'Sair',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout(AuthController authController, BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Logout'),
          content: const Text('Tem certeza que deseja sair?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Get.back();
                await authController.logout();
                Get.offAll(() => SigninScreen());
              },
              child: const Text('Sair', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOption(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Icon(icon,
          color: isDark ? Colors.white : Colors.black.withValues(alpha: 0.7)),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios,
          size: 16, color: Colors.grey.shade600),
      onTap: onTap,
    );
  }
}
