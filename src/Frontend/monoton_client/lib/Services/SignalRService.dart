import 'package:monoton_client/Services/ConstantService.dart';
import 'package:monoton_client/Services/RestService.dart';
import 'package:signalr_netcore/default_reconnect_policy.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/itransport.dart';

import '../Infrustructure/InfinitRetryPolicy.dart';

class SignalRService {

  static bool inited = false;
  static bool ready = false;
  static late  HubConnection hubConnection ;
  static Future<bool> init() async {
    if (inited){
      return true;
    }
    try {

      hubConnection =  HubConnectionBuilder()
          .withAutomaticReconnect(reconnectPolicy: InfinitRetryPolicy())
          .withUrl( ConstantService.SERVER_URL + ConstantService.ENDPOINTS_NOTIFICATIONHUB,    options: HttpConnectionOptions(
          requestTimeout: 60000,
          skipNegotiation: true,
          transport: HttpTransportType.WebSockets,
          accessTokenFactory: () async =>
              RestService.sessionJwtTokenProvider()))
          .build();
      await hubConnection.start();
    }catch (e){
      return false;
    }
// Creates the connection by using the HubConnectionBuilder.

    inited = true;
    ready = true;
    return true;
  }
  static Future informOnline() async {
    if (!ready) return;
    hubConnection.invoke("InformOnline");
  }
}