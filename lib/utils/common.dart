import 'package:flutter/material.dart';

class Palette {
  static const Color white = Color(0xFFEEEEEE);
  static const Color gray = Color(0xFF393E46);
  static const Color semiGray = Color(0xFF2e323d);
  static const Color darkGray = Color(0xFF222831);
  static const Color amber = Color(0xFFD7861A);
  static const Color semiAmber = Color(0xFF755532);
  static const Color semiRed = Color(0xFF844040);
}

final int weeksBehind = 3;
final int weeksAhead = 5;
final DateTime today = DateTime.now();

final List<Map<String, dynamic>> aurionTree = [
  {
    'name': 'Plannings des salles',
    'id': 'submenu_317228',
    'childrens': [
      {'name': 'Salles libres maintenant', 'id': '3_0'},
      {
        'name': 'Brest',
        'id': 'submenu_3995836',
        'childrens': [
          {'name': 'Rez-de-chauss\u00e9e', 'id': '3_1_0'},
          {'name': 'Premier \u00e9tage', 'id': '3_1_1'},
          {'name': 'Deuxi\u00e8me \u00e9tage', 'id': '3_1_2'},
          {'name': 'Troisi\u00e8me \u00e9tage', 'id': '3_1_3'}
        ]
      },
      {'name': 'Caen', 'id': '3_2'},
      {'name': 'Nantes', 'id': '3_3'},
      {'name': 'Rennes', 'id': '3_4'}
    ]
  },
  {
    "name": "Plannings des groupes",
    "id": "submenu_299102",
    "childrens": [
      {
        "name": "Plannings BTS",
        "id": "submenu_1118364",
        "childrens": [
          {"name": "Planning BTS Pr\u00e9pa 1", "id": "2_0_0"},
          {"name": "Planning BTS Pr\u00e9pa 2", "id": "2_0_1"}
        ]
      },
      {
        "name": "Plannings CBIAST",
        "id": "submenu_5415074",
        "childrens": [
          {"name": "Planning CBIAST 1", "id": "2_1_0"},
          {"name": "Planning CBIAST 2", "id": "2_1_1"},
          {"name": "Planning CBIAST 3", "id": "2_1_2"}
        ]
      },
      {
        "name": "Plannings CBIO",
        "id": "submenu_5414109",
        "childrens": [
          {
            "name": "Plannings CBIO Brest",
            "id": "submenu_2349296",
            "childrens": [
              {"name": "Planning CBIO 1", "id": "2_2_0_0"},
              {"name": "Planning CBIO 2", "id": "2_2_0_1"},
              {"name": "Planning CBIO 3", "id": "2_2_0_2"}
            ]
          },
          {
            "name": "Plannings CBIO Caen",
            "id": "submenu_5414112",
            "childrens": [
              {"name": "Planning CBIO 1", "id": "2_2_1_0"},
              {"name": "Planning CBIO 2", "id": "2_2_1_1"},
              {"name": "Planning CBIO 3", "id": "2_2_1_2"}
            ]
          }
        ]
      },
      {
        "name": "Plannings CENT",
        "id": "submenu_2773001",
        "childrens": [
          {"name": "Planning CENT 1", "id": "2_3_0"},
          {"name": "Planning CENT 2", "id": "2_3_1"},
          {"name": "Planning CENT 3", "id": "2_3_2"}
        ]
      },
      {
        "name": "Plannings CEST",
        "id": "submenu_4233612",
        "childrens": [
          {"name": "Planning CEST 1", "id": "2_4_0"},
          {"name": "Planning CEST 2", "id": "2_4_1"},
          {"name": "Planning CEST 3", "id": "2_4_2"}
        ]
      },
      {
        "name": "Plannings CIPA",
        "id": "submenu_300781",
        "childrens": [
          {"name": "Planning CIPA 3", "id": "2_5_0"},
          {"name": "Planning CIPA 4", "id": "2_5_1"},
          {"name": "Planning CIPA 5", "id": "2_5_2"}
        ]
      },
      {
        "name": "Plannings CIR",
        "id": "submenu_299116",
        "childrens": [
          {
            "name": "Plannings CIR Brest",
            "id": "submenu_2853463",
            "childrens": [
              {"name": "Planning CIR 1", "id": "2_6_0_0"},
              {"name": "Planning CIR 2", "id": "2_6_0_1"},
              {"name": "Planning CIR 3", "id": "2_6_0_2"}
            ]
          },
          {
            "name": "Plannings CIR Caen",
            "id": "submenu_5414385",
            "childrens": [
              {"name": "Planning CIR 1", "id": "2_6_1_0"},
              {"name": "Planning CIR 2", "id": "2_6_1_1"},
              {"name": "Planning CIR 3", "id": "2_6_1_2"}
            ]
          },
          {
            "name": "Plannings CIR Nantes",
            "id": "submenu_2853538",
            "childrens": [
              {"name": "Planning CIR 1", "id": "2_6_2_0"},
              {"name": "Planning CIR 2", "id": "2_6_2_1"},
              {"name": "Planning CIR 3", "id": "2_6_2_2"}
            ]
          },
          {
            "name": "Plannings CIR Rennes",
            "id": "submenu_2853541",
            "childrens": [
              {"name": "Planning CIR 1", "id": "2_6_3_0"},
              {"name": "Planning CIR 2", "id": "2_6_3_1"}
            ]
          }
        ]
      },
      {
        "name": "Plannings CSI",
        "id": "submenu_299133",
        "childrens": [
          {
            "name": "Plannings CSI Brest",
            "id": "submenu_2853298",
            "childrens": [
              {"name": "Planning CSI 1", "id": "2_7_0_0"},
              {"name": "Planning CSI 2", "id": "2_7_0_1"},
              {"name": "Planning CSI 3", "id": "2_7_0_2"}
            ]
          },
          {
            "name": "Plannings CSI Caen",
            "id": "submenu_5414552",
            "childrens": [
              {"name": "Planning CSI 1", "id": "2_7_1_0"},
              {"name": "Planning CSI 2", "id": "2_7_1_1"},
              {"name": "Planning CSI 3", "id": "2_7_1_2"}
            ]
          },
          {
            "name": "Plannings CSI Nantes",
            "id": "submenu_2853334",
            "childrens": [
              {"name": "Planning CSI 1", "id": "2_7_2_0"},
              {"name": "Planning CSI 2", "id": "2_7_2_1"},
              {"name": "Planning CSI 3", "id": "2_7_2_2"}
            ]
          }
        ]
      },
      {
        "name": "Plannings Ann\u00e9e 3",
        "id": "submenu_3475756",
        "childrens": [
          {"name": "Planning A3 Brest", "id": "2_8_0"},
          {"name": "Planning A3 Caen", "id": "2_8_1"},
          {"name": "Planning A3 Nantes", "id": "2_8_2"}
        ]
      },
      {
        "name": "Plannings M1",
        "id": "submenu_300813",
        "childrens": [
          {"name": "Planning M1 Brest", "id": "2_9_0"},
          {"name": "Planning M1 Caen", "id": "2_9_1"},
          {"name": "Planning M1 Nantes", "id": "2_9_2"}
        ]
      },
      {
        "name": "Plannings M2",
        "id": "submenu_5414780",
        "childrens": [
          {"name": "Planning M2 Brest", "id": "2_10_0"},
          {"name": "Planning M2 Caen", "id": "2_10_1"},
          {"name": "Planning M2 Nantes", "id": "2_10_2"}
        ]
      },
      {
        "name": "Plannings code.bzh",
        "id": "submenu_2786327",
        "childrens": [
          {"name": "Planning code.bzh", "id": "2_11_0"}
        ]
      }
    ]
  }
];
