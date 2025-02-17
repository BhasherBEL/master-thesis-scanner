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
      Step('Waiting', 60),
      Step('Walking into the POI', -1),
      Step('Waiting', 60),
      Step('Walking out of the POI', -1),
    ]),
    TheoricalExperiment('Experiment 2 - Impact of Beacon Density', [
      Step('Waiting', 60),
      Step('Walking into the POI', -1),
      Step('Waiting', 60),
      Step('Walking out of the POI', -1),
    ]),
    TheoricalExperiment('Experiment 3 - Effect of Smartphone Models', [
      Step('Waiting', 60),
      Step('Walking into the POI', -1),
      Step('Waiting', 60),
      Step('Walking out of the POI', -1),
    ]),
  ];
}
