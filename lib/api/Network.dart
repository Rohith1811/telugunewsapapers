import 'package:http/http.dart';
import 'package:intl/intl.dart';

class Network {
  final String url;

  Network(this.url);

  var formater;
  var formatteddate;
  var formatter = new DateFormat('yyyy-MM-dd');
  

 Future getData(String deviceId,String fcmtoken) async {
   Map<String, String> requestbody ={
     "ip_address":deviceId,
     "fcm_token":fcmtoken
   };
    print('Calling uri: $url');
    Response response = await post(url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: requestbody);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      print(response.statusCode);
    }
  }

  //


  
  Future getpostData(String catid, String subcatid, String date) async {

    Map<String, String> paramBody;
    formater = new DateFormat('yyyy-MM-dd');
    formatteddate = formater.format(DateTime.parse(date));
    if(date == null){
 paramBody = {
      "category_id": catid,
      "sub_category_id": subcatid,
      //"date": formatteddate
    };


    }
    else{
  paramBody = {
      "category_id": catid,
      "sub_category_id": subcatid,
      "date": formatteddate
    };


    }
    
    print('Calling uri: $url');
    Response response = await post(url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: paramBody);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      print(response.statusCode);
    }
  }
}
