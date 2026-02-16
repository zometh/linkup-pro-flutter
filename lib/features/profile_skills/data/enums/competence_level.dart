/*
[
  {
    "_id": {
      "$oid": "68c816a4d72cbfa4d7a91066"
    },
    "type": "CompetenceLevel",
    "value": "BEGINNER",
    "description": "Basic knowledge",
    "active": true,
    "createdAt": {
      "$date": "2025-09-15T13:37:40.463Z"
    }
  },
  {
    "_id": {
      "$oid": "68c816a5d72cbfa4d7a91068"
    },
    "type": "CompetenceLevel",
    "value": "EXPERT",
    "description": "Expert level",
    "active": true,
    "createdAt": {
      "$date": "2025-09-15T13:37:41.547Z"
    }
  },
  {
    "_id": {
      "$oid": "68c816a4d72cbfa4d7a91067"
    },
    "type": "CompetenceLevel",
    "value": "INTERMEDIATE",
    "description": "Intermediate level",
    "active": true,
    "createdAt": {
      "$date": "2025-09-15T13:37:40.910Z"
    }
  }
]*/
enum CompetenceLevel { BEGINNER, INTERMEDIATE, EXPERT }

CompetenceLevel competenceLevelFromString(String level) {
  switch (level) {
    case 'beginner':
      return CompetenceLevel.BEGINNER;
    case 'intermediate':
      return CompetenceLevel.INTERMEDIATE;
    case 'expert':
      return CompetenceLevel.EXPERT;
    default:
      throw Exception('Unknown competence level: $level');
  }
}
