import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yojana/features/itinerary/ui/create_itinerary_ui/create_itinerary_screen_dates.dart';
import 'package:yojana/features/itinerary/ui/create_itinerary_ui/create_itinerary_screen_destination.dart';
import 'package:yojana/features/itinerary/ui/create_itinerary_ui/create_itinerary_screen_friends.dart';
import 'package:yojana/features/itinerary/ui/create_itinerary_ui/create_itinerary_screen_title.dart';
import 'package:yojana/features/itinerary/ui/create_itinerary_ui/temp_Itinerary.dart';
import 'package:yojana/features/itinerary/ui/home_screen.dart';
import '../features/auth/ui/login_screen.dart';
import 'package:yojana/features/itinerary/ui/itinerary_screen.dart';
import 'package:yojana/features/itinerary/models/itinerary.dart';
import 'package:yojana/features/auth/bloc/auth_bloc.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _subscription;
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

GoRouter createAppRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final authState = authBloc.state;
      final isAuth = authState.status == AuthStatus.authenticated;
      final isLoggingIn = state.uri.toString() == '/login';
      if (!isAuth && !isLoggingIn) return '/login';
      if (isAuth && isLoggingIn) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/createitinerary',
        builder: (context, state) => CreateItineraryScreenTitle(),
        routes: [
          GoRoute(
            path: 'createitinerarydestination',
            builder: (context, state) {
              final tempItinerary = state.extra as TempItinerary?;
              return CreateItineraryScreenDestination(
                tempItinerary: tempItinerary,
              );
            },
          ),
          GoRoute(
            path: 'createitineraryfriends',
            builder: (context, state) {
              final tempItinerary = state.extra as TempItinerary;
              return CreateItineraryScreenFriends(tempItinerary: tempItinerary);
            },
          ),

          GoRoute(
            path: 'createitinerarydates',
            builder: (context, state) {
              final tempItinerary = state.extra as TempItinerary?;
              return CreateItineraryScreenDates(tempItinerary: tempItinerary);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/itinerary',
        builder: (context, state) {
          final itinerary = state.extra as Itinerary?;

          return ItineraryScreen(itinerary: itinerary);
        },
      ),
    ],
  );
}
