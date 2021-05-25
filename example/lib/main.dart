import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:easy_signature_pad/signature_pad.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Signature Pad Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignaturePadExample(),
    );
  }
}

class SignaturePadExample extends StatefulWidget {
  SignaturePadExample({Key key}) : super(key: key);

  @override
  _SignaturePadExampleState createState() => _SignaturePadExampleState();
}

class _SignaturePadExampleState extends State<SignaturePadExample> {
  Uint8List signatureBytes;

  void displaySIgnatureImage(String bytes) async {
    if (bytes == null) return;
    Uint8List convertedBytes = base64Decode(bytes);
    setState(() {
      signatureBytes = convertedBytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Signature Pad Example"),
      ),
      body: SafeArea(
        child: Container(
          width: size.width,
          color: Colors.grey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (signatureBytes != null)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    Container(
                      height: size.width / 2,
                      width: size.width / 1.5,
                      child: Image.memory(
                        signatureBytes,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("Processed Signature Image"),
                  ],
                ),
              Divider(),
              SignaturePad(
                onChnaged: (image) {
                  displaySIgnatureImage(image);
                },
                height: size.width ~/ 2,
                width: size.width ~/ 1.5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
