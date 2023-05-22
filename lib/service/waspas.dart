import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:latlng/latlng.dart';
import 'haversine.dart';

import '../models/alternatif.dart';
import '../models/criteria.dart';

class WaspasService {
  final Map<String, dynamic> grades = {
    'D': 2,
    'C': 3,
    'B': 4,
    'A': 5,
  };

  final Map<String, dynamic> fees = {
    "25000": 0,
    "50000": 26000,
    "75000": 51000,
    "100000": 7.000,
    "1000000": 100000
  };

  final Map<String, dynamic> dapung = {
    "100": 0,
    "200": 100,
    "300": 200,
    "10000": 300,
  };

  //Ubah alternatif akreditasi ke angka
  List<Alternatif> akreditasiToAngka(List<Alternatif> la) {
    List<Alternatif> result = la.map((e) => Alternatif.clone(e)).toList();

    for (int i = 0; i < result.length; i++) {
      if (result[i].criteriaValue[0] == 'A') {
        result[i].akreditasi = 5;
      } else if (result[i].criteriaValue[0] == 'B') {
        result[i].akreditasi = 4;
      } else if (result[i].criteriaValue[0] == 'C') {
        result[i].akreditasi = 3;
      } else if (result[i].criteriaValue[0] == 'D') {
        result[i].akreditasi = 2;
      }
    }
    return result;
  }

  // Ubah alternatif latlng ke jarak
  List<Alternatif> latlngToDistance(List<Alternatif> la, LatLng origin) {
    HaversineService H = HaversineService();
    LatLng origin = const LatLng(3.6226818838159516, 98.48055583231027);

    List<Alternatif> result = la.map((e) => Alternatif.clone(e)).toList();
    for (int i = 0; i < result.length; i++) {
      result[i].jarak = H.haversineFormula(origin, result[i].criteriaValue[1]);
      // debugPrint(element.distance);
    }
    return result;
  }

  //Ubah alternatif spp ke angka
  List<Alternatif> sppToAngka(List<Alternatif> la) {
    List<Alternatif> result = la.map((e) => Alternatif.clone(e)).toList();
    for (int i = 0; i < result.length; i++) {
      if (result[i].criteriaValue[2] <= 50000) {
        result[i].spp = 5;
      } else if (result[i].criteriaValue[2] <= 100000) {
        result[i].spp = 4;
      } else if (result[i].criteriaValue[2] <= 150000) {
        result[i].spp = 3;
      } else if (result[i].criteriaValue[2] <= 200000) {
        result[i].spp = 2;
      } else {
        result[i].spp = 1;
      }
    }
    return result;
  }

  //Ubah alternatif daya tampung ke angka
  List<Alternatif> dayaTampungToAngka(List<Alternatif> la) {
    List<Alternatif> result = la.map((e) => Alternatif.clone(e)).toList();
    for (int i = 0; i < result.length; i++) {
      if (result[i].criteriaValue[3] <= 100) {
        result[i].dayaTampung = 1;
      } else if (result[i].criteriaValue[3] <= 200) {
        result[i].dayaTampung = 2;
      } else if (result[i].criteriaValue[3] <= 300) {
        result[i].dayaTampung = 3;
      } else {
        result[i].dayaTampung = 4;
      }
    }
    return result;
  }

  // STEP 1
  List<List<double>> createDecisionMatrix(List<Alternatif> la) {
    var decisionMatrix = List.generate(la.length,
        (i) => List.generate(la[0].criteriaValue.length, (j) => 0.0));

    for (int i = 0; i < la.length; i++) {
      for (int j = 0; j < la[0].criteriaValue.length; j++) {
        if (j == 0) {
          decisionMatrix[i][j] = la[i].akreditasi.toDouble();
        } else if (j == 1) {
          decisionMatrix[i][j] = la[i].jarak.toDouble();
        } else if (j == 2) {
          decisionMatrix[i][j] = la[i].spp.toDouble();
        } else if (j == 3) {
          decisionMatrix[i][j] = la[i].dayaTampung.toDouble();
        }
      }
    }

    debugPrint("Decision Matrix");
    for (int i = 0; i < la.length; i++) {
      String temp = "[ ";
      for (int j = 0; j < la[0].criteriaValue.length; j++) {
        if (j == 1) {
          temp += "${decisionMatrix[i][j].toStringAsFixed(2)}, ";
        } else {
          temp += "${decisionMatrix[i][j].toStringAsFixed(0)}, ";
        }
      }
      temp += "]";
      debugPrint(temp);
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
          if (decisionMatrix[j][i] == 0) {
            normalizationMatrix[j][i] = 1;
          } else {
            normalizationMatrix[j][i] = minXij / decisionMatrix[j][i];
          }
        }
      }
    }

    debugPrint("Normalization Matrix");
    for (int i = 0; i < decisionMatrix.length; i++) {
      String temp = "[ ";
      for (int j = 0; j < decisionMatrix[i].length; j++) {
        temp += "${normalizationMatrix[i][j].toStringAsFixed(2)}, ";
      }
      temp += "]";
      debugPrint(temp);
    }

    return normalizationMatrix;
  }

  // STEP 3
  List<Alternatif> preferenceWeight(List<Alternatif> listAlternatif,
      List<Criteria> listCriteria, List<List<double>> normalizedMatrix) {
    List<Alternatif> result = listAlternatif;

    debugPrint("HITUNG Q");
    for (int i = 0; i < normalizedMatrix.length; i++) {
      String temp = "";
      double sum = 0;
      temp += "Q${i + 1}= 0.5 *";
      for (int j = 0; j < normalizedMatrix[i].length; j++) {
        sum += (normalizedMatrix[i][j] * listCriteria[j].weight);
      }
      temp += " ($sum) + 0.5 *";

      double product = 1;
      for (int j = 0; j < normalizedMatrix[i].length; j++) {
        product *= (pow(normalizedMatrix[i][j], listCriteria[j].weight));
      }
      temp += " ($product)";

      double tempResult = (0.5 * sum) + (0.5 * product);
      result[i].result = tempResult;

      debugPrint("$temp = $tempResult");
    }
    // debugPrint("Count Q");
    // for (var e in result) {
    //   debugPrint(e.result);
    // }
    return result;
  }

  List<Alternatif> sortAlternatif(List<Alternatif> listAlternatif) {
    List<Alternatif> result = listAlternatif;
    debugPrint("SORT HASIL");
    result.sort((a, b) => b.result.compareTo(a.result));

    for (var e in result) {
      debugPrint("${e.name} = ${e.result}");
    }
    return result;
  }

  // Filter data dari form
  List<Alternatif> filterData(
      List<Alternatif> la, List<dynamic> filterOptions) {
    // Filter jarak
    if (filterOptions[1] == 0) {
      filterOptions[1] = 0.75;
    } else if (filterOptions[1] == 1) {
      filterOptions[1] = 1.5;
    } else if (filterOptions[1] == 2) {
      filterOptions[1] = 2.25;
    } else if (filterOptions[1] == 3) {
      filterOptions[1] = 3;
    } else if (filterOptions[1] == 4) {
      filterOptions[1] = 100;
    }

    // Filter SPP
    if (filterOptions[2] == 0) {
      filterOptions[2] = 25000;
    } else if (filterOptions[2] == 1) {
      filterOptions[2] = 50000;
    } else if (filterOptions[2] == 2) {
      filterOptions[2] = 75000;
    } else if (filterOptions[2] == 3) {
      filterOptions[2] = 100000;
    } else if (filterOptions[2] == 4) {
      filterOptions[2] = 1000000;
    }

    // Filter Jumlah Murid
    if (filterOptions[3] == 0) {
      filterOptions[3] = 100;
    } else if (filterOptions[3] == 1) {
      filterOptions[3] = 200;
    } else if (filterOptions[3] == 2) {
      filterOptions[3] = 300;
    } else if (filterOptions[3] == 3) {
      filterOptions[3] = 10000;
    }

    List<Alternatif> result = la
        .where((element) =>
            element.akreditasi >= filterOptions[0] &&
            element.jarak <= filterOptions[1] &&
            // rentang
            element.criteriaValue[2] <= filterOptions[2] &&
            element.criteriaValue[3] <= filterOptions[3])
        .toList();

    // List<Alternatif> result =
    //     la.where((element) => element.distance <= filterOptions[1]).toList();

    // if (kDebugMode) {
    //   for (var r in result) {
    //     debugPrint("${r.name} ${r.distance}");
    //   }
    // }
    return result;
  }

  List<Alternatif> getWaspasRank(
      List<Alternatif> listAlternatif,
      List<Criteria> listCriteria,
      LatLng userLocation,
      List<dynamic> filterOptions) {
    //
    List<Alternatif> result =
        listAlternatif.map((e) => Alternatif.clone(e)).toList();

    result = akreditasiToAngka(result);
    result = latlngToDistance(result, userLocation);
    result = sppToAngka(result);
    result = dayaTampungToAngka(result);

    result = filterData(result, filterOptions);

    // for (var r in result) {
    //   debugPrint("${r.name}, ${r.criteriaValue.toString()}");
    // }

    List<List<double>> decisionMatrix = createDecisionMatrix(result);

    List<List<double>> normalizedMatrix =
        matrixNormalization(decisionMatrix, listCriteria);

    result = preferenceWeight(result, listCriteria, normalizedMatrix);
    result = sortAlternatif(result);

    // if (result.length > 5) {
    //   result = result.sublist(0, 5);
    // }

    // debugPrint table akurasi
    String temp = "";
    int ind = 0;
    int sesuai = 0;
    int totalData = 0;

    for (var res in result) {
      temp += '${++ind};';

      temp += "${res.criteriaValue[0]}";
      if (grades[res.criteriaValue[0]] >= filterOptions[0]) {
        temp += " (sesuai);";
        sesuai++;
      } else {
        temp += " (tidak sesuai);";
      }

      temp += res.jarak.toStringAsFixed(2);
      if (res.jarak <= filterOptions[1]) {
        temp += " (sesuai);";
        sesuai++;
      } else {
        temp += " (tidak sesuai);";
      }

      temp += "${res.criteriaValue[2]}";
      if (res.criteriaValue[2] >= fees[filterOptions[2].toString()] &&
          res.criteriaValue[2] <= filterOptions[2]) {
        temp += " (sesuai);";
        sesuai++;
      } else {
        temp += " (tidak sesuai);";
      }

      temp += "${res.criteriaValue[3]}";
      if (res.criteriaValue[3] <= dapung[filterOptions[3].toString()]) {
        temp += " (sesuai);";
        sesuai++;
      } else {
        temp += " (tidak sesuai);";
      }

      debugPrint(temp);
      temp = "";
      totalData++;
    }
    debugPrint("Sesuai: $sesuai");
    debugPrint("Total data: ${totalData * 4}");

    return result;
  }
}
