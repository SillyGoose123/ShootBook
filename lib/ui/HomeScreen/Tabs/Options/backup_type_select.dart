import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shootbook/models/backup/backup_client.dart';
import 'package:shootbook/models/backup/backup_type.dart';
import '../../../../models/settings.dart';

class BackupTypeSelect extends StatefulWidget {
  const BackupTypeSelect({super.key});

  @override
  State<BackupTypeSelect> createState() => _BackupTypeSelectState();
}

class _BackupTypeSelectState extends State<BackupTypeSelect> {
  Settings? settings;

  @override
  Widget build(BuildContext context) {
    Settings.getInstance().then((instance) => setState(() {
          settings = instance;
        }));

    if (settings == null) {
      return Center(child: CircularProgressIndicator());
    }

    return SegmentedButton<BackupType>(
      segments: const <ButtonSegment<BackupType>>[
        ButtonSegment<BackupType>(
            value: BackupType.none, icon: Icon(CupertinoIcons.nosign)),
        ButtonSegment<BackupType>(
            value: BackupType.drive, icon: Icon(Icons.cloud)),
      ],
      selected: <BackupType>{settings!.backup},
      onSelectionChanged: (Set<BackupType> newSelection) {
        setState(() {
          settings!.backup = newSelection.first;
        });
        settings!.store();
        if (newSelection.first == BackupType.none) return;
        BackupClient.getInstance().then((client) => client!.validateBackup());
      },
    );
  }
}
