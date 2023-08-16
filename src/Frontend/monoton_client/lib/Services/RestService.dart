import 'package:dio/dio.dart';
import 'package:monoton_client/Services/ConstantService.dart';
import 'package:monoton_client/Services/StorageService.dart';

class RestService{



  static bool inited = false;
  static Future<bool> init ( [bool force = false]) async {
    if (inited & ! force){
      return true;
    }
    final dio = Dio();
    try{
      final response = await dio.get(ConstantService.SERVER_URL + ConstantService.ENDPOINTS_PING);
      if (response.data.toString().toLowerCase() != "pong"){
        return false;
      }
      inited = true;
      return true;
    }catch (e){
      return false;
    }

  }

  static Future<String> sessionJwtTokenProvider() async{
    var result = await StorageService.storage.read(key: "jwt");
    if (result == null){
      throw Exception("jwt is not set but it is asked by other services, this usually means you are firing up some services before authentication");
    }
    return result;
  }

  static Future<bool> login(String username , String password) async{

    try{
      final dio = Dio();
      late Response response;
      response = await dio.post(ConstantService.SERVER_URL + ConstantService.ENDPOINTS_LOGIN,
          data : {
            "username" : username,
            "password" : password
          }
      );
      if (response.statusCode == 200){
        StorageService.storage.write(key: "jwt", value: response.data);
        return true;
      }else{
        return false;
      }
    }catch (e){
      rethrow;
    }

  }


  static Future<bool> signup(String username , String password) async{

    try{
      final dio = Dio();
      late Response response;
      response = await dio.post(ConstantService.SERVER_URL + ConstantService.ENDPOINTS_SIGNUP,
          data : {
            "username" : username,
            "password" : password
          }
      );
      if (response.statusCode == 200){
        return true;
      }else{
        return false;
      }
    }catch (e){
      rethrow;
    }

  }
}