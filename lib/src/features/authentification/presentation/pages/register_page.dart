import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:maecha_tasks/src/constants/colors/light_mode/light_mode_colors.dart';
import 'package:maecha_tasks/src/constants/numbers.dart';
import 'package:maecha_tasks/src/constants/strings/form_strings.dart';
import 'package:maecha_tasks/src/constants/strings/strings.dart';
import 'package:maecha_tasks/src/features/authentification/domain/entities/auth_form_fields_model.dart';
import 'package:maecha_tasks/src/features/authentification/domain/entities/user_model/user_model.dart';
import 'package:maecha_tasks/src/features/authentification/domain/value_objects/type_form_enum.dart';
import 'package:maecha_tasks/src/features/authentification/presentation/bloc/auth/auth_bloc.dart';
import 'package:maecha_tasks/src/features/authentification/presentation/bloc/bottom_sheet/bottom_sheet_bloc.dart';
import 'package:maecha_tasks/src/features/authentification/presentation/bloc/form/auth_form_bloc.dart';
import 'package:maecha_tasks/src/features/authentification/presentation/widgets/common_widgets_auth.dart';
import 'package:maecha_tasks/src/utils/easy_loading_messages.dart';
import 'package:maecha_tasks/src/utils/utils.dart';
import 'package:tn_bottom_sheet_navigator/tn_bottom_sheet_navigator.dart';
import 'package:maecha_tasks/src/common_widgets/common_form_widgets.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: TnBottomSheetScaffold(
        appBar:  TnBottomSheetAppBar(
          title: register,
          theme: TnBottomSheetAppBarTheme(
            titleTextStyle: Theme.of(context).textTheme.headlineLarge!,
          ),
          showCloseIcon: true,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(paddingPagesApp, 0, paddingPagesApp, paddingPagesApp),
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if(state is AuthLoadingState){
                showCustomMessage(message: waiting);
              }
              if(state is AuthRegisterSuccessState){
                //Affichage du message
                showCustomSuccess(message: state.message);
                //Redirection
                BlocProvider.of<BottomSheetBloc>(context).add(PushPageEvent(context: context, path: 'login'));
                //Fermeture de dialog
                EasyLoading.dismiss();
              }
              if(state is AuthFailureState){
                showCustomError(message: state.message);
              }

            },
            child: Column(
              children: [
                Text(registerPageDesc,style: Theme.of(context).textTheme.titleMedium,),
                const Gap(20),
                const _FormRegister(),
              ],
            ),
          ),
        ),

      ),
    );
  }
}

class _FormRegister extends StatefulWidget {
  const _FormRegister();

  @override
  State<_FormRegister> createState() => _FormRegisterState();
}

class _FormRegisterState extends State<_FormRegister> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfController = TextEditingController();
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _passwordConfFocusNode = FocusNode();

  bool isChecked = false;
  bool obscureTextPassword=true;
  bool obscureTextPasswordConf=true;

  String firstNameValue="";
  String lastNameValue="";
  String emailValue="";
  String passwordValue="";
  String passwordConfValue="";



  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if( state is AuthRegisterSuccessState){
          //reinialisation des champs
          resetFields([_firstNameController,_lastNameController,_emailController,_passwordController,_passwordConfController]);
          setState(() {
            isChecked=false;
          });
        }
      },
      child: BlocBuilder<AuthFormBloc,AuthFormState>(builder: (context,state){
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFirstNameField(state),
                const Gap(10),
                _buildLastNameField(state),
                const Gap(10),
                _buildEmailField(state),
                const Gap(10),
                _buildPasswordField(state),
                const Gap(10),
                _buildPasswordConfField(state),
                const Gap(10),
                //Consignes erreurs
                _consignes(state),
                const Gap(10),
                Text(ourConditions,style: Theme.of(context).textTheme.labelSmall),
                const Gap(1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Checkbox(
                        checkColor: backgroundLight,
                        activeColor: primaryLight,
                        value: isChecked,
                        onChanged: (val){
                          setState(() {
                            isChecked=val!;
                          });
                        }
                    ),
                    Expanded(
                      child: RichText(text: TextSpan(
                          children: [
                            TextSpan(text: read,style: Theme.of(context).textTheme.titleSmall),
                            TextSpan(text: usingConditions,style: Theme.of(context).textTheme.bodySmall,),
                            TextSpan(text: suite,style: Theme.of(context).textTheme.titleSmall),
                          ]
                      )),
                    )

                  ],),
                const Gap(10),
                elevatedButton(value: register, onPressed:
                  state is AuthFormValidState && isChecked ?
                      (){
                    _logicToRegister();
                  } :
                null),
                const Gap(15),

                Center(child: Text(haveAccount,style: Theme.of(context).textTheme.titleMedium,)),
                const Gap(15),
                outlinedButton(value: login, onPressed: (){
                  BlocProvider.of<BottomSheetBloc>(context).add(PushPageEvent(context: context, path: 'login'));
                }),
              ],),
          );
        }),
    );
  }

  @override
  void dispose() {
    _disposeTextEditingField();
    super.dispose();
  }


  Widget _buildFirstNameField(AuthFormState state){
    return texEditingField(
        label: firstName,
        context: context,
        ctrl: _firstNameController,
        focused: true,
        focusNode: _firstNameFocusNode,
        textInputAction: TextInputAction.next,
        onChanged: (value){
          setState(() {
            firstNameValue=value;
          });
          _onChangeField();
        },
        validator: (value) => _validatedField(state, "firstName"),
        onFieldSubmitted: (value){}
    );
  }

  Widget _buildLastNameField(AuthFormState state){
    return texEditingField(
        label: lastName,
        context: context,
        ctrl: _lastNameController,
        focusNode: _lastNameFocusNode,
        textInputAction: TextInputAction.next,
        onChanged: (value){
          setState(() {
            lastNameValue=value;
          });
          _onChangeField();
        },
        validator: (value) => _validatedField(state, "lastName"),
        onFieldSubmitted: (value){}
    );
  }

  Widget _buildEmailField(AuthFormState state){
    return texEditingField(
        label: emailAddress,
        context: context,
        ctrl: _emailController,
        focusNode: _emailFocusNode,
        textInputAction: TextInputAction.next,
        onChanged: (value){
          setState(() {
            emailValue=value;
          });
          _onChangeField();
        },
        validator: (value) => _validatedField(state, "email"),
        onFieldSubmitted: (value){}
    );
  }

  Widget _buildPasswordField(AuthFormState state){
    return passwordFieldForm(
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
        textInputAction: TextInputAction.next,
        onChanged: (value){
          setState(() {
            passwordValue=value;
          });
          _onChangeField();
        },
        validator: (value) => _validatedField(state, "password"),
        onFieldSubmitted: (value){}
    );
  }

  Widget _buildPasswordConfField(AuthFormState state){
    return passwordFieldForm(
        label: passwordConf,
        context: context,
        ctrl: _passwordConfController,
        obscureText: obscureTextPasswordConf,
        onTapSuffixIcon: (){
          setState(() {
            obscureTextPasswordConf=!obscureTextPasswordConf;
          });
        },
        focusNode: _passwordConfFocusNode,
        textInputAction: TextInputAction.send,
        onChanged: (value){
          setState(() {
            passwordConfValue=value;
          });
          _onChangeField();
        },
        validator: (value) => _validatedField(state, "passwordConf"),
        onFieldSubmitted: (value){
          _logicToRegister();
        }
    );
  }


  //OnValidated
  String? _validatedField(AuthFormState state,String field){
    if(state is AuthFormInvalidState){
      if (field == 'firstName' && state.errors.firstNameField  != "") {
        return state.errors.firstNameField;
      }
      if (field == 'lastName' && state.errors.lastNameField != "") {
        return state.errors.lastNameField;
      }
      if (field == 'email' && state.errors.emailField != "") {
        return state.errors.emailField;
      }
      if (field == 'password' && state.errors.passwordField != "") {
        return passwordWrongMessage;
      }
      if (field == 'passwordConf' && state.errors.passwordConfField != "") {
        return state.errors.passwordConfField;
      }
    }
    return null;
  }

  void _onChangeField(){
    BlocProvider.of<AuthFormBloc>(context).add(AuthValidateFormEvent(
        fields: AuthFormFieldsModel(
          firstNameField: firstNameValue,
          lastNameField: lastNameValue,
          emailField: emailValue,
          passwordField: passwordValue,
          passwordConfField: passwordConfValue
        ),
      typeFormEnum: TypeFormEnum.register
    ));
  }

  void _logicToRegister(){
    if(_formKey.currentState != null && _formKey.currentState!.validate() && isChecked){
      //
      UserModel user=UserModel(firstName: firstNameValue,lastName: lastNameValue,email: _emailController.text, password: _passwordController.text);
      BlocProvider.of<AuthBloc>(context).add(RegisterUserEvent(userModel: user));
    }
  }

  void _disposeTextEditingField(){
    _lastNameController.dispose();
    _firstNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfController.dispose();
  }

  Widget _consignes(AuthFormState state){
    return
      state is AuthFormValidState ?
      const Gap(0):
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(regexUppercaseString,style: Theme.of(context).textTheme.titleMedium,),
          Text(regexDigitString,style: Theme.of(context).textTheme.titleMedium,),
          Text(regexMinLengthString,style: Theme.of(context).textTheme.titleMedium,),
          Text(regexSpecialCharString,style: Theme.of(context).textTheme.titleMedium,),
        ],
      );
  }

}
