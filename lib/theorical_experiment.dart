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
    TheoricalExperiment('Experiment 1 - Distance to beacon estimation', [
      Step('Waiting at 0m', 20),
      Step('Walking to 1m', 0),
      Step('Waiting at 1m', 20),
      Step('Walking to 2m', 0),
      Step('Waiting at 2m', 20),
      Step('Walking to 3m', 0),
      Step('Waiting at 3m', 20),
      Step('Walking to 4m', 0),
      Step('Waiting at 4m', 20),
      Step('Walking to 5m', 0),
      Step('Waiting at 5m', 20),
      Step('Walking to 6m', 0),
      Step('Waiting at 6m', 20),
      Step('Walking to 7m', 0),
      Step('Waiting at 7m', 20),
      Step('Walking to 8m', 0),
      Step('Waiting at 8m', 20),
      Step('Walking to 9m', 0),
      Step('Waiting at 9m', 20),
      Step('Walking to 10m', 0),
      Step('Waiting at 10m', 20),
      Step('Walking to 11m', 0),
      Step('Waiting at 11m', 20),
      Step('Walking to 12m', 0),
      Step('Waiting at 12m', 20),
      Step('Walking to 13m', 0),
      Step('Waiting at 13m', 20),
      Step('Walking to 14m', 0),
      Step('Waiting at 14m', 20),
      Step('Walking to 15m', 0),
      Step('Waiting at 15m', 20),
    ]),
    TheoricalExperiment(
        'Experiment 2 - Localization Accuracy and Responsiveness', [
      Step('Waiting on L2', 60),
      Step('Walking into P0I-1', 0),
      Step('Waiting on L1', 60),
      Step('Walking out of POI-1', 0),
      Step('Waiting on L2', 60),
    ]),
    TheoricalExperiment('Experiment 3 - Impact of Beacon Density', [
      Step('Waiting on L2', 60),
      Step('Walking into P0I-1', 0),
      Step('Waiting on L1', 60),
      Step('Walking out of POI-1', 0),
      Step('Waiting on L2', 60),
    ]),
    TheoricalExperiment('Experiment 4 - Effect of Smartphone Models', [
      Step('Waiting on L2', 60),
      Step('Walking into P0I-1', 0),
      Step('Waiting on L1', 60),
      Step('Walking out of POI-1', 0),
      Step('Waiting on L2', 60),
    ]),
  ];
}
