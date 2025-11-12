import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lojaflutter/view/wishlist_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: const AssetImage('assets/images/avatar.jpg'),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/avatar.jpg',
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Vinicius Silva',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'vinicius@email.com',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 15,
                  ),
                ),
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
          _buildOption(
            context,
            icon: Icons.favorite_outline,
            title: 'Wishlist',
            onTap: () {
              Get.to(() => WishlistScreen());
            },
          ),
          _buildOption(
            context,
            icon: Icons.settings_outlined,
            title: 'Configurações',
            onTap: () {},
          ),
          _buildOption(
            context,
            icon: Icons.help_outline,
            title: 'Ajuda e Suporte',
            onTap: () {},
          ),
          const SizedBox(height: 30),
          Center(
            child: TextButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logout realizado com sucesso!')),
                );
              },
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
