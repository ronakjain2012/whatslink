import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<Home> {
  String? _number = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildNumber() {
    return TextFormField(
      decoration: const InputDecoration(
          hintText: "Enter number",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          prefixIcon: Icon(Icons.link)),
      validator: (String? val) {
        if (val!.isEmpty) {
          return "Number can not be empty";
        }
        return null;
      },
      onSaved: (String? val) {
        _number = val;
      },
    );
  }

  void submit() async {
    // First validate form.
    print(_formKey.currentState);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save our form now.
      print(numberClean(_number));
      var url = "https://wa.me/+91" + numberClean(_number);
      await _launchWAURL(url);
    }
  }

  _launchWAURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String numberClean(num) {
    // First validate form.
    var newNumber = num;
    newNumber = newNumber?.replaceAll(' ', '')?.trim();
    if (newNumber!.startsWith('+91')) {
      newNumber = newNumber.substring(3);
    }
    if (newNumber.startsWith('0')) {
      newNumber = newNumber.substring(1);
    }
    return newNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WhatsLink"),
      ),
      drawer: const Drawer(),
      body: Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _buildNumber(),
                  const SizedBox(height: 10),
                  const Text(
                    'Paste any number from clipboard or call history to message them without saving the number',
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: submit,
                    child: const Text("Message",
                        style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
