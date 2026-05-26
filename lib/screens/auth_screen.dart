import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../core/cloud_profile_sync.dart';
import '../core/invite_service.dart';
import '../core/oauth_config.dart';

class AuthScreen extends StatefulWidget {
  final ValueChanged<String> onAuthenticated;

  const AuthScreen({super.key, required this.onAuthenticated});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();

  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final _registerConfirmPasswordController = TextEditingController();
  final _inviteCodeController = TextEditingController();

  bool _isLoading = false;

  bool get _firebaseReady => Firebase.apps.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _registerConfirmPasswordController.dispose();
    _inviteCodeController.dispose();
    super.dispose();
  }

  String? _emailValidator(String? value) {
    final l10n = AppLocalizations.of(context)!;
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return l10n.authEnterEmail;
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(email)) {
      return l10n.authInvalidEmail;
    }

    return null;
  }

  String? _passwordValidator(String? value) {
    final l10n = AppLocalizations.of(context)!;
    final password = value ?? '';
    if (password.isEmpty) {
      return l10n.authEnterPassword;
    }

    if (password.length < 8) {
      return l10n.authPasswordMin;
    }

    return null;
  }

  Future<void> _signInWithEmail() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_loginFormKey.currentState!.validate()) {
      return;
    }

    if (!_firebaseReady) {
      _showMessage(l10n.authFirebaseGuestOnly);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _loginEmailController.text.trim(),
        password: _loginPasswordController.text,
      );

      if (!mounted) {
        return;
      }

      final email = credential.user?.email ?? _loginEmailController.text.trim();
      widget.onAuthenticated(email);
    } on FirebaseAuthException catch (e) {
      _showMessage(_authErrorText(e));
    } catch (_) {
      _showMessage(l10n.authSignInFailed);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _registerWithEmail() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_registerFormKey.currentState!.validate()) {
      return;
    }

    if (_registerPasswordController.text !=
        _registerConfirmPasswordController.text) {
      _showMessage(l10n.authPasswordsMismatch);
      return;
    }

    if (!_firebaseReady) {
      _showMessage(l10n.authFirebaseGuestOnly);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _registerEmailController.text.trim(),
            password: _registerPasswordController.text,
          );

      if (!mounted) return;

      final user = credential.user!;
      final email = user.email ?? _registerEmailController.text.trim();

      // Если введён инвайт-код — привязываем к организации
      final inviteCode = _inviteCodeController.text.trim();
      if (inviteCode.isNotEmpty) {
        await CloudProfileSync.ensureUserProfile(fallbackName: email);
        try {
          await InviteService.validateAndJoinOrg(
            code: inviteCode,
            userUid: user.uid,
          );
          if (mounted) {
            _showMessage(l10n.authJoinSuccess);
          }
        } catch (inviteError) {
          // Регистрацию не отменяем — просто показываем ошибку кода
          if (mounted) {
            _showMessage(l10n.authInviteRejected(inviteError.toString()));
          }
        }
      }

      if (!mounted) return;
      widget.onAuthenticated(email);
    } on FirebaseAuthException catch (e) {
      _showMessage(_authErrorText(e));
    } catch (_) {
      _showMessage(l10n.authRegisterFailed);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_firebaseReady) {
      _showMessage(l10n.authFirebaseGuestOnly);
      return;
    }

    setState(() => _isLoading = true);

    try {
      UserCredential credential;

      if (kIsWeb) {
        credential = await FirebaseAuth.instance.signInWithPopup(
          GoogleAuthProvider(),
        );
      } else {
        final googleSignIn = GoogleSignIn(
          serverClientId: OAuthConfig.googleServerClientId,
          scopes: const ['email'],
        );

        await googleSignIn.signOut();
        final googleUser = await googleSignIn.signIn();
        if (googleUser == null) {
          if (mounted) {
            _showMessage(l10n.authAuthorizationError);
          }
          return;
        }

        final googleAuth = await googleUser.authentication;
        final firebaseCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        credential = await FirebaseAuth.instance.signInWithCredential(
          firebaseCredential,
        );
      }

      if (!mounted) return;
      final profileLabel =
          credential.user?.displayName ??
          credential.user?.email ??
          _registerEmailController.text.trim();
      widget.onAuthenticated(profileLabel);
    } on FirebaseAuthException catch (e) {
      debugPrint('Google FirebaseAuthException: ${e.code} ${e.message}');
      _showMessage(_authErrorText(e));
    } catch (e) {
      debugPrint('Google sign-in error: $e');
      final message = e.toString();
      if (message.isNotEmpty) {
        _showMessage(message);
      } else {
        _showMessage(l10n.authAuthorizationError);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showMessage(String text) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  String _authErrorText(FirebaseAuthException e) {
    final l10n = AppLocalizations.of(context)!;
    switch (e.code) {
      case 'invalid-email':
        return l10n.authInvalidEmailFormat;
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return l10n.authWrongCredentials;
      case 'email-already-in-use':
        return l10n.authEmailInUse;
      case 'weak-password':
        return l10n.authWeakPassword;
      case 'too-many-requests':
        return l10n.authTooManyRequests;
      case 'network-request-failed':
        return l10n.authAuthorizationError;
      default:
        return e.message ?? l10n.authAuthorizationError;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(Icons.lock_outline, size: 48, color: scheme.primary),
                      const SizedBox(height: 12),
                      Text(
                        l10n.authWelcome,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 6),
                      Text(l10n.authSubtitle, textAlign: TextAlign.center),
                      const SizedBox(height: 20),
                      TabBar(
                        controller: _tabController,
                        tabs: [
                          Tab(text: l10n.authTabSignIn),
                          Tab(text: l10n.authTabRegister),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 370,
                        child: TabBarView(
                          controller: _tabController,
                          children: [_buildSignInForm(), _buildRegisterForm()],
                        ),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: _isLoading ? null : _signInWithGoogle,
                        icon: const Icon(Icons.g_mobiledata),
                        label: Text(l10n.authContinueWithGoogle),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInForm() {
    final l10n = AppLocalizations.of(context)!;
    return Form(
      key: _loginFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: _loginEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: l10n.emailLabel,
              prefixIcon: const Icon(Icons.alternate_email),
            ),
            validator: _emailValidator,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _loginPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: l10n.authPasswordLabel,
              prefixIcon: const Icon(Icons.key_outlined),
            ),
            validator: _passwordValidator,
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: _isLoading ? null : _signInWithEmail,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.authTabSignIn),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    final l10n = AppLocalizations.of(context)!;
    return Form(
      key: _registerFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: _registerEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: l10n.emailLabel,
              prefixIcon: const Icon(Icons.mail_outline),
            ),
            validator: _emailValidator,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _registerPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: l10n.authPasswordLabel,
              prefixIcon: const Icon(Icons.lock_outline),
            ),
            validator: _passwordValidator,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _registerConfirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: l10n.authConfirmPasswordLabel,
              prefixIcon: const Icon(Icons.lock_reset_outlined),
            ),
            validator: _passwordValidator,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _inviteCodeController,
            textCapitalization: TextCapitalization.characters,
            maxLength: 6,
            decoration: InputDecoration(
              labelText: l10n.authInviteCodeOptional,
              hintText: l10n.authInviteHint,
              prefixIcon: const Icon(Icons.group_add_outlined),
              counterText: '',
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: _isLoading ? null : _registerWithEmail,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.authRegisterButton),
          ),
        ],
      ),
    );
  }
}
