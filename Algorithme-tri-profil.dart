// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> mettreAJourScores(
  String villeRecherchee,
  String metierRecherche,
  String contratRecherche,
  String tempsTravailRecherche,
  List<String> competencesProRecherchees,
  List<String> competencesTechRecherchees,
  List<String> competencesLingRecherchees,
  List<String> competencesHumRecherchees,
  List<DocumentReference> userDocumentReferences,
) async {
  for (final ref in userDocumentReferences) {
    final userSnapshot = await ref.get();

    if (userSnapshot.exists) {
      final userData = userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null) {
        double score = 0;

        print('--- Calcul du score pour utilisateur ${ref.id} ---');
        print('Données utilisateur : $userData');

        // Ville (50%)
        final utilisateurVille =
            userData['ville_recherche']?.toString().trim().toLowerCase();
        final critereVille = villeRecherchee.trim().toLowerCase();
        if (utilisateurVille == critereVille) {
          score += 50;
          print('Ville correspondante, +50');
        } else {
          print(
              'Ville non correspondante : utilisateur ($utilisateurVille), critère ($critereVille)');
        }

        // Métier (20%)
        final utilisateurMetier =
            userData['poste_recherche']?.toString().trim().toLowerCase();
        final critereMetier = metierRecherche.trim().toLowerCase();
        if (utilisateurMetier == critereMetier) {
          score += 20;
          print('Métier correspondant, +20');
        } else {
          print(
              'Métier non correspondant : utilisateur ($utilisateurMetier), critère ($critereMetier)');
        }

        // Contrat de travail (5%)
        final utilisateurContrat =
            userData['type_contrat']?.toString().trim().toLowerCase();
        final critereContrat = contratRecherche.trim().toLowerCase();
        if (utilisateurContrat == critereContrat) {
          score += 5;
          print('Contrat correspondant, +5');
        } else {
          print(
              'Contrat non correspondant : utilisateur ($utilisateurContrat), critère ($critereContrat)');
        }

        // Temps de travail (5%)
        final utilisateurTempsTravail =
            userData['temps_travail']?.toString().trim().toLowerCase();
        final critereTempsTravail = tempsTravailRecherche.trim().toLowerCase();
        if (utilisateurTempsTravail == critereTempsTravail) {
          score += 5;
          print('Temps de travail correspondant, +5');
        } else {
          print(
              'Temps de travail non correspondant : utilisateur ($utilisateurTempsTravail), critère ($critereTempsTravail)');
        }

        // Compétences professionnelles (5%)
        final proMatch = (userData['competences_pro'] ?? [])
            .where((c) => competencesProRecherchees.contains(c))
            .length
            .clamp(0, 5)
            .toDouble();
        score += proMatch;
        print('Compétences professionnelles correspondantes, +$proMatch');

        // Compétences techniques (5%)
        final techMatch = (userData['competences_tech'] ?? [])
            .where((c) => competencesTechRecherchees.contains(c))
            .length
            .clamp(0, 5)
            .toDouble();
        score += techMatch;
        print('Compétences techniques correspondantes, +$techMatch');

        // Compétences linguistiques (5%)
        final lingMatch = (userData['competences_linguistiques'] ?? [])
            .where((c) => competencesLingRecherchees.contains(c))
            .length
            .clamp(0, 5)
            .toDouble();
        score += lingMatch;
        print('Compétences linguistiques correspondantes, +$lingMatch');

        // Compétences humaines (5%)
        final humMatch = (userData['competences_humaines'] ?? [])
            .where((c) => competencesHumRecherchees.contains(c))
            .length
            .clamp(0, 5)
            .toDouble();
        score += humMatch;
        print('Compétences humaines correspondantes, +$humMatch');

        print('Score total pour ${ref.id} : $score');

        // Mettre à jour le document utilisateur avec le score calculé
        await ref.update({'score': score});
        print('Score mis à jour pour ${ref.id}');
      } else {
        print('Aucune donnée utilisateur pour ${ref.id}');
      }
    } else {
      print('Document introuvable pour ${ref.id}');
    }
  }
}
