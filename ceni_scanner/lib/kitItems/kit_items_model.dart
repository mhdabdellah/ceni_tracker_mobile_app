class KitItem {
  final String name;
  final int? quantity;
  final String itemType;

  KitItem({
    required this.name,
    this.quantity,
    required this.itemType,
  });

  factory KitItem.fromMap(Map<String, dynamic> map) {
    return KitItem(
      name: map['name'] as String,
      quantity: map['quantity'] as int?,
      itemType: map['itemType'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'itemType': itemType,
    };
  }
}

class KitItemsModel {
  final Map<String, int> quantities = {};
  final Map<String, bool> isChecked = {};

  void updateQuantity(String name, int quantity) {
    quantities[name] = quantity;
  }

  void toggleChecked(String name, bool checked) {
    isChecked[name] = checked;
  }

  Map<String, dynamic> toJson() {
    return {
      'kitItems': quantities.entries
          .map((e) => {
                'name': e.key,
                'quantity': e.value,
              })
          .toList(),
    };
  }
}

// class KitItemsModel {
//   bool batterie = false;
//   int? batterieNumber;

//   bool tubeEncre = false;
//   int? tubeEncreNumber;

//   bool largeEnvelopes = false;
//   int? largeEnvelopesNumber;

//   // bool electionTextsCompendium = true;
//   // int electionTextsCompendiumNumber = 0;

//   // bool votingOperationsGuide = true;
//   // int votingOperationsGuideNumber = 0;

//   bool presidentialElectionProceduresMemo = false;
//   int? presidentialElectionProceduresMemoNumber;

//   bool seals = false;
//   int? sealsNumber;

//   bool indelibleInkBottles = false;
//   int? indelibleInkBottlesNumber;

//   bool flashlights = false;
//   int? flashlightsNumber;

//   bool votingBooths = false;
//   int? votingBoothsNumber;

//   bool votedStamp = false;
//   int? votedStampNumber;

//   bool inkwell = false;
//   int? inkwellNumber;

//   bool calculator = false;
//   int? calculatorNumber;

//   bool scissors = false;
//   int? scissorsNumber;

//   bool pens = false;
//   int? pensNumber;

//   bool scotchTape = false;
//   int? scotchTapeNumber;

//   bool ruler = false;
//   int? rulerNumber;

//   bool vests = false;
//   int? vestsNumber;

//   // bool badges = true ;
//   // int badgesNumber = 0;

//   bool largeBag = false;
//   int? largeBagNumber;

//   bool ballotBoxSticker = false;
//   int? ballotBoxStickerNumber;

//   // bool banner = true;
//   // int? bannerNumber = 0;

//   Map<String, dynamic> toJson() {
//     return {
//       'batterie': {'key': batterie, 'number': batterieNumber},
//       'tubeEncre': {'key': tubeEncre, 'number': tubeEncreNumber},
//       'largeEnvelopes': {'key': largeEnvelopes, 'number': largeEnvelopesNumber},
//       // 'electionTextsCompendium': {'key': electionTextsCompendium, 'number': electionTextsCompendiumNumber},
//       // 'votingOperationsGuide': {'key': votingOperationsGuide, 'number': votingOperationsGuideNumber},
//       'presidentialElectionProceduresMemo': {'key': presidentialElectionProceduresMemo, 'number': presidentialElectionProceduresMemoNumber},
//       'seals': {'key': seals, 'number': sealsNumber},
//       'indelibleInkBottles': {'key': indelibleInkBottles, 'number': indelibleInkBottlesNumber},
//       'flashlights': {'key': flashlights, 'number': flashlightsNumber},
//       'votingBooths': {'key': votingBooths, 'number': votingBoothsNumber},
//       'votedStamp': {'key': votedStamp, 'number': votedStampNumber},
//       'inkwell': {'key': inkwell, 'number': inkwellNumber},
//       'calculator': {'key': calculator, 'number': calculatorNumber},
//       'scissors': {'key': scissors, 'number': scissorsNumber},
//       'pens': {'key': pens, 'number': pensNumber},
//       'scotchTape': {'key': scotchTape, 'number': scotchTapeNumber},
//       'ruler': {'key': ruler, 'number': rulerNumber},
//       'vests': {'key': vests, 'number': vestsNumber},
//       // 'badges': {'key': badges, 'number': badgesNumber},
//       'largeBag': {'key': largeBag, 'number': largeBagNumber},
//       'ballotBoxSticker': {'key': ballotBoxSticker, 'number': ballotBoxStickerNumber},
//       // 'banner': {'key': banner, 'number': bannerNumber},
//     };
//   }
// }
