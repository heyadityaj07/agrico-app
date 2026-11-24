import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

enum CustomerRefundState {
  none,
  dueNotInitiated,
  processing,
  succeeded,
  failed,
  unknown,
}

class CustomerRefundInfo {
  const CustomerRefundInfo({
    required this.state,
    required this.amount,
    required this.rawStatus,
    required this.hasRecordedAmount,
  });

  final CustomerRefundState state;
  final double amount;
  final String rawStatus;
  final bool hasRecordedAmount;

  bool get hasRefund => state != CustomerRefundState.none;
  bool get hasAmount => hasRecordedAmount && amount > 0;
  bool get needsAttention => state == CustomerRefundState.failed;

  factory CustomerRefundInfo.fromOrder(OrderRecord order) {
    final rawStatus = order.refundStatus.trim();
    final normalizedStatus = rawStatus.toLowerCase();
    final data = order.snapshotData;

    final refundDueAmount = (data['remaining_refund_due_amount'] as num?)?.toDouble() ??
        (order.hasRefundDueAmount() ? order.refundDueAmount : 0.0);
    final refundAmount = (data['rejection_refund_amount'] as num?)?.toDouble() ??
        order.refundAmount;

    final recordedAmount = refundAmount > 0
        ? refundAmount
        : (refundDueAmount > 0 ? refundDueAmount : 0.0);

    if (normalizedStatus.isEmpty) {
      if (refundDueAmount > 0) {
        return CustomerRefundInfo(
          state: CustomerRefundState.dueNotInitiated,
          amount: recordedAmount,
          rawStatus: rawStatus,
          hasRecordedAmount: recordedAmount > 0,
        );
      }
      return CustomerRefundInfo(
        state: CustomerRefundState.none,
        amount: recordedAmount,
        rawStatus: rawStatus,
        hasRecordedAmount: recordedAmount > 0,
      );
    }

    late final CustomerRefundState state;
    switch (normalizedStatus) {
      case 'processing':
        state = CustomerRefundState.processing;
        break;
      case 'succeeded':
      case 'completed':
        state = CustomerRefundState.succeeded;
        break;
      case 'failed':
        state = CustomerRefundState.failed;
        break;
      default:
        state = CustomerRefundState.unknown;
    }

    return CustomerRefundInfo(
      state: state,
      amount: recordedAmount,
      rawStatus: rawStatus,
      hasRecordedAmount: recordedAmount > 0,
    );
  }
}

/// Read-only customer refund summary for an order.
class CustomerRefundStatusCard extends StatelessWidget {
  const CustomerRefundStatusCard({
    super.key,
    required this.order,
    this.margin = EdgeInsets.zero,
  });

  final OrderRecord order;
  final EdgeInsetsGeometry margin;

  String _formatCurrency(double amount, BuildContext context) {
    final isFrench = FFLocalizations.of(context).languageCode == 'fr';
    final formatted = amount.toStringAsFixed(2);
    return isFrench ? '$formatted €' : '\$$formatted';
  }

  @override
  Widget build(BuildContext context) {
    final refund = CustomerRefundInfo.fromOrder(order);
    if (!refund.hasRefund) {
      return const SizedBox.shrink();
    }

    final theme = FlutterFlowTheme.of(context);
    final localizations = FFLocalizations.of(context);
    final accent = _accentColor(theme, refund.state);
    final amountText = refund.hasAmount
        ? _formatCurrency(refund.amount, context)
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
                  _iconFor(refund.state),
                  color: accent,
                  size: 18.0,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    _title(context, refund),
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
            if (amountText != null)
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    0.0, 8.0, 0.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      localizations.getVariableText(
                        enText: 'Refund amount',
                        frText: 'Montant du remboursement',
                      ),
                      style: theme.bodySmall.override(
                        fontFamily: theme.bodySmallFamily,
                        color: theme.textsecondary,
                        letterSpacing: 0.0,
                      ),
                    ),
                    Text(
                      amountText,
                      style: theme.bodyMedium.override(
                        fontFamily: theme.bodyMediumFamily,
                        color: theme.textprimary,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 0.0),
              child: Text(
                _message(context, refund, amountText),
                style: theme.bodySmall.override(
                  fontFamily: theme.bodySmallFamily,
                  color: theme.textsecondary,
                  letterSpacing: 0.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _title(BuildContext context, CustomerRefundInfo refund) {
    final localizations = FFLocalizations.of(context);
    switch (refund.state) {
      case CustomerRefundState.dueNotInitiated:
        return localizations.getVariableText(
          enText: 'Refund due',
          frText: 'Remboursement dû',
        );
      case CustomerRefundState.processing:
        return localizations.getVariableText(
          enText: 'Refund processing',
          frText: 'Remboursement en cours',
        );
      case CustomerRefundState.succeeded:
        return localizations.getVariableText(
          enText: 'Refund completed',
          frText: 'Remboursement effectué',
        );
      case CustomerRefundState.failed:
        return localizations.getVariableText(
          enText: 'Refund failed',
          frText: 'Échec du remboursement',
        );
      case CustomerRefundState.unknown:
        return localizations.getVariableText(
          enText: 'Refund update',
          frText: 'Mise à jour du remboursement',
        );
      case CustomerRefundState.none:
        return '';
    }
  }

  String _message(
    BuildContext context,
    CustomerRefundInfo refund,
    String? amountText,
  ) {
    final localizations = FFLocalizations.of(context);
    switch (refund.state) {
      case CustomerRefundState.dueNotInitiated:
        return localizations.getVariableText(
          enText:
              'A refund is due for this order and is waiting to be processed by the producer.',
          frText:
              'Un remboursement est dû pour cette commande et est en attente de traitement par le producteur.',
        );
      case CustomerRefundState.processing:
        return localizations.getVariableText(
          enText:
              'Your refund is being processed and will appear on your payment method in a few business days.',
          frText:
              'Votre remboursement est en cours de traitement et apparaîtra sur votre moyen de paiement dans quelques jours ouvrés.',
        );
      case CustomerRefundState.succeeded:
        return localizations.getVariableText(
          enText:
              'Your refund has been completed and returned to your original payment method.',
          frText:
              'Votre remboursement a été effectué sur votre moyen de paiement d’origine.',
        );
      case CustomerRefundState.failed:
        return localizations.getVariableText(
          enText:
              'The refund could not be completed automatically. Please contact support.',
          frText:
              'Le remboursement automatique n’a pas pu aboutir. Veuillez contacter l’assistance.',
        );
      case CustomerRefundState.unknown:
        return localizations.getVariableText(
          enText:
              'The refund status is being confirmed. Please check back shortly.',
          frText:
              'Le statut du remboursement est en cours de confirmation. Veuillez vérifier dans un instant.',
        );
      case CustomerRefundState.none:
        return '';
    }
  }

  Color _accentColor(FlutterFlowTheme theme, CustomerRefundState state) {
    switch (state) {
      case CustomerRefundState.succeeded:
        return theme.primarytheme;
      case CustomerRefundState.failed:
        return theme.error;
      case CustomerRefundState.processing:
      case CustomerRefundState.dueNotInitiated:
        return theme.orange;
      case CustomerRefundState.unknown:
      case CustomerRefundState.none:
        return theme.textsecondary;
    }
  }

  IconData _iconFor(CustomerRefundState state) {
    switch (state) {
      case CustomerRefundState.succeeded:
        return Icons.check_circle_outline;
      case CustomerRefundState.failed:
        return Icons.error_outline;
      case CustomerRefundState.processing:
      case CustomerRefundState.dueNotInitiated:
        return Icons.hourglass_top_outlined;
      case CustomerRefundState.unknown:
      case CustomerRefundState.none:
        return Icons.info_outline;
    }
  }
}
