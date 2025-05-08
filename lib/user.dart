import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:thesis_scanner/art.dart';
import 'package:thesis_scanner/arts.dart';
import 'package:thesis_scanner/audio_manager.dart';
import 'package:thesis_scanner/device.dart';
import 'package:thesis_scanner/entry.dart';
import 'package:thesis_scanner/experiment.dart';
import 'package:thesis_scanner/poi.dart';
import 'package:thesis_scanner/theorical_experiment.dart';
import 'package:thesis_scanner/utils/localize.dart';

class User extends ChangeNotifier {
  final List<Device> devices;
  final List<POI> pois;
  num X = 0;
  num Y = 0;
  final List<Entry> entries = [];
  final List<Experiment> experiments = [];
  Experiment? experiment;

  POI? currentPoi;
  ArtSection? currentSection;
  ArtSection? _lastFoundSection;
  int _sectionFoundCount = 0;
  num? poiDist;
  int poiCount = 0;

  int audioProgressIndex = 0;
  Set<int> playedSections = {};
  bool _audioManagerListenerAdded = false;

  User(this.devices, this.pois) {
    updateSection();
    _addAudioManagerListener();
  }

  void _addAudioManagerListener() {
    if (_audioManagerListenerAdded) return;
    AudioManager().addListener(_onAudioManagerChanged);
    _audioManagerListenerAdded = true;
  }

  void _onAudioManagerChanged() {
    if (AudioManager().playerState == PlayerState.completed) {
      updateSection();
    }
    notifyListeners();
  }

  void update() {
    updateLocation();
    updatePoi();
    updateSection();
    if (experiment != null) {
      experiment?.record(this);
    }
    notifyListeners();
  }

  void updateLocation() {
    var (x, y) = localize(devices);
    X = x;
    Y = y;
  }

  void updatePoi() {
    for (var poi in pois) {
      final distance = sqrt(pow(X - poi.X, 2) + pow(Y - poi.Y, 2));

      if (currentPoi == poi && distance > poi.radiusOut) {
        currentPoi = null;
        poiDist = null;
        poiCount = 0;
        continue;
      }

      if (distance <= poi.radiusIn) {
        if (currentPoi == poi) {
          poiCount++;
          poiDist = distance;
        } else if (currentPoi == null) {
          currentPoi = poi;
          poiDist = distance;
          poiCount = 1;
        }
      }
    }
  }

  void updateSection() {
    ArtSection? found;

    if (X != 0 || Y != 0) {
      for (final section in floor6.sections) {
        final inX = X >= section.x0 && X <= section.x1;
        final inY = Y >= section.y0 && Y <= section.y1;
        if (inX && inY) {
          found = section;
          break;
        }
      }
    } else {
      return;
    }

    if (_lastFoundSection == found) {
      _sectionFoundCount++;
    } else {
      _lastFoundSection = found;
      _sectionFoundCount = 1;
    }
    if (currentSection != found && _sectionFoundCount >= 3) {
      print('Section changed: ${currentSection?.title} -> ${found?.title}');
      currentSection = found;

      notifyListeners();
    }

    // print('${currentSection?.title}, $audioProgressIndex, $playedSections');

    if (currentSection != null &&
        floor6.sections.asMap().containsKey(audioProgressIndex) &&
        floor6.sections[audioProgressIndex] == currentSection &&
        !playedSections.contains(audioProgressIndex)) {
      final section = floor6.sections[audioProgressIndex];
      if (section.audioUrl != null && section.audioUrl!.isNotEmpty) {
        if ((AudioManager().currentAudio != section.audioUrl! ||
                AudioManager().playerState == PlayerState.stopped) &&
            AudioManager().playerState != PlayerState.playing) {
          AudioManager().play(section.audioUrl!);
          playedSections.add(audioProgressIndex);
          audioProgressIndex++;
          notifyListeners();
        }
      }
    }
  }

  void startExperiment(TheoricalExperiment theoricalExperiment) {
    entries.clear();
    experiment = Experiment(theoricalExperiment, devices, pois);
    print('Experiment started: ${theoricalExperiment.name}');
    notifyListeners();
  }

  void resetAudioProgression() {
    audioProgressIndex = 0;
    playedSections.clear();
    AudioManager().stop();
    notifyListeners();
  }

  void endExperiment() {
    if (experiment != null) {
      experiments.add(experiment!);
      print('Experiment ended: ${experiment!.theoricalExperiment.name}');
      experiment = null;
      notifyListeners();
    }
  }

  void cancelExperiment() {
    if (experiment != null) {
      experiment = null;
      notifyListeners();
    }
  }

  num getDistance(num x, num y) {
    return sqrt(pow(X - x, 2) + pow(Y - y, 2));
  }

  num getRoundedDistance(num x, num y) {
    num realDistance = getDistance(x, y);
    num realSteps = realDistance / 0.65;

    if (realSteps < 20) {
      return (realSteps / 5).round() * 5;
    }

    return (realSteps / 10).round() * 10;
  }
}
