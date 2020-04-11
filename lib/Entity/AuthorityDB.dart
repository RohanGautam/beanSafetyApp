import 'package:firebase_tutorial/Authority.dart';

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
