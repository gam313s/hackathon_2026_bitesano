enum AllergySeverity { high, moderate, intolerance }

extension SeverityLabel on AllergySeverity {
  String get label => switch (this) {
    AllergySeverity.high => 'ALTA',
    AllergySeverity.moderate => 'MODERADA',
    AllergySeverity.intolerance => 'INTOLERANCIA',
  };
}

class AllergyProfile {
  final String name;
  final String email;
  final Map<String, AllergySeverity> allergies;
  final bool crossContact;
  final bool offline;
  final bool alerts;

  const AllergyProfile({
    this.name = 'Invitado',
    this.email = '',
    this.allergies = const {},
    this.crossContact = true,
    this.offline = true,
    this.alerts = true,
  });
}
