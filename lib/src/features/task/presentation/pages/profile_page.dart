import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:maecha_tasks/src/constants/colors/light_mode/light_mode_colors.dart';
import 'package:maecha_tasks/src/features/authentification/presentation/bloc/auth/auth_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage ({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [
      _itemProfilePage(
        context: context,
        label: "Mes préférences",
        iconData: HeroIcons.cog, // Icône plus adaptée pour les préférences
        action: () {},
      ),
      _itemProfilePage(
        context: context,
        label: "Changer le mot de passe",
        iconData: HeroIcons.key, // Icône plus appropriée pour le mot de passe
        action: () {},
      ),
      _itemProfilePage(
        context: context,
        label: "À propos",
        iconData: HeroIcons.informationCircle, // Icône informative pour "À propos"
        action: () {},
      ),
      _itemProfilePage(
        context: context,
        label: "Se déconnecter",
        iconData: HeroIcons.arrowRightOnRectangle, // Icône de déconnexion
        action: () {
          BlocProvider.of<AuthBloc>(context).add(const LogoutUserEvent());
        },
      ),
    ];
    return Scaffold(
      body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context,index){
            return items[index];
      }),
    );
  }

  Widget _itemProfilePage({
    required BuildContext context,
    required String label,
    required HeroIcons iconData,
    required VoidCallback action
  }){
    return Column(
      children: [
        ListTile(
          leading:  HeroIcon(
            iconData,
            color: primaryLight,
          ),
          title: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          onTap:action,
        ),
        Container(
          width: double.infinity,
          color: secondaryTextLight,
          height: 0.5,
        )
      ],
    );
  }
}


