import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PlayingCard {
  final String name;
  final String description;
  final String type;
  final String frontAsset; // Path to the front image asset
  final String backAsset; // Path to the back image asset
  bool isFlipped;

  // New stats as strings
  final int health;
  final int maxWeight;
  final int weight;
  final String cardClass;
  final String drive;
  final String ancestry;
  final String background;
  final String bond;
  final int power;
  final int smarts;
  final int charm;
  final int grit;
  final int armor;
  final int coin;

  PlayingCard(
      {required this.name,
      required this.description,
      required this.type,
      required this.frontAsset,
      required this.backAsset,
      this.isFlipped = false,
      this.health = 0,
      this.maxWeight = 0,
      this.weight = 0,
      this.cardClass = '',
      this.drive = '',
      this.ancestry = '',
      this.background = '',
      this.bond = '',
      this.power = 0,
      this.smarts = 0,
      this.charm = 0,
      this.grit = 0,
      this.armor = 0,
      this.coin = 0});

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'type': type,
        'frontAsset': frontAsset,
        'backAsset': backAsset,
        'isFlipped': isFlipped,
        'health': health,
        'maxWeight': maxWeight,
        'weight': weight,
        'cardClass': cardClass,
        'drive': drive,
        'ancestry': ancestry,
        'background': background,
        'bond': bond,
        'power': power,
        'smarts': smarts,
        'charm': charm,
        'grit': grit,
        'armor': armor,
        'coin': coin
      };

  factory PlayingCard.fromJson(Map<String, dynamic> json) => PlayingCard(
      name: json['name'],
      description: json['description'],
      type: json['type'],
      frontAsset: json['frontAsset'],
      backAsset: json['backAsset'],
      isFlipped: json['isFlipped'],
      health: json['health'],
      maxWeight: json['maxWeight'],
      weight: json['weight'],
      cardClass: json['cardClass'],
      drive: json['drive'],
      ancestry: json['ancestry'],
      background: json['background'],
      bond: json['bond'],
      power: json['power'],
      smarts: json['smarts'],
      charm: json['charm'],
      grit: json['grit'],
      armor: json['armor'],
      coin: json['coin']);
}

class TreasureItem {
  final String id;
  final String name;
  final int cost;
  final int weight;

  TreasureItem({required this.id, required this.name, required this.cost, required this.weight});

  // Method to convert a TreasureItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cost': cost,
      'weight': weight,
    };
  }

  // Method to create a TreasureItem from JSON
  static TreasureItem fromJson(Map<String, dynamic> json) {
    return TreasureItem(
      id: json['id'],
      name: json['name'],
      cost: json['cost'],
      weight: json['weight'],
    );
  }
}

class Deck {
  final String id;
  final String name;
  final List<PlayingCard> cards;

  Deck({required this.id, required this.name, required this.cards});
}

class Hand {
  final List<PlayingCard> selectedCards = [];
  final List<TreasureItem> treasureItems = [];
  Map<String, dynamic> characterStats = {
    'health': 0,
    'maxWeight': 0,
    'weight': 0,
    'class': '',
    'drive': '',
    'ancestry': '',
    'background': '',
    'bond': '',
    'power': 0,
    'smarts': 0,
    'charm': 0,
    'grit': 0,
    'armor': 0,
    'coin': 0
  };

  // Method to add a card to the hand
  void addCard(PlayingCard card) {
    if (!selectedCards.contains(card)) {
      selectedCards.add(card);
      _updateCharacterStats(card);
      _saveToLocalStorage();
    }
  }

  // Method to remove a card from the hand
  void removeCard(PlayingCard card) {
    selectedCards.remove(card);
    _updateCharacterStats(card);
    _saveToLocalStorage();
  }

  // Method to add a treasure item to the hand
  void addTreasureItem(TreasureItem item) {
    treasureItems.add(item);
    _saveToLocalStorage();
  }

  // Method to remove a treasure item from the hand
  void removeTreasureItem(String id) {
    treasureItems.removeWhere((item) => item.id == id);
    _saveToLocalStorage();
  }

  // Method to update a treasure item in the hand
  void updateTreasureItem(TreasureItem updatedItem) {
    int index = treasureItems.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      treasureItems[index] = updatedItem;
      _saveToLocalStorage();
    }
  }

  // Method to update character stats
  void _updateCharacterStats(PlayingCard card) {
    if (card.type == 'class') {
      characterStats['class'] = card.description;
    }
    if (card.type == 'drive') {
      characterStats['drive'] = card.description;
    }
    if (card.type == 'ancestry') {
      characterStats['ancestry'] = card.description;
    }
    if (card.type == 'background') {
      characterStats['health'] = card.health;
      characterStats['maxWeight'] = card.maxWeight;
      characterStats['background'] = card.description;
      characterStats['power'] = card.power;
      characterStats['smarts'] = card.smarts;
      characterStats['charm'] = card.charm;
      characterStats['grit'] = card.grit;
    }
    if (card.type == 'bond') {
      characterStats['bond'] = card.description;
    }
    if (card.armor > 0) {
      characterStats['armor'] += card.armor;
    }
    if (card.weight > 0) {
      characterStats['weight'] += card.weight;
    }
  }

  // Method to load cards and stats from localStorage
  Future<Map<String, dynamic>> loadCards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cardsJson = prefs.getString('selectedCards');
    if (cardsJson != null) {
      List<dynamic> cardsList = jsonDecode(cardsJson);
      selectedCards.clear();
      selectedCards.addAll(cardsList.map((card) => PlayingCard.fromJson(card)).toList());
    }

    String? treasureItemsJson = prefs.getString('treasureItems');
    if (treasureItemsJson != null) {
      List<dynamic> treasureItemsList = jsonDecode(treasureItemsJson);
      treasureItems.clear();
      treasureItems.addAll(treasureItemsList.map((item) => TreasureItem.fromJson(item)).toList());
    }

    return characterStats = {
      'characterName': prefs.getString('characterName') ?? '',
      'health': prefs.getInt('health') ?? 0,
      'maxWeight': prefs.getInt('maxWeight') ?? 0,
      'weight': prefs.getInt('weight') ?? 0,
      'class': prefs.getString('class') ?? '',
      'drive': prefs.getString('drive') ?? '',
      'ancestry': prefs.getString('ancestry') ?? '',
      'background': prefs.getString('background') ?? '',
      'bond': prefs.getString('bond') ?? '',
      'bondName': prefs.getString('bondName') ?? '',
      'power': prefs.getInt('power') ?? 0,
      'smarts': prefs.getInt('smarts') ?? 0,
      'charm': prefs.getInt('charm') ?? 0,
      'grit': prefs.getInt('grit') ?? 0,
      'armor': prefs.getInt('armor') ?? 0,
      'coin': prefs.getInt('coin') ?? 0,
    };
  }

  // Method to update a specific character stat and save it to localStorage
  void updateStat(String key, dynamic value) {
    characterStats[key] = value;
    SharedPreferences.getInstance().then((prefs) {
      if (value is int) {
        prefs.setInt(key, value);
      } else if (value is String) {
        prefs.setString(key, value);
      }
    });
  }

  // Method to save cards, treasure items, and stats to localStorage
  Future<void> _saveToLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cardsJson = jsonEncode(selectedCards.map((card) => card.toJson()).toList());
    await prefs.setString('selectedCards', cardsJson);

    String treasureItemsJson = jsonEncode(treasureItems.map((item) => item.toJson()).toList());
    await prefs.setString('treasureItems', treasureItemsJson);

    characterStats.forEach((key, value) async {
      if (value is int) {
        await prefs.setInt(key, value);
      } else if (value is String) {
        await prefs.setString(key, value);
      }
    });
  }

  // Method to clear the hand, stats, and localStorage
  Future<void> clearHand() async {
    selectedCards.clear();
    treasureItems.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('selectedCards');
    await prefs.remove('treasureItems');
    for (var key in characterStats.keys) {
      await prefs.remove(key);
    }
  }
}

List<Deck> decks = [
  Deck(id: 'wizard', name: 'Wizard', cards: [
    PlayingCard(
      name: 'wizard_class',
      description: 'Wizard',
      type: 'class',
      frontAsset: 'assets/images/wizard_class_back.png',
      backAsset: 'assets/images/wizard_class_back.png',
    ),
    PlayingCard(
      name: 'wizard_arcane_kinship',
      description: 'Arcane Kinship',
      type: 'bond',
      frontAsset: 'assets/images/wizard_arcane_kinship.png',
      backAsset: 'assets/images/wizard_class_back.png',
    ),
    PlayingCard(
      name: 'wizard_human',
      description: 'Human',
      type: 'ancestry',
      frontAsset: 'assets/images/wizard_human.png',
      backAsset: 'assets/images/wizard_class_back.png',
    ),
    PlayingCard(
        name: 'wizard_arcane_ward',
        description: 'Arcane Ward',
        type: 'skill',
        frontAsset: 'assets/images/wizard_arcane_ward.png',
        backAsset: 'assets/images/wizard_class_back.png',
        coin: 2),
    PlayingCard(
        name: 'wizard_amulet',
        description: 'Amulet of Aegis',
        type: 'equipment',
        frontAsset: 'assets/images/wizard_amulet.png',
        backAsset: 'assets/images/wizard_class_back.png',
        coin: 2),
    PlayingCard(
        name: 'wizard_charm_person',
        description: 'Charm Person',
        type: 'skill',
        frontAsset: 'assets/images/wizard_charm_person.png',
        backAsset: 'assets/images/wizard_class_back.png',
        coin: 2),
    PlayingCard(
        name: 'wizard_contact_spirits',
        description: 'Contact Spirits',
        type: 'skill',
        frontAsset: 'assets/images/wizard_contact_spirits.png',
        backAsset: 'assets/images/wizard_class_back.png',
        coin: 2),
    PlayingCard(
      name: 'wizard_curious',
      description: 'Curious',
      type: 'drive',
      frontAsset: 'assets/images/wizard_curious.png',
      backAsset: 'assets/images/wizard_class_back.png',
    ),
    PlayingCard(
        name: 'wizard_detect_magic',
        description: 'Detect Magic',
        type: 'skill',
        frontAsset: 'assets/images/wizard_detect_magic.png',
        backAsset: 'assets/images/wizard_class_back.png',
        coin: 2),
    PlayingCard(
        name: 'wizard_dispel_magic',
        description: 'Dispel Magic',
        type: 'skill',
        frontAsset: 'assets/images/wizard_dispel_magic.png',
        backAsset: 'assets/images/wizard_class_back.png',
        coin: 2),
    PlayingCard(
      name: 'wizard_eccentric',
      description: 'Eccentric',
      type: 'drive',
      frontAsset: 'assets/images/wizard_eccentric.png',
      backAsset: 'assets/images/wizard_class_back.png',
    ),
    PlayingCard(
      name: 'wizard_elf',
      description: 'Elven',
      type: 'ancestry',
      frontAsset: 'assets/images/wizard_elf.png',
      backAsset: 'assets/images/wizard_class_back.png',
    ),
    // Continue adding more cards in a similar manner...
    PlayingCard(
        name: 'wizard_telepathy',
        description: 'Telepathy',
        type: 'skill',
        frontAsset: 'assets/images/wizard_telepathy.png',
        backAsset: 'assets/images/wizard_class_back.png',
        coin: 2),
    PlayingCard(
        name: 'wizard_fireball',
        description: 'Fireball',
        type: 'skill',
        frontAsset: 'assets/images/wizard_fireball.png',
        backAsset: 'assets/images/wizard_class_back.png',
        coin: 2),
    PlayingCard(
        name: 'wizard_invisibility',
        description: 'Invisibility',
        type: 'skill',
        frontAsset: 'assets/images/wizard_invisibility.png',
        backAsset: 'assets/images/wizard_class_back.png',
        coin: 2),
    PlayingCard(
        name: 'wizard_light',
        description: 'Light',
        type: 'skill',
        frontAsset: 'assets/images/wizard_light.png',
        backAsset: 'assets/images/wizard_class_back.png',
        coin: 2),
    PlayingCard(
        name: 'wizard_magic_missile',
        description: 'Magic Missile',
        type: 'skill',
        frontAsset: 'assets/images/wizard_magic_missile.png',
        backAsset: 'assets/images/wizard_class_back.png',
        coin: 2),
    PlayingCard(
        name: 'wizard_mimic',
        description: 'Mimic',
        type: 'skill',
        frontAsset: 'assets/images/wizard_mimic.png',
        backAsset: 'assets/images/wizard_class_back.png',
        coin: 2),
    PlayingCard(
      name: 'wizard_pact',
      description: 'Pact',
      type: 'bond',
      frontAsset: 'assets/images/wizard_pact.png',
      backAsset: 'assets/images/wizard_class_back.png',
    ),
    PlayingCard(
      name: 'wizard_ritual',
      description: 'Ritual',
      type: 'skill',
      frontAsset: 'assets/images/wizard_ritual.png',
      backAsset: 'assets/images/wizard_class_back.png',
      coin: 2,
    ),
    PlayingCard(
      name: 'wizard_sleep',
      description: 'Sleep',
      type: 'skill',
      frontAsset: 'assets/images/wizard_sleep.png',
      backAsset: 'assets/images/wizard_class_back.png',
      coin: 2,
    ),
    PlayingCard(
      name: 'wizard_spear',
      description: 'Spear',
      type: 'equipment',
      frontAsset: 'assets/images/wizard_spear.png',
      backAsset: 'assets/images/wizard_class_back.png',
      coin: 2,
      weight: 2,
    ),
    PlayingCard(
      name: 'wizard_spellbook',
      description: 'Spellbook',
      type: 'recommended',
      frontAsset: 'assets/images/wizard_spellbook.png',
      backAsset: 'assets/images/wizard_class_back.png',
      coin: 2,
      weight: 1,
    ),
    PlayingCard(
      name: 'wizard_staff',
      description: 'Staff',
      type: 'equipment',
      frontAsset: 'assets/images/wizard_staff.png',
      backAsset: 'assets/images/wizard_class_back.png',
      coin: 2,
      weight: 1,
    ),
    PlayingCard(
        name: 'wizard_lore_keeper',
        description: 'Lore Keeper',
        type: 'background',
        frontAsset: 'assets/images/wizard_lore_keeper.png',
        backAsset: 'assets/images/wizard_class_back.png',
        health: 14,
        maxWeight: 4,
        power: 1,
        smarts: 2,
        charm: -1,
        grit: 0),
    PlayingCard(
        name: 'wizard_patrons_herald',
        description: "Patron's Herald",
        type: 'background',
        frontAsset: 'assets/images/wizard_patrons_herald.png',
        backAsset: 'assets/images/wizard_class_back.png',
        health: 14,
        maxWeight: 4,
        power: 0,
        smarts: 2,
        charm: -1,
        grit: 1),
    PlayingCard(
        name: 'wizard_fae_touched',
        description: 'Fae Touched',
        type: 'background',
        frontAsset: 'assets/images/wizard_fae_touched.png',
        backAsset: 'assets/images/wizard_class_back.png',
        health: 14,
        maxWeight: 4,
        power: -1,
        smarts: 2,
        charm: 0,
        grit: 1),
    PlayingCard(
        name: 'wizard_acolyte',
        description: 'Acolyte',
        type: 'background',
        frontAsset: 'assets/images/wizard_acolyte.png',
        backAsset: 'assets/images/wizard_class_back.png',
        health: 14,
        maxWeight: 4,
        power: -1,
        smarts: 2,
        charm: 1,
        grit: 0),
  ]),
  Deck(id: 'fighter', name: 'Fighter', cards: [
    PlayingCard(
      name: 'fighter_class',
      description: 'Fighter',
      type: 'class',
      frontAsset: 'assets/images/fighter_class_back.png',
      backAsset: 'assets/images/fighter_class_back.png',
    ),
    PlayingCard(
        name: 'fighter_noble_scion',
        description: 'Noble Scion',
        type: 'background',
        frontAsset: 'assets/images/fighter_noble_scion.png',
        backAsset: 'assets/images/fighter_class_back.png',
        health: 18,
        maxWeight: 5,
        power: 1,
        smarts: 2,
        charm: 0,
        grit: -1),
    PlayingCard(
        name: 'fighter_bend_bars',
        description: 'Bend Bars',
        type: 'skill',
        frontAsset: 'assets/images/fighter_bend_bars.png',
        backAsset: 'assets/images/fighter_class_back.png',
        coin: 2),
    PlayingCard(
        name: 'fighter_defend',
        description: 'Defend',
        type: 'recommended',
        frontAsset: 'assets/images/fighter_defend.png',
        backAsset: 'assets/images/fighter_class_back.png',
        coin: 2),
    PlayingCard(
        name: 'fighter_gladiator',
        description: 'Gladiator',
        type: 'background',
        frontAsset: 'assets/images/fighter_gladiator.png',
        backAsset: 'assets/images/fighter_class_back.png',
        health: 19,
        maxWeight: 6,
        power: 2,
        smarts: 0,
        charm: -1,
        grit: 1),
    PlayingCard(
        name: 'fighter_pledged_guardian',
        description: 'Guardian',
        type: 'background',
        frontAsset: 'assets/images/fighter_pledged_guardian.png',
        backAsset: 'assets/images/fighter_class_back.png',
        health: 20,
        maxWeight: 6,
        power: 0,
        smarts: -1,
        charm: 1,
        grit: 2),
    PlayingCard(
        name: 'fighter_veteran_of_foreign_wars',
        description: 'Veteran',
        type: 'background',
        frontAsset: 'assets/images/fighter_veteran_of_foreign_wars.png',
        backAsset: 'assets/images/fighter_class_back.png',
        health: 18,
        maxWeight: 7,
        power: 1,
        smarts: 0,
        charm: -1,
        grit: 2),
    PlayingCard(
      name: 'fighter_brothers_oath',
      description: 'Brothers Oath',
      type: 'bond',
      frontAsset: 'assets/images/fighter_brothers_oath.png',
      backAsset: 'assets/images/fighter_class_back.png',
    ),
    PlayingCard(
      name: 'fighter_old_rivalry',
      description: 'Old Rivalry',
      type: 'bond',
      frontAsset: 'assets/images/fighter_old_rivalry.png',
      backAsset: 'assets/images/fighter_class_back.png',
    ),
    PlayingCard(
      name: 'fighter_human',
      description: 'Human',
      type: 'ancestry',
      frontAsset: 'assets/images/fighter_human.png',
      backAsset: 'assets/images/fighter_class_back.png',
    ),
    PlayingCard(
        name: 'fighter_axe',
        description: 'Axe',
        type: 'equipment',
        frontAsset: 'assets/images/fighter_axe.png',
        backAsset: 'assets/images/fighter_class_back.png',
        coin: 2,
        weight: 1),
    PlayingCard(
        name: 'fighter_breastplate',
        description: 'Breastplate',
        type: 'equipment',
        frontAsset: 'assets/images/fighter_breastplate.png',
        backAsset: 'assets/images/fighter_class_back.png',
        armor: 2,
        coin: 2,
        weight: 2),
    // Repeat the pattern for other cards
    PlayingCard(
      name: 'fighter_dauntless',
      description: 'Dauntless',
      type: 'drive',
      frontAsset: 'assets/images/fighter_dauntless.png',
      backAsset: 'assets/images/fighter_class_back.png',
    ),
    PlayingCard(
        name: 'fighter_crossbow',
        description: 'Crossbow',
        type: 'equipment',
        frontAsset: 'assets/images/fighter_crossbow.png',
        backAsset: 'assets/images/fighter_class_back.png',
        coin: 2,
        weight: 1),
    // Skipping some for brevity
    PlayingCard(
      name: 'fighter_dwarven',
      description: 'Dwarven',
      type: 'ancestry',
      frontAsset: 'assets/images/fighter_dwarven.png',
      backAsset: 'assets/images/fighter_class_back.png',
    ),
    // Continue with the provided list
    PlayingCard(
        name: 'fighter_flail',
        description: 'Flail',
        type: 'equipment',
        frontAsset: 'assets/images/fighter_flail.png',
        backAsset: 'assets/images/fighter_class_back.png',
        coin: 2,
        weight: 2),
    PlayingCard(
      name: 'fighter_glory',
      description: 'Glory-Bound',
      type: 'drive',
      frontAsset: 'assets/images/fighter_glory.png',
      backAsset: 'assets/images/fighter_class_back.png',
    ),
    PlayingCard(
        name: 'fighter_hammer',
        description: 'Hammer',
        type: 'equipment',
        frontAsset: 'assets/images/fighter_hammer.png',
        backAsset: 'assets/images/fighter_class_back.png',
        coin: 2,
        weight: 2),
    PlayingCard(
        name: 'fighter_token',
        description: 'Token',
        type: 'recommended',
        frontAsset: 'assets/images/fighter_token.png',
        backAsset: 'assets/images/fighter_class_back.png',
        coin: 2,
        weight: 1),
    PlayingCard(
        name: 'fighter_hard_to_kill',
        description: 'Hard to Kill',
        type: 'skill',
        frontAsset: 'assets/images/fighter_hard_to_kill.png',
        backAsset: 'assets/images/fighter_class_back.png',
        coin: 2),
    PlayingCard(
        name: 'fighter_intimidating',
        description: 'Intimidating',
        type: 'skill',
        frontAsset: 'assets/images/fighter_intimidating.png',
        backAsset: 'assets/images/fighter_class_back.png',
        coin: 2),
    PlayingCard(
        name: 'fighter_mace',
        description: 'Mace',
        type: 'equipment',
        frontAsset: 'assets/images/fighter_mace.png',
        backAsset: 'assets/images/fighter_class_back.png',
        coin: 2,
        weight: 1),
    PlayingCard(
      name: 'fighter_pride',
      description: 'Proud',
      type: 'drive',
      frontAsset: 'assets/images/fighter_pride.png',
      backAsset: 'assets/images/fighter_class_back.png',
    ),
    PlayingCard(
        name: 'fighter_shield',
        description: 'Shield',
        type: 'equipment',
        frontAsset: 'assets/images/fighter_shield.png',
        backAsset: 'assets/images/fighter_class_back.png',
        coin: 2,
        weight: 2),
    PlayingCard(
        name: 'fighter_situational_awareness',
        description: 'Situational Awareness',
        type: 'skill',
        frontAsset: 'assets/images/fighter_situational_awareness.png',
        backAsset: 'assets/images/fighter_class_back.png',
        coin: 2),
    PlayingCard(
        name: 'fighter_spear',
        description: 'Spear',
        type: 'equipment',
        frontAsset: 'assets/images/fighter_spear.png',
        backAsset: 'assets/images/fighter_class_back.png',
        coin: 2,
        weight: 1),
    PlayingCard(
        name: 'fighter_steely_eyed',
        description: 'Steely Eyed',
        type: 'skill',
        frontAsset: 'assets/images/fighter_steely_eyed.png',
        backAsset: 'assets/images/fighter_class_back.png',
        coin: 2),
    PlayingCard(
        name: 'fighter_sword',
        description: 'Sword',
        type: 'equipment',
        frontAsset: 'assets/images/fighter_sword.png',
        backAsset: 'assets/images/fighter_class_back.png',
        coin: 2,
        weight: 1),
  ])
];
