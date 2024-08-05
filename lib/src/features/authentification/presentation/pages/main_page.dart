import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:maecha_tasks/src/constants/numbers.dart';
import 'package:maecha_tasks/src/constants/strings/strings.dart';
import 'package:maecha_tasks/src/features/authentification/presentation/bloc/bottom_sheet/bottom_sheet_bloc.dart';
import 'package:maecha_tasks/src/features/authentification/presentation/widgets/common_widgets_auth.dart';


class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: 800,
            padding: const EdgeInsets.fromLTRB(paddingPagesApp, 5, paddingPagesApp, paddingPagesApp),
            child: Column(
              children: [
                const Image(image: AssetImage('assets/images/Checklist-rafiki.png'),height: 366,width: 338,),
                Text(welcome,style: Theme.of(context).textTheme.headlineLarge,),
                const Gap(25),
                RichText(
                    textAlign: TextAlign.justify ,
                    text: TextSpan(
                      children: [
                        TextSpan(text: mainDesc,style: Theme.of(context).textTheme.labelMedium),
                        TextSpan(text: registerFree,style: Theme.of(context).textTheme.bodyMedium),
                        TextSpan(text: mainDescSuite,style: Theme.of(context).textTheme.labelMedium),
                      ]
                    )
                ),
                const Gap(40),
                elevatedButton(
                    value: login,
                    onPressed:() => BlocProvider.of<BottomSheetBloc>(context).add(ShowPageEvent(context: context, path: 'login'))
                ),
                const Gap(10),
                outlinedButton(
                    value: register,
                    onPressed: ()=> BlocProvider.of<BottomSheetBloc>(context).add(ShowPageEvent(context: context, path: 'register'))
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}