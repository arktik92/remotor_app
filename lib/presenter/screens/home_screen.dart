import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:remotor/presenter/screens/mouse_screen.dart';
import 'package:remotor/services/web_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  final ApiService _apiService = ApiService();
  String? serverIp;
  String? serverPort;

  @override
  void initState() {
    super.initState();
    _textFieldFiller();
  }

  Future<void> _loadServerInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      serverIp = prefs.getString('serverIp') ?? '';
      serverPort = prefs.getString('serverPort') ?? '12345';
    });
  }

  void _textFieldFiller() {
    _loadServerInfo();
    // Remplir les champs texte
    _ipController.text = serverIp ?? '';
    _portController.text = serverPort ?? '';
  }

  Future<bool> _testServerConnection() async {
    final apiService = ApiService();
    var serverUrl = "http://$serverIp:$serverPort";

    try {
      final response = await apiService.getRequest(url: '$serverUrl/');
      print('Réponse du serveur : $response');
      return true;
    } catch (e) {
      print('Erreur lors de la connexion au serveur : $e');
      return false;
    }
  }

  // Sauvegarder les informations du serveur
  Future<void> _saveServerInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('serverIp', serverIp ?? '');
    await prefs.setString('serverPort', serverPort ?? '12345');
  }

  // Function to send IP and Port
  void _sendServerDetails() async {
    String ip = _ipController.text.trim();
    String port = _portController.text.trim();

    if (ip.isNotEmpty && port.isNotEmpty) {
      setState(() {
        serverIp = ip;
        serverPort = port;
      });
      var isConnected = await _testServerConnection();

      if (isConnected) {
        _saveServerInfo();
        if (kDebugMode) {
          print('Server IP: $ip, Port: $port');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Server details sent successfully!')),
        );

        _loadServerInfo();
        if (serverIp != null) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MouseScreen()));
        }
      } else {
        print('Cannot established connection');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both IP and Port.')),
      );
    }
  }

  // Placeholder for the scanner
  void _launchScanner() {
    // TODO: Replace this with actual QR code scanner logic
    if (kDebugMode) {
      print("Launching QR Code Scanner...");
    }
  }

  void _sendCommand() async {
    final url = "http://$serverIp:$serverPort/command";
    final body = {
      "command": "move_mouse_up"
    };

    try {
      final response = await _apiService.postRequest(
        url: url,
        body: body,
      );
      print("Réponse : $response");
    } catch (e) {
      print("Erreur : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote Mouse'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _ipController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Server IP',
                hintText: 'e.g., 192.168.0.1',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _portController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Server Port',
                hintText: 'e.g., 12345',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendServerDetails,
              child: const Text('Send'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _launchScanner,
              child: const Text('Launch QR Code Scanner'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendCommand,
              child: const Text('Move test'),
            ),

            const SizedBox(height: 20),
            if (serverIp != null && serverPort != null)
              Text(
                'Server IP: $serverIp, Port: $serverPort',
                style: const TextStyle(fontSize: 18, color: Colors.black),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
