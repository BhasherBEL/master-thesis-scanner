class Step {
  final String title;
  final int duration;

  const Step(this.title, this.duration);
}

class TheoricalExperiment {
  final String name;
  final List<Step> steps;

  const TheoricalExperiment(this.name, this.steps);

  static const List<TheoricalExperiment> theoricalExperiments = [
    TheoricalExperiment(
        'Experiment 1 - Localization Accuracy and Responsiveness', [
      Step('Waiting on L2', 60),
      Step('Walking into P0I-1', 0),
      Step('Waiting on L1', 60),
      Step('Walking out of POI-1', 0),
      Step('Waiting on L2', 60),
    ]),
    TheoricalExperiment('Experiment 2 - Impact of Beacon Density', [
      Step('Waiting on L2', 60),
      Step('Walking into P0I-1', 0),
      Step('Waiting on L1', 60),
      Step('Walking out of POI-1', 0),
      Step('Waiting on L2', 60),
    ]),
    TheoricalExperiment('Experiment 3 - Effect of Smartphone Models', [
      Step('Waiting on L2', 60),
      Step('Walking into P0I-1', 0),
      Step('Waiting on L1', 60),
      Step('Walking out of POI-1', 0),
      Step('Waiting on L2', 60),
    ]),
  ];
}
