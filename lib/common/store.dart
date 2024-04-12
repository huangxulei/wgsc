import 'package:shared_preferences/shared_preferences.dart';

class Store {
  // static StoreKeys storeKeys;
  final SharedPreferences _store;
  static Future<Store> getInstance() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return Store._internal(preferences);
  }

  Store._internal(this._store);

//  static int getSpKindid(){
//     return _store.getInt("kindid");
//   }

//   setSpKindid(int kindid) {
//     _store.setInt("kindid", kindid);
//   }

//   getSpWriterid() {
//     return _store.getInt("writerid");
//   }

//   setSpWriterid(int writerid) {
//     _store.setInt("writerid", writerid);
//   }

  getCurrPid() {
    return _store.getInt("currpid");
  }

  setCurrPid(int currpid) {
    return _store.setInt("currpid", currpid);
  }
}
