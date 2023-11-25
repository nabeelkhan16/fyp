import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trash_collector/blocs/authentication/authentication_bloc.dart';
import 'package:trash_collector/screens/profile/user_information.dart';
import 'package:trash_collector/widgets/app_bar.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade800,
            Colors.blue.shade700,
            Colors.blue.shade600,
            Colors.blue.shade500,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GlobalAppBar(
          context,
          title: 'Settings',
          leading: true,
          chatcreen: false,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    margin:
                        const EdgeInsets.only(left: 18, right: 18, bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UserInformation()));
                      },
                      leading: Icon(
                        Icons.person_outline_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: const Text(
                        'User Information',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // Container(
                  //   margin:
                  //       const EdgeInsets.only(left: 18, right: 18, bottom: 8),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white.withOpacity(.5),
                  //     borderRadius: BorderRadius.circular(30),
                  //   ),
                  //   child: ListTile(
                  //     onTap: () {
                  //       // Navigator.pushNamed(context, Routes.settings);
                  //     },
                  //     leading: Icon(
                  //       Icons.privacy_tip_sharp,
                  //       color: Theme.of(context).primaryColor,
                  //     ),
                  //     title: const Text(
                  //       'Settings',
                  //       style: TextStyle(
                  //           fontSize: 18, fontWeight: FontWeight.bold),
                  //     ),
                  //     trailing: Icon(
                  //       Icons.arrow_forward_ios_outlined,
                  //       color: Theme.of(context).primaryColor,
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 5,
                  // ),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 18, right: 18, bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ListTile(
                      onTap: () async {
                        context
                            .read<AuthenticationBloc>()
                            .add(AuthenticationLogout());
                        Navigator.pop(context);
                      },
                      leading: Icon(
                        Icons.logout,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: const Text(
                        'Logout',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
