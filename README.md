# Easy Signature Pad

Easy Signature Pad is the flutter plugin that allows users to draw on the canvas and get the signature as Base64 image. 

## Preview
![Preview](https://github.com/imsujan276/easy_signature_pad/blob/main/screenshots/output.gif)

## Features
* set canvas boundaries.
* set drawing pen color, pen size, canvas border radius.
* set callback function to the signature


## Example 
```
import 'package:easy_signature_pad/easy_signature_pad.dart';

// initialise the variable to store signature image
Uint8List signatureBytes;

// Use the SignaturePad Widget
EasySignaturePad(
  onChanged: (image) {
    setImage(image);
  },
  height: size.width ~/ 2,
  width: size.width ~/ 1.5,
  penColor: Colors.black,
  strokeWidth: 1.0,
  borderRadius: 10.0,
  borderColor: Colors.white,
  backgroundColor: Colors.white,
  transparentImage: false,
  transparentSignaturePad: false,
  hideClearSignatureIcon: false,
),


// process the base64 image 
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
```

## Contribution and support
- If you want to contribute to the code, please create a pull request. 
- If you find any bug, please create an issue.
