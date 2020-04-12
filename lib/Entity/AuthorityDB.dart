import 'package:firebase_tutorial/Entity/Authority.dart';

/// This class stores the list of Authority objects
class AuthorityDB {
  List<Authority> authorityList = [];

  AuthorityDB({this.authorityList});

  void setAuthorityList(Authority authority) {
    authorityList.add(authority);
  }

  List<Authority> getAuthorityList() {
    return authorityList;
  }
}
