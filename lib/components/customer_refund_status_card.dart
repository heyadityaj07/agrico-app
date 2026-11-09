import '/backend/currency/currency_utils.dart';
import '/backend/refunds/customer_refund_status.dart';
import '/backend/schema/order_record.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

/// Read-only customer refund summary for an order.
///
/// The widget renders nothing unless the persisted order state contains a
/// refund obligation or a refund lifecycle status. It never writes Firestore
/// state and never infers a successful refund from a client action.
class CustomerRefundStatusCard extends StatelessWidget {
  const CustomerRefundStatusCard({
    super.key,
    required this.order,
    this.margin = EdgeInsets.zero,
  });

  final OrderRecord order;
  final EdgeInsetsGeometry margin;

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
        ? formatLanguageCurrency(refund.amount, localizations.languageCode)
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
                        fontFamily: 'Satoshi',
                        color: theme.textsecondary,
                        letterSpacing: 0.0,
                      ),
                    ),
                    Text(
                      amountText,
                      style: theme.bodyMedium.override(
                        fontFamily: 'Satoshi',
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
                  fontFamily: 'Satoshi',
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
        return amountText != null
            ? localizations.getVariableText(
                enText:
                    'A refund of $amountText is due for this order. It has not been initiated yet.',
                frText:
                    'Un remboursement de $amountText est dû pour cette commande. Il n’a pas encore été initié.',
              )
            : localizations.getVariableText(
                enText:
                    'A refund is due for this order. It has not been initiated yet.',
                frText:
                    'Un remboursement est dû pour cette commande. Il n’a pas encore été initié.',
              );
      case CustomerRefundState.processing:
        return amountText != null
            ? localizations.getVariableText(
                enText:
                    'Your refund of $amountText has been initiated and is being processed by Stripe. It may take a few business days to appear.',
                frText:
                    'Votre remboursement de $amountText a été initié et est en cours de traitement par Stripe. Cela peut prendre quelques jours ouvrés avant d’apparaître.',
              )
            : localizations.getVariableText(
                enText:
                    'Your refund has been initiated and is being processed by Stripe. It may take a few business days to appear.',
                frText:
                    'Votre remboursement a été initié et est en cours de traitement par Stripe. Cela peut prendre quelques jours ouvrés avant d’apparaître.',
              );
      case CustomerRefundState.succeeded:
        return amountText != null
            ? localizations.getVariableText(
                enText:
                    'Your refund of $amountText was completed. It may take a few business days to appear on your statement.',
                frText:
                    'Votre remboursement de $amountText a été effectué. Il peut prendre quelques jours ouvrés avant d’apparaître sur votre relevé.',
              )
            : localizations.getVariableText(
                enText:
                    'Your refund was completed. It may take a few business days to appear on your statement.',
                frText:
                    'Votre remboursement a été effectué. Il peut prendre quelques jours ouvrés avant d’apparaître sur votre relevé.',
              );
      case CustomerRefundState.failed:
        return amountText != null
            ? localizations.getVariableText(
                enText:
                    'Your refund of $amountText could not be completed and needs further attention. Please contact support. The amount has not been returned by this refund.',
                frText:
                    'Votre remboursement de $amountText n’a pas pu être effectué et nécessite une attention supplémentaire. Veuillez contacter le support. Le montant n’a pas été restitué par ce remboursement.',
              )
            : localizations.getVariableText(
                enText:
                    'Your refund could not be completed and needs further attention. Please contact support. The amount has not been returned by this refund.',
                frText:
                    'Votre remboursement n’a pas pu être effectué et nécessite une attention supplémentaire. Veuillez contacter le support. Le montant n’a pas été restitué par ce remboursement.',
              );
      case CustomerRefundState.unknown:
        return localizations.getVariableText(
          enText:
              'Latest refund status: ${refund.rawStatus}. Please contact support if you need help.',
          frText:
              'Dernier statut du remboursement : ${refund.rawStatus}. Veuillez contacter le support si vous avez besoin d’aide.',
        );
      case CustomerRefundState.none:
        return '';
    }
  }

  IconData _iconFor(CustomerRefundState state) {
    switch (state) {
      case CustomerRefundState.dueNotInitiated:
        return Icons.schedule;
      case CustomerRefundState.processing:
        return Icons.autorenew;
      case CustomerRefundState.succeeded:
        return Icons.check_circle_outline;
      case CustomerRefundState.failed:
        return Icons.error_outline;
      case CustomerRefundState.unknown:
        return Icons.help_outline;
      case CustomerRefundState.none:
        return Icons.info_outline;
    }
  }

  Color _accentColor(FlutterFlowTheme theme, CustomerRefundState state) {
    switch (state) {
      case CustomerRefundState.dueNotInitiated:
        return theme.warning;
      case CustomerRefundState.processing:
        return theme.primarytheme;
      case CustomerRefundState.succeeded:
        return theme.success;
      case CustomerRefundState.failed:
        return theme.error;
      case CustomerRefundState.unknown:
        return theme.textsecondary;
      case CustomerRefundState.none:
        return theme.textsecondary;
    }
  }
}
