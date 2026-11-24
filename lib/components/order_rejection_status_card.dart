import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

enum OrderRejectionRefundPhase {
  none,
  notRequired,
  pending,
  processing,
  completed,
  needsAttention,
  unknown,
}

enum OrderRejectionPaymentPhase { none, unpaid, processing, paid, unknown }

class OrderRejectionInfo {
  const OrderRejectionInfo({
    required this.isRejection,
    required this.rejectionCompleted,
    required this.rejectionState,
    required this.paymentState,
    required this.paymentConfirmed,
    required this.paymentCanceled,
    required this.refundState,
    required this.refundAmount,
    required this.refundCurrency,
    required this.inventoryState,
    required this.reconciliationRequired,
    required this.refundPhase,
    required this.paymentPhase,
  });

  final bool isRejection;
  final bool rejectionCompleted;
  final String rejectionState;
  final String paymentState;
  final bool paymentConfirmed;
  final bool paymentCanceled;
  final String refundState;
  final double refundAmount;
  final String refundCurrency;
  final String inventoryState;
  final bool reconciliationRequired;
  final OrderRejectionRefundPhase refundPhase;
  final OrderRejectionPaymentPhase paymentPhase;

  bool get hasRejection => isRejection;
  bool get hasAmount => refundAmount > 0;

  factory OrderRejectionInfo.fromOrder(OrderRecord order) {
    final data = order.snapshotData;
    final status = (data['order_status'] as String? ?? '').trim().toLowerCase();
    final rejectionState =
        (data['rejection_state'] as String? ?? '').trim();
    final rejectionRefundState =
        (data['rejection_refund_state'] as String? ?? '').trim();
    final rejectionRefundKind =
        (data['rejection_refund_kind'] as String? ?? '').trim();
    final refundReason =
        (data['refund_reason'] as String? ?? '').trim();
    final refundKind =
        (data['refund_kind'] as String? ?? '').trim();

    final isRejection = status == 'rejected' ||
        rejectionState.isNotEmpty ||
        rejectionRefundState.isNotEmpty ||
        rejectionRefundKind == 'producer_rejection' ||
        refundReason == 'producer_rejection' ||
        refundKind == 'order_rejection_refund';

    final paymentState =
        (data['rejection_payment_state'] as String? ?? '').trim().toLowerCase();
    final paymentConfirmed = data['rejection_payment_confirmed'] == true;
    final paymentCanceled = data['rejection_payment_canceled'] == true;

    final effectiveRefundState = rejectionRefundState.toLowerCase();

    final amountMinor = (data['rejection_refund_amount_minor'] as num?)?.toDouble() ?? 0.0;
    final amount = amountMinor > 0
        ? amountMinor / 100
        : ((data['rejection_refund_amount'] as num?)?.toDouble() ??
            (data['refund_amount'] as num?)?.toDouble() ??
            0.0);

    final currency = (data['rejection_refund_currency'] as String? ??
            data['currency'] as String? ??
            '')
        .trim()
        .toUpperCase();

    final inventoryState =
        (data['rejection_inventory_state'] as String? ?? '').trim();

    return OrderRejectionInfo(
      isRejection: isRejection,
      rejectionCompleted: status == 'rejected' || rejectionState == 'completed',
      rejectionState: rejectionState.toLowerCase(),
      paymentState: paymentState,
      paymentConfirmed: paymentConfirmed,
      paymentCanceled: paymentCanceled,
      refundState: effectiveRefundState,
      refundAmount: amount,
      refundCurrency: currency,
      inventoryState: inventoryState.toLowerCase(),
      reconciliationRequired: data['reconciliationRequired'] == true,
      refundPhase: _resolveRefundPhase(
        isRejection: isRejection,
        paymentState: paymentState,
        paymentConfirmed: paymentConfirmed,
        refundState: effectiveRefundState,
        amount: amount,
      ),
      paymentPhase: _resolvePaymentPhase(
        isRejection: isRejection,
        paymentState: paymentState,
        paymentConfirmed: paymentConfirmed,
      ),
    );
  }

  static OrderRejectionPaymentPhase _resolvePaymentPhase({
    required bool isRejection,
    required String paymentState,
    required bool paymentConfirmed,
  }) {
    if (!isRejection) return OrderRejectionPaymentPhase.none;
    if (paymentConfirmed || paymentState == 'paid') {
      return OrderRejectionPaymentPhase.paid;
    }
    if (paymentState == 'unpaid' || paymentState == 'not_required') {
      return OrderRejectionPaymentPhase.unpaid;
    }
    if (paymentState == 'processing') {
      return OrderRejectionPaymentPhase.processing;
    }
    return paymentState.isEmpty
        ? OrderRejectionPaymentPhase.paid
        : OrderRejectionPaymentPhase.unknown;
  }

  static OrderRejectionRefundPhase _resolveRefundPhase({
    required bool isRejection,
    required String paymentState,
    required bool paymentConfirmed,
    required String refundState,
    required double amount,
  }) {
    if (!isRejection) return OrderRejectionRefundPhase.none;
    if (refundState == 'completed' || refundState == 'succeeded') {
      return OrderRejectionRefundPhase.completed;
    }
    if (refundState == 'pending' || refundState == 'initiated') {
      return OrderRejectionRefundPhase.pending;
    }
    if (refundState == 'processing') {
      return OrderRejectionRefundPhase.processing;
    }
    if (refundState == 'failed' || refundState == 'needs_attention') {
      return OrderRejectionRefundPhase.needsAttention;
    }
    if (refundState == 'not_required') {
      return OrderRejectionRefundPhase.notRequired;
    }
    if (paymentConfirmed || paymentState == 'paid') {
      return OrderRejectionRefundPhase.pending;
    }
    if (paymentState == 'unpaid') {
      return OrderRejectionRefundPhase.notRequired;
    }
    return OrderRejectionRefundPhase.unknown;
  }
}

/// Read-only producer-rejection summary for an order.
class OrderRejectionStatusCard extends StatelessWidget {
  const OrderRejectionStatusCard({
    super.key,
    required this.order,
    this.showProducerDetails = false,
    this.margin = EdgeInsets.zero,
  });

  final OrderRecord order;
  final bool showProducerDetails;
  final EdgeInsetsGeometry margin;

  String _formatAmount(double amount, String? currency, BuildContext context) {
    final languageCode = FFLocalizations.of(context).languageCode;
    final isFrench = languageCode == 'fr' || currency == 'EUR';
    final formatted = amount.toStringAsFixed(2);
    return isFrench ? '$formatted €' : '\$$formatted';
  }

  @override
  Widget build(BuildContext context) {
    final info = OrderRejectionInfo.fromOrder(order);
    if (!info.hasRejection) {
      return const SizedBox.shrink();
    }

    final theme = FlutterFlowTheme.of(context);
    final localizations = FFLocalizations.of(context);
    final accent = (info.reconciliationRequired ||
            info.refundPhase == OrderRejectionRefundPhase.needsAttention)
        ? theme.error
        : theme.tometoRed;

    final amountText = info.hasAmount
        ? _formatAmount(info.refundAmount, info.refundCurrency, context)
        : null;

    return Padding(
      padding: margin,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: theme.card,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: accent.withOpacity(0.45)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  info.reconciliationRequired ||
                          info.refundPhase ==
                              OrderRejectionRefundPhase.needsAttention
                      ? Icons.error_outline
                      : Icons.cancel_outlined,
                  color: accent,
                  size: 18.0,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    localizations.getVariableText(
                      enText: showProducerDetails
                          ? (info.rejectionCompleted
                              ? 'Rejection completed'
                              : 'Rejection requested')
                          : (info.rejectionCompleted
                              ? 'Order rejected by producer'
                              : 'Rejection requested by producer'),
                      frText: showProducerDetails
                          ? (info.rejectionCompleted
                              ? 'Refus confirmé'
                              : 'Refus demandé')
                          : (info.rejectionCompleted
                              ? 'Commande refusée par le producteur'
                              : 'Refus demandé par le producteur'),
                    ),
                    style: theme.bodyMedium.override(
                      fontFamily: theme.bodyMediumFamily,
                      color: theme.textprimary,
                      fontSize: 14.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
              child: _line(
                context,
                _paymentLabel(context, info),
                info.paymentCanceled
                    ? localizations.getVariableText(
                        enText: 'Payment cancelled',
                        frText: 'Paiement annulé',
                      )
                    : null,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 0.0),
              child: _line(context, _refundLabel(context, info), amountText),
            ),
            if (showProducerDetails)
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                  0.0,
                  6.0,
                  0.0,
                  0.0,
                ),
                child: _line(context, _inventoryLabel(context, info), null),
              ),
            if (info.reconciliationRequired)
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                  0.0,
                  6.0,
                  0.0,
                  0.0,
                ),
                child: Text(
                  localizations.getVariableText(
                    enText:
                        'An administrator must review the payment/refund reconciliation for this order.',
                    frText:
                        'Un administrateur doit vérifier le rapprochement du paiement et du remboursement de cette commande.',
                  ),
                  style: theme.bodySmall.override(
                    fontFamily: theme.bodySmallFamily,
                    color: theme.error,
                    letterSpacing: 0.0,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _line(BuildContext context, String label, String? value) {
    final theme = FlutterFlowTheme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.bodySmall.override(
              fontFamily: theme.bodySmallFamily,
              color: theme.textsecondary,
              letterSpacing: 0.0,
            ),
          ),
        ),
        if (value != null)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
            child: Text(
              value,
              style: theme.bodySmall.override(
                fontFamily: theme.bodySmallFamily,
                color: theme.textprimary,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  String _paymentLabel(BuildContext context, OrderRejectionInfo info) {
    final localizations = FFLocalizations.of(context);
    switch (info.paymentPhase) {
      case OrderRejectionPaymentPhase.paid:
        return localizations.getVariableText(
          enText: 'Payment collected',
          frText: 'Paiement encaissé',
        );
      case OrderRejectionPaymentPhase.unpaid:
        return localizations.getVariableText(
          enText: 'No payment was collected',
          frText: 'Aucun paiement encaissé',
        );
      case OrderRejectionPaymentPhase.processing:
        return localizations.getVariableText(
          enText: 'Payment confirmation pending',
          frText: 'Confirmation du paiement en attente',
        );
      case OrderRejectionPaymentPhase.unknown:
        return localizations.getVariableText(
          enText: 'Payment status is being confirmed',
          frText: 'Statut du paiement en cours de confirmation',
        );
      case OrderRejectionPaymentPhase.none:
        return '';
    }
  }

  String _refundLabel(BuildContext context, OrderRejectionInfo info) {
    final localizations = FFLocalizations.of(context);
    switch (info.refundPhase) {
      case OrderRejectionRefundPhase.notRequired:
        return localizations.getVariableText(
          enText: 'No refund is required',
          frText: 'Aucun remboursement requis',
        );
      case OrderRejectionRefundPhase.pending:
        return localizations.getVariableText(
          enText: 'Refund pending',
          frText: 'Remboursement en attente',
        );
      case OrderRejectionRefundPhase.processing:
        return localizations.getVariableText(
          enText: 'Refund processing',
          frText: 'Remboursement en cours',
        );
      case OrderRejectionRefundPhase.completed:
        return localizations.getVariableText(
          enText: 'Refund completed',
          frText: 'Remboursement effectué',
        );
      case OrderRejectionRefundPhase.needsAttention:
        return localizations.getVariableText(
          enText: 'Refund needs attention',
          frText: 'Le remboursement nécessite une vérification',
        );
      case OrderRejectionRefundPhase.unknown:
        return localizations.getVariableText(
          enText: 'Refund status is being confirmed',
          frText: 'Statut du remboursement en cours de confirmation',
        );
      case OrderRejectionRefundPhase.none:
        return '';
    }
  }

  String _inventoryLabel(BuildContext context, OrderRejectionInfo info) {
    final localizations = FFLocalizations.of(context);
    switch (info.inventoryState) {
      case 'restored':
        return localizations.getVariableText(
          enText: 'Inventory restored',
          frText: 'Stock restauré',
        );
      case 'not_required':
        return localizations.getVariableText(
          enText: 'No inventory restoration required',
          frText: 'Aucune restauration de stock requise',
        );
      case 'awaiting_payment':
        return localizations.getVariableText(
          enText: 'Inventory restoration is waiting for payment confirmation',
          frText: 'La restauration du stock attend la confirmation du paiement',
        );
      case 'partial':
        return localizations.getVariableText(
          enText: 'Inventory partially restored; manual review required',
          frText: 'Stock partiellement restauré ; vérification manuelle requise',
        );
      case 'unverified':
        return localizations.getVariableText(
          enText: 'Inventory could not be verified; manual review required',
          frText: 'Le stock n’a pas pu être vérifié ; une vérification manuelle est requise',
        );
      default:
        return localizations.getVariableText(
          enText: 'Inventory status is being confirmed',
          frText: 'Statut du stock en cours de confirmation',
        );
    }
  }
}
