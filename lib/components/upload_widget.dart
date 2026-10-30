import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart' hide Type;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'upload_model.dart';
export 'upload_model.dart';

class UploadWidget extends StatefulWidget {
  const UploadWidget({
    super.key,
    required this.farm,
    required this.upload,
  });

  final DocumentReference? farm;
  final String? upload;

  @override
  State<UploadWidget> createState() => _UploadWidgetState();
}

class _UploadWidgetState extends State<UploadWidget> {
  late UploadModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UploadModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 1.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.0),
            topRight: Radius.circular(18.0),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FFButtonWidget(
                onPressed: () async {
                  final selectedFiles = await selectFiles(
                    allowedExtensions: ['pdf'],
                    multiFile: false,
                  );
                  if (selectedFiles != null) {
                    safeSetState(() =>
                        _model.isDataUploading_uploadDataProductpdf = true);
                    var selectedUploadedFiles = <FFUploadedFile>[];

                    var downloadUrls = <String>[];
                    try {
                      showUploadMessage(
                        context,
                        'Uploading file...',
                        showLoading: true,
                      );
                      selectedUploadedFiles = selectedFiles
                          .map((m) => FFUploadedFile(
                                name: m.storagePath.split('/').last,
                                bytes: m.bytes,
                                originalFilename: m.originalFilename,
                              ))
                          .toList();

                      downloadUrls = (await Future.wait(
                        selectedFiles.map(
                          (f) async => await uploadData(f.storagePath, f.bytes),
                        ),
                      ))
                          .where((u) => u != null)
                          .map((u) => u!)
                          .toList();
                    } finally {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      _model.isDataUploading_uploadDataProductpdf = false;
                    }
                    if (selectedUploadedFiles.length == selectedFiles.length &&
                        downloadUrls.length == selectedFiles.length) {
                      safeSetState(() {
                        _model.uploadedLocalFile_uploadDataProductpdf =
                            selectedUploadedFiles.first;
                        _model.uploadedFileUrl_uploadDataProductpdf =
                            downloadUrls.first;
                      });
                      showUploadMessage(
                        context,
                        'Success!',
                      );
                    } else {
                      safeSetState(() {});
                      showUploadMessage(
                        context,
                        'Failed to upload file',
                      );
                      return;
                    }
                  }

                  if (widget!.upload == 'Farm license') {
                    await widget!.farm!.update(createFarmsRecordData(
                      farmLicense: createUploaddataStruct(
                        pdf: _model.uploadedFileUrl_uploadDataProductpdf,
                        clearUnsetFields: false,
                      ),
                    ));
                  } else {
                    if (widget!.upload == 'Organic certification') {
                      await widget!.farm!.update(createFarmsRecordData(
                        organicCertific: createUploaddataStruct(
                          pdf: _model.uploadedFileUrl_uploadDataProductpdf,
                          clearUnsetFields: false,
                        ),
                      ));
                    } else {
                      await widget!.farm!.update(createFarmsRecordData(
                        governmentId: createUploaddataStruct(
                          pdf: _model.uploadedFileUrl_uploadDataProductpdf,
                          clearUnsetFields: false,
                        ),
                      ));
                    }
                  }

                  Navigator.pop(context);
                },
                text: FFLocalizations.of(context).getText(
                  'tjf6q3ec' /* Upload Pdf */,
                ),
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 48.0,
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: FlutterFlowTheme.of(context).primarytheme,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Satoshi',
                        color: FlutterFlowTheme.of(context).alternate,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                  elevation: 0.0,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              FFButtonWidget(
                onPressed: () async {
                  final selectedMedia = await selectMediaWithSourceBottomSheet(
                    context: context,
                    allowPhoto: true,
                  );
                  if (selectedMedia != null &&
                      selectedMedia.every(
                          (m) => validateFileFormat(m.storagePath, context))) {
                    safeSetState(
                        () => _model.isDataUploading_uploadDataImage = true);
                    var selectedUploadedFiles = <FFUploadedFile>[];

                    var downloadUrls = <String>[];
                    try {
                      selectedUploadedFiles = selectedMedia
                          .map((m) => FFUploadedFile(
                                name: m.storagePath.split('/').last,
                                bytes: m.bytes,
                                height: m.dimensions?.height,
                                width: m.dimensions?.width,
                                blurHash: m.blurHash,
                                originalFilename: m.originalFilename,
                              ))
                          .toList();

                      downloadUrls = (await Future.wait(
                        selectedMedia.map(
                          (m) async => await uploadData(m.storagePath, m.bytes),
                        ),
                      ))
                          .where((u) => u != null)
                          .map((u) => u!)
                          .toList();
                    } finally {
                      _model.isDataUploading_uploadDataImage = false;
                    }
                    if (selectedUploadedFiles.length == selectedMedia.length &&
                        downloadUrls.length == selectedMedia.length) {
                      safeSetState(() {
                        _model.uploadedLocalFile_uploadDataImage =
                            selectedUploadedFiles.first;
                        _model.uploadedFileUrl_uploadDataImage =
                            downloadUrls.first;
                      });
                    } else {
                      safeSetState(() {});
                      return;
                    }
                  }

                  if (widget!.upload == 'Farm license') {
                    await widget!.farm!.update(createFarmsRecordData(
                      farmLicense: createUploaddataStruct(
                        image: _model.uploadedFileUrl_uploadDataImage,
                        clearUnsetFields: false,
                      ),
                    ));
                  } else {
                    if (widget!.upload == 'Organic certification') {
                      await widget!.farm!.update(createFarmsRecordData(
                        organicCertific: createUploaddataStruct(
                          image: _model.uploadedFileUrl_uploadDataImage,
                          clearUnsetFields: false,
                        ),
                      ));
                    } else {
                      await widget!.farm!.update(createFarmsRecordData(
                        governmentId: createUploaddataStruct(
                          image: _model.uploadedFileUrl_uploadDataImage,
                          clearUnsetFields: false,
                        ),
                      ));
                    }
                  }

                  Navigator.pop(context);
                },
                text: FFLocalizations.of(context).getText(
                  'coob0z9v' /* Upload Image */,
                ),
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 48.0,
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: FlutterFlowTheme.of(context).primarytheme,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Satoshi',
                        color: FlutterFlowTheme.of(context).alternate,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                  elevation: 0.0,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ].divide(SizedBox(height: 8.0)),
          ),
        ),
      ),
    );
  }
}
