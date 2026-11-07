import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'add_weight_order_model.dart';
export 'add_weight_order_model.dart';

class AddWeightOrderWidget extends StatefulWidget {
  const AddWeightOrderWidget({
    super.key,
    this.orderRef,
    this.productRef,
    this.minWeight,
    this.maxWeight,
  });

  final DocumentReference? orderRef;
  final DocumentReference? productRef;
  final double? minWeight;
  final double? maxWeight;

  @override
  State<AddWeightOrderWidget> createState() => _AddWeightOrderWidgetState();
}

class _AddWeightOrderWidgetState extends State<AddWeightOrderWidget> {
  late AddWeightOrderModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddWeightOrderModel());

    _model.actualWeightInputTextController ??= TextEditingController();
    _model.actualWeightInputFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Form(
          key: _model.formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      FFLocalizations.of(context).getText(
                        'lasqzwp3' /* Product weight */,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Satoshi',
                            letterSpacing: 0.0,
                          ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24.0,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                  child: Container(
                    width: double.infinity,
                    child: TextFormField(
                      controller: _model.actualWeightInputTextController,
                      focusNode: _model.actualWeightInputFocusNode,
                      autofocus: false,
                      enabled: true,
                      obscureText: false,
                      decoration: InputDecoration(
                        isDense: true,
                        labelStyle:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: 'Satoshi',
                                  letterSpacing: 0.0,
                                ),
                        hintText: FFLocalizations.of(context).getText(
                          '38vhln6u' /* Enter Product Weight */,
                        ),
                        hintStyle:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: 'Satoshi',
                                  letterSpacing: 0.0,
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
                        fillColor:
                            FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Satoshi',
                            letterSpacing: 0.0,
                          ),
                      maxLines: null,
                      keyboardType: (FFKeyboardType.decimal).flutterValue,
                      cursorColor: FlutterFlowTheme.of(context).primaryText,
                      enableInteractiveSelection: true,
                      validator: _model.actualWeightInputTextControllerValidator
                          .asValidator(context),
                    ),
                  ),
                ),
                Text(
                  FFLocalizations.of(context).getVariableText(
                    enText:
                        'The customer will receive a payment request after all variable-weight products have confirmed weights.',
                    frText:
                        'Le client recevra une demande de paiement après la confirmation du poids de tous les produits vendus au poids.',
                  ),
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'Satoshi',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                ),
                Align(
                  alignment: AlignmentDirectional(0.0, -1.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                    child: FFButtonWidget(
                      onPressed: () async {
                        if (_model.formKey.currentState == null ||
                            !_model.formKey.currentState!.validate()) {
                          return;
                        }
                        if (functions.isWeightOutsideRange(
                            _model.actualWeightInputTextController.text,
                            widget.minWeight!,
                            widget.maxWeight!)) {
                          var confirmDialogResponse = await showDialog<bool>(
                                context: context,
                                builder: (alertDialogContext) {
                                  return AlertDialog(
                                    title: Text(FFLocalizations.of(context)
                                        .getVariableText(
                                      enText: 'Weight outside selected range',
                                      frText:
                                          'Poids en dehors de la plage sélectionnée',
                                    )),
                                    content: Text(FFLocalizations.of(context)
                                        .getVariableText(
                                      enText:
                                          'The entered weight is below the minimum or above the maximum for the selected product bracket. The weight will be billed at the actual weight. If the weight is unusually high, we recommend using Chat with Customer to communicate the revised quantity and price. Are you sure you want to send this weight request to the customer?',
                                      frText:
                                          'Le poids saisi est inférieur au minimum ou supérieur au maximum de la plage sélectionnée pour ce produit. Ce poids sera facturé au poids réel. Si le poids est exceptionnellement élevé, nous vous recommandons d’utiliser le chat avec le client pour communiquer la quantité et le prix révisés. Voulez-vous vraiment envoyer cette demande de poids au client ?',
                                    )),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(
                                            alertDialogContext, false),
                                        child: Text(FFLocalizations.of(context)
                                            .getVariableText(
                                          enText: 'Cancel',
                                          frText: 'Annuler',
                                        )),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(
                                            alertDialogContext, true),
                                        child: Text(FFLocalizations.of(context)
                                            .getVariableText(
                                          enText: 'Send weight request',
                                          frText: 'Envoyer la demande de poids',
                                        )),
                                      ),
                                    ],
                                  );
                                },
                              ) ??
                              false;
                          if (confirmDialogResponse) {
                            await actions.updateOrderActualWeight(
                              context,
                              widget.orderRef!.path,
                              widget.productRef!.path,
                              _model.actualWeightInputTextController.text,
                            );
                            Navigator.pop(context);
                          }
                        } else {
                          await actions.updateOrderActualWeight(
                            context,
                            widget.orderRef!.path,
                            widget.productRef!.path,
                            _model.actualWeightInputTextController.text,
                          );
                          Navigator.pop(context);
                        }
                      },
                      text: FFLocalizations.of(context).getText(
                        'vif6oghs' /* Add */,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
