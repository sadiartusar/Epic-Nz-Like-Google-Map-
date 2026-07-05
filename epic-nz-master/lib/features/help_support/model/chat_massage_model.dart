class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.createdAt,
  });

  factory ChatMessage.fromApi(Map<String, dynamic> data) {
    final msgObj = data["message"];
    final text = (msgObj is Map && msgObj["text"] != null)
        ? msgObj["text"].toString()
        : (data["text"] ?? "").toString();

    var senderData = data["sender"];
    String senderId = (senderData is Map)
        ? (senderData["_id"] ?? "").toString()
        : senderData.toString();

    var receiverData = data["receiver"];
    String receiverId = (receiverData is Map)
        ? (receiverData["_id"] ?? "").toString()
        : receiverData.toString();

    return ChatMessage(
      id: (data["_id"] ?? data["id"] ?? "").toString(),
      senderId: senderId,
      receiverId: receiverId,
      text: text,
      createdAt:
          DateTime.tryParse((data["createdAt"] ?? "").toString()) ??
          DateTime.now(),
    );
  }

  factory ChatMessage.fromSocket(dynamic payload) {
    if (payload is String) {
      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: "unknown",
        receiverId: "me",
        text: payload,
        createdAt: DateTime.now(),
      );
    }

    if (payload is Map) {
      final msgObj = payload["message"];
      String text = "";

      if (msgObj is Map && msgObj["text"] != null) {
        text = msgObj["text"].toString();
      } else if (payload["text"] != null) {
        text = payload["text"].toString();
      } else {
        text = payload.toString();
      }

      return ChatMessage(
        id:
            (payload["_id"] ??
                    payload["id"] ??
                    DateTime.now().millisecondsSinceEpoch)
                .toString(),
        senderId: (payload["sender"] ?? "unknown").toString(),
        receiverId: (payload["receiver"] ?? "unknown").toString(),
        text: text,
        createdAt:
            DateTime.tryParse((payload["createdAt"] ?? "").toString()) ??
            DateTime.now(),
      );
    }

    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: "unknown",
      receiverId: "unknown",
      text: payload.toString(),
      createdAt: DateTime.now(),
    );
  }
}
