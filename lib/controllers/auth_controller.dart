import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lojaflutter/models/user_model.dart';
import 'dart:io';
import 'dart:convert';

class AuthController extends GetxController {
  final _storage = GetStorage();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxBool _isFirstTime = true.obs;
  final RxBool _isLoggedIn = false.obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  final Rx<User?> _firebaseUser = Rx<User?>(null);
  final Rx<UserModel?> _userData = Rx<UserModel?>(null);

  bool get isFirstTime => _isFirstTime.value;
  bool get isLoggedIn => _isLoggedIn.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  User? get firebaseUser => _firebaseUser.value;
  UserModel? get userData => _userData.value;

  @override
  void onInit() {
    super.onInit();
    _loadInitialState();
    _firebaseAuth.authStateChanges().listen((User? user) {
      _firebaseUser.value = user;
      if (user != null) {
        _isLoggedIn.value = true;
        _storage.write('isLoggedIn', true);
        _loadUserData(user.uid);
      }
    });
  }

  void _loadInitialState() {
    _isFirstTime.value = _storage.read('isFirstTime') ?? true;
    _isLoggedIn.value = _storage.read('isLoggedIn') ?? false;
  }

  void setFirstTimeDone() {
    _isFirstTime.value = false;
    _storage.write('isFirstTime', false);
  }

  // Carregar dados do usuário do Firestore
  Future<void> _loadUserData(String uid) async {
    try {
      final doc = await _firestore.collection('usuarios').doc(uid).get();
      if (doc.exists) {
        _userData.value = UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('Erro ao carregar dados do usuário: $e');
    }
  }

  // Login com Email e Senha
  Future<bool> login(String email, String password) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _isLoggedIn.value = true;
      _storage.write('isLoggedIn', true);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage.value = _getErrorMessage(e.code);
      _isLoggedIn.value = false;
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // Sign Up com Email e Senha
  Future<bool> signUp(String name, String email, String password, String confirmPassword) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      // Validar se as senhas conferem
      if (password != confirmPassword) {
        _errorMessage.value = 'As senhas não conferem';
        _isLoading.value = false;
        return false;
      }

      // Criar usuário
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Atualizar o nome do usuário
      await userCredential.user?.updateDisplayName(name);
      await userCredential.user?.reload();

      // Salvar dados do usuário no Firestore
      final userModel = UserModel(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
        photoBase64: null,
        isAdmin: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection('usuarios')
          .doc(userCredential.user!.uid)
          .set(userModel.toMap());

      _userData.value = userModel;
      _isLoggedIn.value = true;
      _storage.write('isLoggedIn', true);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage.value = _getErrorMessage(e.code);
      _isLoggedIn.value = false;
      return false;
    } catch (e) {
      _errorMessage.value = 'Erro ao criar usuário: ${e.toString()}';
      _isLoggedIn.value = false;
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      _isLoading.value = true;
      await _firebaseAuth.signOut();
      _isLoggedIn.value = false;
      _storage.write('isLoggedIn', false);
      _firebaseUser.value = null;
      _userData.value = null;
      _errorMessage.value = '';
    } catch (e) {
      _errorMessage.value = 'Erro ao fazer logout';
    } finally {
      _isLoading.value = false;
    }
  }

  // Mapear erros do Firebase para mensagens amigáveis
  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Usuário não encontrado';
      case 'wrong-password':
        return 'Senha incorreta';
      case 'email-already-in-use':
        return 'Este email já está cadastrado';
      case 'weak-password':
        return 'A senha é muito fraca';
      case 'invalid-email':
        return 'Email inválido';
      case 'user-disabled':
        return 'Usuário desativado';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde';
      default:
        return 'Erro de autenticação. Tente novamente';
    }
  }

  // Limpar mensagem de erro
  void clearError() {
    _errorMessage.value = '';
  }

  // Converter imagem para Base64
  Future<String?> imageToBase64(dynamic imageFile) async {
    try {
      String base64String = '';
      
      if (kIsWeb) {
        // Para Web - imageFile já será uma Future<List<int>>
        if (imageFile is Future<List<int>>) {
          final bytes = await imageFile;
          base64String = base64Encode(bytes);
        } else if (imageFile is List<int>) {
          base64String = base64Encode(imageFile);
        }
      } else {
        // Para Mobile - usar dart:io File
        if (imageFile is File) {
          final bytes = await imageFile.readAsBytes();
          base64String = base64Encode(bytes);
        }
      }
      
      return base64String.isNotEmpty ? base64String : null;
    } catch (e) {
      _errorMessage.value = 'Erro ao processar imagem: ${e.toString()}';
      debugPrint('Erro ao converter para base64: $e');
      return null;
    }
  }

  // Editar perfil do usuário com foto em Base64
  Future<bool> updateUserProfile({
    required String name,
    dynamic imageFile,
  }) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final uid = _firebaseUser.value?.uid;
      if (uid == null) {
        _errorMessage.value = 'Usuário não autenticado';
        return false;
      }

      // Atualizar no Firebase Auth
      await _firebaseUser.value?.updateDisplayName(name);

      // Se houver imagem, converter para Base64
      String? photoBase64;
      if (imageFile != null) {
        photoBase64 = await imageToBase64(imageFile);
      }

      // Atualizar no Firestore
      final updatedUser = _userData.value?.copyWith(
        name: name,
        photoBase64: photoBase64 ?? _userData.value?.photoBase64,
        updatedAt: DateTime.now(),
      );

      if (updatedUser != null) {
        await _firestore
            .collection('usuarios')
            .doc(uid)
            .update(updatedUser.toMap());

        _userData.value = updatedUser;
      }

      return true;
    } catch (e) {
      _errorMessage.value = 'Erro ao atualizar perfil: ${e.toString()}';
      debugPrint('Erro ao atualizar perfil: $e');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }
}