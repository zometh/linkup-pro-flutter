/*
participant:{
        id: otherParticipant?.user.id,
        displayName: senderName,
        image: imageUrl
      }*/
class ParticipantPreview {
  final String id;
  final String displayName;
  final String? image;
  ParticipantPreview({required this.id, required this.displayName, this.image});
  factory ParticipantPreview.fromJson(Map<String, dynamic> json) {
    return ParticipantPreview(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      image: json['image'] as String?,
    );
  }
}
