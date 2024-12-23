// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiki/authentications_bloc/cubits/signup_cubit.dart';
import 'package:tiki/constatns/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:tiki/pages/onboarding/onboardinng.dart';
import 'package:tiki/pages/tabs/mainpage.dart';
import 'package:tiki/providers/userdata.dart';
import 'package:tiki/respositories/bloc/image_bloc.dart';
import 'package:tiki/respositories/bloc/swipebloc_bloc.dart';
import 'package:tiki/respositories/databerepository.dart';
import 'package:tiki/respositories/mainauth.dart';
import 'respositories/baseusers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    // options: FirebaseOptions(
    //   apiKey: "AIzaSyBeBPCoGMU8NLigK5uVscj8AkPxK7WVrx0",
    //   authDomain: "tinder-clone-705a4.firebaseapp.com",
    //   projectId: "tinder-clone-705a4",
    //   storageBucket: "tinder-clone-705a4.firebasestorage.app",
    //   messagingSenderId: "79733169452",
    //   appId: "1:79733169452:web:0fdc6e145a53d63098a089",
    //   measurementId: "G-T9CGREL91D",
    // ),
  );

  runApp(MultiProvider(
    providers: [
      Provider<UserData>(create: (_) => UserData()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? status;
  void getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      status = prefs.getString('loggedIn');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoginStatus();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [RepositoryProvider(create: (_) => AuthRepository())],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SignupCubit>(
            create: (_) =>
                SignupCubit(authRepository: context.read<AuthRepository>()),
            child: const OnboardingScreen(),
          ),
          BlocProvider(
            create: (_) => SwipeBloc(
              baseUsersRepo: Usersdata(),
            )..add(LoadedSwipe()),
          ),
          BlocProvider(
              create: (_) => ImageBloc(databaseRepository: DatabaseRepository())
                ..add(LoadImage())),
        ],
        child: MaterialApp(
          title: 'Discover',
          debugShowCheckedModeBanner: false,
          initialRoute: OnboardingScreen.routeName,
          onGenerateRoute: AppRouter.onGenerateRoute,
          theme: ThemeData(
              primarySwatch: Colors.red,
              bottomSheetTheme: const BottomSheetThemeData(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              hintColor: Colors.red,
              primaryColorLight: Colors.red),
          home: OnboardingScreen(),
        ),
      ),
    );
  }
}

Future<firebase_auth.User> getCurrentUser() async {
  // Using the prefix directly to access FirebaseAuth
  final firebase_auth.FirebaseAuth auth = firebase_auth.FirebaseAuth.instance;
  final firebase_auth.User? user = auth.currentUser;

  // Make sure to return the user if it's not null, otherwise handle null case
  if (user != null) {
    return user;
  } else {
    throw Exception("No user is currently logged in.");
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<auth.User>(
      future: getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MainPage();
        }
        return OnboardingScreen();
      },
    );
  }
}

// class AuthenticationWrapper extends StatefulWidget {
//   static const String routeName = '/wrapper';
//   static Route route() {
//     return MaterialPageRoute(
//       settings: const RouteSettings(name: AuthenticationWrapper.routeName),
//       builder: (_) => AuthenticationWrapper(),
//     );
//   }

//   @override
//   State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
// }

// class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<auth.User>(
//         future: auth.FirebaseAuth.instance.currentUser! as Future<auth.User>,
//         builder: (BuildContext context, AsyncSnapshot<auth.User> snapshot) {
//           if (snapshot.hasData) {
//             auth.User? user = snapshot.data; // this is your user instance
//             /// is because there is user already logged
//             return HomePage();
//           }

//           /// other way there is no user logged.
//           return OnboardingScreen();
//         });
//   }
// }
