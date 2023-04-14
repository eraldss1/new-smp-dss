import 'dart:math';

import '../models/alternatif.dart';
import '../models/criteria.dart';

class WaspasService {
  // STEP 1
  List<List<double>> createDecisionMatrix(List<Alternatif> la) {
    var decisionMatrix = List.generate(la.length,
        (i) => List.generate(la[0].criteriaValue.length, (j) => 0.0));

    for (int i = 0; i < la.length; i++) {
      for (int j = 0; j < la[0].criteriaValue.length; j++) {
        decisionMatrix[i][j] = la[i].criteriaValue[j];
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
    result.sort((a, b) => a.result.compareTo(b.result));
    return result;
  }

  List<Alternatif> getWaspasRank(
      List<Alternatif> listAlternatif, List<Criteria> listCriteria) {
    List<Alternatif> result = listAlternatif;

    List<List<double>> decisionMatrix = createDecisionMatrix(listAlternatif);

    List<List<double>> normalizedMatrix =
        matrixNormalization(decisionMatrix, listCriteria);

    result = preferenceWeight(listAlternatif, listCriteria, normalizedMatrix);

    result = sortAlternatif(result);

    return result;
  }
}
