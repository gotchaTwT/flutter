
class AuditLog {
  final int? id;
  final int? userId;
  final String action;
  final String entity;
  final String? entityId;
  final String? details;
  final String createdAt;

  const AuditLog({
    this.id,
    this.userId,
    required this.action,
    required this.entity,
    this.entityId,
    this.details,
    required this.createdAt,
  });

  factory AuditLog.fromMap(Map<String, dynamic> map) => AuditLog(
        id: map['id'] as int?,
        userId: map['user_id'] as int?,
        action: map['action'] as String,
        entity: map['entity'] as String,
        entityId: map['entity_id'] as String?,
        details: map['details'] as String?,
        createdAt: map['created_at'] as String,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'action': action,
        'entity': entity,
        'entity_id': entityId,
        'details': details,
        'created_at': createdAt,
      };
}

