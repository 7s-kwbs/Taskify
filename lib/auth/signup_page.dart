import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _signupPageState();
}

class _signupPageState extends State<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  void showSnackBar(String message){
    ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(message),)
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text(
          "Sign Up",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              "Lets get Started",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Full Name",
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Confirm Password",
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async{
                String name = nameController.text;
                String email = emailController.text;
                String password = passwordController.text;
                String confirmPassword = confirmPasswordController.text;

                if(name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty){
                  showSnackBar("Please fill all fields");
                  return;
                }
                if(password != confirmPassword){
                  showSnackBar("Password do not match");
                  return;
                }
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString("name", name);
                await prefs.setString("email", email);
                await prefs.setString("password", password);
                
                showSnackBar("Account Created Successfully ");
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
              ),
              child: Text(
                "sign Up",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 10,),
            Text("OR"),
            Text("Sign in with", style:TextStyle(
              fontSize: 16,
              color: Colors.black
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              
              children: [
                IconButton(onPressed: (){}, icon: Icon(Icons.facebook_rounded, color: Colors.blue, size: 32,),),
                // SizedBox(width: 5,),
                IconButton(onPressed: (){}, icon: Image.asset("assets/images/google.png",width: 54,fit:BoxFit.cover,)),
                // SizedBox(width: 5,),
                IconButton(onPressed: (){}, icon: Image.asset("assets/images/linkedin.webp",width: 28,))
              ],
            )
          ],
        ),
      ),
    );
  }
}
