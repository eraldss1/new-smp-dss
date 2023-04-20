class Alternatif {
  String name;
  List<dynamic> criteriaValue;
  double result;
  double distance;

  Alternatif(
      {required this.name,
      required this.criteriaValue,
      required this.result,
      required this.distance});

  factory Alternatif.clone(Alternatif source) {
    return Alternatif(
        name: source.name,
        criteriaValue: source.criteriaValue,
        result: source.result,
        distance: source.distance);
  }
}
