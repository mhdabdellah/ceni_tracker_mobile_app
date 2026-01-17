import 'package:ceni_scanner/auth/auth_model.dart';
import 'package:ceni_scanner/kitItems/kit_items_model.dart';
import 'package:ceni_scanner/position_vusialisation/position_model.dart';

class ObjectType {
  final String id;
  final String name;
  final String codeType;
  final String description;

  ObjectType({
    required this.id,
    required this.name,
    required this.codeType,
    required this.description,
  });

  factory ObjectType.fromJson(Map<String, dynamic> json) {
    return ObjectType(
      id: json['id'].toString(),
      name: json['name'],
      codeType: json['codeType'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'codeType': codeType,
      'description': description,
    };
  }
}

class TypeModel {
  final String name;
  final String? codeType;
  final String? description;
  final List<KitItem>? kitItems;

  TypeModel({
    required this.name,
    this.codeType,
    this.description,
    this.kitItems,
  });

  factory TypeModel.fromMap(Map<String, dynamic> map) {
    return TypeModel(
      name: map['name'] as String,
      codeType: map['codeType'] as String?,
      description: map['description'] as String?,
      kitItems: map['kitItems'] != null
          ? (map['kitItems'] as List)
              .map((item) => KitItem.fromMap(item))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'codeType': codeType,
      'description': description,
      'kitItems': kitItems?.map((item) => item.toMap()).toList(),
    };
  }
}

class TrackedObject {
  // final UserModel? sender;
  // final UserModel? receiver;
  final String code;
  final String? barcodeImage;
  final String? qrcodeImage;
  final String source;
  final String destination;
  final DateTime generatedDate;
  final DateTime? scanDate;
  final int status;
  final int? wilaya;
  final int? moughataa;
  final int? commune;
  final int? center;
  final int? bureau;
  final TypeModel? type;
  final int? generationGroupe;

  TrackedObject({
    // this.sender,
    // this.receiver,
    required this.code,
    this.barcodeImage,
    this.qrcodeImage,
    required this.source,
    required this.destination,
    required this.generatedDate,
    this.scanDate,
    required this.status,
    this.wilaya,
    this.moughataa,
    this.commune,
    this.center,
    this.bureau,
    this.type,
    this.generationGroupe,
  });

  factory TrackedObject.fromMap(Map<String, dynamic> map) {
    return TrackedObject(
        // sender: map['sender'] != null ? UserModel.fromMap(map['sender']) : null,
        // receiver:
        //     map['receiver'] != null ? UserModel.fromMap(map['receiver']) : null,
        code: map['code'],
        barcodeImage: map['barcode_image'],
        qrcodeImage: map['qrcode_image'],
        source: map['source'],
        destination: map['destination'],
        generatedDate: DateTime.parse(map['generatedDate']),
        scanDate:
            map['scanDate'] != null ? DateTime.parse(map['scanDate']) : null,
        status: map['status'],
        wilaya: map['wilaya'],
        moughataa: map['moughataa'],
        commune: map['commune'],
        center: map['center'],
        bureau: map['bureau'],
        type: map['type'] != null ? TypeModel.fromMap(map['type']) : null,
        generationGroupe: map['generationGroupe']);
  }
}

// class TrackedObject {
//   final int id;
//   final String code;
//   final String source;
//   final String destination;
//   final ObjectType type;
//   // final int type;
//   final int status;

//   final List<ObjectPosition> trajet;
//   int wilaya;

//   int moughataa;

//   int commune;

//   int center;
//   int bureau;

//   TrackedObject({
//     required this.id,
//     required this.code,
//     required this.type,
//     required this.source,
//     required this.destination,
//     required this.trajet,
//     required  this.status,
//     required this.wilaya,
//     required this.moughataa,
//     required this.commune,
//     required this.center,
//     required this.bureau,
//   });

//   factory TrackedObject.fromJson(Map<String, dynamic> json) {
//     return TrackedObject(
//       id: json['id'],
//       code: json['code'],
//       // type: json['type'],
//       type: ObjectType.fromJson(json['type']),
//       source: json['source'],
//       destination: json['destination'],
//       status : json['status'],

//       wilaya: json['wilaya'] ?? 00,
//       moughataa: json['moughataa'] ?? 00,
//       commune: json['commune'] ?? 00,
//       center: json['center'] ?? 00,
//       bureau: json['bureau'] ?? 00,
//       trajet: (json['trajet'] as List)
//           .map((positionJson) => ObjectPosition.fromJson(positionJson))
//           .toList(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'code': code,
//       'source': source,
//       'destination': destination,
//       'status': status,
//       'trajet': trajet.map((position) => position.toJson()).toList(),
//     };
//   }
// }

enum ElectionMaterials {
  ballots, // Les bulletins de vote
  reports, // Les procès-verbaux
  reportExtracts, // Les extraits du procès-verbal
  electoralRoll, // Liste électorale
  attendanceSheet, // Feuille de pointage
  largeEnvelopes, // Enveloppes grand modèle
  electionTextsCompendium, // Recueil des textes relatifs aux élections
  votingOperationsGuide, // Guide des opérations de vote
  presidentialElectionProceduresMemo, // Mémento des procédures applicables à l’élection présidentielle
  ballotBox, // Urne
  seals, // Scellés
  indelibleInkBottles, // Flacons d’encre indélébile
  flashlights, // Lampes d’éclairage
  votingBooths, // Isoloirs
  votedStamp, // Cachet a voté
  inkwell, // Encreur
  calculator, // Calculatrice
  scissors, // Ciseaux
  pens, // Stylos
  scotchTape, // Scotch
  ruler, // Règle graduée
  vests, // Gilets
  badges, // Badges
  largeBag, // Sac grand format
  ballotBoxSticker, // Autocollant (urne)
  banner; // Banderole

  String get title {
    switch (this) {
      case ElectionMaterials.ballots:
        return "Les bulletins de vote";
      case ElectionMaterials.reports:
        return "Les procès-verbaux";
      case ElectionMaterials.reportExtracts:
        return "Les extraits du procès-verbal";
      case ElectionMaterials.electoralRoll:
        return "Liste électorale";
      case ElectionMaterials.attendanceSheet:
        return "Feuille de pointage";
      case ElectionMaterials.largeEnvelopes:
        return "Enveloppes grand modèle";
      case ElectionMaterials.electionTextsCompendium:
        return "Recueil des textes relatifs aux élections";
      case ElectionMaterials.votingOperationsGuide:
        return "Guide des opérations de vote";
      case ElectionMaterials.presidentialElectionProceduresMemo:
        return "Mémento des procédures applicables à l’élection présidentielle";
      case ElectionMaterials.ballotBox:
        return "Urne";
      case ElectionMaterials.seals:
        return "Scellés";
      case ElectionMaterials.indelibleInkBottles:
        return "Flacons d’encre indélébile";
      case ElectionMaterials.flashlights:
        return "Lampes d’éclairage";
      case ElectionMaterials.votingBooths:
        return "Isoloirs";
      case ElectionMaterials.votedStamp:
        return "Cachet a voté";
      case ElectionMaterials.inkwell:
        return "Encreur";
      case ElectionMaterials.calculator:
        return "Calculatrice";
      case ElectionMaterials.scissors:
        return "Ciseaux";
      case ElectionMaterials.pens:
        return "Stylos";
      case ElectionMaterials.scotchTape:
        return "Scotch";
      case ElectionMaterials.ruler:
        return "Règle graduée";
      case ElectionMaterials.vests:
        return "Gilets";
      case ElectionMaterials.badges:
        return "Badges";
      case ElectionMaterials.largeBag:
        return "Sac grand format";
      case ElectionMaterials.ballotBoxSticker:
        return "Autocollant (urne)";
      case ElectionMaterials.banner:
        return "Banderole";
      default:
        return "";
    }
  }
}
