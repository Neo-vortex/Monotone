import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:monoton_client/Models/Dto/Response/ApplicationUser.dart';
import 'package:monoton_client/Services/ConstantService.dart';
import 'package:monoton_client/Services/StorageService.dart';

import '../Models/Dto/Request/CreateNewChat.dart';

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
        Map<String, dynamic> decodedToken = JwtDecoder.decode(response.data);
        StorageService.storage.write(key: "jwt", value: response.data);
        StorageService.storage.write(key: "id",  value:  decodedToken['nameid']);
        StorageService.storage.write(key: "name",  value:  decodedToken['unique_name']);
        StorageService.storage.write(key: "profilePicture",  value:  decodedToken['ProfilePicture']);

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

  static Future<List<String>> SearchUsername(String query) async {
    try{
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            options.headers['Authorization'] = 'Bearer ${await sessionJwtTokenProvider()}';
            return handler.next(options);
          },
        ),
      );
      late Response response;
      Map<String, dynamic> queryitems = {
        'searchKey': query,
      };
      response = await dio.get("${ConstantService.SERVER_URL}${ConstantService.ENDPOINTS_SEARCHUSERNAME}" , queryParameters:queryitems  );
      if (response.statusCode == 200){
        final List<dynamic> jsonList = (response.data);
        final List<String> newXList = jsonList.map((json) {
          //todo read profile picture as well
          return json['userName'].toString();
        }).toList();
        return newXList;
      }else{
        return [];
      }
    }catch (e){
      return [];
    }
  }

  static Future<ApplicationUser?> GetUserByUserName(String query) async {
    try{
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            options.headers['Authorization'] = 'Bearer ${await sessionJwtTokenProvider()}';
            return handler.next(options);
          },
        ),
      );
      late Response response;
      Map<String, dynamic> queryitems = {
        'username': query,
      };
      response = await dio.get("${ConstantService.SERVER_URL}${ConstantService.ENDPOINTS_GETUSERBYUSERNAME}" , queryParameters:queryitems  );
      if (response.statusCode == 200){
        var user = ApplicationUser.fromJson(response.data);
        return user;
      }else{
        return null;
      }
    }catch (e){
      return null;
    }
  }

  static Future<String> CreateNewChat(CreateNewChatCommand query) async {
    try{
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            options.headers['Authorization'] = 'Bearer ${await sessionJwtTokenProvider()}';
            return handler.next(options);
          },
        ),
      );
      late Response response;

      response = await dio.post("${ConstantService.SERVER_URL}${ConstantService.ENDPOINTS_CREATENEWCHAT}" , data:  query.toJson()  );
      if (response.statusCode == 200){
        return response.data as String;
      }else{
        return "";
      }
    }catch (e){
      return "";
    }
  }
}