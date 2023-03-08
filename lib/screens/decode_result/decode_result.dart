import 'package:firebase_stacktrace_decoder/application/localization.dart';
import 'package:firebase_stacktrace_decoder/application/theme.dart';
import 'package:firebase_stacktrace_decoder/blocs/screens/decode_result/decode_result_bloc.dart';
import 'package:firebase_stacktrace_decoder/dialogs/app_dialog/app_dialog.dart';
import 'package:firebase_stacktrace_decoder/widgets/drop_target_box/drop_target_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:tabbed_view/tabbed_view.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DecodeResultScreen extends StatefulWidget {
  final List<DecodeResult> decodeList;

  const DecodeResultScreen({Key? key, this.decodeList = const []})
      : super(key: key);

  @override
  State<DecodeResultScreen> createState() => _DecodeResultScreenState();
}

class _DecodeResultScreenState extends State<DecodeResultScreen> {
  late final TabbedViewController _controller;
  late final _decodeResultBloc = DecodeResultBloc(Get.find())..shown();

  @override
  void initState() {
    super.initState();
    final decodeList = widget.decodeList;
    _controller = TabbedViewController([
      for (final decodeItem in decodeList)
        TabData(
          value: decodeItem,
          text: decodeItem.filename,
          closable: false,
          keepAlive: true,
          content: _buildResult(decodeItem),
          buttons: [
            TabButton(
                icon: IconProvider.data(Icons.save),
                onPressed: () => _saveResult(decodeItem)),
          ],
        ),
    ]);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    return BlocListener<DecodeResultBloc, DecodeResultState>(
      bloc: _decodeResultBloc,
      listener: (context, state) async {
        context.loaderOverlay.hide();
        if (state is DecodeResultSaveInProcess) {
          context.loaderOverlay.show();
        } else if (state is DecodeResultSaveSuccess) {
          await _openOutputsFolder(state.folderPath);
        } else if (state is DecodeResultSaveFailed) {
          await _showSaveErrorDialog(context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TabbedViewTheme(
          data: TabbedViewThemeData.classic(
            borderColor: AppTheme.borderColor,
          ),
          child: TabbedView(
              controller: _controller,
              tabsAreaButtonsBuilder: (context, tabsCount) {
                return [
                  if (tabsCount > 1)
                    TabButton(
                      icon: IconProvider.data(Icons.save),
                      toolTip: l.decodeResultScreenSaveAllTitle,
                      onPressed: () => _saveAll(widget.decodeList),
                    )
                ];
              }),
        ),
      ),
    );
  }

  Widget _buildResult(DecodeResult decodeItem) {
    return SelectionArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(decodeItem.result),
          ),
        ),
      ),
    );
  }

  Future<void> _saveResult(DecodeResult result) async {
    _decodeResultBloc.saveFile(result);
  }

  Future<void> _saveAll(List<DecodeResult> list) async {
    _decodeResultBloc.saveAllFiles(list);
  }

  Future<void> _openOutputsFolder(String folderPath) async {
    await launchUrlString('file:$folderPath');
  }

  Future<void> _showSaveErrorDialog(BuildContext context) async {
    final l = context.l;
    await AppDialog.showAlert(context, content: l.saveDecodeResultErrorText);
  }
}
