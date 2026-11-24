import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/data_load_widget.dart';
import '/components/no_chat_producer_widget.dart';
import '/components/producer_navbar_widget.dart';
import '/components/suspend_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'producerchat_model.dart';
export 'producerchat_model.dart';

class ProducerchatWidget extends StatefulWidget {
  const ProducerchatWidget({super.key});

  static String routeName = 'producerchat';
  static String routePath = '/producerchat';

  @override
  State<ProducerchatWidget> createState() => _ProducerchatWidgetState();
}

class _ProducerchatWidgetState extends State<ProducerchatWidget> {
  late ProducerchatModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProducerchatModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          title: Text(
            FFLocalizations.of(context).getText(
              'tfmi7zxx' /* Messages */,
            ),
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).headlineMediumFamily,
                  color: FlutterFlowTheme.of(context).textprimary,
                  fontSize: 16.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).headlineMediumIsCustom,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          16.0, 16.0, 16.0, 16.0),
                      child: PagedListView<DocumentSnapshot<Object?>?,
                          ChatRecord>.separated(
                        pagingController: _model.setListViewController(
                          ChatRecord.collection
                              .where(
                                'users',
                                arrayContains: currentUserReference,
                              )
                              .where(
                                'is_suspend',
                                isEqualTo: false,
                              )
                              .orderBy('last_meesage_time', descending: true),
                        ),
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        reverse: false,
                        scrollDirection: Axis.vertical,
                        separatorBuilder: (_, __) => SizedBox(height: 12.0),
                        builderDelegate: PagedChildBuilderDelegate<ChatRecord>(
                          // Customize what your widget looks like when it's loading the first page.
                          firstPageProgressIndicatorBuilder: (_) =>
                              DataLoadWidget(
                            height: 72.0,
                            width: MediaQuery.sizeOf(context).width,
                            cmncolor: FlutterFlowTheme.of(context).boderdivder,
                            length: 5,
                          ),
                          // Customize what your widget looks like when it's loading another page.
                          newPageProgressIndicatorBuilder: (_) =>
                              DataLoadWidget(
                            height: 72.0,
                            width: MediaQuery.sizeOf(context).width,
                            cmncolor: FlutterFlowTheme.of(context).boderdivder,
                            length: 5,
                          ),
                          noItemsFoundIndicatorBuilder: (_) =>
                              NoChatProducerWidget(
                            message: 'No conversations yet with any consumers',
                            submsg:
                                'Once you message a farm or place an order, your conversations will appear here.',
                            index: 1,
                          ),
                          itemBuilder: (context, _, listViewIndex) {
                            final listViewChatRecord = _model
                                .listViewPagingController!
                                .itemList![listViewIndex];
                            return StreamBuilder<UsersRecord>(
                              stream: UsersRecord.getDocument(listViewChatRecord
                                  .users
                                  .where((e) => e != currentUserReference)
                                  .toList()
                                  .firstOrNull!),
                              builder: (context, snapshot) {
                                // Customize what your widget looks like when it's loading.
                                if (!snapshot.hasData) {
                                  return DataLoadWidget(
                                    height: 80.0,
                                    width: MediaQuery.sizeOf(context).width,
                                    cmncolor: FlutterFlowTheme.of(context).card,
                                    length: 1,
                                  );
                                }

                                final containerUsersRecord = snapshot.data!;

                                return Container(
                                  decoration: BoxDecoration(),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      context.pushNamed(
                                        ProducerChatConversationWidget
                                            .routeName,
                                        queryParameters: {
                                          'chatRef': serializeParam(
                                            listViewChatRecord,
                                            ParamType.Document,
                                          ),
                                        }.withoutNulls,
                                        extra: <String, dynamic>{
                                          'chatRef': listViewChatRecord,
                                        },
                                      );
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 72.0,
                                      decoration: BoxDecoration(
                                        color:
                                            FlutterFlowTheme.of(context).card,
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    width: 48.0,
                                                    height: 48.0,
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: CachedNetworkImage(
                                                      fadeInDuration: Duration(
                                                          milliseconds: 500),
                                                      fadeOutDuration: Duration(
                                                          milliseconds: 500),
                                                      imageUrl:
                                                          containerUsersRecord
                                                              .photoUrl,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  8.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            containerUsersRecord
                                                                .displayName,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .textprimary,
                                                                  fontSize:
                                                                      16.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                          ),
                                                          Text(
                                                            listViewChatRecord
                                                                .lastMessage,
                                                            maxLines: 1,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .textsecondary,
                                                                  fontSize:
                                                                      12.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              listViewChatRecord
                                                          .lastMeesageTime !=
                                                      null
                                                  ? dateTimeFormat(
                                                      "relative",
                                                      listViewChatRecord
                                                          .lastMeesageTime!,
                                                      locale:
                                                          FFLocalizations.of(
                                                                  context)
                                                              .languageCode,
                                                    )
                                                  : dateTimeFormat(
                                                      "relative",
                                                      listViewChatRecord
                                                          .createdAt!,
                                                      locale:
                                                          FFLocalizations.of(
                                                                  context)
                                                              .languageCode,
                                                    ),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primarytheme,
                                                    fontSize: 14.0,
                                                    letterSpacing: 0.0,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    if (valueOrDefault<bool>(
                        currentUserDocument?.isSuspend, false))
                      AuthUserStreamWidget(
                        builder: (context) => ClipRRect(
                          borderRadius: BorderRadius.circular(0.0),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 4.0,
                              sigmaY: 4.0,
                            ),
                            child: wrapWithModel(
                              model: _model.suspendModel,
                              updateCallback: () => safeSetState(() {}),
                              child: SuspendWidget(
                                action: () async {
                                  context.pushNamed(
                                      HelpandsupportWidget.routeName);
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              wrapWithModel(
                model: _model.producerNavbarModel,
                updateCallback: () => safeSetState(() {}),
                child: ProducerNavbarWidget(
                  index: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
