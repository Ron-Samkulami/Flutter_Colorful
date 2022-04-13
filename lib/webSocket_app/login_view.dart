
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import '../webSocket_app/webSocket.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  GlobalKey _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //点击空白收起键盘
        FocusScopeNode currentFocus = FocusScope.of(context);
        if(!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: null,
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Container(
            margin:EdgeInsets.only(left: 50.0, top: 100, right: 50.0),
            child: Form(
              key : _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child:  Column(
                children: <Widget>[
                  TextFormField(
                    autofocus: true,
                    controller: _unameController,
                    decoration: new InputDecoration(
                      // icon: Icon(Icons.person),
                      prefixIcon: Icon(Icons.person),
                      // prefix: Icon(Icons.person),
                      labelText: 'User',
                      hintText: 'User name/ E-Mail',
                    ),
                    // cursorColor: Colors.red,
                    // cursorWidth: 5.0,
                    // cursorHeight: 50.0,
                    validator: (v) {
                      return v!.trim().isNotEmpty ? null : 'UserName cannot be empty';
                    },
                  ),
                  TextFormField(
                    controller: _pwdController,
                    decoration: new InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    validator: (v) {
                      return v!.trim().length > 5 ? null : "Length of Password must at least 6";
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 38.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                              // style: ButtonStyle (
                              //   shape: MaterialStateProperty.all(StadiumBorder()),
                              // ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text('Login'),
                              ),
                              onPressed: (){
                                if((_formKey.currentState as FormState).validate()) {
                                  _doLogin(_unameController.text, _pwdController.text);
                                }
                              },
                            )
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ),
      ),

    );
  }

  void _doLogin(String userName, String password) {
    print('$userName-$password');

    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          return new WebSocketPage(
            title: 'WebSocketPage',
            channel: new IOWebSocketChannel.connect(
                'ws://echo.websocket.org'),
          );
        },
        fullscreenDialog: true,
      ),
    );
  }

  @override
  void dispose() {
    // widget.channel.sink.close();
    super.dispose();
  }
}

