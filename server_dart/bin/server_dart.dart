import 'dart:io';
import 'package:server_dart/api/get_application_form_api.dart';
import 'package:server_dart/api/save_application_form_api.dart';
import 'package:server_dart/api/send_otp_api.dart';
import 'package:server_dart/private/setting/mongodb.dart';
import 'package:server_dart/private/setting/server_setting.dart';
import 'package:server_dart/private/utility/request_to_api.dart';
import 'package:share_dart/private/path/api_path.dart';
import 'package:share_dart/private/path/folder_path.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import 'package:shelf_static/shelf_static.dart' as shelf_static;

Future main(List<String> arguments) async {
  if (!await initialApp()) return;
  final cascade = Cascade().add(_staticHandler).add(_router);
  final context = SecurityContext()
    ..useCertificateChain(ServerSetting.certificateChain)
    ..usePrivateKey(ServerSetting.privateKey);
  //final server = await shelf_io.serve(logRequests().addHandler(cascade.handler), InternetAddress.anyIPv4, ServerSetting.port); //local
  final server = await shelf_io.serve(cascade.handler, InternetAddress.anyIPv4, ServerSetting.port, securityContext: context); // server
  print('\nServer is running\naddress:${server.address.address}\nhost:${server.address.host}\nport: ${server.port}\n');
}

Future<bool> initialApp() async {
  if (!await Mongodb().initialApp()) {
    print("Mongodb initialApp failed.");
    return false;
  }
  return true;
}

final _staticHandler = shelf_static.createStaticHandler(FolderPath.rootPublic, defaultDocument: 'index.html');
final _router = shelf_router.Router()
  ..post(ApiPath.sendOtp, (Request request) => requestToApi(request).then(sendOtpApi))
  ..post(ApiPath.getApplicationForm, (Request request) => requestToApi(request).then(getApplicationFormApi))
  ..post(ApiPath.saveApplicationForm, (Request request) => requestToApi(request).then(saveApplicationFormApi))
  ..all('/<ignored|.*>', (Request request) {
    if (request.method == 'OPTIONS') return ServerSetting.preflightResponse;
    return Response.internalServerError();
  });
