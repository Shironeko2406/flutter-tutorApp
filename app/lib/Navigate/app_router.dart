import 'package:app/screen/Appointment.dart';
import 'package:app/screen/add_post.dart';
import 'package:app/screen/create_appointment.dart';
import 'package:app/screen/edit_post.dart';
import 'package:app/screen/test_file_upload.dart';
import 'package:app/screen/test_push_noti.dart';
import 'package:app/screen/update_profile.dart';
import 'package:app/screen/view_tutor.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app/screen/Sign_up_form.dart';
import 'package:app/screen/home.dart';
import 'package:app/screen/login_form.dart';
import 'package:app/screen/profile.dart';

final GoRouter route = GoRouter(
  // initialLocation: '/login', // Set initial location to login page
  initialLocation: '/login', // Set initial location to login page

  debugLogDiagnostics: true,
  routes: <GoRoute>[
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
      },
    ),

    // GoRoute(
    //   path: '/push-noti',
    //   builder: (BuildContext context, GoRouterState state) {
    //     return const PushNoti();
    //   },
    // ),
    // GoRoute(
    //   path: '/upload',
    //   builder: (BuildContext context, GoRouterState state) {
    //     return const UploadFile();
    //   },
    // ),
    GoRoute(
      path: '/register',
      builder: (BuildContext context, GoRouterState state) {
        return const SignUp();
      },
    ),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
      routes: <GoRoute>[
        GoRoute(
            path: 'user-profile',
            builder: (BuildContext context, GoRouterState state) {
              return ProfilePage();
            },
            routes: <GoRoute>[
              GoRoute(
                path: 'update-profile',
                builder: (BuildContext context, GoRouterState state) {
                  final extra = state.extra as Map<String, dynamic>;
                  final userData = extra['dataUserById'] as Map<String, dynamic>;
                  final refreshProfile = extra['refreshProfile'] as VoidCallback;
                  return UpdateProfile(userData: userData, refreshProfile: refreshProfile);
                },
              ),
            ]),
        GoRoute(
            path: 'view-tutor/:id/:postId', //đường dẫn params
            builder: (BuildContext context, GoRouterState state) {
              final tutorData =
                  state.extra as Map<String, dynamic>; // Lấy param id từ state
              return ViewTutor(
                  id: state.pathParameters['id']!,
                  postId: state.pathParameters['postId']!,
                  tutorData: tutorData);
            },
            routes: <GoRoute>[]),
        GoRoute(
          path: 'create-appointment',
          builder: (BuildContext context, GoRouterState state) {
            final dataAppointment = state.extra as Map<String, dynamic>;
            return CreateAppointment(dataAppointment: dataAppointment);
          },
        ),
        GoRoute(
          path: 'add-post',
          builder: (BuildContext context, GoRouterState state) {
            return AddPostPage();
          },
        ),
        GoRoute(
          path: 'edit-post',
          builder: (BuildContext context, GoRouterState state) {
            final postData = state.extra as Map<String, dynamic>;
            return EditPostPage(postData: postData);
          },
        ),
        GoRoute(
          path: 'appointment',
          builder: (BuildContext context, GoRouterState state) {
            return Appointment();
          },
        )
      ],
    )
  ],
  redirect: (context, state) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (state.uri.path == '/login' && accessToken != null) {
      // If user is logged in and tries to access login page, redirect to home
      return '/home';
    } else if (state.uri.path != '/login' && accessToken == null) {
      // If user tries to access any page other than login and is not logged in, redirect to login
      // return '/login';
      return '/login';
    }

    // No redirection needed
    return null;
  },
);
