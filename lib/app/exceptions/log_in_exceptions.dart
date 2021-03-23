class LoginExceptions {
  static String showException(String? exception) {
    switch (exception) {
      case 'The email address is badly formatted.':
        return "Hatalı mail adresi";

      case 'The password is invalid or the user does not have a password.':
        return "Hatalı mail adresi veya şifre";

      case 'There is no user record corresponding to this identifier. The user may have been deleted.':
        return "Kayıtlı böyle bir mail adresi yok";

      default:
        return "Bir hata olustu";
    }
  }
}