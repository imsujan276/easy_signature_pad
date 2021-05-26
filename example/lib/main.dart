import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:easy_signature_pad/easy_signature_pad.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Signature Pad Example',
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

  void setImage(String bytes) async {
    if (bytes.isNotEmpty) {
      Uint8List convertedBytes = base64Decode(bytes);
      setState(() {
        signatureBytes = convertedBytes;
      });
    } else {
      setState(() {
        signatureBytes = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Easy Signature Pad Example"),
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
              EasySignaturePad(
                onChanged: (image) {
                  setImage(image);
                },
                height: size.width ~/ 2,
                width: size.width ~/ 1.5,
                penColor: Colors.black,
                strokeWidth: 1.0,
                borderRadius: 10.0,
                enableShadow: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
