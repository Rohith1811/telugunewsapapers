import 'Network.dart';

const String catAPIURL =
    'http://telugupaper.in/news/apis/mobile_api/all_categories';
const String paperdistrictURL =
    'http://telugupaper.in/news/apis/mobile_api/newspapers';

class CatAPI {
  Future<dynamic> getnewscategories(String deviceId,String fcmToken) async {
    Network network = Network('$catAPIURL');
    var catData = await network.getData(deviceId,fcmToken);
    return catData;
  }

  Future<dynamic> getdistrictpapers(
      String catid, String subcatid, String date) async {
    Network network = Network('$paperdistrictURL');
    var catData = await network.getpostData(catid, subcatid, date); //
    return catData;
  }
}
