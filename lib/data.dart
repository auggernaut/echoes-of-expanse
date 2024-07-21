import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayingCard {
  final String name;
  final String description;
  final String type;
  final String frontAsset; // Path to the front image asset
  final String backAsset; // Path to the back image asset
  bool isFlipped;

  // New stats as strings
  final String health;
  final String attack;
  final String cardClass; // renamed from class to avoid reserved keyword
  final String drive;
  final String ancestry;
  final String background;
  final String mission;
  final String power;
  final String smarts;
  final String charm;
  final String grit;

  PlayingCard({
    required this.name,
    required this.description,
    required this.type,
    required this.frontAsset,
    required this.backAsset,
    this.isFlipped = false,
    this.health = '',
    this.attack = '',
    this.cardClass = '',
    this.drive = '',
    this.ancestry = '',
    this.background = '',
    this.mission = '',
    this.power = '',
    this.smarts = '',
    this.charm = '',
    this.grit = '',
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'type': type,
        'frontAsset': frontAsset,
        'backAsset': backAsset,
        'isFlipped': isFlipped,
        'health': health,
        'attack': attack,
        'cardClass': cardClass,
        'drive': drive,
        'ancestry': ancestry,
        'background': background,
        'mission': mission,
        'power': power,
        'smarts': smarts,
        'charm': charm,
        'grit': grit,
      };

  factory PlayingCard.fromJson(Map<String, dynamic> json) => PlayingCard(
        name: json['name'],
        description: json['description'],
        type: json['type'],
        frontAsset: json['frontAsset'],
        backAsset: json['backAsset'],
        isFlipped: json['isFlipped'],
        health: json['health'],
        attack: json['attack'],
        cardClass: json['cardClass'],
        drive: json['drive'],
        ancestry: json['ancestry'],
        background: json['background'],
        mission: json['mission'],
        power: json['power'],
        smarts: json['smarts'],
        charm: json['charm'],
        grit: json['grit'],
      );
}

class InteractiveArea {
  Rect box;
  bool toggled;

  InteractiveArea({required this.box, this.toggled = false});
}

class Deck {
  final String id;
  final String name;
  final List<PlayingCard> cards;

  Deck({required this.id, required this.name, required this.cards});
}

class Hand {
  final List<PlayingCard> selectedCards = [];
  Map<String, String> characterStats = {
    'health': '',
    'attack': '',
    'class': '',
    'drive': '',
    'ancestry': '',
    'background': '',
    'mission': '',
    'power': '',
    'smarts': '',
    'charm': '',
    'grit': '',
  };

  // Method to add a card to the hand
  void addCard(PlayingCard card) {
    if (!selectedCards.contains(card)) {
      selectedCards.add(card);
      _updateCharacterStats();
      _saveToLocalStorage();
    }
  }

  // Method to remove a card from the hand
  void removeCard(PlayingCard card) {
    selectedCards.remove(card);
    _updateCharacterStats();
    _saveToLocalStorage();
  }

  // Method to update character stats
  void _updateCharacterStats() {
    characterStats = {
      'health': '',
      'attack': '',
      'class': '',
      'drive': '',
      'ancestry': '',
      'background': '',
      'mission': '',
      'power': '',
      'smarts': '',
      'charm': '',
      'grit': '',
    };

    for (var card in selectedCards) {
      characterStats['health'] = card.health;
      characterStats['attack'] = card.attack;

      if (card.cardClass.isNotEmpty) {
        characterStats['class'] = card.cardClass;
      }
      if (card.drive.isNotEmpty) {
        characterStats['drive'] = card.drive;
      }
      if (card.type == 'ancestry') {
        characterStats['ancestry'] = card.description;
      }
      if (card.background.isNotEmpty) {
        characterStats['background'] = card.background;
      }
      if (card.mission.isNotEmpty) {
        characterStats['mission'] = card.mission;
      }
      if (card.power.isNotEmpty) {
        characterStats['power'] = card.power;
      }
      if (card.smarts.isNotEmpty) {
        characterStats['smarts'] = card.smarts;
      }
      if (card.charm.isNotEmpty) {
        characterStats['charm'] = card.charm;
      }
      if (card.grit.isNotEmpty) {
        characterStats['grit'] = card.grit;
      }
    }
  }

  // Method to load cards and stats from localStorage
  Future<Map<String, String>> loadCards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cardsJson = prefs.getString('selectedCards');
    if (cardsJson != null) {
      List<dynamic> cardsList = jsonDecode(cardsJson);
      selectedCards.clear();
      selectedCards.addAll(cardsList.map((card) => PlayingCard.fromJson(card)).toList());
    }
    return characterStats = {
      'health': prefs.getString('health') ?? '',
      'attack': prefs.getString('attack') ?? '',
      'class': prefs.getString('class') ?? '',
      'drive': prefs.getString('drive') ?? '',
      'ancestry': prefs.getString('ancestry') ?? '',
      'background': prefs.getString('background') ?? '',
      'mission': prefs.getString('mission') ?? '',
      'power': prefs.getString('power') ?? '',
      'smarts': prefs.getString('smarts') ?? '',
      'charm': prefs.getString('charm') ?? '',
      'grit': prefs.getString('grit') ?? '',
    };
  }

  // Method to update a specific character stat and save it to localStorage
  void updateStat(String key, String value) {
    characterStats[key] = value;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(key, value);
    });
  }

  // Method to save cards and stats to localStorage
  Future<void> _saveToLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cardsJson = jsonEncode(selectedCards.map((card) => card.toJson()).toList());
    await prefs.setString('selectedCards', cardsJson);
    characterStats.forEach((key, value) async {
      await prefs.setString(key, value);
    });
  }

  // Method to clear the hand, stats, and localStorage
  Future<void> clearHand() async {
    selectedCards.clear();
    characterStats = {
      'health': '',
      'attack': '',
      'class': '',
      'drive': '',
      'ancestry': '',
      'background': '',
      'mission': '',
      'power': '',
      'smarts': '',
      'charm': '',
      'grit': '',
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('selectedCards');
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
      frontAsset: 'assets/images/wizard_class.png',
      backAsset: 'assets/images/wizard_class_back.png',
    ),
    PlayingCard(
      name: 'wizard_arcane_kinship',
      description: 'Wizard Arcane Kinship',
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
    ),
    PlayingCard(
      name: 'wizard_cast_spell',
      description: 'Cast Spell',
      type: 'skill',
      frontAsset: 'assets/images/wizard_cast_spell.png',
      backAsset: 'assets/images/wizard_class_back.png',
    ),
    PlayingCard(
      name: 'wizard_charm_person',
      description: 'Charm Person',
      type: 'skill',
      frontAsset: 'assets/images/wizard_charm_person.png',
      backAsset: 'assets/images/wizard_class_back.png',
    ),
    PlayingCard(
      name: 'wizard_contact_spirits',
      description: 'Contact Spirits',
      type: 'skill',
      frontAsset: 'assets/images/wizard_contact_spirits.png',
      backAsset: 'assets/images/wizard_class_back.png',
    ),
    PlayingCard(
      name: 'wizard_curiosity',
      description: 'Curiosity',
      type: 'drive',
      frontAsset: 'assets/images/wizard_curiosity.png',
      backAsset: 'assets/images/wizard_class_back.png',
    ),
    PlayingCard(
      name: 'wizard_detect_magic',
      description: 'Detect Magic',
      type: 'skill',
      frontAsset: 'assets/images/wizard_detect_magic.png',
      backAsset: 'assets/images/wizard_class_back.png',
    ),
    PlayingCard(
      name: 'wizard_dispel_magic',
      description: 'Dispel Magic',
      type: 'skill',
      frontAsset: 'assets/images/wizard_dispel_magic.png',
      backAsset: 'assets/images/wizard_class_back.png',
    ),
    PlayingCard(
      name: 'wizard_eccentricity',
      description: 'Eccentricity',
      type: 'drive',
      frontAsset: 'assets/images/wizard_eccentricity.png',
      backAsset: 'assets/images/wizard_class_back.png',
    ),
    PlayingCard(
      name: 'wizard_elf',
      description: 'Elf',
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
    ),
    PlayingCard(
      name: 'wizard_fireball',
      description: 'Fireball',
      type: 'skill',
      frontAsset: 'assets/images/wizard_fireball.png',
      backAsset: 'assets/images/wizard_class_back.png',
    ),
    PlayingCard(
      name: 'wizard_formally_trained',
      description: 'Formally Trained',
      type: 'background',
      frontAsset: 'assets/images/wizard_formally_trained.png',
      backAsset: 'assets/images/wizard_class_back.png',
    ),
    PlayingCard(
      name: 'wizard_invisibility',
      description: 'Invisibility',
      type: 'skill',
      frontAsset: 'assets/images/wizard_invisibility.png',
      backAsset: 'assets/images/wizard_class_back.png',
    ),
    PlayingCard(
      name: 'wizard_light',
      description: 'Light',
      type: 'skill',
      frontAsset: 'assets/images/wizard_light.png',
      backAsset: 'assets/images/wizard_class_back.png',
    ),
    PlayingCard(
      name: 'wizard_magic_missile',
      description: 'Magic Missile',
      type: 'skill',
      frontAsset: 'assets/images/wizard_magic_missile.png',
      backAsset: 'assets/images/wizard_class_back.png',
    ),
    PlayingCard(
      name: 'wizard_mimic',
      description: 'Mimic',
      type: 'skill',
      frontAsset: 'assets/images/wizard_mimic.png',
      backAsset: 'assets/images/wizard_class_back.png',
    ),
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
    ),
    PlayingCard(
      name: 'wizard_sleep',
      description: 'Sleep',
      type: 'skill',
      frontAsset: 'assets/images/wizard_sleep.png',
      backAsset: 'assets/images/wizard_class_back.png',
    ),
    PlayingCard(
      name: 'wizard_spear',
      description: 'Spear',
      type: 'skill',
      frontAsset: 'assets/images/wizard_spear.png',
      backAsset: 'assets/images/wizard_class_back.png',
    ),
    PlayingCard(
      name: 'wizard_spellbook',
      description: 'Spellbook',
      type: 'skill',
      frontAsset: 'assets/images/wizard_spellbook.png',
      backAsset: 'assets/images/wizard_class_back.png',
    ),
    PlayingCard(
      name: 'wizard_staff',
      description: 'Staff',
      type: 'skill',
      frontAsset: 'assets/images/wizard_staff.png',
      backAsset: 'assets/images/wizard_class_back.png',
    ),
    PlayingCard(
      name: 'wizard_steeped_in_lore',
      description: 'Steeped in Lore',
      type: 'background',
      frontAsset: 'assets/images/wizard_steeped_in_lore.png',
      backAsset: 'assets/images/wizard_class_back.png',
    ),
    PlayingCard(
      name: 'wizard_arcane_patronage',
      description: 'Arcane Patronage',
      type: 'background',
      frontAsset: 'assets/images/wizard_arcane_patronage.png',
      backAsset: 'assets/images/wizard_class_back.png',
    ),
  ]),
  Deck(id: 'fighter', name: 'Fighter', cards: [
    PlayingCard(
      name: 'fighter_class',
      description: 'fighter',
      type: 'class',
      frontAsset: 'assets/images/fighter_class.png',
      backAsset: 'assets/images/fighter_class_back.png',
    ),
    PlayingCard(
      name: 'fighter_noble_scion',
      description: 'Fighter Noble Scion',
      type: 'background',
      frontAsset: 'assets/images/fighter_noble_scion.png',
      backAsset: 'assets/images/fighter_class_back.png',
    ),
    PlayingCard(
      name: 'fighter_bend_bars',
      description: 'Bend Bars',
      type: 'skill',
      frontAsset: 'assets/images/fighter_bend_bars.png',
      backAsset: 'assets/images/fighter_class_back.png',
    ),
    PlayingCard(
      name: 'fighter_defend',
      description: 'Defend',
      type: 'skill',
      frontAsset: 'assets/images/fighter_defend.png',
      backAsset: 'assets/images/fighter_class_back.png',
    ),
    PlayingCard(
      name: 'fighter_gladiator',
      description: 'Gladiator',
      type: 'background',
      frontAsset: 'assets/images/fighter_gladiator.png',
      backAsset: 'assets/images/fighter_class_back.png',
    ),
    PlayingCard(
      name: 'fighter_pledged_guardian',
      description: 'Pledged Guardian',
      type: 'background',
      frontAsset: 'assets/images/fighter_pledged_guardian.png',
      backAsset: 'assets/images/fighter_class_back.png',
    ),
    PlayingCard(
      name: 'fighter_veteran_of_foreign_wars',
      description: 'Veteran of Foreign Wars',
      type: 'background',
      frontAsset: 'assets/images/fighter_veteran_of_foreign_wars.png',
      backAsset: 'assets/images/fighter_class_back.png',
    ),
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
      type: 'skill',
      frontAsset: 'assets/images/fighter_axe.png',
      backAsset: 'assets/images/fighter_class_back.png',
    ),
    PlayingCard(
      name: 'fighter_breastplate',
      description: 'Breastplate',
      type: 'skill',
      frontAsset: 'assets/images/fighter_breastplate.png',
      backAsset: 'assets/images/fighter_class_back.png',
    ),
    // Repeat the pattern for other cards
    PlayingCard(
      name: 'fighter_challenge',
      description: 'Challenge',
      type: 'drive',
      frontAsset: 'assets/images/fighter_challenge.png',
      backAsset: 'assets/images/fighter_class_back.png',
    ),
    PlayingCard(
      name: 'fighter_crossbow',
      description: 'Crossbow',
      type: 'skill',
      frontAsset: 'assets/images/fighter_crossbow.png',
      backAsset: 'assets/images/fighter_class_back.png',
    ),
    // Skipping some for brevity
    PlayingCard(
      name: 'fighter_dwarf',
      description: 'Dwarf',
      type: 'ancestry',
      frontAsset: 'assets/images/fighter_dwarf.png',
      backAsset: 'assets/images/fighter_class_back.png',
    ),
    // Continue with the provided list
    PlayingCard(
      name: 'fighter_flail',
      description: 'Flail',
      type: 'skill',
      frontAsset: 'assets/images/fighter_flail.png',
      backAsset: 'assets/images/fighter_class_back.png',
    ),
    PlayingCard(
      name: 'fighter_glory',
      description: 'Glory',
      type: 'drive',
      frontAsset: 'assets/images/fighter_glory.png',
      backAsset: 'assets/images/fighter_class_back.png',
    ),
    PlayingCard(
      name: 'fighter_hammer',
      description: 'Hammer',
      type: 'skill',
      frontAsset: 'assets/images/fighter_hammer.png',
      backAsset: 'assets/images/fighter_class_back.png',
    ),
    PlayingCard(
      name: 'fighter_token',
      description: 'Token',
      type: 'skill',
      frontAsset: 'assets/images/fighter_token.png',
      backAsset: 'assets/images/fighter_class_back.png',
    ),
    PlayingCard(
      name: 'fighter_hard_to_kill',
      description: 'Hard to Kill',
      type: 'skill',
      frontAsset: 'assets/images/fighter_hard_to_kill.png',
      backAsset: 'assets/images/fighter_class_back.png',
    ),
    PlayingCard(
      name: 'fighter_intimidating',
      description: 'Intimidating',
      type: 'skill',
      frontAsset: 'assets/images/fighter_intimidating.png',
      backAsset: 'assets/images/fighter_class_back.png',
    ),
    PlayingCard(
      name: 'fighter_mace',
      description: 'Mace',
      type: 'skill',
      frontAsset: 'assets/images/fighter_mace.png',
      backAsset: 'assets/images/fighter_class_back.png',
    ),
    PlayingCard(
      name: 'fighter_pride',
      description: 'Pride',
      type: 'drive',
      frontAsset: 'assets/images/fighter_pride.png',
      backAsset: 'assets/images/fighter_class_back.png',
    ),
    PlayingCard(
      name: 'fighter_shield',
      description: 'Shield',
      type: 'skill',
      frontAsset: 'assets/images/fighter_shield.png',
      backAsset: 'assets/images/fighter_class_back.png',
    ),
    PlayingCard(
      name: 'fighter_situational_awareness',
      description: 'Situational Awareness',
      type: 'skill',
      frontAsset: 'assets/images/fighter_situational_awareness.png',
      backAsset: 'assets/images/fighter_class_back.png',
    ),
    PlayingCard(
      name: 'fighter_spear',
      description: 'Spear',
      type: 'skill',
      frontAsset: 'assets/images/fighter_spear.png',
      backAsset: 'assets/images/fighter_class_back.png',
    ),
    PlayingCard(
      name: 'fighter_steely_eyed',
      description: 'Steely Eyed',
      type: 'skill',
      frontAsset: 'assets/images/fighter_steely_eyed.png',
      backAsset: 'assets/images/fighter_class_back.png',
    ),
    PlayingCard(
      name: 'fighter_sword',
      description: 'Sword',
      type: 'skill',
      frontAsset: 'assets/images/fighter_sword.png',
      backAsset: 'assets/images/fighter_class_back.png',
    ),
  ])
];
