import 'package:flutter/material.dart';
import 'package:thesis_scanner/experiment.dart';
import 'package:thesis_scanner/theorical_experiment.dart';
import 'package:thesis_scanner/user.dart';

class RecordPage extends StatefulWidget {
  final bool record;
  final Function(bool r) setRecord;
  final User user;

  const RecordPage({
    required this.record,
    required this.setRecord,
    required this.user,
    super.key,
  });

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  @override
  void initState() {
    super.initState();
    widget.user.addListener(_onUserChanged);
  }

  @override
  void dispose() {
    widget.user.removeListener(_onUserChanged);
    super.dispose();
  }

  num nEntries = -1;

  void _onUserChanged() {
    setState(() {
      nEntries = widget.user.experiment?.entries.length ?? -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.user.experiment == null) ...[
          Text(
            'Select an experiment to start',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: TheoricalExperiment.theoricalExperiments
                .map(
                    (TheoricalExperiment theoricalExperiment) => ElevatedButton(
                          child: Text(theoricalExperiment.name),
                          onPressed: () =>
                              widget.user.startExperiment(theoricalExperiment),
                        ))
                .toList(),
          )
        ] else ...[
          Text(
            '${widget.user.experiment!.theoricalExperiment.name} in progress',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text('$nEntries entries recorded'),
          ElevatedButton(
            onPressed: widget.user.endExperiment,
            child: const Text('End experiment'),
          )
        ],
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.user.experiments.length,
          itemBuilder: (context, index) {
            Experiment experiment = widget.user.experiments.elementAt(index);
            return ListTile(
              title: Text(experiment.theoricalExperiment.name),
              subtitle: Text('${experiment.entries.length} entries'),
              onTap: experiment.save,
              trailing: const Icon(Icons.save),
            );
          },
        ),
      ],
    );
  }
}
