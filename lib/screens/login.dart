import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:obliviate_app/screens/home.dart';
import 'package:obliviate_app/screens/register.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // A Form Key is an instance of GlobalKey<FormState>, which uniquely identifies the Form widget and allows you to interact with it.
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();


  //firebase
  // Create an instance of FirebaseAuth that provides access to Firebase's authentication methods, like signInWithEmailAndPassword.
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("please enter a value");
        }
        //exp for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),

      ),

    );
    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordController,
        obscureText: true,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("please enter password of min 6 character");
          }
        },

        onSaved: (value) {
          passwordController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.tealAccent,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery
              .of(context)
              .size
              .width,
          onPressed: () { signIn(emailController.text, passwordController.text);
          },
          child: Text(
            "Login",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20,
                color: Colors.black38,
                fontWeight: FontWeight.bold),
          )),


    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>
                  [
                    SizedBox(
                        height: 200,
                        child: Image.asset("assets/logo1.png",
                            fit: BoxFit.contain)),
                    SizedBox(height: 45),


                    emailField,
                    SizedBox(height: 25),
                    passwordField,
                    SizedBox(height: 35),
                    loginButton,
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Dont have an account?"),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => RegistrationScreen()));
                          },
                          child: Text("SignUp", style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        )

                      ],
                    )
                  ],
                ),
              ),
            ),


          ),
        ),
      ),

    );
  }


 // Function to sign in the user using email and password
  void signIn(String email, String password) async {

    // When calling _formKey.currentState.validate(), it will check the validation conditions of each field and return true only if all fields meet their criteria. 
    if (_formKey.currentState!.validate())
    {

      // Use Firebase's signInWithEmailAndPassword method to authenticate the user , which will return the object having information about user and authentication status
      await  _auth.signInWithEmailAndPassword(email: email, password: password)
          .then((uid)=>{
            Fluttertoast.showToast(msg:"Login Succesful"),
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (contex)=>HomeScreen()))
      }).catchError((e)
      {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

}
