import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/data_load_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Type;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'nochatfarmlist_model.dart';
export 'nochatfarmlist_model.dart';

class NochatfarmlistWidget extends StatefulWidget {
  const NochatfarmlistWidget({super.key});

  @override
  State<NochatfarmlistWidget> createState() => _NochatfarmlistWidgetState();
}

class _NochatfarmlistWidgetState extends State<NochatfarmlistWidget> {
  late NochatfarmlistModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NochatfarmlistModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.6,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
              child: Container(
                width: double.infinity,
                child: TextFormField(
                  controller: _model.textController,
                  focusNode: _model.textFieldFocusNode,
                  onChanged: (_) => EasyDebounce.debounce(
                    '_model.textController',
                    Duration(milliseconds: 0),
                    () async {
                      safeSetState(() {});
                    },
                  ),
                  autofocus: false,
                  enabled: true,
                  obscureText: false,
                  decoration: InputDecoration(
                    isDense: true,
                    labelStyle: FlutterFlowTheme.of(context)
                        .labelMedium
                        .override(
                          fontFamily:
                              FlutterFlowTheme.of(context).labelMediumFamily,
                          letterSpacing: 0.0,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).labelMediumIsCustom,
                        ),
                    hintText: FFLocalizations.of(context).getText(
                      'yv3fwfx8' /* search Farm Name */,
                    ),
                    hintStyle: FlutterFlowTheme.of(context)
                        .labelMedium
                        .override(
                          fontFamily:
                              FlutterFlowTheme.of(context).labelMediumFamily,
                          letterSpacing: 0.0,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).labelMediumIsCustom,
                        ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).boderdivder,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).boderdivder,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).textfeildfillcolour,
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).bodyMediumFamily,
                        letterSpacing: 0.0,
                        useGoogleFonts:
                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                      ),
                  cursorColor: FlutterFlowTheme.of(context).primaryText,
                  enableInteractiveSelection: true,
                  validator:
                      _model.textControllerValidator.asValidator(context),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<FarmsRecord>>(
                stream: queryFarmsRecord(
                  queryBuilder: (farmsRecord) => farmsRecord.where(
                    'approval_status',
                    isEqualTo: true,
                  ),
                  limit: 20,
                ),
                builder: (context, snapshot) {
                  // Customize what your widget looks like when it's loading.
                  if (!snapshot.hasData) {
                    return DataLoadWidget(
                      height: 180.0,
                      width: 320.0,
                      cmncolor: FlutterFlowTheme.of(context).card,
                    );
                  }
                  List<FarmsRecord> containerFarmsRecordList = snapshot.data!;

                  return Container(
                    decoration: BoxDecoration(),
                    child: Builder(
                      builder: (context) {
                        final farmsdata = containerFarmsRecordList
                            .where((e) =>
                                (e.reference != currentUserReference) &&
                                (e.farmName.toLowerCase().contains(
                                    _model.textController.text.toLowerCase())))
                            .toList();

                        return SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(farmsdata.length,
                                (farmsdataIndex) {
                              final farmsdataItem = farmsdata[farmsdataIndex];
                              return InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  _model.addToUserRef(currentUserReference!);
                                  safeSetState(() {});
                                  _model.addToUserRef(farmsdataItem.userRef!);
                                  safeSetState(() {});

                                  var chatRecordReference =
                                      ChatRecord.collection.doc();
                                  await chatRecordReference.set({
                                    ...createChatRecordData(
                                      createdAt: getCurrentTimestamp,
                                      isSuspend: false,
                                      usera: currentUserReference,
                                      timea: getCurrentTimestamp,
                                      userb: farmsdataItem.userRef,
                                      timeb: getCurrentTimestamp,
                                      farmRef: farmsdataItem.reference,
                                    ),
                                    ...mapToFirestore(
                                      {
                                        'users': _model.userRef,
                                      },
                                    ),
                                  });
                                  _model.chatcreate =
                                      ChatRecord.getDocumentFromData({
                                    ...createChatRecordData(
                                      createdAt: getCurrentTimestamp,
                                      isSuspend: false,
                                      usera: currentUserReference,
                                      timea: getCurrentTimestamp,
                                      userb: farmsdataItem.userRef,
                                      timeb: getCurrentTimestamp,
                                      farmRef: farmsdataItem.reference,
                                    ),
                                    ...mapToFirestore(
                                      {
                                        'users': _model.userRef,
                                      },
                                    ),
                                  }, chatRecordReference);

                                  context.pushNamed(
                                    ChatConversationWidget.routeName,
                                    queryParameters: {
                                      'chatRef': serializeParam(
                                        _model.chatcreate,
                                        ParamType.Document,
                                      ),
                                    }.withoutNulls,
                                    extra: <String, dynamic>{
                                      'chatRef': _model.chatcreate,
                                    },
                                  );

                                  Navigator.pop(context);

                                  safeSetState(() {});
                                },
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Container(
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .boderdivder,
                                      ),
                                    ),
                                    alignment: AlignmentDirectional(-1.0, 0.0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10.0, 0.0, 0.0, 0.0),
                                      child: Text(
                                        farmsdataItem.farmName,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).divide(SizedBox(height: 13.0)),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
