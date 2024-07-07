  String getIdOfGroupFromFullString(String res) {
    return res.substring(0, res.indexOf('_'));
  }

  String getNameOfGroupFromFullString(String res) {
    return res.substring(res.indexOf('_') + 1);
  }