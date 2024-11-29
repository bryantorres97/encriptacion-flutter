class BodyEncripted {
  final String data;
  final String sessionKey;
  final String iv;

  BodyEncripted({
    required this.data,
    required this.sessionKey,
    required this.iv,
  });

  BodyEncripted copyWith({
    String? data,
    String? sessionKey,
    String? iv,
  }) =>
      BodyEncripted(
        data: data ?? this.data,
        sessionKey: sessionKey ?? this.sessionKey,
        iv: iv ?? this.iv,
      );

  factory BodyEncripted.fromJson(Map<String, dynamic> json) => BodyEncripted(
        data: json["Data"],
        sessionKey: json["SessionKey"],
        iv: json["IV"],
      );

  Map<String, dynamic> toJson() => {
        "Data": data,
        "SessionKey": sessionKey,
        "IV": iv,
      };
}
