import '/flutter_flow/flutter_flow_util.dart';
import 'notifications_widget.dart' show NotificationsWidget;
import 'package:flutter/material.dart';

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
