import 'dart:async';
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
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    widget.user.addListener(_onUserChanged);
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.user.removeListener(_onUserChanged);
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (widget.user.experiment == null) return;

      if (widget.user.experiment!.currentStepDurationDecrease) {
        if (widget.user.experiment!.currentStepRemainingDuration > 0) {
          widget.user.experiment!.currentStepRemainingDuration--;
        }
      } else {
        widget.user.experiment!.currentStepRemainingDuration++;
      }
      widget.user.update();
    });
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
          if (widget.user.experiment!.currentStep == -1)
            const Text('Move into the starting point of the experiment')
          else ...[
            Text('Current step: ${widget.user.experiment!.currentStepTitle}'),
            Text(
              'Duration: ${widget.user.experiment!.currentStepRemainingDuration} seconds',
            ),
          ],
          const SizedBox(height: 16),
          if (widget.user.experiment!.currentStep <
              widget.user.experiment!.theoricalExperiment.steps.length - 1)
            ElevatedButton(
              onPressed: () {
                if (widget.user.experiment == null) return;
                Experiment experiment = widget.user.experiment!;
                experiment.currentStep++;
                experiment.currentStepDurationDecrease = experiment
                        .theoricalExperiment
                        .steps[experiment.currentStep]
                        .duration >
                    0;
                experiment.currentStepRemainingDuration = experiment
                    .theoricalExperiment.steps[experiment.currentStep].duration;

                _startTimer();

                widget.user.update();
              },
              child: const Text('Next step'),
            )
          else
            ElevatedButton(
              onPressed: widget.user.endExperiment,
              child: const Text('End experiment'),
            ),
          const SizedBox(height: 16),
          Text('$nEntries entries recorded'),
          ElevatedButton(
            onPressed: widget.user.cancelExperiment,
            child: const Text('Cancel experiment'),
          )
        ],
        const SizedBox(height: 32),
        const Text('History', style: TextStyle(fontSize: 24)),
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
