import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smpc/Views/Auth/signup.dart';
import '../../../constants/constants.dart';
import '../../Controllers/controllers.dart';
import '../Widgets/widgets.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool isValid = false.obs;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      }),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Image.asset(
                  'assets/images/smpclogo.png',
                  // width: 250,
                ),
                const SizedBox(height: 70),
                KTextFieldOutline(
                  lable: 'Email',
                  controller: emailController,
                  autoFillHints: const [AutofillHints.email],
                  textInputType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email),
                  onChange: (value) {
                    checkValidity();
                  },
                ),
                const SizedBox(height: 15),
                KTextFieldOutline(
                  lable: 'Password',
                  controller: passwordController,
                  obscure: true,
                  maxLines: 1,
                  textInputType: TextInputType.visiblePassword,
                  prefixIcon: const Icon(Icons.password),
                  onChange: (value) {
                    checkValidity();
                  },
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.topRight,
                  child: TextButton(onPressed: () {}, child: const Text('Forgot Password? ')),
                ),
                const SizedBox(height: 10),
                KTextHeavyButton(
                  isEnable: isValid,
                  lable: 'LOGIN',
                  height: 47,
                  activeColor: kMainColor,
                  onTap: () async {
                    await Get.find<AuthController>().login(context, emailController.text, passwordController.text);
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const KText(text: 'Your College isn\'t registered? '),
                    TextButton(
                        onPressed: () {
                          Get.to(() => SignupView());
                        },
                        child: const Text('Join Now'))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  checkValidity() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      isValid.value = true;
    } else {
      isValid.value = false;
    }
  }
}
