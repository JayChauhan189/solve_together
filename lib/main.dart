import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:solve_together/organization/OrgCompletedProjects.dart';
import 'package:solve_together/organization/OrgDisplaySolutionUrl.dart';
import 'package:solve_together/organization/OrgIssuedCertificates.dart';
import 'package:solve_together/organization/OrgOngoingProjects.dart';
import 'package:solve_together/organization/OrgProjectDetails.dart';
import 'package:solve_together/organization/OrgUpdateMyProject.dart';
import 'package:solve_together/screens/wrapper.dart';
import 'package:solve_together/services/auth.dart';
import 'package:solve_together/user/UserCompletedProject.dart';
import 'package:solve_together/user/UserOngoingProject.dart';
import 'package:solve_together/user/UserRequestedProject.dart';
import 'package:solve_together/user/homepage.dart';
import 'package:solve_together/user/signup.dart';
import 'package:solve_together/user/userUpdateProfile.dart';
import 'organization/DisplayProject.dart';
import 'organization/HomePage.dart';
import 'organization/OrgPostProject.dart';
import 'organization/UpdateProfile.dart';
import 'organization/OrgMyProject.dart';
Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ApplicationInit());
}
class ApplicationInit extends StatelessWidget {
  const ApplicationInit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        fontFamily: 'Custom_Fonts',

      ),
      initialRoute: "/",
      routes: {

        "/" : (context) =>Wrapper(auth: Auth()),
        "/home" : (context) =>HomePage(auth: Auth(),),
        "/userhome" : (context) =>HomePageUser(auth: Auth(),),
        "/register" : (context) =>RegisterUser(auth: Auth(),),
        "/org_update_profile" : (context) => UpdateProfile(auth: Auth(),),
        "/userUpdateProfile" : (context) => UserUpdateProfile(auth: Auth(),),
        "/displayproject" : (context) =>DisplayProject(),
        "/display_myprojects" : (context) => OrgMyProjects(auth: Auth(),),
        "/display_ongoingprojects" : (context) => OrgOngoingProjects(auth: Auth(),),
        "/display_user_requestedprojects" : (context) => UserRequestedProject(auth: Auth(),),
        "/display_user_ongoingprojects" : (context) => UserOngoingProject(auth: Auth(),),
        "/display_user_completedprojects" : (context) => UserCompletedProject(auth: Auth(),),
        "/display_completedprojects" : (context) => OrgCompletedProjects(auth: Auth(),),
        "/display_issuedcertificates" : (context) => OrgIssuedCertificates(auth: Auth(),),
        "/org_postproject" : (context) => OrgPostProject(auth: Auth()),
        "/org_updatemyproject" : (context) => OrgUpdateMyProject(auth: Auth()),
        "/org_projectdetails" : (context) => OrgProjectsDetails(auth: Auth()),
        "/org_viewsolutionofproject" : (context) => DisplaySolutionUrl(auth: Auth()),

      }
    );
  }
}
