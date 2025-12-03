import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lojaflutter/controllers/admin_controller.dart';
import 'package:lojaflutter/models/user_model.dart';
import 'package:lojaflutter/utils/app_textstyles.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminController adminController = Get.put(AdminController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          style: AppTextStyle.withColor(
            AppTextStyle.h3,
            isDark ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Error Banner
          Obx(() {
            if (adminController.hasError) {
              return Container(
                width: double.infinity,
                color: Colors.red.shade100,
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        adminController.errorMessage,
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: adminController.clearError,
                      constraints: const BoxConstraints(maxWidth: 30),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) => adminController.searchUsers(value),
              decoration: InputDecoration(
                hintText: 'Buscar por nome ou email',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          // Usuários list
          Expanded(
            child: Obx(() {
              if (adminController.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (adminController.paginatedUsers.isEmpty) {
                return Center(
                  child: Text(
                    'Nenhum usuário encontrado',
                    style: AppTextStyle.bodyMedium,
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: adminController.paginatedUsers.length,
                itemBuilder: (context, index) {
                  final user = adminController.paginatedUsers[index];
                  return _buildUserCard(context, user, adminController);
                },
              );
            }),
          ),
          // Pagination
          Obx(() => _buildPaginationControls(adminController, isDark)),
        ],
      ),
      bottomNavigationBar: Obx(() {
        return Container(
          color: adminController.firebaseConnected
              ? Colors.green.shade100
              : Colors.red.shade100,
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                adminController.firebaseConnected
                    ? Icons.cloud_done
                    : Icons.cloud_off,
                color: adminController.firebaseConnected
                    ? Colors.green.shade700
                    : Colors.red.shade700,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  adminController.firebaseStatus,
                  style: TextStyle(
                    color: adminController.firebaseConnected
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  adminController.loadUsers();
                },
                child: const Text(
                  'Reconectar',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildUserCard(
    BuildContext context,
    UserModel user,
    AdminController adminController,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey.shade300,
                  child: Text(user.name[0].toUpperCase()),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: AppTextStyle.withColor(
                          AppTextStyle.bodyLarge,
                          Theme.of(context).textTheme.bodyLarge!.color!,
                        ),
                      ),
                      Text(
                        user.email,
                        style: AppTextStyle.withColor(
                          AppTextStyle.bodySmall,
                          isDark ? Colors.grey[400]! : Colors.grey[600]!,
                        ),
                      ),
                    ],
                  ),
                ),
                if (user.isAdmin)
                  Chip(
                    label: const Text('Admin'),
                    backgroundColor: Colors.orange.withValues(alpha: 0.2),
                    labelStyle: const TextStyle(color: Colors.orange),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Toggle Admin
                TextButton.icon(
                  onPressed: () => _showConfirmDialog(
                    context,
                    'Mudar status de admin',
                    user.isAdmin
                        ? 'Remover permissões de admin?'
                        : 'Transformar em admin?',
                    () => adminController.toggleAdminStatus(user),
                  ),
                  icon: Icon(
                    user.isAdmin ? Icons.admin_panel_settings : Icons.person,
                  ),
                  label: Text(user.isAdmin ? 'Remover Admin' : 'Fazer Admin'),
                ),
                // Edit
                TextButton.icon(
                  onPressed: () => _showEditDialog(context, user, adminController),
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar'),
                ),
                // Delete
                TextButton.icon(
                  onPressed: () => _showConfirmDialog(
                    context,
                    'Deletar usuário',
                    'Tem certeza que deseja deletar ${user.name}?',
                    () => adminController.deleteUser(user.uid),
                  ),
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text(
                    'Deletar',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationControls(AdminController adminController, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: adminController.currentPage > 0
                ? adminController.previousPage
                : null,
            child: const Text('Anterior'),
          ),
          Text(
            'Página ${adminController.currentPage + 1} de ${adminController.totalPages}',
            style: AppTextStyle.bodyMedium,
          ),
          ElevatedButton(
            onPressed: adminController.currentPage < adminController.totalPages - 1
                ? adminController.nextPage
                : null,
            child: const Text('Próxima'),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog(
    BuildContext context,
    String title,
    String message,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              onConfirm();
              Get.back();
            },
            child: const Text('Confirmar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    UserModel user,
    AdminController adminController,
  ) {
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Usuário'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final updatedUser = user.copyWith(
                name: nameController.text,
                email: emailController.text,
              );
              adminController.updateUser(updatedUser);
              Get.back();
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
