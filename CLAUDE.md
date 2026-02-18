# Claude Code Documentation: article_support_parties_racialized

## Objectif de l'article
Cet article étudie le potentiel de croissance des minorités visibles au Québec/Canada à travers l'analyse des données des études électorales canadiennes de 2019 et 2021. L'objectif est d'analyser les tendances de vote et les attitudes politiques des minorités visibles dans ces deux cycles électoraux.

## Contexte et données utilisées
- **Données**: Études électorales canadiennes (CES) de 2019 et 2021
- **Préparation des données**: Les données seront préparées ici, suivant la même approche que dans le mémoire (téléchargement des données et codebooks, nettoyage)
- **Variables d'intérêt**: 
  - Statut électoral des minorités visibles (vote intention, second choice, rejet)
  - Indicateurs socio-économiques (âge, genre, langue, province)
  - IRC/RCI (indicateur de racialisation/crédibilité institutionnelle) - seul indicurateur utilisé

## Structure du dépôt
- `data/` : Données transformées (modèles, agrégats)
- `data_raw/` : Scripts de préparation et nettoyage des données brutes
- `R/` : Scripts d'analyse (niveau individuel et agrégé)
- `redaction/` : Documents de rédaction (articles, défense, .qmd)
- `figures/` : Graphiques et visualisations

## Workflow de traitement des données
1. **Extraction** : Téléchargement des données CES et codebooks (même approche que dans le mémoire)
2. **Nettoyage** : Scripts de nettoyage pour 2019 et 2021
3. **Fusion** : Fusion des données 2019 et 2021
4. **Analyse** : Scripts d'analyse en R (niveau individuel et agrégé)

## Variables clés pour l'analyse des minorités visibles
- `irc_rci` : Indicateur IRC/RCI (racialisation/crédibilité institutionnelle)
- `id_partisane` : Parti identifié par le répondant
- `second_choice` : Second choix de vote
- `rejet_*` : Variables binaires de rejet (rejet_liberal, rejet_con, etc.)
- `ses_*` : Variables socio-économiques (age, genre, langue, province)
- `statut_electoral_*` : Statut électoral combiné (Vote Intent, Second Choice, Potential, Rejected)

## Analyse des résultats
L'article examine les tendances de vote et de préférence des minorités visibles à travers :
- Analyse de l'IRC/RCI selon les statuts électoraux
- Comparaison des statuts électoraux entre 2019 et 2021
- Analyse des préférences partisanes selon les caractéristiques socio-démographiques
- Identification des groupes à fort potentiel de croissance basé sur l'IRC/RCI

## Notes importantes
- Les données seront préparées ici (téléchargement et nettoyage comme dans le mémoire)
- L'analyse se concentre uniquement sur l'IRC/RCI comme indicateur
- Les analyses doivent être effectuées en tenant compte des pondérations (`weight` variable)
- L'analyse se concentre sur les répondants identifiés comme appartenant à des minorités visibles
- Les variables de rejet sont binaires et capturent toutes les préférences de rejet (multi-sélection)