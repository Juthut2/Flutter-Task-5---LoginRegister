class UserStore {
  UserStore._();

  static final Map<String, String> _users = {};

  static bool usernameExists(String username) {
    return _users.containsKey(username.trim().toLowerCase());
  }

  static void addUser({required String username, required String password}) {
    _users[username.trim().toLowerCase()] = password;
  }

  static bool validateCredentials({
    required String username,
    required String password,
  }) {
    return _users[username.trim().toLowerCase()] == password;
  }
}
