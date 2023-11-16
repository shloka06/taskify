import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'task_list_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Parse().initialize(
    'fA8MsaGKCPupUCXY13weBoPEhhbU63HDEAoGS6Sd',
    'https://parseapi.back4app.com',
    clientKey: '{ADD YOUR CLIENT KEY HERE}',
    autoSendSessionId: true,
    debug: true,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TASKIFY',
      home: TaskListScreen(),
    );
  }
}