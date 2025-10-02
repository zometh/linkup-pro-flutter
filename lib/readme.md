lib/
├── core/                       # Code partagé par toutes les fonctionnalités
│   ├── usecases/               # Cas d'utilisation de base (ex: UseCase<Type, Params>)
│   ├── error/                  # Gestion des erreurs (Failures, Exceptions)
│   ├── network/                # Client HTTP, gestion de la connexion
│   ├── theme/                  # Thème de l'application
│   └── utils/                  # Classes utilitaires
│
├── features/                   # Dossier principal contenant toutes les fonctionnalités
│
│   ├── 1_authentication/       # Fonctionnalité d'authentification
│   │   ├── data/
│   │   │   ├── datasources/    # Appel API pour login, register...
│   │   │   ├── models/         # UserModel, AuthTokenModel
│   │   │   └── repositories/   # AuthRepositoryImpl
│   │   ├── domain/
│   │   │   ├── entities/       # User
│   │   │   ├── repositories/   # AuthRepository (contrat)
│   │   │   └── usecases/       # LoginUseCase, LogoutUseCase
│   │   └── presentation/
│   │       ├── bloc/           # AuthBloc, LoginState, LoginEvent
│   │       └── pages/          # LoginPage, RegisterPage
│
│   ├── 2_feed/                 # Fonctionnalité du fil d'actualité
│   │   ├── data/
│   │   │   ├── datasources/    # API pour récupérer les posts, liker...
│   │   │   ├── models/         # PostModel, CommentModel
│   │   │   └── repositories/   # FeedRepositoryImpl
│   │   ├── domain/
│   │   │   ├── entities/       # Post, Comment
│   │   │   ├── repositories/   # FeedRepository (contrat)
│   │   │   └── usecases/       # GetFeedPostsUseCase, CreatePostUseCase
│   │   └── presentation/
│   │       ├── bloc/           # FeedBloc
│   │       ├── pages/          # FeedPage
│   │       └── widgets/        # PostCardWidget, CommentWidget
│
│   ├── 3_profile/              # Fonctionnalité du profil utilisateur
│   │   └── ... (même structure)
│
│   ├── 4_messaging/            # Fonctionnalité de messagerie
│   │   └── ... (même structure)
│
└── main.dart                   # Point d'entrée, injection de dépendances