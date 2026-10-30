import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/no_chat_producer_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'notifications_widget.dart' show NotificationsWidget;
import 'package:cloud_firestore/cloud_firestore.dart' hide Type;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NotificationsModel extends FlutterFlowModel<NotificationsWidget> {
  ///  Local state fields for this page.

  List<dynamic> allNotifications = [];
  void addToAllNotifications(dynamic item) => allNotifications.add(item);
  void removeFromAllNotifications(dynamic item) =>
      allNotifications.remove(item);
  void removeAtIndexFromAllNotifications(int index) =>
      allNotifications.removeAt(index);
  void insertAtIndexInAllNotifications(int index, dynamic item) =>
      allNotifications.insert(index, item);
  void updateAllNotificationsAtIndex(int index, Function(dynamic) updateFn) =>
      allNotifications[index] = updateFn(allNotifications[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getAllUserPushNotifications] action in Notifications widget.
  List<dynamic>? notifications;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
