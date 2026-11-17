import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/orders/order_rejection_status.dart';
import '/backend/refunds/customer_refund_status.dart';
import '/components/customer_refund_status_card.dart';
import '/components/order_rejection_status_card.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'refund_status_model.dart';
export 'refund_status_model.dart';

/// Read-only customer refund history.
///
/// Every entry is derived from the persisted order record. The page never
/// creates, retries or reconciles a refund and never displays mock data.
class RefundStatusWidget extends StatefulWidget {
  const RefundStatusWidget({super.key});

  static String routeName = 'refundStatus';
  static String routePath = '/refundStatus';

  @override
  State<RefundStatusWidget> createState() => _RefundStatusWidgetState();
}

class _RefundStatusWidgetState extends State<RefundStatusWidget> {
  late RefundStatusModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  /// Bumped by the error-state retry action to resubscribe the existing query.
  int _queryAttempt = 0;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RefundStatusModel());
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
          leading: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
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
                        const Color(0xFFF7F6F4),
                        const Color(0xFFF7F6F4),
                        FlutterFlowTheme.of(context).info
                      ],
                      stops: const [0.0, 0.6, 1.0],
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
            alignment: const AlignmentDirectional(0.0, 0.0),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 40.0, 0.0),
              child: Text(
                FFLocalizations.of(context).getVariableText(
                  enText: 'Refunds',
                  frText: 'Remboursements',
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
          actions: const [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: currentUserReference == null
              ? _emptyState(context)
              : StreamBuilder<List<OrderRecord>>(
                  key: ValueKey('refund-query-$_queryAttempt'),
                  stream: queryOrderRecord(
                    queryBuilder: (orderRecord) => orderRecord.where(
                      'user_ref',
                      isEqualTo: currentUserReference,
                    ),
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return _errorState(context);
                    }

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

                    final refunds = snapshot.data!
                        .where((order) {
                          final rejection =
                              OrderRejectionInfo.fromOrder(order);
                          if (rejection.hasRejection) {
                            // A rejected order appears here only when the
                            // trusted state records a refund obligation/lifecycle.
                            return rejection.refundPhase !=
                                    OrderRejectionRefundPhase.none &&
                                rejection.refundPhase !=
                                    OrderRejectionRefundPhase.notRequired;
                          }
                          return CustomerRefundInfo.fromOrder(order).hasRefund;
                        })
                        .toList()
                      ..sort((a, b) {
                        final aDate = a.createdAt ??
                            DateTime.fromMillisecondsSinceEpoch(0);
                        final bDate = b.createdAt ??
                            DateTime.fromMillisecondsSinceEpoch(0);
                        return bDate.compareTo(aDate);
                      });

                    if (refunds.isEmpty) {
                      return _emptyState(context);
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: refunds.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12.0),
                      itemBuilder: (context, index) {
                        final order = refunds[index];
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 6.0),
                              child: Text(
                                '${FFLocalizations.of(context).getVariableText(
                                  enText: 'Order #',
                                  frText: 'Commande #',
                                )}${order.reference.id}',
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: 'Satoshi',
                                      color: FlutterFlowTheme.of(context)
                                          .textsecondary,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                            if (OrderRejectionInfo.fromOrder(order)
                                .hasRejection)
                              OrderRejectionStatusCard(order: order)
                            else
                              CustomerRefundStatusCard(order: order),
                          ],
                        );
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _errorState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              FFLocalizations.of(context).getVariableText(
                enText: 'We could not load your refunds. Please try again.',
                frText:
                    'Nous n’avons pas pu charger vos remboursements. Veuillez réessayer.',
              ),
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Satoshi',
                    color: FlutterFlowTheme.of(context).textsecondary,
                    letterSpacing: 0.0,
                  ),
            ),
            const SizedBox(height: 12.0),
            FFButtonWidget(
              onPressed: () {
                setState(() {
                  _queryAttempt++;
                });
              },
              text: FFLocalizations.of(context).getVariableText(
                enText: 'Try again',
                frText: 'Réessayer',
              ),
              options: FFButtonOptions(
                height: 44.0,
                padding: const EdgeInsetsDirectional.fromSTEB(
                    20.0, 0.0, 20.0, 0.0),
                color: FlutterFlowTheme.of(context).primarytheme,
                textStyle:
                    FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Satoshi',
                          color: FlutterFlowTheme.of(context).alternate,
                          letterSpacing: 0.0,
                        ),
                elevation: 0.0,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          FFLocalizations.of(context).getVariableText(
            enText: 'No refunds yet.',
            frText: 'Aucun remboursement pour le moment.',
          ),
          textAlign: TextAlign.center,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Satoshi',
                color: FlutterFlowTheme.of(context).textsecondary,
                letterSpacing: 0.0,
              ),
        ),
      ),
    );
  }
}
