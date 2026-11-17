import '/backend/currency/currency_utils.dart';
import '/backend/orders/order_rejection_status.dart';
import '/backend/schema/order_record.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

import 'package:flutter/material.dart';

/// Read-only producer-rejection summary for an order.
///
/// Every value comes from the trusted order document written by the backend
/// (`rejectOrder`, the payment webhook and the shared refund engine). The
/// widget never writes Firestore and never reports a completed refund merely
/// because the rejection request succeeded.
class OrderRejectionStatusCard extends StatelessWidget {
  const OrderRejectionStatusCard({
    super.key,
    required this.order,
    this.showProducerDetails = false,
    this.margin = EdgeInsets.zero,
  });

  final OrderRecord order;

  /// Inventory and reconciliation details are relevant to the producer. The
  /// customer sees the order rejection, payment and refund outcome only.
  final bool showProducerDetails;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final info = OrderRejectionInfo.fromOrder(order);
    if (!info.hasRejection) {
      return const SizedBox.shrink();
    }

    final theme = FlutterFlowTheme.of(context);
    final localizations = FFLocalizations.of(context);
    final accent =
        (info.reconciliationRequired ||
            info.refundPhase == OrderRejectionRefundPhase.needsAttention)
        ? theme.error
        : theme.tometoRed;
    final amountText = info.hasAmount
        ? formatCurrencyAmount(info.refundAmount, info.refundCurrency)
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
                      fontFamily: 'Satoshi',
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
                    enText: 'An administrator must review the payment/refund reconciliation for this order.',
                    frText: 'Un administrateur doit vérifier le rapprochement du paiement et du remboursement de cette commande.',
                  ),
                  style: theme.bodySmall.override(
                    fontFamily: 'Satoshi',
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
              fontFamily: 'Satoshi',
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
                fontFamily: 'Satoshi',
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
          frText:
              'Stock partiellement restauré ; vérification manuelle requise',
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
