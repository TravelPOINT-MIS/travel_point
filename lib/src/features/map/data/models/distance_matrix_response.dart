class DistanceMatrixResponse {
  final List<String> destinationAddresses;
  final List<String> originAddresses;
  final List<DistanceMatrixRow> rows;
  final DistanceMatrixStatus status;
  final String? errorMessage;

  DistanceMatrixResponse({
    required this.destinationAddresses,
    required this.originAddresses,
    required this.rows,
    required this.status,
    this.errorMessage,
  });

  factory DistanceMatrixResponse.fromJson(Map<String, dynamic>? json) {
    final List<String> destinationAddresses =
        List<String>.from(json?['destination_addresses'] ?? []);
    final List<String> originAddresses =
        List<String>.from(json?['origin_addresses'] ?? []);
    final List<DistanceMatrixRow> rows = List<DistanceMatrixRow>.from(
        (json?['rows'] ?? []).map((x) => DistanceMatrixRow.fromJson(x)));
    final DistanceMatrixStatus status =
        DistanceMatrixStatus.fromJson(json?['status']);
    final String? errorMessage = json?['error_message'];

    return DistanceMatrixResponse(
      destinationAddresses: destinationAddresses,
      originAddresses: originAddresses,
      rows: rows,
      status: status,
      errorMessage: errorMessage,
    );
  }
}

class DistanceMatrixRow {
  final DistanceMatrixStatus status;
  final DistanceMatrixDuration duration;
  final DistanceMatrixDistance distance;

  DistanceMatrixRow({
    required this.status,
    required this.duration,
    required this.distance,
  });

  factory DistanceMatrixRow.fromJson(Map<String, dynamic>? json) {
    final DistanceMatrixStatus status =
        DistanceMatrixStatus.fromJson(json?['status']);
    final DistanceMatrixDuration duration =
        DistanceMatrixDuration.fromJson(json?['duration']);
    final DistanceMatrixDistance distance =
        DistanceMatrixDistance.fromJson(json?['distance']);

    return DistanceMatrixRow(
      status: status,
      duration: duration,
      distance: distance,
    );
  }
}

class DistanceMatrixStatus {
  final String status;

  DistanceMatrixStatus({
    required this.status,
  });

  factory DistanceMatrixStatus.fromJson(String? status) {
    return DistanceMatrixStatus(
      status: status ?? "",
    );
  }
}

class DistanceMatrixDuration {
  final String text;
  final int value;

  DistanceMatrixDuration({
    required this.text,
    required this.value,
  });

  factory DistanceMatrixDuration.fromJson(Map<String, dynamic>? json) {
    return DistanceMatrixDuration(
      text: json?['text'] ?? "",
      value: json?['value'] ?? 0,
    );
  }
}

class DistanceMatrixDistance {
  final String text;
  final int value;

  DistanceMatrixDistance({
    required this.text,
    required this.value,
  });

  factory DistanceMatrixDistance.fromJson(Map<String, dynamic>? json) {
    return DistanceMatrixDistance(
      text: json?['text'] ?? "",
      value: json?['value'] ?? 0,
    );
  }
}
