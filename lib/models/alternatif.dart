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
