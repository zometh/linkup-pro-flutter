# Custom Confirmation Dialog

Un dialogue de confirmation moderne, élégant et personnalisable pour Flutter avec des animations fluides.

## ✨ Caractéristiques

- 🎨 Design moderne et élégant
- 🌓 Support du mode sombre et clair
- 🎭 Animations fluides et naturelles
- 🌍 Support de la localisation (i18n)
- 🎯 Plusieurs variantes pré-configurées
- 🔧 Hautement personnalisable
- 📱 Responsive et adaptatif

## 🚀 Utilisation

### 1. Dialogue de base

```dart
final result = await CustomConfirmationDialog.show(
  context: context,
  title: 'Confirmer l\'action',
  message: 'Êtes-vous sûr de vouloir continuer ?',
  confirmText: 'Oui',
  cancelText: 'Non',
);

if (result == true) {
  // L'utilisateur a confirmé
}
```

### 2. Dialogue de suppression (dangereux)

```dart
final result = await CustomConfirmationDialog.showDeleteConfirmation(
  context: context,
  title: 'Supprimer le commentaire',
  message: 'Cette action est irréversible.',
  onConfirm: () {
    // Action de suppression
  },
);
```

### 3. Dialogue d'avertissement

```dart
await CustomConfirmationDialog.showWarningConfirmation(
  context: context,
  title: 'Attention',
  message: 'Cette action peut avoir des conséquences.',
  confirmText: 'Je comprends',
);
```

### 4. Dialogue de succès

```dart
await CustomConfirmationDialog.showSuccessConfirmation(
  context: context,
  title: 'Succès',
  message: 'Vos modifications ont été enregistrées !',
  confirmText: 'Super !',
);
```

### 5. Dialogue d'information

```dart
await CustomConfirmationDialog.showInfoConfirmation(
  context: context,
  title: 'Information',
  message: 'Veuillez lire les informations avant de continuer.',
  confirmText: 'Compris',
);
```

### 6. Dialogue personnalisé

```dart
await CustomConfirmationDialog.show(
  context: context,
  title: 'Dialogue personnalisé',
  message: 'Avec des couleurs et icônes personnalisées.',
  icon: Icons.rocket_launch_rounded,
  iconColor: Colors.purple,
  confirmColor: Colors.purple,
  cancelColor: Colors.grey,
  confirmText: 'Lancer',
  cancelText: 'Pas encore',
);
```

## 📋 Paramètres

### Paramètres obligatoires

| Paramètre | Type | Description |
|-----------|------|-------------|
| `context` | BuildContext | Le contexte du widget |
| `title` | String | Titre du dialogue |
| `message` | String | Message du dialogue |

### Paramètres optionnels

| Paramètre | Type | Description | Défaut |
|-----------|------|-------------|--------|
| `confirmText` | String? | Texte du bouton de confirmation | 'confirm' (traduit) |
| `cancelText` | String? | Texte du bouton d'annulation | 'cancel' (traduit) |
| `onConfirm` | VoidCallback? | Callback lors de la confirmation | null |
| `onCancel` | VoidCallback? | Callback lors de l'annulation | null |
| `confirmColor` | Color? | Couleur du bouton de confirmation | Theme.primaryColor |
| `cancelColor` | Color? | Couleur du bouton d'annulation | Colors.grey |
| `icon` | IconData? | Icône à afficher | null |
| `iconColor` | Color? | Couleur de l'icône | Theme.primaryColor |
| `isDangerous` | bool | Action dangereuse (rouge) | false |

## 🎨 Variantes pré-configurées

### `showDeleteConfirmation`
- Icône : `Icons.delete_outline_rounded`
- Couleur : Rouge (danger)
- Usage : Suppressions

### `showWarningConfirmation`
- Icône : `Icons.warning_amber_rounded`
- Couleur : Orange
- Usage : Avertissements

### `showSuccessConfirmation`
- Icône : `Icons.check_circle_outline_rounded`
- Couleur : Vert
- Usage : Confirmations de succès

### `showInfoConfirmation`
- Icône : `Icons.info_outline_rounded`
- Couleur : Bleu
- Usage : Informations

## 🌍 Traductions

Le dialogue utilise `easy_localization` pour les traductions. Assurez-vous d'avoir les clés suivantes dans vos fichiers de traduction :

- `confirm` : Texte du bouton de confirmation
- `cancel` : Texte du bouton d'annulation
- `delete` : Texte pour les actions de suppression

## 🎭 Animations

Le dialogue inclut plusieurs animations :

1. **Fade in** : Apparition progressive du dialogue
2. **Scale** : Effet de zoom à l'apparition
3. **Slide Y** : Glissement vertical du titre et message
4. **Slide X** : Glissement horizontal des boutons
5. **Elastic bounce** : Rebond élastique de l'icône

## 💡 Exemples d'utilisation

Consultez le fichier `confirmation_dialog_examples.dart` pour plus d'exemples d'utilisation.

## 🎯 Cas d'usage courants

- Confirmation de suppression
- Déconnexion de compte
- Abandon de modifications
- Validation d'actions importantes
- Affichage d'informations critiques
- Alertes et avertissements

## 📝 Notes

- Le dialogue retourne `bool?` : `true` si confirmé, `false` si annulé, `null` si fermé
- Compatible avec le mode sombre et clair
- Animations optimisées pour la performance
- Design responsive sur tous les écrans

