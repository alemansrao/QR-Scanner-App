import 'dart:async';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart'; 
void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}
 String result = "Click the Button to Scan the attendance QR code !";

class HomePageState extends State<HomePage> {

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
        Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ScanningPage()),
  );
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "Click the Button to Scan the attendance QR code";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
      });
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Scanner"),
      ),
      body: Center(
        child: Text(
          // result,
          "Click the Button to Scan the attendance QR code",
          style: new TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.photo_camera),
        label: Text("Scan"),
        onPressed: _scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class ScanningPage extends StatelessWidget {
  Completer<WebViewController> _controller = Completer<WebViewController>();
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        
      ),
      body: WebView(
        initialUrl: 'http://192.168.43.59/Project-root/scan.php?qrcode='+result,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        javascriptMode: JavascriptMode.unrestricted,
      ),
      
    );
  }
}
