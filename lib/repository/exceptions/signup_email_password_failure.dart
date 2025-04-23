
class SignUpWithEmailAndPasswordFailure{
  final String message;

  const SignUpWithEmailAndPasswordFailure([this.message = "An Unknown error occurred."]);

  factory SignUpWithEmailAndPasswordFailure.code(String code){
    switch(code){
      case 'weak-password':
        return const SignUpWithEmailAndPasswordFailure('Please enter a stronger password');
      case 'invalid-email':
        return const SignUpWithEmailAndPasswordFailure('Please enter a valid email address');
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordFailure('Email is already in use. Please try a different one');
      case 'operation-not-allowed':
        return const SignUpWithEmailAndPasswordFailure('Email/password sign-in is not enabled for your Firebase project');
      case 'user-disabled':
        return const SignUpWithEmailAndPasswordFailure('This account has been disabled');
      default:
        return const SignUpWithEmailAndPasswordFailure();
    }
  }
}