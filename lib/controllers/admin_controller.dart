import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lojaflutter/models/user_model.dart';

class AdminController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxList<UserModel> _users = <UserModel>[].obs;
  final RxList<UserModel> _filteredUsers = <UserModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _searchQuery = ''.obs;
  final RxInt _currentPage = 0.obs;
  final RxString _errorMessage = ''.obs;
  final RxBool _hasError = false.obs;
  final RxBool _firebaseConnected = false.obs;
  final RxString _firebaseStatus = 'Verificando conexão...'.obs;

  static const int itemsPerPage = 10;

  List<UserModel> get users => _users;
  List<UserModel> get filteredUsers => _filteredUsers;
  bool get isLoading => _isLoading.value;
  String get searchQuery => _searchQuery.value;
  int get currentPage => _currentPage.value;
  String get errorMessage => _errorMessage.value;
  bool get hasError => _hasError.value;
  bool get firebaseConnected => _firebaseConnected.value;
  String get firebaseStatus => _firebaseStatus.value;

  int get totalPages => (filteredUsers.length / itemsPerPage).ceil();

  List<UserModel> get paginatedUsers {
    final startIndex = currentPage * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage).clamp(0, filteredUsers.length);
    if (startIndex >= filteredUsers.length) return [];
    return filteredUsers.sublist(startIndex, endIndex);
  }

  @override
  void onInit() {
    super.onInit();
    loadUsers();
    _checkFirebaseConnection();
  }

  // Verificar conexão com Firebase
  Future<void> _checkFirebaseConnection() async {
    try {
      await _firestore.collection('usuarios').limit(1).get().timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw Exception('Firebase timeout'),
      );
      _firebaseConnected.value = true;
      _firebaseStatus.value = 'Conectado ao Firebase';
    } catch (e) {
      _firebaseConnected.value = false;
      _firebaseStatus.value = 'Sem conexão com Firebase';
      debugPrint('Erro de conexão Firebase: $e');
    }
  }

  // Carregar todos os usuários
  Future<void> loadUsers() async {
    try {
      _isLoading.value = true;
      _hasError.value = false;
      _errorMessage.value = '';
      final snapshot = await _firestore.collection('usuarios').get();
      
      _users.value = snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .toList();
      
      _filteredUsers.value = List.from(_users);
      _currentPage.value = 0;
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = 'Erro ao carregar usuários: $e';
      debugPrint(_errorMessage.value);
    } finally {
      _isLoading.value = false;
    }
  }

  // Buscar usuários por nome
  void searchUsers(String query) {
    _searchQuery.value = query;
    _currentPage.value = 0;

    if (query.isEmpty) {
      _filteredUsers.value = List.from(_users);
    } else {
      _filteredUsers.value = _users
          .where((user) =>
              user.name.toLowerCase().contains(query.toLowerCase()) ||
              user.email.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  // Ir para próxima página
  void nextPage() {
    if (currentPage < totalPages - 1) {
      _currentPage.value++;
    }
  }

  // Voltar página
  void previousPage() {
    if (currentPage > 0) {
      _currentPage.value--;
    }
  }

  // Mudar status de admin
  Future<void> toggleAdminStatus(UserModel user) async {
    try {
      _isLoading.value = true;
      _hasError.value = false;
      _errorMessage.value = '';
      final updatedUser = user.copyWith(isAdmin: !user.isAdmin);
      
      await _firestore
          .collection('usuarios')
          .doc(user.uid)
          .update({'isAdmin': updatedUser.isAdmin});

      await loadUsers();
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = 'Erro ao atualizar status de admin: $e';
      debugPrint(_errorMessage.value);
    } finally {
      _isLoading.value = false;
    }
  }

  // Deletar usuário
  Future<void> deleteUser(String uid) async {
    try {
      _isLoading.value = true;
      _hasError.value = false;
      _errorMessage.value = '';
      await _firestore.collection('usuarios').doc(uid).delete();
      await loadUsers();
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = 'Erro ao deletar usuário: $e';
      debugPrint(_errorMessage.value);
    } finally {
      _isLoading.value = false;
    }
  }

  // Editar usuário
  Future<void> updateUser(UserModel user) async {
    try {
      _isLoading.value = true;
      _hasError.value = false;
      _errorMessage.value = '';
      await _firestore
          .collection('usuarios')
          .doc(user.uid)
          .update(user.toMap());

      await loadUsers();
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = 'Erro ao atualizar usuário: $e';
      debugPrint(_errorMessage.value);
    } finally {
      _isLoading.value = false;
    }
  }

  // Limpar erro
  void clearError() {
    _hasError.value = false;
    _errorMessage.value = '';
  }
}
