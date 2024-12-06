import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:remotor/services/web_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MouseScreen extends StatefulWidget {
  const MouseScreen({super.key});

  @override
  _MouseScreenState createState() => _MouseScreenState();

}

  class _MouseScreenState extends State<MouseScreen> {
    final apiService = ApiService();
    String? serverIp;
    String? serverPort;
    
    @override
  void initState() {
    super.initState();
    _loadServerInfo();
  }
  
    Future<void> _loadServerInfo() async {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        serverIp = prefs.getString('serverIp') ?? '';
        serverPort = prefs.getString('serverPort') ?? '12345';
      });
    }

    void _handleSwipe(DragUpdateDetails details) {
      // Logique pour le glissement
      print('Glissement détecté : ${details.delta}');
    }

    void _handleSingleTap() async {
      // Logique pour un simple tap à un doigt
      final apiService = ApiService();
      var serverUrl = "http://$serverIp:$serverPort/command";

      const body = {"command": "left_click"};
      
      try {
        await apiService.postRequest(url: serverUrl, body: body);
      } catch (e) {
        print("Erreur lors de l'envoi de la commande au server");
      }

      print('Touché à un doigt détecté');
    }

    void _handleDoubleTap() async {
      // Logique pour un double tap ou un tap à deux doigts
      final apiService = ApiService();
      var serverUrl = "http://$serverIp:$serverPort/command";

      const body = { "command": "right_click"};

      try {
        await apiService.postRequest(url: serverUrl, body: body);
      } catch (e) {
        print("Erreur lors de l'envoi de la commande au server");
      }
      print('Touché à deux doigts détecté');
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Remote Mouse'),
          centerTitle: true,
        ),
        body: GestureDetector(
          onPanUpdate: _handleSwipe, // Pour détecter les glissements
          onTap: _handleSingleTap, // Pour un tap à un doigt
          onDoubleTap: _handleDoubleTap, // Pour un double tap ou 2 doigts
          child: Container(
            color: Colors.grey[300],
            child: const Center(
              child: Text(
                'Interact with the screen',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
      );
    }  
  }

  

