class Alternatif {
  String name;
  List<dynamic> criteriaValue;
  double result;

  double akreditasi;
  double jarak;
  double spp;
  double dayaTampung;

  // constructor
  Alternatif(
      {required this.name,
      required this.criteriaValue,
      required this.result,
      required this.akreditasi,
      required this.jarak,
      required this.spp,
      required this.dayaTampung});

  factory Alternatif.clone(Alternatif source) {
    return Alternatif(
        name: source.name,
        criteriaValue: source.criteriaValue,
        result: source.result,
        akreditasi: source.akreditasi,
        jarak: source.jarak,
        spp: source.spp,
        dayaTampung: source.dayaTampung);
  }
}

// import 'package:flutter/material.dart';

// @immutable
// class Alternatif {
//   final String name;
//   final List<dynamic> criteriaValue;
//   final double result;
//   final double distance;

//   // constructor
//   const Alternatif(
//       {required this.name,
//       required this.criteriaValue,
//       required this.result,
//       required this.distance});

//   Alternatif copyWith(
//       {String? name,
//       List<dynamic>? criteriaValue,
//       double? result,
//       double? distance}) {
//     return Alternatif(
//         name: name ?? this.name,
//         criteriaValue: criteriaValue ?? this.criteriaValue,
//         result: result ?? this.result,
//         distance: distance ?? this.distance);
//   }
// }

