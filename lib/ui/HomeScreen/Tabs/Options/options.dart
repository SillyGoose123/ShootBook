import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shootbook/disag/disag_utils.dart';
import "package:shootbook/localizations/app_localizations.dart";
import 'package:shootbook/disag/disag_client.dart';
import 'package:shootbook/models/backup/backup_client.dart';
import 'package:shootbook/models/model_saver.dart';
import 'package:shootbook/disag/disag_login.dart';
import 'package:shootbook/ui/HomeScreen/Tabs/Options/backup_type_select.dart';
import 'package:shootbook/ui/common/utils.dart';
import 'package:shootbook/models/shooting/result.dart';

class Options extends StatefulWidget {
  final CupertinoTabController tabController;
  final int myIndex;

  const Options(
      {super.key, required this.tabController, required this.myIndex});

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  late AppLocalizations locale;
  bool login = false;
  BuildContext? dialogContext;

  @override
  Widget build(BuildContext context) {
    locale = AppLocalizations.of(context)!;

    if (login) {
      return PopScope(
          canPop: false,
          onPopInvokedWithResult: _onPop,
          child: DisagLogin(onLogin: (DisagClient client) {
            setState(() {
              login = false;
            });
          }));
    }

    return Column(spacing: 10, children: [
      ElevatedButton.icon(
          onPressed: dialogContext == null ? _disagClientImport : null,
          icon: Icon(Icons.download),
          label: Text(locale.importDisagResults)),
      ElevatedButton.icon(
          onPressed: () => DisagClient.logout(),
          icon: Icon(Icons.logout),
          label: Text(locale.logout)),
      ElevatedButton.icon(
          onPressed: dialogContext == null ? _deleteAllResults : null,
          icon: Icon(CupertinoIcons.delete),
          label: Text(locale.deleteAll)),
      ElevatedButton.icon(
          onPressed: _zipExport,
          icon: Icon(CupertinoIcons.arrow_up_doc),
          label: Text(locale.export)),
      ElevatedButton.icon(
          onPressed: _zipImport,
          icon: Icon(CupertinoIcons.arrow_down_doc),
          label: Text(locale.import)),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [BackupTypeSelect()],
      ),
      ElevatedButton.icon(
          onPressed: _cloudImport,
          icon: Icon(CupertinoIcons.cloud_download),
          label: Text(locale.import)),
    ]);
  }

  void _onPop(bool close, test) {
    setState(() {
      login = false;
    });
  }

  Future<void> _disagClientImport() async {
    try {
      DisagClient client = await DisagClient.getInstance(locale);
      _showLoadingDialog(locale.importingDisagResults);
      List<dynamic> res = await client.getAllResults();

      ModelSaver saver = await ModelSaver.getInstance();
      for (dynamic result in res) {
        if (result.runtimeType == Result) {
          try {
            await saver.save(result);
          } on ResultAlreadyStoredException catch(e) {
            if (mounted) {
              showSnackBarError(msg: locale.resultAlreadyStoredName(result.toString()), context: context);
            }
          }
          continue;
        }

        if (mounted) {
          showSnackBarError(msg: result, context: context);
        }
      }

    } on TokenException catch (e) {
      setState(() {
        login = true;
      });
    } catch (e) {
      if (mounted) {
        showSnackBarError(msg: locale.importFailed, context: context);
      }
    }
    if (dialogContext != null && dialogContext!.mounted) {
      Navigator.pop(dialogContext!);
      setState(() {
        dialogContext = null;
      });
    }
  }

  void _showLoadingDialog(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          dialogContext = context;
          return PopScope(
              canPop: false,
              child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                      child: Column(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("$text..."),
                          Center(child: CircularProgressIndicator())
                        ],
                      ))));
        });
    setState(() {});
  }

  Future<void> _deleteResults() async {
    _showLoadingDialog(locale.deleteAll);
    ModelSaver saver = await ModelSaver.getInstance();
    await saver.deleteAll();
    Navigator.pop(dialogContext!);
    setState(() {
      dialogContext = null;
    });
  }

  void _deleteAllResults() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(locale.deleteTitle),
        message: Text(locale.deleteAll),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: Text(locale.no),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              _deleteResults();
            },
            child: Text(locale.yes),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.pop(context);
              _showLoadingDialog(locale.deleteAll);
              try {
                await deleteAllResults(locale);
              } on TokenException catch (e) {
                setState(() {
                  login = true;
                });
              }

              Navigator.pop(dialogContext!);
              setState(() {
                dialogContext = null;
              });
            },
            child: Text(locale.yesDisag),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.pop(context);
              _showLoadingDialog(locale.deleteAll);
              try {
                await deleteAllResults(locale);
              } on TokenException catch (e) {
                setState(() {
                  login = true;
                });
              }

              Navigator.pop(dialogContext!);
              setState(() {
                dialogContext = null;
              });
            },
            child: Text(locale.yesCloud),
          )
        ],
      ),
    );
  }

  Future<void> _zipExport() async {
    ModelSaver saver = await ModelSaver.getInstance();
    File file = await saver.createZip();

    var bytes = await file.readAsBytes();
    await FilePicker.platform
        .saveFile(fileName: file.path.split("/").last, bytes: bytes);

    saver.zipExportCleanUp();
  }

  Future<void> _zipImport() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["zip"]);

    if (result != null) {
      File file = File(result.files.single.path!);
      ModelSaver saver = await ModelSaver.getInstance();
      saver.importZip(file);
    }
  }

  Future<void> _cloudImport() async {
    BackupClient? client = await BackupClient.getInstance();

    //TODO: error handling
    if (client == null) throw "";

    client.import();
  }
}
