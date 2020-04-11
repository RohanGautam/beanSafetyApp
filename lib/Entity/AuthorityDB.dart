import 'package:firebase_tutorial/Entity/Authority.dart';

///This class is to store a List of Authority objects
///Allows for adding authorities to the list
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
