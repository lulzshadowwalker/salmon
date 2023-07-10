// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/helpers/salmon_helpers.dart';
import 'package:salmon/models/salmon_silent_exception.dart';
import 'package:salmon/models/salmon_user_credentials.dart';
import 'package:salmon/providers/db/remote_db/remote_db_provider.dart';
import 'package:salmon/providers/salmon_user_credentials/salmon_user_credentials_provider.dart';
import '../../l10n/l10n_imports.dart';
import '../../models/enums/notif_type.dart';
import '../../models/typedefs/user_id.dart';
import '../notif/notif_controller.dart';

/// Authentication Controller
class A12nController {
  A12nController(this.ref);
  final Ref ref;

  static final _auth = FirebaseAuth.instance;
  static final _log = SalmonHelpers.getLogger('A12nController');

  UserId? get userId => user?.uid;
  User? get user => _auth.currentUser;
  Stream<User?> get authState => _auth.authStateChanges();
  bool get isAuthenticated => user != null;
  bool get isGuest => user?.isAnonymous ?? true;

  Future<void> guestSignIn(BuildContext context) async {
    try {
      await _auth.signInAnonymously();

      _log.v('Signed-in anonymously');
    } catch (e) {
      SalmonHelpers.handleException(context: context, e: e, logger: _log);
    }
  }

  Future<void> sendPasswordResetEmail(BuildContext context) async {
    try {
      if (isGuest) {
        throw Exception('tried resetting the password for a guest user');
      }
      await _auth.sendPasswordResetEmail(email: user!.email!);

      _log.v('password reset email has been sent');
      NotifController.showPopup(
        context: context,
        message: SL.of(context).passwordResetEmailHasBeenSent,
        type: NotifType.success,
      );
    } catch (e) {
      SalmonHelpers.handleException(context: context, e: e, logger: _log);
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      _log.v('Signed-out');
    } catch (e) {
      SalmonHelpers.handleException(context: context, e: e, logger: _log);
    }
  }

  Future<void> emailSignIn(
    BuildContext context,
  ) async {
    try {
      final cred = ref.read(salmonUserCredentialsProvider).credentials;

      await _auth.signInWithEmailAndPassword(
        email: cred.email!,
        password: cred.password!,
      );

      _log.v('Signed-in with email and password');
    } catch (e) {
      SalmonHelpers.handleException(context: context, e: e, logger: _log);
      throw const SalmonSilentException('sign in failed');
    }
  }

  Future<void> emailSignUp(
    BuildContext context,
  ) async {
    try {
      final cred = ref.read(salmonUserCredentialsProvider).credentials;

      final u = await _auth.createUserWithEmailAndPassword(
        email: cred.email!,
        password: cred.password!,
      );

      _log.v('Signed-up with email and password');

      await ref.read(remoteDbProvider).createUserRecord(
            context: context,
            uid: u.user!.uid,
          );
    } catch (e) {
      SalmonHelpers.handleException(context: context, e: e, logger: _log);
    }
  }

  Future<void> googleAuth(
    BuildContext context,
  ) async {
    try {
      final googleSignIn = GoogleSignIn(
        scopes: [
          'profile',
        ],
      );

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw const SalmonSilentException('Process terminated by the user');
      }

      _log.v('Google auth process initiated');

      final googleAuth = await googleUser.authentication;
      _log.v('Obtained user details via Google auth');

      final ouathCredential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential = await _auth.signInWithCredential(ouathCredential);
      _log.v('Signed-in with Google auth');

      await _auth
          .fetchSignInMethodsForEmail(googleUser.email)
          .then((authMethods) async {
        ref.read(salmonUserCredentialsProvider.notifier).set(
              SalmonUserCredentials.fromGoogleAuth(
                userCredential.additionalUserInfo!.profile!,
              ),
            );

        await ref.read(remoteDbProvider).createUserRecord(
              context: context,
              uid: userCredential.user!.uid,
            );
      });
    } catch (e) {
      SalmonHelpers.handleException(context: context, e: e, logger: _log);
    }
  }

  Future<void> updateEmail(
    BuildContext context,
    String email,
  ) async {
    try {
      await user?.updateEmail(email);

      _log.v('updated user email successfully');
    } catch (e) {
      SalmonHelpers.handleException(context: context, e: e, logger: _log);
    }
  }

  Future<void> appleAuth() async {
    // TODO implement [appleAuth].
    //  ..
    //  requires an Apple developer account.
    throw UnimplementedError('Apple auth has not been implemnted');
  }
}
