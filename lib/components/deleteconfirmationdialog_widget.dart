import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/checkout/checkout_v1_client.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'deleteconfirmationdialog_model.dart';
export 'deleteconfirmationdialog_model.dart';

class DeleteconfirmationdialogWidget extends StatefulWidget {
  const DeleteconfirmationdialogWidget({
    super.key,
    required this.address,
    required this.addressIndex,
  });

  final DeliveryAdressStruct? address;
  final int addressIndex;

  @override
  State<DeleteconfirmationdialogWidget> createState() =>
      _DeleteconfirmationdialogWidgetState();
}

class _DeleteconfirmationdialogWidgetState
    extends State<DeleteconfirmationdialogWidget> {
  late DeleteconfirmationdialogModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DeleteconfirmationdialogModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 350.0,
        ),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                FFLocalizations.of(context).getText(
                  'wbkv05c9' /* Alert  */,
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Satoshi',
                      fontSize: 20.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                FFLocalizations.of(context).getText(
                  'g9k38s4o' /* Are you sure you want to delet... */,
                ),
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Satoshi',
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: FFButtonWidget(
                      onPressed: () async {
                        context.pop();
                      },
                      text: FFLocalizations.of(context).getText(
                        'lik4dq1y' /* Cancel */,
                      ),
                      options: FFButtonOptions(
                        height: 40.0,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).primarytheme,
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Satoshi',
                                  color: FlutterFlowTheme.of(context).alternate,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                ),
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  Expanded(
                    child: FFButtonWidget(
                      onPressed: () async {
                        final result = await FirebaseFirestore.instance
                            .runTransaction<DeliveryAddressMutationResult>(
                          (transaction) async {
                            final snapshot = await transaction.get(
                              currentUserReference!,
                            );
                            if (!snapshot.exists) {
                              return DeliveryAddressMutationResult.userMissing;
                            }
                            final latestUser =
                                UsersRecord.fromSnapshot(snapshot);
                            return applyDeleteDeliveryAddress(
                              user: latestUser,
                              index: widget.addressIndex,
                              expected: widget.address,
                              write: (data) => transaction.update(
                                currentUserReference!,
                                data,
                              ),
                            );
                          },
                        );
                        if (result != DeliveryAddressMutationResult.updated) {
                          await actions.toast(
                            context,
                            'This address changed. Please refresh the list and try again.',
                          );
                          context.pop();
                          return;
                        }
                        context.pop();
                      },
                      text: FFLocalizations.of(context).getText(
                        '6sl8acyi' /* Delete */,
                      ),
                      options: FFButtonOptions(
                        height: 40.0,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).orange,
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Satoshi',
                                  color: FlutterFlowTheme.of(context).alternate,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                ),
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ].divide(SizedBox(width: 10.0)),
              ),
            ].divide(SizedBox(height: 10.0)),
          ),
        ),
      ),
    );
  }
}
