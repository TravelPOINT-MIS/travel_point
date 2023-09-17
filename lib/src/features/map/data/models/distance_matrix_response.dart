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
    final List<DistanceMatrixRow> rows =
        (json?['rows'] ?? []).map<DistanceMatrixRow>((row) {
      final List<DistanceMatrixElement> elements =
          (row['elements'] ?? []).map<DistanceMatrixElement>((element) {
        return DistanceMatrixElement.fromJson(element);
      }).toList();
      return DistanceMatrixRow(elements: elements);
    }).toList();
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
  final List<DistanceMatrixElement> elements;

  DistanceMatrixRow({
    required this.elements,
  });
}

class DistanceMatrixElement {
  final DistanceMatrixDuration duration;
  final DistanceMatrixDistance distance;
  final String status;

  DistanceMatrixElement({
    required this.duration,
    required this.distance,
    required this.status,
  });

  factory DistanceMatrixElement.fromJson(Map<String, dynamic>? json) {
    final DistanceMatrixDuration duration =
        DistanceMatrixDuration.fromJson(json?['duration']);
    final DistanceMatrixDistance distance =
        DistanceMatrixDistance.fromJson(json?['distance']);
    final String status = json?['status'] ?? "";

    return DistanceMatrixElement(
      duration: duration,
      distance: distance,
      status: status,
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
