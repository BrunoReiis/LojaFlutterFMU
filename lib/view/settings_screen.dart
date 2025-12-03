import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lojaflutter/controllers/auth_controller.dart';
import 'package:lojaflutter/utils/app_textstyles.dart';
import 'dart:io';
import 'dart:convert';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _nameController;
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: authController.userData?.name ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Configurações',
          style: AppTextStyle.withColor(
            AppTextStyle.h3,
            isDark ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto de perfil
            Center(
              child: Column(
                children: [
                  Obx(() {
                    return Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: authController.userData?.photoBase64 != null && authController.userData!.photoBase64!.isNotEmpty
                              ? MemoryImage(base64Decode(authController.userData!.photoBase64!))
                              : null,
                          child: authController.userData?.photoBase64 == null || authController.userData!.photoBase64!.isEmpty
                              ? Text(
                                  (authController.userData?.name ?? 'U')[0].toUpperCase(),
                                  style: const TextStyle(fontSize: 40),
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickAndUploadImage,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 16),
                  Text(
                    'Alterar foto de perfil',
                    style: AppTextStyle.withColor(
                      AppTextStyle.bodyMedium,
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Nome
            Text(
              'Nome',
              style: AppTextStyle.withColor(
                AppTextStyle.bodyMedium,
                isDark ? Colors.grey[400]! : Colors.grey[600]!,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Digite seu nome',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Email (não editável)
            Text(
              'Email',
              style: AppTextStyle.withColor(
                AppTextStyle.bodyMedium,
                isDark ? Colors.grey[400]! : Colors.grey[600]!,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
                color: isDark ? Colors.grey[900] : Colors.grey[100],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      authController.userData?.email ?? 'email@exemplo.com',
                      style: AppTextStyle.bodyMedium,
                    ),
                  ),
                  Icon(
                    Icons.lock,
                    size: 18,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'O email não pode ser alterado',
              style: AppTextStyle.withColor(
                AppTextStyle.bodySmall,
                isDark ? Colors.grey[400]! : Colors.grey[600]!,
              ),
            ),
            const SizedBox(height: 40),
            // Mensagem de erro
            Obx(() {
              if (authController.errorMessage.isNotEmpty) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          authController.errorMessage,
                          style: AppTextStyle.withColor(
                            AppTextStyle.bodyMedium,
                            Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            const SizedBox(height: 24),
            // Botão salvar
            Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: authController.isLoading ? null : _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: authController.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Salvar Alterações',
                        style: AppTextStyle.withColor(
                          AppTextStyle.buttonMedium,
                          Colors.white,
                        ),
                      ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        authController.clearError();
        // Atualizar perfil com a foto em Base64
        final imageFile = kIsWeb ? image.readAsBytes() : File(image.path);
        final success = await authController.updateUserProfile(
          name: authController.userData?.name ?? '',
          imageFile: imageFile,
        );

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Foto de perfil atualizada com sucesso!'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Erro ao pegar imagem: $e');
    }
  }

  Future<void> _saveChanges() async {
    authController.clearError();

    if (_nameController.text.isEmpty) {
      Get.snackbar(
        'Erro',
        'O nome não pode estar vazio',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final success = await authController.updateUserProfile(
      name: _nameController.text.trim(),
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil atualizado com sucesso!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
