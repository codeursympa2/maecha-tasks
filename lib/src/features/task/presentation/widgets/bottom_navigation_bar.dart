import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:maecha_tasks/src/constants/colors/light_mode/light_mode_colors.dart';
import 'package:maecha_tasks/src/features/task/presentation/pages/home_page.dart';
import 'package:maecha_tasks/src/features/task/presentation/pages/list_tasks_page.dart';
import 'package:maecha_tasks/src/features/task/presentation/pages/task_page.dart';

BottomNavigationBar bottomNavigationBar(BuildContext context,int selectedIndex, onItemTapped)  {
  return BottomNavigationBar(
      enableFeedback:false ,
      type: BottomNavigationBarType.fixed,
      backgroundColor: backgroundLight,
      selectedItemColor: primaryLight,
      unselectedItemColor: primaryTextLight,
      onTap: onItemTapped,
      currentIndex: selectedIndex,
      items: [
        _buildBottomNavigationBarItem(
          icon: HeroIcons.home,
          label: 'Accueil',
          selectedIndex: selectedIndex
        ),
        _buildBottomNavigationBarItem(
          icon: HeroIcons.calendar,
          label: 'Agenda',
          selectedIndex: selectedIndex
        ),
        _buildBottomNavigationBarItem(
          icon: HeroIcons.plusCircle,
          label: 'Ajouter',
          selectedIndex: selectedIndex
        ),
        _buildBottomNavigationBarItem(
          icon: HeroIcons.clipboardDocumentList,
          label: 'Tâches',
          selectedIndex: selectedIndex
        ),
        _buildBottomNavigationBarItem(
          icon: HeroIcons.user,
          label: 'Mon compte',
          selectedIndex: selectedIndex
        ),
      ]
  );
}

BottomNavigationBarItem _buildBottomNavigationBarItem({
  required HeroIcons icon,
  required String label,
  required int selectedIndex
}) {
  return BottomNavigationBarItem(

    icon: HeroIcon(
      icon,
      size: label == "Ajouter" ? 50 :24,
      style: selectedIndex == _bottomNavItems.indexOf(label)
          ? HeroIconStyle.solid
          : HeroIconStyle.outline,
      ),
      label: label == "Ajouter" ? "" : label,
  );
}

Widget getPage(int index) {
  // Return the appropriate widget for each tab
  switch (index) {
    case 0:
      return const HomePage();
    case 1:
      return const Text('Agenda Page');
    case 2:
      return  const TaskPage();
    case 3:
      return const ListTasksPage();
    case 4:
      return const Text('Mon compte Page');
    default:
      return const Text('Home Page');
  }
}

final List<String> _bottomNavItems = [
  'Accueil',
  'Agenda',
  'Ajouter',
  'Tâches',
  'Mon compte',
];

String  tooltip(int index){
  switch (index) {
    case 0:
      return _bottomNavItems[0];
    case 1:
      return _bottomNavItems[1];
    case 2:
      return _bottomNavItems[2];
    case 3:
      return _bottomNavItems[3];
    case 4:
      return _bottomNavItems[4];
    default:
      return _bottomNavItems[5];
  }
}

