import 'dart:async';

import 'serialization_util.dart';

import '/backend/backend.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';


final _handledMessageIds = <String?>{};

class PushNotificationsHandler extends StatefulWidget {
  const PushNotificationsHandler({Key? key, required this.child})
      : super(key: key);

  final Widget child;

  @override
  _PushNotificationsHandlerState createState() =>
      _PushNotificationsHandlerState();
}

class _PushNotificationsHandlerState extends State<PushNotificationsHandler> {
  bool _loading = false;

  Future handleOpenedPushNotification() async {
    if (isWeb) {
      return;
    }

    final notification = await FirebaseMessaging.instance.getInitialMessage();
    if (notification != null) {
      await _handlePushNotification(notification);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handlePushNotification);
  }

  Future _handlePushNotification(RemoteMessage message) async {
    if (_handledMessageIds.contains(message.messageId)) {
      return;
    }
    _handledMessageIds.add(message.messageId);

    await _handlePushNotificationData(message.data);
  }

  Future _handlePushNotificationData(Map<String, dynamic> messageData) async {
    safeSetState(() => _loading = true);
    try {
      final initialPageName = messageData['initialPageName'] as String;
      final initialParameterData = getInitialParameterData(messageData);
      final parametersBuilder = parametersBuilderMap[initialPageName];
      if (parametersBuilder != null) {
        final parameterData = await parametersBuilder(initialParameterData);
        if (mounted) {
          context.pushNamed(
            initialPageName,
            pathParameters: parameterData.pathParameters,
            extra: parameterData.extra,
          );
        } else {
          appNavigatorKey.currentContext?.pushNamed(
            initialPageName,
            pathParameters: parameterData.pathParameters,
            extra: parameterData.extra,
          );
        }
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      safeSetState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      handleOpenedPushNotification();
    });
  }

  @override
  Widget build(BuildContext context) => _loading
      ? Container(
          color: Color(0xFFF3EEDD),
          child: Image.asset(
            'assets/images/271AB6CA-9646-4315-9BF1-9E5A6E351536.PNG',
            fit: BoxFit.contain,
          ),
        )
      : widget.child;
}

class ParameterData {
  const ParameterData(
      {this.requiredParams = const {}, this.allParams = const {}});
  final Map<String, String?> requiredParams;
  final Map<String, dynamic> allParams;

  Map<String, String> get pathParameters => Map.fromEntries(
        requiredParams.entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
  Map<String, dynamic> get extra => Map.fromEntries(
        allParams.entries.where((e) => e.value != null),
      );

  static Future<ParameterData> Function(Map<String, dynamic>) none() =>
      (data) async => ParameterData();
}

final parametersBuilderMap =
    <String, Future<ParameterData> Function(Map<String, dynamic>)>{
  'HomePage': ParameterData.none(),
  'splashpage': ParameterData.none(),
  'Onbording': ParameterData.none(),
  'loginpage': ParameterData.none(),
  'Forgotpassword': ParameterData.none(),
  'checkyourEmail': ParameterData.none(),
  'Register': ParameterData.none(),
  'selectOption': ParameterData.none(),
  'Search': ParameterData.none(),
  'productDetailsPage': (data) async => ParameterData(
        allParams: {
          'product': getParameter<DocumentReference>(data, 'product'),
        },
      ),
  'mapsPage': ParameterData.none(),
  'farmProfile': (data) async => ParameterData(
        allParams: {
          'farm': getParameter<DocumentReference>(data, 'farm'),
        },
      ),
  'chat': ParameterData.none(),
  'ChatConversation': (data) async => ParameterData(
        allParams: {
          'chatRef': await getDocumentParameter<ChatRecord>(
              data, 'chatRef', ChatRecord.fromSnapshot),
        },
      ),
  'cart': ParameterData.none(),
  'checkout': (data) async => ParameterData(
        allParams: {
          'vouchercode': getParameter<String>(data, 'vouchercode'),
          'note': getParameter<String>(data, 'note'),
          'tip': getParameter<double>(data, 'tip'),
        },
      ),
  'checkoutfinal': (data) async => ParameterData(
        allParams: {
          'orderRef': getParameter<DocumentReference>(data, 'orderRef'),
        },
      ),
  'MyOrders': ParameterData.none(),
  'OrderDetails': (data) async => ParameterData(
        allParams: {
          'orderRef': getParameter<DocumentReference>(data, 'orderRef'),
        },
      ),
  'Myfavorites': ParameterData.none(),
  'myprofile': ParameterData.none(),
  'personalInformation': ParameterData.none(),
  'deliveryAddress': ParameterData.none(),
  'MyReviews': ParameterData.none(),
  'Helpandsupport': ParameterData.none(),
  'refundStatus': ParameterData.none(),
  'Helpandsupportticket': ParameterData.none(),
  'HelpAndSuppeortConversation': (data) async => ParameterData(
        allParams: {
          'helpchat': getParameter<DocumentReference>(data, 'helpchat'),
        },
      ),
  'termsAndCondition': ParameterData.none(),
  'PrivacyPolicy': ParameterData.none(),
  'farmerOnbording': ParameterData.none(),
  'farmerdetailsEntry': ParameterData.none(),
  'farmerdetailsEntrylast': ParameterData.none(),
  'producerHome': ParameterData.none(),
  'product': ParameterData.none(),
  'Ordermanegement': ParameterData.none(),
  'scadule': ParameterData.none(),
  'insights': ParameterData.none(),
  'producerProfile': ParameterData.none(),
  'FarmInformation': ParameterData.none(),
  'producerpersonalInformation': ParameterData.none(),
  'FarmLocation': ParameterData.none(),
  'certification': ParameterData.none(),
  'Subscription': ParameterData.none(),
  'SubscriptionPlans': ParameterData.none(),
  'splashpage1': ParameterData.none(),
  'producerchat': ParameterData.none(),
  'allfarms': ParameterData.none(),
  'producerproductDetailsPage': (data) async => ParameterData(
        allParams: {
          'product': getParameter<DocumentReference>(data, 'product'),
        },
      ),
  'ProducerChatConversation': (data) async => ParameterData(
        allParams: {
          'chatRef': await getDocumentParameter<ChatRecord>(
              data, 'chatRef', ChatRecord.fromSnapshot),
        },
      ),
  'mapsroutpage': (data) async => ParameterData(
        allParams: {
          'destination': getParameter<LatLng>(data, 'destination'),
          'startlocation': getParameter<LatLng>(data, 'startlocation'),
          'radius': getParameter<double>(data, 'radius'),
        },
      ),
  'mapsPageCopy': ParameterData.none(),
  'farmAvailability': (data) async => ParameterData(
        allParams: {
          'farm': await getDocumentParameter<FarmsRecord>(
              data, 'farm', FarmsRecord.fromSnapshot),
        },
      ),
  'demo': ParameterData.none(),
  'Notifications': ParameterData.none(),
  'harvestdeliverysetting': (data) async => ParameterData(
        allParams: {
          'farmRef': getParameter<DocumentReference>(data, 'farmRef'),
        },
      ),
  'rootdeliverysetting': (data) async => ParameterData(
        allParams: {
          'farmRef': getParameter<DocumentReference>(data, 'farmRef'),
        },
      ),
  'flavourdeliverysetting': (data) async => ParameterData(
        allParams: {
          'farmRef': getParameter<DocumentReference>(data, 'farmRef'),
        },
      ),
  'selectOptionCopy': ParameterData.none(),
  'checkoutCopy': (data) async => ParameterData(
        allParams: {
          'vouchercode': getParameter<String>(data, 'vouchercode'),
          'note': getParameter<String>(data, 'note'),
          'tip': getParameter<double>(data, 'tip'),
        },
      ),
  'ProducerTerm': ParameterData.none(),
  'WeightBalance': (data) async => ParameterData(
        allParams: {
          'orderRef': getParameter<DocumentReference>(data, 'orderRef'),
        },
      ),
};

Map<String, dynamic> getInitialParameterData(Map<String, dynamic> data) {
  try {
    final parameterDataStr = data['parameterData'];
    if (parameterDataStr == null ||
        parameterDataStr is! String ||
        parameterDataStr.isEmpty) {
      return {};
    }
    return jsonDecode(parameterDataStr) as Map<String, dynamic>;
  } catch (e) {
    print('Error parsing parameter data: $e');
    return {};
  }
}
