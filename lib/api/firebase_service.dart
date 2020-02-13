import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meus_livros/api/api_response.dart';
import 'package:meus_livros/utils/prefs.dart';

class FirebaseService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<ApiResponse> loginGoogle() async {
    try {
      // Login com o Google
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print("Google User: ${googleUser.email}");

      // Credenciais para o Firebase
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Login no Firebase
      AuthResult result = await _auth.signInWithCredential(credential);
      final FirebaseUser fuser = result.user;
      print("Firebase Nome: " + fuser.displayName);
      print("Firebase Email: " + fuser.email);
      print("Firebase Foto: " + fuser.photoUrl);

      Prefs.setBool("LOGIN", true);
      // Resposta genérica
      return ApiResponse.ok();
    } catch (error) {
      print("Firebase error $error");
      return ApiResponse.error(msg: "Não foi possível fazer o login");
    }
  }

  Future<ApiResponse> doLogin(String email, String pass) async {
    try {
      AuthResult result =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      if (result.user != null) {
        return ApiResponse.ok();
      } else {
        return ApiResponse.error(
            msg: "Não foi possível cadastrar o novo usuário.");
      }
    } catch (e) {
      return ApiResponse.error(msg: "Erro: $e");
    }
  }


  Future<ApiResponse> doResetLogin(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return ApiResponse.error(
          msg: "Se este foi o email que você cadastrou, você recebera um link, para resetar.");
    } catch (e) {
      print("--> $e");
      return ApiResponse.error(msg: "Erro: $e");
    }
  }

  Future<ApiResponse> doCreateUser(String email, String pass) async {
    try {
      AuthResult result =
      await _auth.createUserWithEmailAndPassword(email: email, password: pass);
      if (result.user != null) {
        return ApiResponse.ok();
      } else {
        return ApiResponse.error(
            msg: "Usuário cadastrado com sucesso.");
      }
    } catch (e) {
      return ApiResponse.error(msg: "Erro: $e");
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
