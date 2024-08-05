import 'package:authentication_buttons/authentication_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:maecha_tasks/global/services/shared_preferences_service.dart';
import 'package:maecha_tasks/src/constants/colors/light_mode/light_mode_colors.dart';
import 'package:maecha_tasks/src/constants/numbers.dart';
import 'package:maecha_tasks/src/constants/strings/form_strings.dart';
import 'package:maecha_tasks/src/constants/strings/strings.dart';
import 'package:maecha_tasks/src/features/authentification/domain/entities/auth_form_fields_model.dart';
import 'package:maecha_tasks/src/features/authentification/domain/entities/user_model/user_model.dart';
import 'package:maecha_tasks/src/features/authentification/domain/enum/type_form_enum.dart';
import 'package:maecha_tasks/src/features/authentification/presentation/bloc/auth/auth_bloc.dart';
import 'package:maecha_tasks/src/features/authentification/presentation/bloc/bottom_sheet/bottom_sheet_bloc.dart';
import 'package:maecha_tasks/src/features/authentification/presentation/bloc/form/auth_form_bloc.dart';
import 'package:maecha_tasks/src/features/authentification/presentation/widgets/common_widgets_auth.dart';
import 'package:maecha_tasks/src/utils/easy_loading_messages.dart';
import 'package:maecha_tasks/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tn_bottom_sheet_navigator/tn_bottom_sheet_navigator.dart';
import 'package:maecha_tasks/src/common_widgets/common_form_widgets.dart';

import '../../../../../global/injectable/injectable.dart';



class LoginPage extends StatelessWidget {
  final SharedPreferencesService local;
  const LoginPage(this.local,{super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
    listener: (context, state) {
      if(state is AuthLoadingState){
        showCustomMessage(message: waiting);
      }
      if(state is AuthSuccessState){
        //Affichage du message
        showCustomSuccess(message: state.message);
        //Redirection
        context.go('/home');
        //Fermeture de dialog
        EasyLoading.dismiss();
      }
      if(state is AuthFailureState){
        showCustomError(message: state.message);
        //Fermeture de dialog
        EasyLoading.dismiss();
      }

    },
  child: SingleChildScrollView(
      child: TnBottomSheetScaffold(
          appBar:  TnBottomSheetAppBar(
            title: login,
            theme: TnBottomSheetAppBarTheme(
              titleTextStyle: Theme.of(context).textTheme.headlineLarge!,
            ),
            showCloseIcon: true,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(paddingPagesApp, 0, paddingPagesApp, paddingPagesApp),
            child: Column(
              children: [
                Text(loginPageDesc,style: Theme.of(context).textTheme.titleMedium,),
                const Gap(20),
                _FormLogin(local: local,),
              ],
            ),
          ),

      ),
    ),
);
  }
}

class _FormLogin extends StatefulWidget {
  final SharedPreferencesService local;
  const _FormLogin({required this.local});

  @override
  State<_FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<_FormLogin> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool isChecked = false;
  bool obscureTextPassword = true;

  String emailValue = "";
  String passwordValue = "";

  //
  late bool focusedEmailField;
  late bool focusedPasswordField;
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
    listener: (context, state) {
      if(state is AuthSuccessState){
        //reinialisation des champs
        resetFields([_emailController,_passwordController]);
        setState(() {
          isChecked=false;
        });
      }
    },
  child: BlocBuilder<AuthFormBloc, AuthFormState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(children: [
            _buildEmailField(state),
            const Gap(10),
            _buildPasswordField(state),
            const Gap(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                        checkColor: backgroundLight,
                        activeColor: primaryLight,
                        value: isChecked,
                        onChanged: (val) {
                          setState(() {
                            isChecked = val!;
                          });
                        }
                    ),
                    Text(seSouvenir, style: Theme
                        .of(context)
                        .textTheme
                        .titleMedium,)
                  ],),
                buttonTextCustomize(context, forgotPassword, () {})
              ],),
            const Gap(5),
            elevatedButton(value: login,
                onPressed: state is AuthFormValidState ?
                    () {
                  _logicToLogin(isChecked);
                } :
                null
            ),
            const Gap(15),
            //Or
            Row(
              children: <Widget>[
                const Expanded(
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(continueWith, style: Theme
                      .of(context)
                      .textTheme
                      .titleMedium),
                ),
                const Expanded(
                  child: Divider(
                    thickness: 1,
                    color: secondaryTextLight,
                  ),
                ),
              ],
            ),
            const Gap(15),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: AuthenticationButton(
                authenticationMethod: AuthenticationMethod.google,
                onPressed: () {},
                showLoader: false,
                buttonSize: ButtonSize.large,
              ),
            ),
            const Gap(15),
            Text(noAccount, style: Theme
                .of(context)
                .textTheme
                .titleMedium,),
            const Gap(15),
            outlinedButton(value: register, onPressed: () {
              BlocProvider.of<BottomSheetBloc>(context).add(
                  PushPageEvent(context: context, path: 'register'));
            }),
          ],),
        );
      },
    ),
);
  }
  
  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _initialize()  {
    String? emailLocalValue = widget.local.getUserEmailLocal();
    if (emailLocalValue != null && emailLocalValue.isNotEmpty) {
      setState(() {
        _emailController.text = emailLocalValue;
        emailValue=emailLocalValue;
        _onChangeField();

        focusedPasswordField = true;
        focusedEmailField = false;
        isChecked = true;
      });
    }else{
      setState(() {
        focusedEmailField=true;
        focusedPasswordField=false;
      });
    }
  }

  Widget _buildEmailField(AuthFormState state) {
    return texEditingField(
        label: emailAddress,
        context: context,
        ctrl: _emailController,
        focused: focusedEmailField,
        focusNode: _emailFocusNode,
        textInputAction: TextInputAction.next,
        onChanged: (value) {
          setState(() {
            emailValue=value;
          });
          _onChangeField();
        },
        validator: (value) => _validatedField(state, "email"),
        onFieldSubmitted: (value) {}
    );
  }

  Widget _buildPasswordField(AuthFormState state){
    return passwordFieldForm(
        autofocus: focusedPasswordField,
        label: password,
        context: context,
        ctrl: _passwordController,
        obscureText: obscureTextPassword,
        onTapSuffixIcon: (){
          setState(() {
            obscureTextPassword=!obscureTextPassword;
          });
        },
        focusNode: _passwordFocusNode,
        textInputAction: TextInputAction.done,
        onChanged: (value){
          setState(() {
            passwordValue=value;
          });
          _onChangeField();
        },
        validator: (value) => _validatedField(state, "password"),
        onFieldSubmitted: (value){
          _logicToLogin(isChecked);
        }
    );
  }

  void _logicToLogin(bool checked) {
    BlocProvider.of<AuthBloc>(context).add(LoginUserEvent(userModel: UserModel(email: emailValue,password: passwordValue),isChecked:isChecked));
  }

  //OnValidated
  String? _validatedField(AuthFormState state, String field) {
    if (state is AuthFormInvalidState) {
      if (field == 'email' && state.errors.emailField != "") {
        return state.errors.emailField;
      }
      if (field == 'password' && state.errors.passwordField != "") {
        return state.errors.passwordField;
      }
    }
    return null;
  }

  void _onChangeField(){
    BlocProvider.of<AuthFormBloc>(context).add(AuthValidateFormEvent(
        fields: AuthFormFieldsModel(
          emailField: emailValue,
          passwordField: passwordValue,
        ),
      typeFormEnum: TypeFormEnum.login
    ));
  }
  
  
}
