import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/backend/backend.dart';

import '/auth/base_auth_user_provider.dart';

import '/backend/push_notifications/push_notifications_handler.dart'
    show PushNotificationsHandler;
import '/flutter_flow/flutter_flow_util.dart';

import '/index.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  bool get loading => user == null || showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  /// Mark as not needing to notify on a sign in / out when we intend
  /// to perform subsequent actions (such as navigation) afterwards.
  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(BaseAuthUser newUser) {
    final shouldUpdate =
        user?.uid == null || newUser.uid == null || user?.uid != newUser.uid;
    initialUser ??= newUser;
    user = newUser;
    // Refresh the app on auth change unless explicitly marked otherwise.
    // No need to update unless the user has changed.
    if (notifyOnAuthChange && shouldUpdate) {
      notifyListeners();
    }
    // Once again mark the notifier as needing to update on auth change
    // (in order to catch sign in / out events).
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      navigatorKey: appNavigatorKey,
      errorBuilder: (context, state) =>
          appStateNotifier.loggedIn ? Splashpage1Widget() : SplashpageWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => appStateNotifier.loggedIn
              ? Splashpage1Widget()
              : SplashpageWidget(),
        ),
        FFRoute(
          name: HomePageWidget.routeName,
          path: HomePageWidget.routePath,
          builder: (context, params) => HomePageWidget(),
        ),
        FFRoute(
          name: SplashpageWidget.routeName,
          path: SplashpageWidget.routePath,
          builder: (context, params) => SplashpageWidget(),
        ),
        FFRoute(
          name: OnbordingWidget.routeName,
          path: OnbordingWidget.routePath,
          builder: (context, params) => OnbordingWidget(),
        ),
        FFRoute(
          name: LoginpageWidget.routeName,
          path: LoginpageWidget.routePath,
          builder: (context, params) => LoginpageWidget(),
        ),
        FFRoute(
          name: ForgotpasswordWidget.routeName,
          path: ForgotpasswordWidget.routePath,
          builder: (context, params) => ForgotpasswordWidget(),
        ),
        FFRoute(
          name: CheckyourEmailWidget.routeName,
          path: CheckyourEmailWidget.routePath,
          builder: (context, params) => CheckyourEmailWidget(),
        ),
        FFRoute(
          name: RegisterWidget.routeName,
          path: RegisterWidget.routePath,
          builder: (context, params) => RegisterWidget(),
        ),
        FFRoute(
          name: SelectOptionWidget.routeName,
          path: SelectOptionWidget.routePath,
          builder: (context, params) => SelectOptionWidget(),
        ),
        FFRoute(
          name: SearchWidget.routeName,
          path: SearchWidget.routePath,
          builder: (context, params) => SearchWidget(),
        ),
        FFRoute(
          name: ProductDetailsPageWidget.routeName,
          path: ProductDetailsPageWidget.routePath,
          builder: (context, params) => ProductDetailsPageWidget(
            product: params.getParam(
              'product',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['product'],
            ),
          ),
        ),
        FFRoute(
          name: MapsPageWidget.routeName,
          path: MapsPageWidget.routePath,
          builder: (context, params) => MapsPageWidget(),
        ),
        FFRoute(
          name: FarmProfileWidget.routeName,
          path: FarmProfileWidget.routePath,
          builder: (context, params) => FarmProfileWidget(
            farm: params.getParam(
              'farm',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['farms'],
            ),
          ),
        ),
        FFRoute(
          name: ChatWidget.routeName,
          path: ChatWidget.routePath,
          builder: (context, params) => ChatWidget(),
        ),
        FFRoute(
          name: ChatConversationWidget.routeName,
          path: ChatConversationWidget.routePath,
          asyncParams: {
            'chatRef': getDoc(['chat'], ChatRecord.fromSnapshot),
          },
          builder: (context, params) => ChatConversationWidget(
            chatRef: params.getParam(
              'chatRef',
              ParamType.Document,
            ),
          ),
        ),
        FFRoute(
          name: CartWidget.routeName,
          path: CartWidget.routePath,
          builder: (context, params) => CartWidget(),
        ),
        FFRoute(
          name: CheckoutWidget.routeName,
          path: CheckoutWidget.routePath,
          builder: (context, params) => CheckoutWidget(
            vouchercode: params.getParam(
              'vouchercode',
              ParamType.String,
            ),
            note: params.getParam(
              'note',
              ParamType.String,
            ),
            tip: params.getParam(
              'tip',
              ParamType.double,
            ),
          ),
        ),
        FFRoute(
          name: CheckoutfinalWidget.routeName,
          path: CheckoutfinalWidget.routePath,
          builder: (context, params) => CheckoutfinalWidget(
            orderRef: params.getParam(
              'orderRef',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['order'],
            ),
          ),
        ),
        FFRoute(
          name: MyOrdersWidget.routeName,
          path: MyOrdersWidget.routePath,
          builder: (context, params) => MyOrdersWidget(),
        ),
        FFRoute(
          name: OrderDetailsWidget.routeName,
          path: OrderDetailsWidget.routePath,
          builder: (context, params) => OrderDetailsWidget(
            orderRef: params.getParam(
              'orderRef',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['order'],
            ),
          ),
        ),
        FFRoute(
          name: MyfavoritesWidget.routeName,
          path: MyfavoritesWidget.routePath,
          builder: (context, params) => MyfavoritesWidget(),
        ),
        FFRoute(
          name: MyprofileWidget.routeName,
          path: MyprofileWidget.routePath,
          builder: (context, params) => MyprofileWidget(),
        ),
        FFRoute(
          name: PersonalInformationWidget.routeName,
          path: PersonalInformationWidget.routePath,
          builder: (context, params) => PersonalInformationWidget(),
        ),
        FFRoute(
          name: DeliveryAddressWidget.routeName,
          path: DeliveryAddressWidget.routePath,
          builder: (context, params) => DeliveryAddressWidget(),
        ),
        FFRoute(
          name: MyReviewsWidget.routeName,
          path: MyReviewsWidget.routePath,
          builder: (context, params) => MyReviewsWidget(),
        ),
        FFRoute(
          name: HelpandsupportWidget.routeName,
          path: HelpandsupportWidget.routePath,
          builder: (context, params) => HelpandsupportWidget(),
        ),
        FFRoute(
          name: RefundStatusWidget.routeName,
          path: RefundStatusWidget.routePath,
          builder: (context, params) => RefundStatusWidget(),
        ),
        FFRoute(
          name: HelpandsupportticketWidget.routeName,
          path: HelpandsupportticketWidget.routePath,
          builder: (context, params) => HelpandsupportticketWidget(),
        ),
        FFRoute(
          name: HelpAndSuppeortConversationWidget.routeName,
          path: HelpAndSuppeortConversationWidget.routePath,
          builder: (context, params) => HelpAndSuppeortConversationWidget(
            helpchat: params.getParam(
              'helpchat',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['helpChat'],
            ),
          ),
        ),
        FFRoute(
          name: TermsAndConditionWidget.routeName,
          path: TermsAndConditionWidget.routePath,
          builder: (context, params) => TermsAndConditionWidget(),
        ),
        FFRoute(
          name: PrivacyPolicyWidget.routeName,
          path: PrivacyPolicyWidget.routePath,
          builder: (context, params) => PrivacyPolicyWidget(),
        ),
        FFRoute(
          name: FarmerOnbordingWidget.routeName,
          path: FarmerOnbordingWidget.routePath,
          builder: (context, params) => FarmerOnbordingWidget(),
        ),
        FFRoute(
          name: FarmerdetailsEntryWidget.routeName,
          path: FarmerdetailsEntryWidget.routePath,
          builder: (context, params) => FarmerdetailsEntryWidget(),
        ),
        FFRoute(
          name: FarmerdetailsEntrylastWidget.routeName,
          path: FarmerdetailsEntrylastWidget.routePath,
          builder: (context, params) => FarmerdetailsEntrylastWidget(),
        ),
        FFRoute(
          name: ProducerHomeWidget.routeName,
          path: ProducerHomeWidget.routePath,
          builder: (context, params) => ProducerHomeWidget(),
        ),
        FFRoute(
          name: ProductWidget.routeName,
          path: ProductWidget.routePath,
          builder: (context, params) => ProductWidget(),
        ),
        FFRoute(
          name: OrdermanegementWidget.routeName,
          path: OrdermanegementWidget.routePath,
          builder: (context, params) => OrdermanegementWidget(),
        ),
        FFRoute(
          name: ScaduleWidget.routeName,
          path: ScaduleWidget.routePath,
          builder: (context, params) => ScaduleWidget(),
        ),
        FFRoute(
          name: InsightsWidget.routeName,
          path: InsightsWidget.routePath,
          builder: (context, params) => InsightsWidget(),
        ),
        FFRoute(
          name: ProducerProfileWidget.routeName,
          path: ProducerProfileWidget.routePath,
          builder: (context, params) => ProducerProfileWidget(),
        ),
        FFRoute(
          name: FarmInformationWidget.routeName,
          path: FarmInformationWidget.routePath,
          builder: (context, params) => FarmInformationWidget(),
        ),
        FFRoute(
          name: ProducerpersonalInformationWidget.routeName,
          path: ProducerpersonalInformationWidget.routePath,
          builder: (context, params) => ProducerpersonalInformationWidget(),
        ),
        FFRoute(
          name: FarmLocationWidget.routeName,
          path: FarmLocationWidget.routePath,
          builder: (context, params) => FarmLocationWidget(),
        ),
        FFRoute(
          name: CertificationWidget.routeName,
          path: CertificationWidget.routePath,
          builder: (context, params) => CertificationWidget(),
        ),
        FFRoute(
          name: SubscriptionWidget.routeName,
          path: SubscriptionWidget.routePath,
          builder: (context, params) => SubscriptionWidget(),
        ),
        FFRoute(
          name: SubscriptionPlansWidget.routeName,
          path: SubscriptionPlansWidget.routePath,
          builder: (context, params) => SubscriptionPlansWidget(),
        ),
        FFRoute(
          name: Splashpage1Widget.routeName,
          path: Splashpage1Widget.routePath,
          builder: (context, params) => Splashpage1Widget(),
        ),
        FFRoute(
          name: ProducerchatWidget.routeName,
          path: ProducerchatWidget.routePath,
          builder: (context, params) => ProducerchatWidget(),
        ),
        FFRoute(
          name: AllfarmsWidget.routeName,
          path: AllfarmsWidget.routePath,
          builder: (context, params) => AllfarmsWidget(),
        ),
        FFRoute(
          name: ProducerproductDetailsPageWidget.routeName,
          path: ProducerproductDetailsPageWidget.routePath,
          builder: (context, params) => ProducerproductDetailsPageWidget(
            product: params.getParam(
              'product',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['product'],
            ),
          ),
        ),
        FFRoute(
          name: ProducerChatConversationWidget.routeName,
          path: ProducerChatConversationWidget.routePath,
          asyncParams: {
            'chatRef': getDoc(['chat'], ChatRecord.fromSnapshot),
          },
          builder: (context, params) => ProducerChatConversationWidget(
            chatRef: params.getParam(
              'chatRef',
              ParamType.Document,
            ),
          ),
        ),
        FFRoute(
          name: MapsroutpageWidget.routeName,
          path: MapsroutpageWidget.routePath,
          builder: (context, params) => MapsroutpageWidget(
            destination: params.getParam(
              'destination',
              ParamType.LatLng,
            ),
            startlocation: params.getParam(
              'startlocation',
              ParamType.LatLng,
            ),
            radius: params.getParam(
              'radius',
              ParamType.double,
            ),
          ),
        ),
        FFRoute(
          name: MapsPageCopyWidget.routeName,
          path: MapsPageCopyWidget.routePath,
          builder: (context, params) => MapsPageCopyWidget(),
        ),
        FFRoute(
          name: FarmAvailabilityWidget.routeName,
          path: FarmAvailabilityWidget.routePath,
          asyncParams: {
            'farm': getDoc(['farms'], FarmsRecord.fromSnapshot),
          },
          builder: (context, params) => FarmAvailabilityWidget(
            farm: params.getParam(
              'farm',
              ParamType.Document,
            ),
          ),
        ),
        FFRoute(
          name: DemoWidget.routeName,
          path: DemoWidget.routePath,
          builder: (context, params) => DemoWidget(),
        ),
        FFRoute(
          name: NotificationsWidget.routeName,
          path: NotificationsWidget.routePath,
          builder: (context, params) => NotificationsWidget(),
        ),
        FFRoute(
          name: HarvestdeliverysettingWidget.routeName,
          path: HarvestdeliverysettingWidget.routePath,
          builder: (context, params) => HarvestdeliverysettingWidget(
            farmRef: params.getParam(
              'farmRef',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['farms'],
            ),
          ),
        ),
        FFRoute(
          name: RootdeliverysettingWidget.routeName,
          path: RootdeliverysettingWidget.routePath,
          builder: (context, params) => RootdeliverysettingWidget(
            farmRef: params.getParam(
              'farmRef',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['farms'],
            ),
          ),
        ),
        FFRoute(
          name: FlavourdeliverysettingWidget.routeName,
          path: FlavourdeliverysettingWidget.routePath,
          builder: (context, params) => FlavourdeliverysettingWidget(
            farmRef: params.getParam(
              'farmRef',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['farms'],
            ),
          ),
        ),
        FFRoute(
          name: SelectOptionCopyWidget.routeName,
          path: SelectOptionCopyWidget.routePath,
          builder: (context, params) => SelectOptionCopyWidget(),
        ),
        FFRoute(
          name: CheckoutCopyWidget.routeName,
          path: CheckoutCopyWidget.routePath,
          builder: (context, params) => CheckoutCopyWidget(
            vouchercode: params.getParam(
              'vouchercode',
              ParamType.String,
            ),
            note: params.getParam(
              'note',
              ParamType.String,
            ),
            tip: params.getParam(
              'tip',
              ParamType.double,
            ),
          ),
        ),
        FFRoute(
          name: ProducerTermWidget.routeName,
          path: ProducerTermWidget.routePath,
          builder: (context, params) => ProducerTermWidget(),
        ),
        FFRoute(
          name: WeightBalanceWidget.routeName,
          path: WeightBalanceWidget.routePath,
          builder: (context, params) => WeightBalanceWidget(
            orderRef: params.getParam(
              'orderRef',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['order'],
            ),
          ),
        )
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
      observers: ffNavigatorObservers,
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : goNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : pushNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState => AppStateNotifier.instance;
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect
          ? null
          : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) =>
      !ignoreRedirect && appState.hasRedirect();
  void clearRedirectLocation() => appState.clearRedirectLocation();
  void setRedirectLocationIfUnset(String location) =>
      appState.updateNotifyOnAuthChange(false);
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
    List<String>? collectionNamePath,
    StructBuilder<T>? structBuilder,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
      collectionNamePath: collectionNamePath,
      structBuilder: structBuilder,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        redirect: (context, state) {
          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            appStateNotifier.clearRedirectLocation();
            return redirectLocation;
          }

          if (requireAuth && !appStateNotifier.loggedIn) {
            appStateNotifier.setRedirectLocationIfUnset(state.uri.toString());
            return '/splashpage';
          }
          return null;
        },
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = appStateNotifier.loading
              ? Container(
                  color: Color(0xFFF3EEDD),
                  child: Image.asset(
                    'assets/images/271AB6CA-9646-4315-9BF1-9E5A6E351536.PNG',
                    fit: BoxFit.contain,
                  ),
                )
              : PushNotificationsHandler(child: page);

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  name: state.name,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    curve: transitionInfo.transitionType ==
                            PageTransitionType.scale
                        ? const Interval(0.0, 0.5)
                        : Curves.linear,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(
                  key: state.pageKey, name: state.name, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
