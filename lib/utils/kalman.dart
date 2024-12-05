// Inspired by https://github.com/ZainCheema/Indoor-Positioning-System-using-BLE-and-Flutter/blob/70bf9c257338e255d1f45d4ac2a14d0b7e1d6bf6/lib/UmbrellaBeaconTools/Filters/KalmanFilter.dart#L3
class KalmanFilter {
  double processNoise;
  double sensorNoise;
  double estimatedError;
  double predictionCycles = 0;

  double value;

  KalmanFilter(
      this.processNoise, this.sensorNoise, this.estimatedError, this.value);

  double getFilteredValue(double measurement) {
    // prediction phase
    estimatedError += processNoise;

    // measurement update
    double kalmanGain = estimatedError / (estimatedError + sensorNoise);
    value = value + kalmanGain * (measurement - value);
    estimatedError = (1 - kalmanGain) * estimatedError;

    return value;
  }
}
