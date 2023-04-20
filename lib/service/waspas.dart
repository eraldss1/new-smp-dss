import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:latlng/latlng.dart';
import 'package:new_smp_dss/service/haversine.dart';

import '../models/alternatif.dart';
import '../models/criteria.dart';

class WaspasService {
  //Ubah alternatif akreditasi ke angka
  List<Alternatif> akreditasiToAngka(List<Alternatif> la) {
    var result = la;
    for (var element in result) {
      if (element.criteriaValue[0] == 'A') {
        element.criteriaValue[0] = 4;
      } else if (element.criteriaValue[0] == 'B+') {
        element.criteriaValue[0] = 3;
      } else if (element.criteriaValue[0] == 'B') {
        element.criteriaValue[0] = 2;
      } else if (element.criteriaValue[0] == 'C') {
        element.criteriaValue[0] = 1;
      } else if (element.criteriaValue[0] == 'D') {
        element.criteriaValue[0] = 0;
      }
    }
    return result;
  }

  // Ubah alternatif latlng ke jarak
  List<Alternatif> latlngToDistance(List<Alternatif> la) {
    HaversineService H = HaversineService();
    LatLng origin = const LatLng(3.6226818838159516, 98.48055583231027);

    var result = la;
    for (var element in result) {
      element.distance = H.haversineFormula(origin, element.criteriaValue[1]);

      // if (kDebugMode) {
      //   print(element.distance);
      // }
    }
    return result;
  }

  // STEP 1
  List<List<double>> createDecisionMatrix(List<Alternatif> la) {
    var decisionMatrix = List.generate(la.length,
        (i) => List.generate(la[0].criteriaValue.length, (j) => 0.0));

    for (int i = 0; i < la.length; i++) {
      for (int j = 0; j < la[0].criteriaValue.length; j++) {
        if (j == 1) {
          decisionMatrix[i][j] = la[i].distance.toDouble();
        } else {
          decisionMatrix[i][j] = la[i].criteriaValue[j].toDouble();
        }
      }
    }
    return decisionMatrix;
  }

  // STEP 2
  double getMinColumn(int colIndex, List<List<double>> decisionMatrix) {
    double minVal = double.maxFinite;
    for (int i = 0; i < decisionMatrix.length; i++) {
      if (decisionMatrix[i][colIndex] < minVal) {
        minVal = decisionMatrix[i][colIndex];
      }
    }
    return minVal;
  }

  double getMaxColumn(int colIndex, List<List<double>> decisionMatrix) {
    double maxVal = double.minPositive;
    for (int i = 0; i < decisionMatrix.length; i++) {
      if (decisionMatrix[i][colIndex] > maxVal) {
        maxVal = decisionMatrix[i][colIndex];
      }
    }
    return maxVal;
  }

  List<List<double>> matrixNormalization(
      List<List<double>> decisionMatrix, List<Criteria> listCriteria) {
    var normalizationMatrix = List.generate(decisionMatrix.length,
        (i) => List.generate(listCriteria.length, (j) => 0.0));

    for (int i = 0; i < listCriteria.length; i++) {
      if (listCriteria[i].type == "Benefit") {
        // Persamaan benefit
        double maxXij = getMaxColumn(i, decisionMatrix);
        for (int j = 0; j < decisionMatrix.length; j++) {
          normalizationMatrix[j][i] = decisionMatrix[j][i] / maxXij;
        }
      } else if (listCriteria[i].type == "Cost") {
        // Persamaan cost
        double minXij = getMinColumn(i, decisionMatrix);
        for (int j = 0; j < decisionMatrix.length; j++) {
          normalizationMatrix[j][i] = minXij / decisionMatrix[j][i];
        }
      }
    }
    return normalizationMatrix;
  }

  // STEP 3
  List<Alternatif> preferenceWeight(List<Alternatif> listAlternatif,
      List<Criteria> listCriteria, List<List<double>> normalizedMatrix) {
    List<Alternatif> result = listAlternatif;
    for (int i = 0; i < normalizedMatrix.length; i++) {
      double sum = 0;
      for (int j = 0; j < normalizedMatrix[i].length; j++) {
        sum += (normalizedMatrix[i][j] * listCriteria[j].weight);
      }

      double product = 0;
      for (int j = 0; j < normalizedMatrix[i].length; j++) {
        product *= (pow(normalizedMatrix[i][j], listCriteria[j].weight));
      }

      double tempResult = (0.5 * sum) + (0.5 * product);
      result[i].result = tempResult;
    }
    return result;
  }

  List<Alternatif> sortAlternatif(List<Alternatif> listAlternatif) {
    List<Alternatif> result = listAlternatif;
    result.sort((a, b) => b.result.compareTo(a.result));
    return result;
  }

  // Filter data dari form
  List<Alternatif> filterData(
      List<Alternatif> la, List<dynamic> filterOptions) {
    // Filter jarak
    filterOptions[1] == 0
        ? filterOptions[1] = 0.75
        : filterOptions[1] == 1
            ? filterOptions[1] = 1.5
            : filterOptions[1] == 2
                ? filterOptions[1] = 2.25
                : filterOptions[1] == 3
                    ? filterOptions[1] = 3
                    : filterOptions[1] == 4
                        ? filterOptions[1] = 100
                        : 0;
    // Filter SPP
    filterOptions[2] == 0
        ? filterOptions[2] = 25000
        : filterOptions[2] == 1
            ? filterOptions[2] = 50000
            : filterOptions[2] == 2
                ? filterOptions[2] = 75000
                : filterOptions[2] == 3
                    ? filterOptions[2] = 100000
                    : filterOptions[2] == 4
                        ? filterOptions[2] = 1000000
                        : 0;

    // Filter Jumlah Murid
    filterOptions[3] == 0
        ? filterOptions[3] = 100
        : filterOptions[3] == 1
            ? filterOptions[3] = 200
            : filterOptions[3] == 2
                ? filterOptions[3] = 300
                : filterOptions[3] == 3
                    ? filterOptions[3] = 10000
                    : 0;

    List<Alternatif> result = la
        .where((element) =>
            element.criteriaValue[0] >= filterOptions[0] &&
            element.distance <= filterOptions[1] &&
            element.criteriaValue[2] <= filterOptions[2] &&
            element.criteriaValue[3] <= filterOptions[3])
        .toList();

    if (kDebugMode) {
      print(filterOptions);
      for (var r in result) {
        print("${r.name} ${r.criteriaValue[0]}");
      }
    }
    return result;
  }

  List<Alternatif> getWaspasRank(List<Alternatif> listAlternatif,
      List<Criteria> listCriteria, List<dynamic> filterOptions) {
    List<Alternatif> result =
        listAlternatif.map((e) => Alternatif.clone(e)).toList();

    result = akreditasiToAngka(result);
    result = latlngToDistance(result);
    result = filterData(result, filterOptions);

    List<List<double>> decisionMatrix = createDecisionMatrix(result);

    List<List<double>> normalizedMatrix =
        matrixNormalization(decisionMatrix, listCriteria);

    result = preferenceWeight(result, listCriteria, normalizedMatrix);
    result = sortAlternatif(result);
    // result = result.sublist(0, 5);

    return result;
  }
}
