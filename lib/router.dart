import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:strybuc/layout.dart';
import 'package:strybuc/screens/contact_sales_rep.dart';
import 'package:strybuc/screens/photo_gallery.dart';
import 'package:strybuc/screens/exclusive_offers.dart';
import 'package:strybuc/screens/forms.dart';
import 'package:strybuc/screens/guest_login.dart';
import 'package:strybuc/screens/home.dart';
import 'package:strybuc/screens/library.dart';
import 'package:strybuc/screens/live_chat.dart';
import 'package:strybuc/screens/login.dart';
import 'package:strybuc/screens/photograph_parts/android/distance_tracking.dart';
import 'package:strybuc/screens/photograph_parts/ios/ios_distance_tracking.dart';
import 'package:strybuc/screens/photograph_parts/instructions.dart';
import 'package:strybuc/screens/photograph_parts/send_request.dart';
import 'package:strybuc/screens/profile.dart';
import 'package:strybuc/screens/shop.dart';
import 'package:strybuc/screens/sign_up.dart';
import 'package:strybuc/screens/splash_screen.dart';
import 'package:strybuc/screens/thank_you.dart';
import 'package:strybuc/screens/android_distance_tracking_screen.dart';

GoRouter createRouter(bool isFirstLaunch) {
  return GoRouter(
      initialLocation: isFirstLaunch ? '/thank_you' : '/login',
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/guest_login',
          builder: (BuildContext context, GoRouterState state) {
            return const GuestLoginScreen(key: Key('guest_login'));
          },
        ),
        GoRoute(
          path: '/sign_up',
          builder: (BuildContext context, GoRouterState state) {
            return const SignUpScreen(key: Key('sign_up'));
          },
        ),
        GoRoute(
          path: '/thank_you',
          builder: (BuildContext context, GoRouterState state) {
            return const ThankYouScreen(key: Key('thank_you'));
          },
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return LayoutScreen(
              navigationShell: navigationShell,
            );
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: 'home',
                  path: '/',
                  builder: (BuildContext context, GoRouterState state) {
                    return const HomeScreen();
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: 'library',
                  path: '/library',
                  builder: (BuildContext context, GoRouterState state) {
                    return const LibraryScreen(key: Key('library'));
                  },
                ),
              ],
              // preload: true,
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: 'forms',
                  path: '/forms',
                  builder: (BuildContext context, GoRouterState state) {
                    return const FormsScreen(key: Key('forms'));
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: 'profile',
                  path: '/profile',
                  builder: (BuildContext context, GoRouterState state) {
                    return const ProfileScreen(key: Key('profile'));
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/live_chat',
                  builder: (BuildContext context, GoRouterState state) {
                    return const LiveChatScreen(key: Key('live_chat'));
                  },
                ),
              ],
              // preload: true
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: 'contact_sales_rep',
                  path: '/contact_sales_rep',
                  builder: (BuildContext context, GoRouterState state) {
                    return const ContactSalesRepScreen(
                        key: Key('contact_sales_rep'));
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: 'photo_gallery_rep',
                  path: '/photo_gallery_rep',
                  builder: (BuildContext context, GoRouterState state) {
                    return const PhotoGalleryRepScreen(
                        key: Key('photo_gallery_rep'));
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: 'exclusive_offers',
                  path: '/exclusive_offers',
                  builder: (BuildContext context, GoRouterState state) {
                    return const ExclusiveOffersScreen(
                        key: Key('exclusive_offers'));
                  },
                ),
              ],
              // preload: true,
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: 'shop',
                  path: '/shop',
                  builder: (BuildContext context, GoRouterState state) {
                    return const ShopScreen(key: Key('shop'));
                  },
                ),
              ],
              // preload: true,
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: 'photograph_parts_instructions',
                  path: '/photograph_parts/instructions',
                  builder: (BuildContext context, GoRouterState state) {
                    return const InstructionsScreen(
                      key: Key('photograph_parts_instructions'),
                    );
                  },
                ),
                GoRoute(
                  name: 'photograph_parts_send_request',
                  path: '/photograph_parts/send_request',
                  builder: (BuildContext context, GoRouterState state) {
                    return const SendRequestScreen(
                      key: Key('photograph_parts_send_request'),
                    );
                  },
                ),
              ],
            ),
            // StatefulShellBranch(
            //   routes: [
            //     GoRoute(
            //       name: 'photograph_parts_distance_tracking',
            //       path: '/photograph_parts/distance_tracking',
            //       builder: (BuildContext context, GoRouterState state) {
            //         // detact the platform is it android or ios and return the correct screen
            //         // return Platform.isAndroid
            //         //     ? AndroidDistanceTrackingScreen(
            //         //         key: Key('photograph_parts_distance_tracking'),
            //         //       )
            //         //     : DistanceTrackingScreen(
            //         //         key: Key('photograph_parts_distance_tracking'),
            //         //       );
            //       },
            //     ),
            //   ],
            // ),
          ],
        )
      ]);
}
