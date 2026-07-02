import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:todo_app/auth/login_page.dart';
import 'package:todo_app/pages/dashboard/dashboard_screen.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //observable state
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = "".obs;

  //convenience getter
  String? get uid => currentUser.value?.uid;
  bool get isLoggedIn => currentUser.value != null;
  String get displayName => currentUser.value?.displayName ?? 'User'; // ← add
  String get email => currentUser.value?.email ?? '';

  @override
  void onInit() {
    super.onInit();

    currentUser.bindStream(_auth.authStateChanges());

    ever(currentUser, _handleAuthChanges);
  }

  void _handleAuthChanges(User? user) {
    if (user == null) {
      Get.offAll(() => LoginPage());
    } else {
      Get.offAll(() => DashboardPage());
    }
  }

  //Sign Up
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await credential.user?.updateDisplayName(name.trim());
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _parseError(e.code);
    } finally {
      isLoading.value = false;
    }
  }

  //Login
  Future<void> login({required String email, required String password}) async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _parseError(e.code);
    } finally {
      isLoading.value = false;
    }
  }

  //Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  //Password reset
  Future<void> resetPassword(String email) async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      await _auth.sendPasswordResetEmail(email: email.trim());
      Get.snackbar(
        "Email sent",
        "Check your inbox to reset your password.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _parseError(e.code);
    } finally {
      isLoading.value = false;
    }
  }

  //changePassword
  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      if (oldPassword == newPassword) {
        errorMessage.value =
            'New password must be different from the current password.';
      }

      final user = _auth.currentUser;
      if (user == null || user.email == null) return false;
      print("user email is ${user.email}");

      //creating AuthCredential
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      //reauthenticate
      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPassword);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        errorMessage.value = 'incorrect password. Please try again. ';
      } else {
        print(e.code);
        errorMessage.value = _parseError(e.code);
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  String _parseError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-credential':
        return 'Invalid email or password. Please try again.';
      case 'requires-recent-login':
        return 'please log out and log in again before changing your password';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'No internet connection.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
