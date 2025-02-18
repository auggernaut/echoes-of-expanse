class AdventureCard {
  final String name;
  final String type; // Monster, Location, Obstacle, Item
  final String frontAsset;
  final String backAsset;
  bool isFlipped;
  final int? weight;
  final int? coin;
  final int? hp;
  Map<String, double> position;
  String? id; // New field to store the Firestore document ID
  bool isHovered = false;

  AdventureCard({
    this.id,
    this.isHovered = false,
    required this.name,
    required this.type,
    required this.frontAsset,
    required this.backAsset,
    this.isFlipped = false,
    this.weight,
    this.coin,
    this.hp,
    this.position = const {'x': 0, 'y': 0},
  });

  void flip() {
    isFlipped = !isFlipped;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'frontAsset': frontAsset,
      'backAsset': backAsset,
      'isFlipped': isFlipped,
      'weight': weight,
      'coin': coin,
      'hp': hp,
    };
  }

  factory AdventureCard.fromJson(String id, Map<String, dynamic> json) {
    return AdventureCard(
      id: id,
      name: json['name'],
      type: json['type'] as String? ?? 'default', // Provide a default value
      frontAsset: json['frontAsset'],
      backAsset: json['backAsset'],
      isFlipped: json['isFlipped'] ?? false,
      position: Map<String, double>.from(json['position'] ?? {'x': 0, 'y': 0}),
    );
  }
}

// Create lists for each type of AdventureCard
List<AdventureCard> threatCards = [
  AdventureCard(
    name: 'Armored Statues',
    type: 'Threat',
    frontAsset: 'assets/images/adventure_cards/armored_statues_front.png',
    backAsset: 'assets/images/adventure_cards/armored_statues_back.png',
    hp: 5,
  ),
  AdventureCard(
    name: 'Carnivorous Plant',
    type: 'Threat',
    frontAsset: 'assets/images/adventure_cards/carnivorous_plant_front.png',
    backAsset: 'assets/images/adventure_cards/carnivorous_plant_back.png',
    hp: 5,
  ),
  AdventureCard(
    name: 'Living Blood',
    type: 'Threat',
    frontAsset: 'assets/images/adventure_cards/living_blood_front.png',
    backAsset: 'assets/images/adventure_cards/living_blood_back.png',
    hp: 5,
  ),
  AdventureCard(
    name: 'Vampire',
    type: 'Threat',
    frontAsset: 'assets/images/adventure_cards/vampire_front.png',
    backAsset: 'assets/images/adventure_cards/vampire_back.png',
    hp: 5,
  ),
  AdventureCard(
    name: 'Blood Thrall Guards',
    type: 'Threat',
    frontAsset: 'assets/images/adventure_cards/blood_thrall_guards_front.png',
    backAsset: 'assets/images/adventure_cards/blood_thrall_guards_back.png',
    hp: 5,
  ),
  AdventureCard(
    name: 'Biting Gate',
    type: 'Threat',
    frontAsset: 'assets/images/adventure_cards/biting_gate_front.png',
    backAsset: 'assets/images/adventure_cards/biting_gate_back.png',
    hp: 5,
  ),
  AdventureCard(
    name: 'Enchanted Tune',
    type: 'Threat',
    frontAsset: 'assets/images/adventure_cards/enchanted_tune_front.png',
    backAsset: 'assets/images/adventure_cards/enchanted_tune_back.png',
    hp: 5,
  ),
  AdventureCard(
    name: 'Seeping Walls',
    type: 'Threat',
    frontAsset: 'assets/images/adventure_cards/seeping_walls_front.png',
    backAsset: 'assets/images/adventure_cards/seeping_walls_back.png',
    hp: 5,
  ),
  AdventureCard(
    name: 'Shadow Hound',
    type: 'Threat',
    frontAsset: 'assets/images/adventure_cards/shadow_hound_front.png',
    backAsset: 'assets/images/adventure_cards/shadow_hound_back.png',
    hp: 5,
  ),
  AdventureCard(
    name: "Dark Vines",
    type: 'Threat',
    frontAsset: 'assets/images/adventure_cards/dark_vines.png',
    backAsset: 'assets/images/adventure_cards/dark_vines_back.png',
  ),
  AdventureCard(
    name: "Banshee Mother",
    type: 'Threat',
    frontAsset: 'assets/images/adventure_cards/banshee_mother.png',
    backAsset: 'assets/images/adventure_cards/banshee_mother_back.png',
  ),
  AdventureCard(
    name: "Enchanted Tune",
    type: 'Threat',
    frontAsset: 'assets/images/adventure_cards/enchanted_tune_front.png',
    backAsset: 'assets/images/adventure_cards/enchanted_tune_back.png',
  ),
  AdventureCard(
    name: "Sweeping Darkness",
    type: 'Threat',
    frontAsset: 'assets/images/adventure_cards/sweeping_darkness_front.png',
    backAsset: 'assets/images/adventure_cards/sweeping_darkness_back.png',
  ),
  // Add more monster cards...
];

List<AdventureCard> characterCards = [
  AdventureCard(
    name: 'Blood King',
    type: 'Character',
    frontAsset: 'assets/images/adventure_cards/blood_king_front.png',
    backAsset: 'assets/images/adventure_cards/blood_king_back.png',
  ),
  AdventureCard(
    name: 'Brunt Steelarm',
    type: 'Character',
    frontAsset: 'assets/images/adventure_cards/brunt_steelarm_front.png',
    backAsset: 'assets/images/adventure_cards/brunt_steelarm_back.png',
  ),
  AdventureCard(
    name: 'Haltis-Paldis Tetrafangs',
    type: 'Character',
    frontAsset: 'assets/images/adventure_cards/haltis_paldis_tetrafangs_front.png',
    backAsset: 'assets/images/adventure_cards/haltis_paldis_tetrafangs_back.png',
  ),
  AdventureCard(
    name: 'Lord Daemetrius',
    type: 'Character',
    frontAsset: 'assets/images/adventure_cards/lord_daemetrius_front.png',
    backAsset: 'assets/images/adventure_cards/lord_daemetrius_back.png',
  ),
  AdventureCard(
    name: 'Princess Blood',
    type: 'Character',
    frontAsset: 'assets/images/adventure_cards/princess_blood_front.png',
    backAsset: 'assets/images/adventure_cards/princess_blood_back.png',
  ),
  AdventureCard(
    name: 'Lenice Albathea',
    type: 'Character',
    frontAsset: 'assets/images/adventure_cards/lenice_albathea_front.png',
    backAsset: 'assets/images/adventure_cards/lenice_albathea_back.png',
  ),
  AdventureCard(
    name: 'Vampire Prisoner',
    type: 'Character',
    frontAsset: 'assets/images/adventure_cards/vampire_prisoner_front.png',
    backAsset: 'assets/images/adventure_cards/vampire_prisoner_back.png',
  ),
  AdventureCard(
    name: 'Zarzzizol Fastwing',
    type: 'Character',
    frontAsset: 'assets/images/adventure_cards/zarzzizol_fastwing_front.png',
    backAsset: 'assets/images/adventure_cards/zarzzizol_fastwing_back.png',
  ),
  // Add more character cards...
];

List<AdventureCard> itemCards = [
  AdventureCard(
    name: 'Health Booze',
    type: 'Item',
    frontAsset: 'assets/images/adventure_cards/health_booze_front.png',
    backAsset: 'assets/images/adventure_cards/health_booze_front.png',
    weight: 2,
    coin: 50,
  ),
  AdventureCard(
    name: 'Obsidian Dagger',
    type: 'Item',
    frontAsset: 'assets/images/adventure_cards/obsidian_dagger_front.png',
    backAsset: 'assets/images/adventure_cards/obsidian_dagger_front.png',
    weight: 2,
    coin: 50,
  ),
  AdventureCard(
    name: 'Spacetime Telescope',
    type: 'Item',
    frontAsset: 'assets/images/adventure_cards/spacetime_telescope_front.png',
    backAsset: 'assets/images/adventure_cards/spacetime_telescope_front.png',
    weight: 2,
    coin: 50,
  ),
  AdventureCard(
    name: 'Sun Ray Pistol',
    type: 'Item',
    frontAsset: 'assets/images/adventure_cards/sun_ray_pistol_front.png',
    backAsset: 'assets/images/adventure_cards/sun_ray_pistol_front.png',
    weight: 2,
    coin: 50,
  ),
  AdventureCard(
    name: 'Tome of Alien Worlds',
    type: 'Item',
    frontAsset: 'assets/images/adventure_cards/tome_of_alien_worlds_front.png',
    backAsset: 'assets/images/adventure_cards/tome_of_alien_worlds_front.png',
    weight: 2,
    coin: 50,
  ),
  AdventureCard(
    name: 'Blood Rose',
    type: 'Item',
    frontAsset: 'assets/images/adventure_cards/blood_rose_front.png',
    backAsset: 'assets/images/adventure_cards/blood_rose_front.png',
    weight: 2,
    coin: 50,
  ),
  AdventureCard(
    name: 'Elixer of Life',
    type: 'Item',
    frontAsset: 'assets/images/adventure_cards/elixer_of_life.png',
    backAsset: 'assets/images/adventure_cards/elixer_of_life.png',
    weight: 2,
    coin: 50,
  ),
  AdventureCard(
    name: 'Holy Water',
    type: 'Item',
    frontAsset: 'assets/images/adventure_cards/holy_water.png',
    backAsset: 'assets/images/adventure_cards/holy_water.png',
    weight: 2,
    coin: 50,
  ),
  AdventureCard(
    name: 'Royal Crown',
    type: 'Item',
    frontAsset: 'assets/images/adventure_cards/royal_crown.png',
    backAsset: 'assets/images/adventure_cards/royal_crown.png',
    weight: 2,
    coin: 50,
  ),
  AdventureCard(
    name: 'Cape of the Undead',
    type: 'Item',
    frontAsset: 'assets/images/adventure_cards/cape_of_undead.png',
    backAsset: 'assets/images/adventure_cards/cape_of_undead.png',
    weight: 2,
    coin: 50,
  ),
  // Add more item cards...
];

List<AdventureCard> locationCards = [
  AdventureCard(
    name: 'King\'s Chambers',
    type: 'Location',
    frontAsset: 'assets/images/adventure_cards/kings_chambers_front.png',
    backAsset: 'assets/images/adventure_cards/kings_chambers_back.png',
  ),
  AdventureCard(
    name: 'King\'s Hall',
    type: 'Location',
    frontAsset: 'assets/images/adventure_cards/kings_hall_front.png',
    backAsset: 'assets/images/adventure_cards/kings_hall_back.png',
  ),
  AdventureCard(
    name: "Princess's Study",
    type: 'Location',
    frontAsset: 'assets/images/adventure_cards/princesses_study_front.png',
    backAsset: 'assets/images/adventure_cards/princesses_study_back.png',
  ),
  AdventureCard(
    name: "Seleana's Trapped Lair",
    type: 'Location',
    frontAsset: 'assets/images/adventure_cards/seleanas_trapped_lair_front.png',
    backAsset: 'assets/images/adventure_cards/seleanas_trapped_lair_back.png',
  ),
  AdventureCard(
    name: "Service Stairs",
    type: 'Location',
    frontAsset: 'assets/images/adventure_cards/service_stairs_front.png',
    backAsset: 'assets/images/adventure_cards/service_stairs_back.png',
  ),
  AdventureCard(
    name: "Balcony",
    type: 'Location',
    frontAsset: 'assets/images/adventure_cards/balcony_front.png',
    backAsset: 'assets/images/adventure_cards/balcony_back.png',
  ),
  AdventureCard(
    name: "Blood Baths",
    type: 'Location',
    frontAsset: 'assets/images/adventure_cards/blood_baths_front.png',
    backAsset: 'assets/images/adventure_cards/blood_baths_back.png',
  ),
  AdventureCard(
    name: "Great Hall",
    type: 'Location',
    frontAsset: 'assets/images/adventure_cards/great_hall_front.png',
    backAsset: 'assets/images/adventure_cards/great_hall_back.png',
  ),
  AdventureCard(
    name: "Main Gate",
    type: 'Location',
    frontAsset: 'assets/images/adventure_cards/main_gate_front.png',
    backAsset: 'assets/images/adventure_cards/main_gate_back.png',
  ),
  AdventureCard(
    name: "Vine Fence",
    type: 'Location',
    frontAsset: 'assets/images/adventure_cards/vine_fence_front.png',
    backAsset: 'assets/images/adventure_cards/vine_fence_back.png',
  ),
  AdventureCard(
    name: "Corridors",
    type: 'Location',
    frontAsset: 'assets/images/adventure_cards/corridors_front.png',
    backAsset: 'assets/images/adventure_cards/corridors_back.png',
  ),
  AdventureCard(
    name: "Entry Hall",
    type: 'Location',
    frontAsset: 'assets/images/adventure_cards/entry_hall_front.png',
    backAsset: 'assets/images/adventure_cards/entry_hall_back.png',
  ),
  AdventureCard(
    name: "Garden of Roses",
    type: 'Location',
    frontAsset: 'assets/images/adventure_cards/garden_of_roses_front.png',
    backAsset: 'assets/images/adventure_cards/garden_of_roses_back.png',
  ),
  AdventureCard(
    name: "Guest Room",
    type: 'Location',
    frontAsset: 'assets/images/adventure_cards/guest_room_front.png',
    backAsset: 'assets/images/adventure_cards/guest_room_back.png',
  ),
  AdventureCard(
    name: "Hat Room",
    type: 'Location',
    frontAsset: 'assets/images/adventure_cards/hat_room_front.png',
    backAsset: 'assets/images/adventure_cards/hat_room_back.png',
  ),
  AdventureCard(
    name: "Secret Conference Room",
    type: 'Location',
    frontAsset: 'assets/images/adventure_cards/secret_conference_room_front.png',
    backAsset: 'assets/images/adventure_cards/secret_conference_room_back.png',
  ),
  // Add more location cards...
];

// ... rest of the existing code ...

List<AdventureCard> hookCards = [
  AdventureCard(
    name: 'Seleana Suantis',
    type: 'Hook',
    frontAsset: 'assets/images/adventure_cards/hook_seleana.png',
    backAsset: 'assets/images/adventure_cards/hook_seleana_back.png',
  ),
];
