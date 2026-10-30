import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/components/no_chat_producer_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:cloud_firestore/cloud_firestore.dart' hide Type;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'help_and_suppeort_conversation_model.dart';
export 'help_and_suppeort_conversation_model.dart';

class HelpAndSuppeortConversationWidget extends StatefulWidget {
  const HelpAndSuppeortConversationWidget({
    super.key,
    required this.helpchat,
  });

  final DocumentReference? helpchat;

  static String routeName = 'HelpAndSuppeortConversation';
  static String routePath = '/helpAndSuppeortConversation';

  @override
  State<HelpAndSuppeortConversationWidget> createState() =>
      _HelpAndSuppeortConversationWidgetState();
}

class _HelpAndSuppeortConversationWidgetState
    extends State<HelpAndSuppeortConversationWidget> {
  late HelpAndSuppeortConversationModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HelpAndSuppeortConversationModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await widget!.helpchat!.update({
        ...createHelpChatRecordData(
          userTime: getCurrentTimestamp,
        ),
        ...mapToFirestore(
          {
            'onlineUsers': FieldValue.arrayUnion([currentUserReference]),
          },
        ),
      });
    });

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    // On page dispose action.
    () async {
      _model.conversation11 = await queryConversationRecordCount(
        parent: widget!.helpchat,
      );
      if (_model.conversation11 == 0) {
        await widget!.helpchat!.delete();
      } else {
        await widget!.helpchat!.update({
          ...createHelpChatRecordData(
            userTime: getCurrentTimestamp,
          ),
          ...mapToFirestore(
            {
              'onlineUsers': FieldValue.arrayRemove([currentUserReference]),
            },
          ),
        });
      }
    }();

    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<HelpChatRecord>(
      stream: HelpChatRecord.getDocument(widget!.helpchat!),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).offwhite,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primarytheme,
                  ),
                ),
              ),
            ),
          );
        }

        final helpAndSuppeortConversationHelpChatRecord = snapshot.data!;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).offwhite,
            appBar: AppBar(
              backgroundColor: FlutterFlowTheme.of(context).offwhite,
              automaticallyImplyLeading: false,
              leading: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.safePop();
                  },
                  child: Material(
                    color: Colors.transparent,
                    elevation: 0.0,
                    shape: const CircleBorder(),
                    child: Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFF7F6F4),
                            Color(0xFFF7F6F4),
                            FlutterFlowTheme.of(context).info
                          ],
                          stops: [0.0, 0.6, 1.0],
                          begin: AlignmentDirectional(0.0, -1.0),
                          end: AlignmentDirectional(0, 1.0),
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).info,
                          width: 2.0,
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24.0,
                      ),
                    ),
                  ),
                ),
              ),
              title: Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 40.0, 0.0),
                  child: Text(
                    FFLocalizations.of(context).getText(
                      'vh4hho1t' /* Help & Support */,
                    ),
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: 'Satoshi',
                          color: FlutterFlowTheme.of(context).textprimary,
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ),
              actions: [],
              centerTitle: false,
              elevation: 0.0,
            ),
            body: SafeArea(
              top: true,
              child: StreamBuilder<List<ConversationRecord>>(
                stream: queryConversationRecord(
                  parent: helpAndSuppeortConversationHelpChatRecord.reference,
                ),
                builder: (context, snapshot) {
                  // Customize what your widget looks like when it's loading.
                  if (!snapshot.hasData) {
                    return Center(
                      child: SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            FlutterFlowTheme.of(context).primarytheme,
                          ),
                        ),
                      ),
                    );
                  }
                  List<ConversationRecord> containerConversationRecordList =
                      snapshot.data!;

                  return Container(
                    decoration: BoxDecoration(),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Builder(
                            builder: (context) {
                              final chats = containerConversationRecordList
                                  .sortedList(
                                      keyOf: (e) => e.messageTime!, desc: true)
                                  .toList();
                              if (chats.isEmpty) {
                                return Center(
                                  child: NoChatProducerWidget(
                                    message: 'No conversations yet',
                                    submsg:
                                        'Once you message a farm or place an order, your conversations will appear here.',
                                    index: 0,
                                  ),
                                );
                              }

                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                reverse: true,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: chats.length,
                                itemBuilder: (context, chatsIndex) {
                                  final chatsItem = chats[chatsIndex];
                                  return Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 10.0, 16.0, 10.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        if (chatsItem.sender ==
                                            currentUserReference)
                                          Align(
                                            alignment:
                                                AlignmentDirectional(1.0, 0.0),
                                            child: Container(
                                              constraints: BoxConstraints(
                                                maxWidth: 260.0,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Color(0xFF3BB273),
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        12.0, 8.0, 12.0, 8.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Builder(
                                                      builder: (context) {
                                                        if (chatsItem.image !=
                                                                null &&
                                                            chatsItem.image !=
                                                                '') {
                                                          return Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                                child: Image
                                                                    .network(
                                                                  chatsItem
                                                                      .image,
                                                                  width: 150.0,
                                                                  height: 150.0,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                              if (chatsItem
                                                                          .message !=
                                                                      null &&
                                                                  chatsItem
                                                                          .message !=
                                                                      '')
                                                                Text(
                                                                  chatsItem
                                                                      .message,
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Satoshi',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .card,
                                                                        fontSize:
                                                                            16.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                      ),
                                                                ),
                                                            ],
                                                          );
                                                        } else {
                                                          return Text(
                                                            chatsItem.message,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Satoshi',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .card,
                                                                  fontSize:
                                                                      16.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  8.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            dateTimeFormat(
                                                              "jm",
                                                              chatsItem
                                                                  .messageTime!,
                                                              locale: FFLocalizations
                                                                      .of(context)
                                                                  .languageCode,
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Satoshi',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .card,
                                                                  fontSize:
                                                                      13.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                          ),
                                                          Builder(
                                                            builder: (context) {
                                                              if ((helpAndSuppeortConversationHelpChatRecord
                                                                          .adminTime! >=
                                                                      chatsItem
                                                                          .messageTime!) ||
                                                                  (helpAndSuppeortConversationHelpChatRecord
                                                                          .onlineUsers
                                                                          .length >
                                                                      1)) {
                                                                return Icon(
                                                                  FFIcons.kseen,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .card,
                                                                  size: 16.0,
                                                                );
                                                              } else {
                                                                return Icon(
                                                                  Icons.check,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .card,
                                                                  size: 16.0,
                                                                );
                                                              }
                                                            },
                                                          ),
                                                        ].divide(SizedBox(
                                                            width: 4.0)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        if (chatsItem.sender !=
                                            currentUserReference)
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 16.0, 0.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 36.0,
                                                  height: 36.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: Image.network(
                                                        'https://images.unsplash.com/photo-1620712943543-bcc4688e7485?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw2fHxhaXxlbnwwfHx8fDE3NjM3MDg1ODF8MA&ixlib=rb-4.1.0&q=80&w=1080',
                                                      ).image,
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                Container(
                                                  constraints: BoxConstraints(
                                                    maxWidth: 260.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .card,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(12.0, 8.0,
                                                                12.0, 8.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Builder(
                                                          builder: (context) {
                                                            if (chatsItem
                                                                        .image !=
                                                                    null &&
                                                                chatsItem
                                                                        .image !=
                                                                    '') {
                                                              return Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                    child: Image
                                                                        .network(
                                                                      chatsItem
                                                                          .image,
                                                                      width:
                                                                          150.0,
                                                                      height:
                                                                          150.0,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                  if (chatsItem
                                                                              .message !=
                                                                          null &&
                                                                      chatsItem
                                                                              .message !=
                                                                          '')
                                                                    Text(
                                                                      chatsItem
                                                                          .message,
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Satoshi',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).textprimary,
                                                                            fontSize:
                                                                                16.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                          ),
                                                                    ),
                                                                ],
                                                              );
                                                            } else {
                                                              return Text(
                                                                chatsItem
                                                                    .message,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Satoshi',
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .textprimary,
                                                                      fontSize:
                                                                          16.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                    ),
                                                              );
                                                            }
                                                          },
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      8.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                dateTimeFormat(
                                                                  "jm",
                                                                  chatsItem
                                                                      .messageTime!,
                                                                  locale: FFLocalizations.of(
                                                                          context)
                                                                      .languageCode,
                                                                ),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Satoshi',
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                    ),
                                                              ),
                                                            ].divide(SizedBox(
                                                                width: 4.0)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ].divide(SizedBox(width: 8.0)),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        if (!helpAndSuppeortConversationHelpChatRecord.resolved)
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 20.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                await helpAndSuppeortConversationHelpChatRecord
                                    .reference
                                    .update(createHelpChatRecordData(
                                  resolved: true,
                                  resolvedDate: getCurrentTimestamp,
                                  status: 'Resolved',
                                ));
                              },
                              text: FFLocalizations.of(context).getText(
                                'owmjk16e' /* Mark as Resolved */,
                              ),
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 48.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color:
                                    FlutterFlowTheme.of(context).primarytheme,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Satoshi',
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                        if (!helpAndSuppeortConversationHelpChatRecord.resolved)
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 6.0,
                                  color: Color(0x19000000),
                                  offset: Offset(
                                    0.0,
                                    -2.0,
                                  ),
                                )
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                if (_model.uploadedFileUrl_helpimge != null &&
                                    _model.uploadedFileUrl_helpimge != '')
                                  Container(
                                    width: 90.0,
                                    child: Stack(
                                      alignment:
                                          AlignmentDirectional(1.0, -1.0),
                                      children: [
                                        Align(
                                          alignment:
                                              AlignmentDirectional(-1.0, 0.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: CachedNetworkImage(
                                              fadeInDuration:
                                                  Duration(milliseconds: 100),
                                              fadeOutDuration:
                                                  Duration(milliseconds: 100),
                                              imageUrl: _model
                                                  .uploadedFileUrl_helpimge,
                                              width: 85.0,
                                              height: 85.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  2.0, 0.0, 0.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              await FirebaseStorage.instance
                                                  .refFromURL(_model
                                                      .uploadedFileUrl_helpimge)
                                                  .delete();
                                            },
                                            child: Icon(
                                              Icons.close_sharp,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primarytheme,
                                              size: 24.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 12.0, 16.0, 12.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF5F5F5),
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .boderdivder,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 12.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    12.0, 8.0, 0.0, 8.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Builder(
                                                  builder: (context) {
                                                    if (!_model
                                                        .isDataUploading_helpimge) {
                                                      return InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          final selectedMedia =
                                                              await selectMediaWithSourceBottomSheet(
                                                            context: context,
                                                            allowPhoto: true,
                                                          );
                                                          if (selectedMedia !=
                                                                  null &&
                                                              selectedMedia.every((m) =>
                                                                  validateFileFormat(
                                                                      m.storagePath,
                                                                      context))) {
                                                            safeSetState(() =>
                                                                _model.isDataUploading_helpimge =
                                                                    true);
                                                            var selectedUploadedFiles =
                                                                <FFUploadedFile>[];

                                                            var downloadUrls =
                                                                <String>[];
                                                            try {
                                                              selectedUploadedFiles =
                                                                  selectedMedia
                                                                      .map((m) =>
                                                                          FFUploadedFile(
                                                                            name:
                                                                                m.storagePath.split('/').last,
                                                                            bytes:
                                                                                m.bytes,
                                                                            height:
                                                                                m.dimensions?.height,
                                                                            width:
                                                                                m.dimensions?.width,
                                                                            blurHash:
                                                                                m.blurHash,
                                                                            originalFilename:
                                                                                m.originalFilename,
                                                                          ))
                                                                      .toList();

                                                              downloadUrls =
                                                                  (await Future
                                                                          .wait(
                                                                selectedMedia
                                                                    .map(
                                                                  (m) async =>
                                                                      await uploadData(
                                                                          m.storagePath,
                                                                          m.bytes),
                                                                ),
                                                              ))
                                                                      .where((u) =>
                                                                          u !=
                                                                          null)
                                                                      .map((u) =>
                                                                          u!)
                                                                      .toList();
                                                            } finally {
                                                              _model.isDataUploading_helpimge =
                                                                  false;
                                                            }
                                                            if (selectedUploadedFiles
                                                                        .length ==
                                                                    selectedMedia
                                                                        .length &&
                                                                downloadUrls
                                                                        .length ==
                                                                    selectedMedia
                                                                        .length) {
                                                              safeSetState(() {
                                                                _model.uploadedLocalFile_helpimge =
                                                                    selectedUploadedFiles
                                                                        .first;
                                                                _model.uploadedFileUrl_helpimge =
                                                                    downloadUrls
                                                                        .first;
                                                              });
                                                            } else {
                                                              safeSetState(
                                                                  () {});
                                                              return;
                                                            }
                                                          }
                                                        },
                                                        child: Icon(
                                                          FFIcons.kattechcustom,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .textsecondary,
                                                          size: 24.0,
                                                        ),
                                                      );
                                                    } else {
                                                      return Container(
                                                        width: 40.0,
                                                        height: 40.0,
                                                        child: custom_widgets
                                                            .CircleProgessCustom(
                                                          width: 40.0,
                                                          height: 40.0,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                                Container(
                                                  width: 200.0,
                                                  child: TextFormField(
                                                    controller:
                                                        _model.textController,
                                                    focusNode: _model
                                                        .textFieldFocusNode,
                                                    autofocus: false,
                                                    enabled: true,
                                                    obscureText: false,
                                                    decoration: InputDecoration(
                                                      isDense: false,
                                                      labelStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Satoshi',
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                      hintText:
                                                          FFLocalizations.of(
                                                                  context)
                                                              .getText(
                                                        'si9vp0zg' /* Type your message... */,
                                                      ),
                                                      hintStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Satoshi',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .textprimary,
                                                                fontSize: 13.0,
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              Color(0x00000000),
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              Color(0x00000000),
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      filled: true,
                                                      fillColor:
                                                          Color(0xFFF5F5F5),
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Satoshi',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .textprimary,
                                                          letterSpacing: 0.0,
                                                        ),
                                                    cursorColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .primaryText,
                                                    enableInteractiveSelection:
                                                        true,
                                                    validator: _model
                                                        .textControllerValidator
                                                        .asValidator(context),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          FlutterFlowIconButton(
                                            borderRadius: 8.0,
                                            buttonSize: 40.0,
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .primarytheme,
                                            icon: Icon(
                                              FFIcons.ksentcustom,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .card,
                                              size: 24.0,
                                            ),
                                            onPressed: () async {
                                              if ((_model.textController.text !=
                                                          null &&
                                                      _model.textController
                                                              .text !=
                                                          '') ||
                                                  (_model.uploadedFileUrl_helpimge !=
                                                          null &&
                                                      _model.uploadedFileUrl_helpimge !=
                                                          '')) {
                                                if (containerConversationRecordList
                                                        .length >
                                                    0) {
                                                  _model.msg = _model
                                                      .textController.text;
                                                  _model.image = _model
                                                      .uploadedFileUrl_helpimge;
                                                  safeSetState(() {});
                                                  safeSetState(() {
                                                    _model.textController
                                                        ?.clear();
                                                  });
                                                  safeSetState(() {
                                                    _model.isDataUploading_helpimge =
                                                        false;
                                                    _model.uploadedLocalFile_helpimge =
                                                        FFUploadedFile(
                                                            bytes: Uint8List
                                                                .fromList([]),
                                                            originalFilename:
                                                                '');
                                                    _model.uploadedFileUrl_helpimge =
                                                        '';
                                                  });

                                                  var conversationRecordReference1 =
                                                      ConversationRecord.createDoc(
                                                          helpAndSuppeortConversationHelpChatRecord
                                                              .reference);
                                                  await conversationRecordReference1
                                                      .set(
                                                          createConversationRecordData(
                                                    createdAt:
                                                        getCurrentTimestamp,
                                                    message: _model.msg,
                                                    messageTime:
                                                        getCurrentTimestamp,
                                                    sender:
                                                        currentUserReference,
                                                    recever:
                                                        helpAndSuppeortConversationHelpChatRecord
                                                            .adminref,
                                                    image: _model.image,
                                                  ));
                                                  _model.conversation =
                                                      ConversationRecord
                                                          .getDocumentFromData(
                                                              createConversationRecordData(
                                                                createdAt:
                                                                    getCurrentTimestamp,
                                                                message:
                                                                    _model.msg,
                                                                messageTime:
                                                                    getCurrentTimestamp,
                                                                sender:
                                                                    currentUserReference,
                                                                recever:
                                                                    helpAndSuppeortConversationHelpChatRecord
                                                                        .adminref,
                                                                image: _model
                                                                    .image,
                                                              ),
                                                              conversationRecordReference1);
                                                } else {
                                                  _model.msg = _model
                                                      .textController.text;
                                                  _model.image = _model
                                                      .uploadedFileUrl_helpimge;
                                                  safeSetState(() {});

                                                  var conversationRecordReference2 =
                                                      ConversationRecord.createDoc(
                                                          helpAndSuppeortConversationHelpChatRecord
                                                              .reference);
                                                  await conversationRecordReference2
                                                      .set(
                                                          createConversationRecordData(
                                                    createdAt:
                                                        getCurrentTimestamp,
                                                    message: _model
                                                        .textController.text,
                                                    messageTime:
                                                        getCurrentTimestamp,
                                                    sender:
                                                        currentUserReference,
                                                    recever:
                                                        helpAndSuppeortConversationHelpChatRecord
                                                            .adminref,
                                                    image: _model.image,
                                                  ));
                                                  _model.conversation1 =
                                                      ConversationRecord
                                                          .getDocumentFromData(
                                                              createConversationRecordData(
                                                                createdAt:
                                                                    getCurrentTimestamp,
                                                                message: _model
                                                                    .textController
                                                                    .text,
                                                                messageTime:
                                                                    getCurrentTimestamp,
                                                                sender:
                                                                    currentUserReference,
                                                                recever:
                                                                    helpAndSuppeortConversationHelpChatRecord
                                                                        .adminref,
                                                                image: _model
                                                                    .image,
                                                              ),
                                                              conversationRecordReference2);
                                                  safeSetState(() {
                                                    _model.textController
                                                        ?.clear();
                                                  });
                                                  safeSetState(() {
                                                    _model.isDataUploading_helpimge =
                                                        false;
                                                    _model.uploadedLocalFile_helpimge =
                                                        FFUploadedFile(
                                                            bytes: Uint8List
                                                                .fromList([]),
                                                            originalFilename:
                                                                '');
                                                    _model.uploadedFileUrl_helpimge =
                                                        '';
                                                  });

                                                  await helpAndSuppeortConversationHelpChatRecord
                                                      .reference
                                                      .update(
                                                          createHelpChatRecordData(
                                                    firstmessage: _model.msg,
                                                    status: 'Pending',
                                                  ));
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 2000,
                                                    ),
                                                  );

                                                  var conversationRecordReference3 =
                                                      ConversationRecord.createDoc(
                                                          helpAndSuppeortConversationHelpChatRecord
                                                              .reference);
                                                  await conversationRecordReference3
                                                      .set(
                                                          createConversationRecordData(
                                                    createdAt:
                                                        getCurrentTimestamp,
                                                    message:
                                                        'Hi there, i am Agricoo bot ,we will connect you soon to resolved your issue',
                                                    messageTime:
                                                        getCurrentTimestamp,
                                                    sender:
                                                        helpAndSuppeortConversationHelpChatRecord
                                                            .adminref,
                                                    recever:
                                                        helpAndSuppeortConversationHelpChatRecord
                                                            .adminref,
                                                  ));
                                                  _model.conversation2 =
                                                      ConversationRecord
                                                          .getDocumentFromData(
                                                              createConversationRecordData(
                                                                createdAt:
                                                                    getCurrentTimestamp,
                                                                message:
                                                                    'Hi there, i am Agricoo bot ,we will connect you soon to resolved your issue',
                                                                messageTime:
                                                                    getCurrentTimestamp,
                                                                sender:
                                                                    helpAndSuppeortConversationHelpChatRecord
                                                                        .adminref,
                                                                recever:
                                                                    helpAndSuppeortConversationHelpChatRecord
                                                                        .adminref,
                                                              ),
                                                              conversationRecordReference3);
                                                }
                                              }

                                              safeSetState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (helpAndSuppeortConversationHelpChatRecord.resolved)
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                15.0, 30.0, 15.0, 30.0),
                            child: Text(
                              FFLocalizations.of(context).getText(
                                '04bui8tl' /* Resolved Issue */,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Satoshi',
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
