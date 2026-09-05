import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class WasteGuideEntry extends Equatable {
  const WasteGuideEntry({
    required this.title,
    required this.description,
    required this.examples,
    required this.doText,
    required this.dontText,
    required this.recommendation,
    required this.icon,
  });
  final String title, description, examples, doText, dontText, recommendation;
  final IconData icon;
  @override
  List<Object> get props => [
    title,
    description,
    examples,
    doText,
    dontText,
    recommendation,
    icon,
  ];
}

const wasteGuideEntries = [
  WasteGuideEntry(
    title: 'Wet Waste',
    description: 'Food scraps and other biodegradable material.',
    examples: 'Fruit peels, leftovers, garden waste',
    doText: 'Drain excess water and compost where possible.',
    dontText: 'Do not mix plastic or batteries.',
    recommendation: 'Use the wet waste stream.',
    icon: Icons.eco,
  ),
  WasteGuideEntry(
    title: 'Dry Waste',
    description: 'Clean, non-biodegradable recyclable material.',
    examples: 'Paper, cardboard, clean packaging',
    doText: 'Keep items clean and dry.',
    dontText: 'Do not include food-soiled material.',
    recommendation: 'Send to dry waste collection.',
    icon: Icons.recycling,
  ),
  WasteGuideEntry(
    title: 'Plastic',
    description: 'Plastic items that can be recovered and recycled.',
    examples: 'Bottles, containers, packaging',
    doText: 'Rinse and flatten containers.',
    dontText: 'Do not burn plastic.',
    recommendation: 'Use a verified recycling collection point.',
    icon: Icons.local_drink,
  ),
  WasteGuideEntry(
    title: 'E-Waste',
    description: 'Discarded electronic devices and accessories.',
    examples: 'Phones, chargers, batteries',
    doText: 'Keep batteries separate.',
    dontText: 'Do not put electronics in household bins.',
    recommendation: 'Use a dedicated e-waste center.',
    icon: Icons.devices,
  ),
];
