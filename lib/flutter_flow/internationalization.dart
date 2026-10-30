import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = '__locale_key__';

class FFLocalizations {
  FFLocalizations(this.locale);

  final Locale locale;

  static FFLocalizations of(BuildContext context) =>
      Localizations.of<FFLocalizations>(context, FFLocalizations)!;

  static List<String> languages() => ['en', 'fr'];

  static late SharedPreferences _prefs;
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static Future storeLocale(String locale) =>
      _prefs.setString(_kLocaleStorageKey, locale);
  static Locale? getStoredLocale() {
    final locale = _prefs.getString(_kLocaleStorageKey);
    return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  }

  String get languageCode => locale.toString();
  String? get languageShortCode =>
      _languagesWithShortCode.contains(locale.toString())
          ? '${locale.toString()}_short'
          : null;
  int get languageIndex => languages().contains(languageCode)
      ? languages().indexOf(languageCode)
      : 0;

  String getText(String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? '';

  String getVariableText({
    String? enText = '',
    String? frText = '',
  }) =>
      [enText, frText][languageIndex] ?? '';

  static const Set<String> _languagesWithShortCode = {
    'ar',
    'az',
    'ca',
    'cs',
    'da',
    'de',
    'dv',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'gr',
    'he',
    'hi',
    'hu',
    'it',
    'km',
    'ku',
    'mn',
    'ms',
    'no',
    'pt',
    'ro',
    'ru',
    'rw',
    'sv',
    'th',
    'uk',
    'vi',
  };
}

/// Used if the locale is not supported by GlobalMaterialLocalizations.
class FallbackMaterialLocalizationDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<MaterialLocalizations> load(Locale locale) async =>
      SynchronousFuture<MaterialLocalizations>(
        const DefaultMaterialLocalizations(),
      );

  @override
  bool shouldReload(FallbackMaterialLocalizationDelegate old) => false;
}

/// Used if the locale is not supported by GlobalCupertinoLocalizations.
class FallbackCupertinoLocalizationDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      SynchronousFuture<CupertinoLocalizations>(
        const DefaultCupertinoLocalizations(),
      );

  @override
  bool shouldReload(FallbackCupertinoLocalizationDelegate old) => false;
}

class FFLocalizationsDelegate extends LocalizationsDelegate<FFLocalizations> {
  const FFLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<FFLocalizations> load(Locale locale) =>
      SynchronousFuture<FFLocalizations>(FFLocalizations(locale));

  @override
  bool shouldReload(FFLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains('_')
    ? Locale.fromSubtags(
        languageCode: language.split('_').first,
        scriptCode: language.split('_').last,
      )
    : Locale(language);

bool _isSupportedLocale(Locale locale) {
  final language = locale.toString();
  return FFLocalizations.languages().contains(
    language.endsWith('_')
        ? language.substring(0, language.length - 1)
        : language,
  );
}

final kTranslationsMap = <Map<String, Map<String, String>>>[
  // HomePage
  {
    'ai7ralmk': {
      'en': 'Search by name, product, or location',
      'fr': 'Recherche par nom, produit ou lieu',
    },
    'yakvvh3d': {
      'en': 'Top Products',
      'fr': 'Meilleurs produits',
    },
    'j7kg3yv5': {
      'en': 'See all',
      'fr': 'Voir tout',
    },
    'g86cwtgu': {
      'en': 'Along your route',
      'fr': 'Sur votre route',
    },
    '44rmwyod': {
      'en': 'See all',
      'fr': 'Voir tout',
    },
    '8ibn3dj9': {
      'en': 'Seasonal',
      'fr': 'Saisonnier',
    },
    'pft5izs9': {
      'en': 'See all',
      'fr': 'Voir tout',
    },
    'kojq9uo0': {
      'en': 'Top farms',
      'fr': 'Les meilleures fermes',
    },
    '5f6b4yqe': {
      'en': 'See all',
      'fr': 'Voir tout',
    },
    'jmns9akw': {
      'en': 'View Farm',
      'fr': 'Voir la ferme',
    },
    '7g50i7li': {
      'en': 'Favourites',
      'fr': 'Favoris',
    },
    'o9n809eh': {
      'en': 'See all',
      'fr': 'Voir tout',
    },
    'g74xgfoy': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // splashpage
  {
    'xgg3k977': {
      'en': 'Agricoo',
      'fr': 'Agricoo',
    },
    'd6tq0uto': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // Onbording
  {
    'ndho1cpl': {
      'en': 'Welcome to Agricou 🌾',
      'fr': 'Bienvenue chez Agricoo 🌾',
    },
    'j38olewa': {
      'en':
          'Local food, straight from the source. Discover nearby farmers and buy directly from local producers.',
      'fr':
          'Les produits locaux, directement à la source. Découvrez les producteurs près de chez vous et achetez directement auprès d’eux.',
    },
    '8lz5af46': {
      'en': 'Next',
      'fr': 'Suivant',
    },
    'ybl7bnnq': {
      'en': 'Skip',
      'fr': 'Passer',
    },
    '7vkiupws': {
      'en': 'Local food, along your way.',
      'fr': 'Les producteurs locaux sur votre trajet.',
    },
    'z0gzhjd0': {
      'en':
          'Find local producers along your route and plan a convenient pickup.',
      'fr':
          'Trouvez des producteurs sur votre itinéraire et prévoyez facilement votre retrait.',
    },
    'put8qk9w': {
      'en': 'Next',
      'fr': 'Suivant',
    },
    'te3zhikt': {
      'en': 'Skip',
      'fr': 'Passer',
    },
    '8rv94tkq': {
      'en': 'Order local. Pick up simply.',
      'fr': 'Commandez local. Récupérez simplement.',
    },
    '942j4dl9': {
      'en':
          'Order ahead and collect fresh products directly from the producer.',
      'fr':
          'Commandez à l\'avance et récupérez vos produits directement auprès du producteur.',
    },
    '31fx1hfx': {
      'en': 'Get Started',
      'fr': 'Commencer',
    },
    '9b592wxo': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // loginpage
  {
    'el1kub40': {
      'en': 'Welcome back!',
      'fr': 'Ravi de vous revoir!',
    },
    'pzjblwwk': {
      'en': 'Sign in to continue to Agricou',
      'fr': 'Connectez-vous pour continuer sur Agricou',
    },
    'i5bd4qy4': {
      'en': 'Email',
      'fr': 'E-mail',
    },
    '6c465cxn': {
      'en': 'Enter your email',
      'fr': 'Saisissez votre adresse e-mail',
    },
    'rrcz7bnv': {
      'en': 'Password',
      'fr': 'Mot de passe',
    },
    '059fmzt2': {
      'en': 'Enter your password',
      'fr': 'Saisissez votre mot de passe',
    },
    'ugmrooc5': {
      'en': 'Forgot your password?',
      'fr': 'Mot de passe oublié ?',
    },
    'h4uslu6u': {
      'en': 'Log In',
      'fr': 'Se connecter',
    },
    'bzhe5pg9': {
      'en': 'or',
      'fr': 'ou',
    },
    '7zc13uda': {
      'en': 'Continue with Google',
      'fr': 'Continuer avec Google',
    },
    'gjucs0x4': {
      'en': 'Continue with Apple',
      'fr': 'Continuez avec Apple',
    },
    'nu2wy22o': {
      'en': 'New to Agricou?  Create an account: ',
      'fr': 'Nouveau ici ?',
    },
    'nl23q85j': {
      'en': ' Sign up',
      'fr': 'S\'inscrire',
    },
    'wewuy5ft': {
      'en': 'Enter your email is required',
      'fr': 'Votre adresse e-mail est obligatoire.',
    },
    '689uxfo0': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    '54j5pwa4': {
      'en': 'Create a password is required',
      'fr': 'La création d\'un mot de passe est requise.',
    },
    'uflqtkm6': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    '5zpskwnf': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // Forgotpassword
  {
    'f77qv1u9': {
      'en': 'Forgot your password?',
      'fr': 'Mot de passe oublié ?',
    },
    'oyzvcgad': {
      'en': 'No worries - we\'ll send you a reset link',
      'fr': 'Pas de souci, nous vous enverrons un lien de réinitialisation',
    },
    'lzqc62l5': {
      'en': 'Email',
      'fr': 'E-mail',
    },
    '4zq3ml8p': {
      'en': 'Enter your email',
      'fr': 'Saisissez votre adresse e-mail',
    },
    '0nl21nxl': {
      'en': 'Send Reset Link',
      'fr': 'Envoyer le lien de réinitialisation',
    },
    't5jum9fp': {
      'en': 'Back to Login',
      'fr': 'Retour à la connexion',
    },
    'j7dftwxk': {
      'en': 'If your email is registered, you’ll get instructions shortly.',
      'fr':
          'Si votre adresse e-mail est enregistrée, vous recevrez prochainement des instructions.',
    },
    'sx748th4': {
      'en': 'Enter your email is required',
      'fr': 'Votre adresse e-mail est obligatoire.',
    },
    'pi7lkci2': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'ucjt162w': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // checkyourEmail
  {
    'r397bd1a': {
      'en': 'Check your email',
      'fr': 'Consultez votre boîte mail',
    },
    'y3mseoxl': {
      'en':
          'We\'ve sent you a verification link. Please check your inbox and verify your email address to activate your account.',
      'fr':
          'Si votre adresse e-mail est enregistrée, vous recevrez prochainement des instructions.',
    },
    'trizwxkr': {
      'en': 'I\'ve verified my email',
      'fr': 'D\'accord',
    },
    'wpb4tvrs': {
      'en': 'Resend verification email',
      'fr': 'D\'accord',
    },
    '6saq6qmz': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // Register
  {
    'tjizdcdv': {
      'en': 'Create your account',
      'fr': 'Créez votre compte',
    },
    'j834jood': {
      'en': 'Join the community connecting you directly with farmers near you.',
      'fr':
          'Rejoignez la communauté qui vous met directement en relation avec les agriculteurs près de chez vous.',
    },
    'ka4ky6uj': {
      'en': 'Name',
      'fr': 'Nom',
    },
    'dvc1klds': {
      'en': 'Enter your name',
      'fr': 'Entrez votre nom',
    },
    '2jvfzfuh': {
      'en': 'Email',
      'fr': 'E-mail',
    },
    '4vw9beux': {
      'en': 'Enter your email',
      'fr': 'Saisissez votre adresse e-mail',
    },
    '6b1agvqm': {
      'en': 'Password',
      'fr': 'Mot de passe',
    },
    '71p239jw': {
      'en': 'Create a password',
      'fr': 'Créer un mot de passe',
    },
    'at4ghctt': {
      'en': 'I agree to the ',
      'fr': 'En vous inscrivant, vous acceptez nos conditions générales.',
    },
    'z5wvjph6': {
      'en': 'Terms of Service ',
      'fr': 'Conditions d\'utilisation',
    },
    '8cltzvvs': {
      'en': 'and acknowledge the       ',
      'fr': 'et',
    },
    'imfcex6y': {
      'en': 'Privacy Policy',
      'fr': 'politique de confidentialité',
    },
    'a6ge6hnw': {
      'en': 'I agree to the Producer ',
      'fr': 'En vous inscrivant, vous acceptez nos conditions générales.',
    },
    'c0sw16yx': {
      'en': 'Terms & Conditions ',
      'fr': 'Conditions d\'utilisation',
    },
    '814e9mi2': {
      'en': 'Create Account',
      'fr': 'Créer un compte',
    },
    'tajxrixc': {
      'en': 'or',
      'fr': 'ou',
    },
    'b9w79jln': {
      'en': 'Continue with Google',
      'fr': 'Continuer avec Google',
    },
    'vylx6je9': {
      'en': 'Continue with Apple',
      'fr': 'Continuez avec Apple',
    },
    'xs5ihn0a': {
      'en': 'Already have an account?  ',
      'fr': 'Vous avez déjà un compte ?',
    },
    'dj7qza6d': {
      'en': ' Log in',
      'fr': 'Se connecter',
    },
    'c3zzori7': {
      'en': 'Enter your name is required',
      'fr': 'Votre nom est obligatoire.',
    },
    'q4m3430o': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    '4ztqsju2': {
      'en': 'Enter your email is required',
      'fr': 'Votre adresse e-mail est obligatoire.',
    },
    '6mg43hd8': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'qm7707nt': {
      'en': 'Create a password is required',
      'fr': 'La création d\'un mot de passe est requise.',
    },
    'yyfhq8tj': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    '3628n14r': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // selectOption
  {
    'jrib75qm': {
      'en': 'How would you like to use Agricou?',
      'fr': 'Comment souhaitez-vous utiliser Agricou ?',
    },
    '8obceyd2': {
      'en': 'I’m a Producer',
      'fr': 'Je suis producteur',
    },
    '69q3mcea': {
      'en': 'Sell my products directly to local customers',
      'fr': 'Vendez vos produits directement aux consommateurs',
    },
    'rg18qlw1': {
      'en': 'I’m a Consumer',
      'fr': 'Je suis un consommateur',
    },
    'kblruoqb': {
      'en': 'Discover local products and buy directly from producers',
      'fr':
          'Découvrez des produits locaux et achetez directement aux producteurs',
    },
    'axjq2n4u': {
      'en': 'Continue',
      'fr': 'Continuer',
    },
    'hnkfyo1q': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // Search
  {
    'bfjdr7fv': {
      'en': 'Organic',
      'fr': 'Organique',
    },
    'xgvykmi1': {
      'en': '4.5 km • 0.2 lbs CO₂ saved',
      'fr': '4,5 km • 0,2 lb de CO₂ économisé',
    },
    '6tap2z6j': {
      'en': '\$',
      'fr': '\$',
    },
    's8ddl1xo': {
      'en': '€',
      'fr': '€',
    },
    'lm0l39pj': {
      'en': 'No results found',
      'fr': 'Aucun résultat trouvé',
    },
    '2um6qye6': {
      'en': 'We couldn’t find any products or farms matching your search.',
      'fr':
          'Nous n\'avons trouvé aucun produit ni aucune ferme correspondant à votre recherche.',
    },
    'ibnhfn3k': {
      'en': '\$',
      'fr': '\$',
    },
    'lewy73tn': {
      'en': '€',
      'fr': '€',
    },
    'vl18nyun': {
      'en': 'View Cart',
      'fr': 'Voir le panier',
    },
    '8bztsxby': {
      'en': 'Filter',
      'fr': 'Filtre',
    },
    'm7s1itx8': {
      'en': 'Price',
      'fr': 'Prix',
    },
    'h40w3yzl': {
      'en': '',
      'fr': '',
    },
    '02q8t09p': {
      'en': 'Availability',
      'fr': 'Disponibilité',
    },
    'zolwh4zo': {
      'en': '',
      'fr': '',
    },
    'a6eocfcr': {
      'en': 'tags',
      'fr': 'étiquettes',
    },
    'ffd86frp': {
      'en': '',
      'fr': '',
    },
    'hlgdox8f': {
      'en': 'Farming Method',
      'fr': 'Méthode agricole',
    },
    '02iosxhh': {
      'en': '',
      'fr': '',
    },
    'mhg6tb4c': {
      'en': 'Update',
      'fr': 'Mise à jour',
    },
    'uk8c0xb8': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // productDetailsPage
  {
    '5ouuribn': {
      'en': '\$',
      'fr': '\$',
    },
    'fiyl4ap3': {
      'en': '€',
      'fr': '€',
    },
    'jd8jdtqu': {
      'en': 'Choose a weight bracket',
      'fr': '',
    },
    '712ejhno': {
      'en': 'Live Pricing Breakdown',
      'fr': '',
    },
    'zyb0xsv9': {
      'en': 'Origin:',
      'fr': 'Origine:',
    },
    '0uh9fa9q': {
      'en': 'Season:',
      'fr': 'Saison:',
    },
    'fn9xpy3g': {
      'en': 'Storage:',
      'fr': 'Stockage:',
    },
    'cych588f': {
      'en': 'Preparation:',
      'fr': 'Préparation:',
    },
    'csulp82c': {
      'en': 'Same day',
      'fr': 'Le même jour',
    },
    't3jgia1b': {
      'en': 'Stock:',
      'fr': 'Action:',
    },
    '5acsopa9': {
      'en': 'Contact',
      'fr': 'Contact',
    },
    '4swbd93p': {
      'en': 'Batch Information',
      'fr': 'Informations sur le lot',
    },
    'qsjjip25': {
      'en': 'Out of Stock',
      'fr': 'En rupture de stock',
    },
    '8yc8uohd': {
      'en': '\$',
      'fr': '\$',
    },
    'dsjj3mae': {
      'en': '€',
      'fr': '€',
    },
    'gqb8j1wj': {
      'en': 'View Cart',
      'fr': 'Voir le panier',
    },
    '0lhe9opr': {
      'en': 'Products from this farm are currently not available for purchase.',
      'fr':
          'Les produits de cette ferme ne sont actuellement pas disponibles à la vente.',
    },
    'ba09438r': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // mapsPage
  {
    'rr00dlwj': {
      'en': '4.9 (420 reviews)',
      'fr': '4,9 (420 avis)',
    },
    'zrhss0np': {
      'en': 'View Farm',
      'fr': 'Voir la ferme',
    },
    'bfxwlnqy': {
      'en': 'Filter',
      'fr': 'Filtre',
    },
    'ewx8lnpj': {
      'en': 'Category',
      'fr': 'Catégorie',
    },
    'ljz9duiw': {
      'en': '',
      'fr': '',
    },
    'd80mlaf0': {
      'en': 'Farming Method',
      'fr': 'Méthode agricole',
    },
    'equqxv1v': {
      'en': '',
      'fr': '',
    },
    'wgfanzui': {
      'en': 'Update',
      'fr': 'Mise à jour',
    },
    'u744b50l': {
      'en': 'Map',
      'fr': 'Panier',
    },
  },
  // farmProfile
  {
    '4o5tn889': {
      'en': 'Organic',
      'fr': 'Organique',
    },
    'f868d1rp': {
      'en': 'Farm Availability Hours',
      'fr': 'Heures d\'ouverture de la ferme',
    },
    '8mfchhko': {
      'en': 'Break',
      'fr': 'Du lundi au vendredi',
    },
    '28obpcaq': {
      'en': 'Contact',
      'fr': 'Contact',
    },
    '83x1gouv': {
      'en': 'Products',
      'fr': 'Produits',
    },
    '484l3dx2': {
      'en': 'About',
      'fr': 'À propos',
    },
    'yissxlww': {
      'en': 'Reviews',
      'fr': 'Avis',
    },
    'yiexbrf5': {
      'en': 'Free delivery from  ',
      'fr': 'Livraison gratuite depuis',
    },
    'q1328y1k': {
      'en': 'Farming Methods',
      'fr': 'Méthodes agricoles',
    },
    '4wsdq54i': {
      'en': 'Location',
      'fr': 'Emplacement',
    },
    'gz1kip71': {
      'en': 'Farm Pickup',
      'fr': 'Ramassage agricole',
    },
    'acn2ejpb': {
      'en': 'Collect directly from our barn shop',
      'fr': 'À retirer directement dans notre boutique à la grange',
    },
    'fe2puti0': {
      'en': 'Free',
      'fr': 'Gratuit',
    },
    'g2l2qx4n': {
      'en': 'Farm Delivery',
      'fr': 'Livraison à la ferme',
    },
    'xscy18qu': {
      'en': 'Delivery offered by the farm',
      'fr': 'Livraison proposée par la ferme',
    },
    'ltho0dim': {
      'en': 'delivery price:',
      'fr': 'prix de livraison :',
    },
    'skf297bu': {
      'en': 'Charges',
      'fr': 'Frais',
    },
    '11hlg9ql': {
      'en': '4.5 km • 0.2 lbs CO₂ saved',
      'fr': '4,5 km • 0,2 lb de CO₂ économisé',
    },
    'pc1nv7wn': {
      'en': 'Products from this farm are currently not available for purchase.',
      'fr':
          'Les produits de cette ferme ne sont actuellement pas disponibles à la vente.',
    },
    'q6429qyq': {
      'en': 'Harvest Schedule',
      'fr': 'Calendrier des récoltes',
    },
    'bgbmp9ro': {
      'en': 'Planted',
      'fr': 'Planté',
    },
    'rzbrcg65': {
      'en': 'Expected Harvest',
      'fr': 'Récolte prévue',
    },
    'j6hmxtui': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // chat
  {
    '9urz99lx': {
      'en': 'Messages',
      'fr': 'Messages',
    },
    'wk4s4dka': {
      'en': 'No conversations yet with any farmer',
      'fr': 'Aucune conversation pour l\'instant avec un agriculteur.',
    },
    'wes2l6jv': {
      'en':
          'Once you message a farm or place an order, your conversations will appear here.',
      'fr':
          'Une fois que vous aurez envoyé un message à une ferme ou passé une commande, vos conversations apparaîtront ici.',
    },
    'x18e63lx': {
      'en': 'Chat',
      'fr': 'Chat',
    },
  },
  // ChatConversation
  {
    '3egh5hin': {
      'en': 'Type your message...',
      'fr': 'Saisissez votre message...',
    },
    'qrq0zi5j': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // cart
  {
    '8pvkkii6': {
      'en': 'My Cart',
      'fr': 'Mon panier',
    },
    'jvfj1dxd': {
      'en': '\$',
      'fr': '\$',
    },
    '7fnli8rb': {
      'en': '€',
      'fr': '€',
    },
    '5z0w3e4n': {
      'en': 'Keep shopping',
      'fr': 'Continuez vos achats',
    },
    '12kd80r7': {
      'en': 'Voucher code',
      'fr': 'Code de réduction',
    },
    'w6raf6jr': {
      'en': 'Apply a voucher',
      'fr': 'Utiliser un bon d\'achat',
    },
    'v42f8c2h': {
      'en': 'Add a note (optional)',
      'fr': 'Ajouter une note (facultatif)',
    },
    'hu7eoscx': {
      'en': 'Add instructions',
      'fr': 'Ajouter des instructions',
    },
    'pn0y3wya': {
      'en': 'Order Summary',
      'fr': 'Résumé de la commande',
    },
    '3h0zszq6': {
      'en': 'Subtotal',
      'fr': 'Total',
    },
    's5upk5ku': {
      'en': 'Service Fee',
      'fr': 'Frais de service',
    },
    'x4hwy2qo': {
      'en': '\$1.20',
      'fr': '1,20 \$',
    },
    'cseix1nk': {
      'en': 'Driver Tip',
      'fr': 'Conseils aux conducteurs',
    },
    't7hdymy5': {
      'en': 'Add tip',
      'fr': 'Ajouter un pourboire',
    },
    '9mu92j0t': {
      'en': 'Enter Tip Ammount',
      'fr': 'Saisissez le montant du pourboire',
    },
    '5b1o6kg3': {
      'en': 'Delivery Fee',
      'fr': 'Frais de livraison',
    },
    'a4k6bgyv': {
      'en': '\$2.00',
      'fr': '2,00 \$',
    },
    'h1iky0sz': {
      'en': 'Taxes',
      'fr': 'Impôts',
    },
    'qymt3ngb': {
      'en': '\$1.10',
      'fr': '1,10 \$',
    },
    'q0pku5c5': {
      'en': 'Subtotal',
      'fr': 'Payer',
    },
    '9ghizzdt': {
      'en': '\$',
      'fr': '\$',
    },
    's066btzn': {
      'en': '€',
      'fr': '€',
    },
    'bdy251bd': {
      'en': 'To Platform Fees',
      'fr': 'Frais de plateforme',
    },
    'wf3w6fs7': {
      'en': '\$',
      'fr': '\$',
    },
    'o7f6q430': {
      'en': '€',
      'fr': '€',
    },
    'gzo8m73f': {
      'en': 'Total',
      'fr': 'Total',
    },
    '3yo2vzji': {
      'en': '\$',
      'fr': '\$',
    },
    'zl1uuu9z': {
      'en': '€',
      'fr': '€',
    },
    '0q5sepfa': {
      'en': 'cart',
      'fr': 'chariot',
    },
  },
  // checkout
  {
    'lu0p7nns': {
      'en': 'Delivery Method',
      'fr': 'Méthode de livraison',
    },
    'k3ndusuh': {
      'en': 'Farm Pickup',
      'fr': 'Ramassage agricole',
    },
    '7xls1wha': {
      'en': 'Pick up directly',
      'fr': 'Retrait direct',
    },
    '9vc5t66t': {
      'en': 'Free',
      'fr': 'Gratuit',
    },
    'wnwpccca': {
      'en': 'Farm Delivery',
      'fr': 'Livraison à la ferme',
    },
    'q9iypyxk': {
      'en': 'Delivered by the Farm directly',
      'fr': 'Livré directement par la ferme',
    },
    'wlmmuenv': {
      'en': 'Charges',
      'fr': 'Frais',
    },
    'fw9wspbp': {
      'en': 'Agricoo delivery',
      'fr': 'Livraison par Agricou',
    },
    'nrvkre0y': {
      'en': 'Delivered by the Uber directly',
      'fr': 'Livré directement par la ferme',
    },
    'wv0pqcfi': {
      'en': 'Charges',
      'fr': 'Frais',
    },
    '7id364xz': {
      'en': 'Delivery Address',
      'fr': 'Adresse de livraison',
    },
    'lztswhnl': {
      'en': 'Full Name',
      'fr': 'Nom et prénom',
    },
    'enu74j2w': {
      'en': 'Enter your Name',
      'fr': 'Entrez votre nom',
    },
    'quj18qj6': {
      'en': 'Street Address',
      'fr': 'Adresse de la rue',
    },
    'ifh4n7vn': {
      'en': 'Enter Street Address',
      'fr': 'Saisissez l\'adresse de la rue',
    },
    'p413qawq': {
      'en': 'Phone Number',
      'fr': 'Numéro de téléphone',
    },
    'arz57nh8': {
      'en': 'Enter Phone Number',
      'fr': 'Saisissez le numéro de téléphone',
    },
    'oshzyp78': {
      'en': 'change address',
      'fr': 'changer d\'adresse',
    },
    'dmgoukdz': {
      'en': 'Add address',
      'fr': 'Ajouter une adresse',
    },
    '98lfe7qd': {
      'en': 'Continue',
      'fr': 'Continuer',
    },
    '8wt9y803': {
      'en': 'Bill Details',
      'fr': 'Détails de la facture',
    },
    '5qs1gck7': {
      'en': 'To Pay',
      'fr': 'Payer',
    },
    'bkj5vxmz': {
      'en': 'To Platform Fees',
      'fr': 'Frais de plateforme',
    },
    'ri8vndzg': {
      'en': '\$',
      'fr': '\$',
    },
    'h5e60vik': {
      'en': '€',
      'fr': '€',
    },
    'bgdlmlmp': {
      'en': 'Delivery Fees',
      'fr': 'Frais de livraison',
    },
    '91x7pldz': {
      'en': '\$',
      'fr': '\$',
    },
    'pc28s6lo': {
      'en': '€',
      'fr': '€',
    },
    'vep8y23n': {
      'en': 'Delivery Partner Fee',
      'fr': 'Frais du partenaire de livraison',
    },
    'so6mqfbx': {
      'en': '\$2.00',
      'fr': '2,00 \$',
    },
    's3p4ae0h': {
      'en': 'GST and Charges',
      'fr': 'TPS et frais',
    },
    'vzdqkqwk': {
      'en': '\$1.10',
      'fr': '1,10 \$',
    },
    'ld0mqmw0': {
      'en': 'Total Pay',
      'fr': 'Rémunération totale',
    },
    'h1ary2hl': {
      'en': '\$',
      'fr': '\$',
    },
    'zu5b0qqc': {
      'en': '€',
      'fr': '€',
    },
    'dgltazmy': {
      'en': 'Pay',
      'fr': 'Payer',
    },
    'fpaalzml': {
      'en': 'Checkout',
      'fr': 'Vérifier',
    },
    'thbeibcj': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // checkoutfinal
  {
    'ehmef986': {
      'en': 'Your order is on its way! 🚜',
      'fr': 'Votre commande est en route ! 🚜',
    },
    'vmr7f0f3': {
      'en':
          'Thank you for supporting local farmers. Your fresh produce will be packed and delivered soon.',
      'fr':
          'Merci de soutenir les agriculteurs locaux. Vos produits frais seront emballés et livrés prochainement.',
    },
    'xd1iueca': {
      'en': 'Track Order',
      'fr': 'Suivre la commande',
    },
    '7jhjomr6': {
      'en': 'Continue Shopping',
      'fr': 'Continuer vos achats',
    },
    'adm89jxa': {
      'en': 'Checkout',
      'fr': 'Vérifier',
    },
    '2shd1sjm': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // MyOrders
  {
    'm0s9cjdw': {
      'en': 'Active',
      'fr': 'Actif',
    },
    'u9cnt058': {
      'en': 'Completed',
      'fr': 'Complété',
    },
    '1vs8uomu': {
      'en': '\$',
      'fr': '\$',
    },
    't9xpudyi': {
      'en': '€',
      'fr': '€',
    },
    'shk98rve': {
      'en': 'Click And Collect',
      'fr': 'Cliquez et retirez',
    },
    'fvyonwm8': {
      'en': 'Track Order',
      'fr': 'Suivre la commande',
    },
    'yv61d98f': {
      'en': 'No orders placed yet',
      'fr': 'Aucune commande passée pour le moment',
    },
    'ckc9u651': {
      'en':
          'Your basket is empty! Explore our local farms to find fresh produce and start your first order.',
      'fr':
          'Votre panier est vide ! Explorez nos fermes locales pour trouver des produits frais et passez votre première commande.',
    },
    'f4m90gru': {
      'en': 'Deliverd',
      'fr': 'Livré',
    },
    'p2b0kmpj': {
      'en': 'View Details',
      'fr': 'Voir les détails',
    },
    'caxyg7tu': {
      'en': 'Write a review',
      'fr': 'Rédiger un avis',
    },
    'qwiiqxl8': {
      'en': 'No completed orders',
      'fr': 'Aucune commande finalisée',
    },
    'mvozdhnz': {
      'en':
          'You haven\'t finished any orders yet. Once your current orders are delivered and marked as complete, they will appear here.',
      'fr':
          'Vous n\'avez encore finalisé aucune commande. Une fois vos commandes en cours livrées et marquées comme terminées, elles apparaîtront ici.',
    },
    'y85iv2u6': {
      'en': 'My Orders',
      'fr': 'Mes commandes',
    },
    'r5g4q48h': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // OrderDetails
  {
    'dlr4llma': {
      'en': 'Confirmed',
      'fr': 'Confirmé',
    },
    'n8qavman': {
      'en': 'Preparing',
      'fr': 'Préparation',
    },
    'hdg7fu2w': {
      'en': 'Picked Up',
      'fr': 'Ramassé',
    },
    'bo1qevvv': {
      'en': 'In Transit',
      'fr': 'En transit',
    },
    'ubgps83r': {
      'en': 'Delivered',
      'fr': 'Livré',
    },
    'fa2yv1t4': {
      'en': 'Confirmed',
      'fr': 'Confirmé',
    },
    '1cxhh5t8': {
      'en': 'Preparing',
      'fr': 'Préparation',
    },
    'f8rnp406': {
      'en': 'Picked Up',
      'fr': 'Ramassé',
    },
    'my73fao6': {
      'en': 'Delivered',
      'fr': 'Livré',
    },
    '7kzhwbai': {
      'en': 'Tracking Delivery',
      'fr': 'Suivi de livraison',
    },
    'cq2lwmp3': {
      'en': 'Order Items',
      'fr': 'Articles commandés',
    },
    'f6hqzzn8': {
      'en': '\$',
      'fr': '\$',
    },
    'qig1mrls': {
      'en': '€',
      'fr': '€',
    },
    'qahwkvyu': {
      'en': 'Delivery Information',
      'fr': 'Informations de livraison',
    },
    'dh2j8ubj': {
      'en': 'Name',
      'fr': 'Nom',
    },
    '1z7225d6': {
      'en': 'Address',
      'fr': 'Adresse',
    },
    'wjm1onhk': {
      'en': 'Phone Number',
      'fr': 'Numéro de téléphone',
    },
    'u70c3r2r': {
      'en': 'Delivery Method',
      'fr': 'Méthode de livraison',
    },
    '4sbhs3bg': {
      'en': 'Delivery Method',
      'fr': 'Méthode de livraison',
    },
    'id4kjjz0': {
      'en': 'Bill Details',
      'fr': 'Détails de la facture',
    },
    '7qtwacfa': {
      'en': 'Item Total',
      'fr': 'Total des articles',
    },
    'efa1pknq': {
      'en': 'Handling Fee',
      'fr': 'Frais de traitement',
    },
    '53hdh1pq': {
      'en': '\$1.20',
      'fr': '1,20 \$',
    },
    '7ouyyzp8': {
      'en': 'Delivery Partner Fee',
      'fr': 'Frais du partenaire de livraison',
    },
    'cwvkervx': {
      'en': '\$2.00',
      'fr': '2,00 \$',
    },
    'ofh9l50a': {
      'en': 'GST and Charges',
      'fr': 'TPS et frais',
    },
    'lhu32r6z': {
      'en': '\$1.10',
      'fr': '1,10 \$',
    },
    '7e9ntp0a': {
      'en': 'To Pay',
      'fr': 'Payer',
    },
    's53tf2am': {
      'en': '\$',
      'fr': '\$',
    },
    'wvbbcn92': {
      'en': '€',
      'fr': '€',
    },
    '7lz37nwy': {
      'en': 'Stripe Payment',
      'fr': 'Paiement Stripe',
    },
    'vvpsn1l2': {
      'en': 'Contact',
      'fr': 'Contact',
    },
    'xz7u0066': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // Myfavorites
  {
    'zll5gg8c': {
      'en': 'Products',
      'fr': 'Produits',
    },
    'ufwhunit': {
      'en': 'Farms',
      'fr': 'Fermes',
    },
    'de7ouydt': {
      'en': 'View Farm',
      'fr': 'Voir la ferme',
    },
    'l5d5u4ux': {
      'en': '\$',
      'fr': '\$',
    },
    '3a3foko5': {
      'en': '€',
      'fr': '€',
    },
    'f8l50fru': {
      'en': 'No favorites yet',
      'fr': 'Pas encore de favoris',
    },
    'ecm4ig0d': {
      'en': 'My Favorites',
      'fr': 'Mes favoris',
    },
    'df08imk4': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // myprofile
  {
    'qtwdqrbe': {
      'en': 'Orders',
      'fr': 'Ordres',
    },
    '7c8nwxbm': {
      'en': 'Favorites',
      'fr': 'Favoris',
    },
    'wipgk8bh': {
      'en': 'Account',
      'fr': 'Compte',
    },
    'dkxf9c2c': {
      'en': 'Personal Information',
      'fr': 'Informations personnelles',
    },
    'zekow2j1': {
      'en': 'Addresses',
      'fr': 'Adresses',
    },
    'hbuv8mcc': {
      'en': 'Ativity',
      'fr': 'Activité',
    },
    'cu3bdwq7': {
      'en': 'My Orders',
      'fr': 'Mes commandes',
    },
    'p3pa04of': {
      'en': 'My Favorites',
      'fr': 'Mes favoris',
    },
    'usl0aaeu': {
      'en': 'My Reviews',
      'fr': 'Mes avis',
    },
    'muln5tga': {
      'en': 'Legal & Privacy',
      'fr': 'Mentions légales et confidentialité',
    },
    '949yp00z': {
      'en': 'Terms & Conditions',
      'fr': 'Conditions générales',
    },
    'szzluiof': {
      'en': 'Help & Support',
      'fr': 'Aide et assistance',
    },
    'e1fndg8d': {
      'en': 'Privacy Policy',
      'fr': 'politique de confidentialité',
    },
    'a81ouo7p': {
      'en': 'Logout',
      'fr': 'Déconnexion',
    },
    '83874wjk': {
      'en': 'Profile',
      'fr': 'Profil',
    },
  },
  // personalInformation
  {
    'ia3d4lzs': {
      'en': 'Personal Information',
      'fr': 'Informations personnelles',
    },
    '18x0n2ye': {
      'en': 'Change Photo',
      'fr': 'Changer de photo',
    },
    'nl511z23': {
      'en': 'Basic Information',
      'fr': 'Informations de base',
    },
    'tce2lm0m': {
      'en': 'Display Name',
      'fr': 'Nom d\'affichage',
    },
    'trr38l48': {
      'en': 'Enter Full Name',
      'fr': 'Veuillez saisir votre nom complet.',
    },
    'pbzd6dkd': {
      'en': 'Email',
      'fr': 'E-mail',
    },
    '6ummy7rs': {
      'en': 'Enter Email',
      'fr': 'Saisissez votre adresse e-mail',
    },
    'rkzape1u': {
      'en': 'Phone Number',
      'fr': 'Numéro de téléphone',
    },
    'uucfe9we': {
      'en': 'Enter Phone Number',
      'fr': 'Saisissez le numéro de téléphone',
    },
    'bgde74p2': {
      'en': 'Preferences',
      'fr': 'Préférences',
    },
    'sw58bijr': {
      'en': 'Language',
      'fr': 'Langue',
    },
    'dgs370xe': {
      'en': 'Update Profile',
      'fr': 'Mettre à jour le profil',
    },
    'ql0mout0': {
      'en': 'Delete Account',
      'fr': 'Supprimer le compte',
    },
    'eumcs29k': {
      'en': 'display_name is required',
      'fr': '',
    },
    'gwsbs75t': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'f80zxtn7': {
      'en': 'email is required',
      'fr': '',
    },
    '0ws2vvox': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'rih1sdbx': {
      'en': 'phone_number is required',
      'fr': '',
    },
    'fausi90e': {
      'en': 'Enter Valid Phone Number',
      'fr': 'Veuillez saisir un numéro de téléphone valide.',
    },
    'cfp5kc2w': {
      'en': 'Please choose an option from the dropdown',
      'fr': '',
    },
    'mxa4jkze': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // deliveryAddress
  {
    '9t4i6deq': {
      'en': 'Default',
      'fr': 'Défaut',
    },
    '12maf66w': {
      'en': 'Set as Default',
      'fr': 'Définir comme valeur par défaut',
    },
    'ztuw3xma': {
      'en': 'No delivery address found',
      'fr': 'Adresse de livraison introuvable',
    },
    '46ijuzau': {
      'en': 'Delivery Addresses',
      'fr': 'Adresses de livraison',
    },
    'arg6cgxh': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // MyReviews
  {
    'h9h64fyv': {
      'en': 'No Review Found',
      'fr': 'Aucun avis trouvé',
    },
    'p0n7kvys': {
      'en': 'My Reviews',
      'fr': 'Mes avis',
    },
    '241mu2cz': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // Helpandsupport
  {
    'qrswdlm3': {
      'en': 'Contact Admin',
      'fr': 'Contacter l\'administrateur',
    },
    'y6wmshnc': {
      'en': 'Chat with Admin 💬',
      'fr': 'Discutez avec l\'administrateur 💬',
    },
    '10jg4o6l': {
      'en':
          'Have an issue with your store, product listing, or order? Start a chat with our team.',
      'fr':
          'Vous rencontrez un problème avec votre boutique, votre fiche produit ou votre commande ? Discutez-en avec notre équipe.',
    },
    'mec4v25b': {
      'en': 'Active Conversations',
      'fr': 'Conversations actives',
    },
    'xf5e8cbp': {
      'en': 'Did this Issue resolved',
      'fr': 'Ce problème a-t-il été résolu ?',
    },
    'nbgrb73e': {
      'en': 'YES',
      'fr': 'OUI',
    },
    'vovgj45u': {
      'en': 'Past Conversations',
      'fr': 'Conversations passées',
    },
    'mqtkqaqr': {
      'en': 'Frequently Asked Questions',
      'fr': 'Foire aux questions',
    },
    'sdgmj0i2': {
      'en': 'How do I place an order?',
      'fr': 'Je n\'ai pas reçu cette commande',
    },
    'xomscn2t': {
      'en':
          'Browse products from local farms, select a product, add it to your cart, choose your delivery address, and complete the payment at checkout.',
      'fr':
          'Ma commande est indiquée comme livrée, mais je ne l\'ai pas reçue.',
    },
    'c0xzjh5n': {
      'en': ' ',
      'fr': '',
    },
    'ik8kiqtd': {
      'en': 'Chat with Us',
      'fr': 'Discutez avec nous',
    },
    '8v9x1lkc': {
      'en': 'How can I track my order?',
      'fr': 'La portion de ce(s) produit(s) n\'est pas adéquate',
    },
    'zr68v6mv': {
      'en': ' ',
      'fr': '',
    },
    'c4iupjd0': {
      'en':
          'Open My Orders from your profile and select the order to view its current status and details.',
      'fr': 'Bonjour le monde',
    },
    'p8leytn3': {
      'en': 'What should I do if my order is missing or marked as delivered?',
      'fr': 'Signaler un incident de sécurité',
    },
    'uitbpgyh': {
      'en': ' ',
      'fr': '',
    },
    '663btxao': {
      'en':
          'Check your delivery location and contact details first. If you still cannot find the order, contact Agricoo support with your order number.',
      'fr': 'Bonjour le monde',
    },
    'uhd1m8qq': {
      'en': 'What if an item is missing, damaged, or incorrect?',
      'fr': 'Il manque quelques articles dans ma commande',
    },
    '0l2op626': {
      'en': ' ',
      'fr': '',
    },
    '8qj7ec0z': {
      'en':
          'Contact support and provide your order number, the affected product name, and a clear photo when possible. Our team will review the issue.',
      'fr': 'Bonjour le monde',
    },
    'xrexzqh3': {
      'en': 'How do I contact a farmer?',
      'fr': 'Les articles livrés sont incorrects ou erronés.',
    },
    'ur47pcpu': {
      'en': ' ',
      'fr': '',
    },
    'zoyu89t9': {
      'en':
          'Open the farmer’s profile or your order conversation and use the chat option to send the farmer a message.',
      'fr': 'Bonjour le monde',
    },
    'fjdfjwzo': {
      'en': 'How do I change my profile information',
      'fr': 'La qualité des articles est médiocre.',
    },
    'gx3pbpv2': {
      'en': ' ',
      'fr': '',
    },
    'ksttic8o': {
      'en':
          'Go to Profile → Personal Information to update your name, phone number, profile picture, and other available details.',
      'fr': 'Bonjour le monde',
    },
    'i9hcudug': {
      'en': 'Item(s) has spillage issue',
      'fr': 'Le(s) produit(s) présente(nt) un problème de déversement',
    },
    'm46x6pp3': {
      'en': ' ',
      'fr': '',
    },
    'fmj60ecm': {
      'en': 'Hello World',
      'fr': 'Bonjour le monde',
    },
    '0r3dfa3g': {
      'en': 'Report a Delivery Partner fraud incident',
      'fr':
          'Signaler un incident de fraude impliquant un partenaire de livraison',
    },
    'ia24j5zo': {
      'en': ' ',
      'fr': '',
    },
    '7a6y33kt': {
      'en': 'Hello World',
      'fr': 'Bonjour le monde',
    },
    'y3r0lpxi': {
      'en': 'Payment and billing related query',
      'fr': 'Questionnaire relatif aux paiements et à la facturation',
    },
    '60dg28x1': {
      'en': ' ',
      'fr': '',
    },
    'ojw392fg': {
      'en': 'Hello World',
      'fr': 'Bonjour le monde',
    },
    '4wzps40k': {
      'en': 'Help & Support',
      'fr': 'Aide et assistance',
    },
    'u9wpin97': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // refundStatus
  {
    'yxlkiovv': {
      'en': 'Completed Refunds',
      'fr': 'Remboursements effectués',
    },
    '03gdusq7': {
      'en': 'Green Valley Farm',
      'fr': 'Ferme de Green Valley',
    },
    'cv1d83f6': {
      'en': 'To: UPI',
      'fr': 'À : UPI',
    },
    'jv2c1k7i': {
      'en': 'Completed On: 18 Apr 2025',
      'fr': 'Terminé le : 18 avril 2025',
    },
    'v45lt3iu': {
      'en': 'Deliverd',
      'fr': 'Livré',
    },
    'gwfqeua9': {
      'en': '€120',
      'fr': '120 €',
    },
    'kf039wky': {
      'en': 'Order ID: #123741852963',
      'fr': 'Numéro de commande : #123741852963',
    },
    '5tu0kkyn': {
      'en': 'Agricoo has initiated your refund',
      'fr': 'Agricoo a lancé votre remboursement',
    },
    '6tbp5fna': {
      'en': 'Completed On: 18 Apr 2025',
      'fr': 'Terminé le : 18 avril 2025',
    },
    '95oqzre3': {
      'en': 'Your bank has processed your refund',
      'fr': 'Votre banque a traité votre remboursement.',
    },
    '0ql5asdc': {
      'en': 'Completed On: 18 Apr 2025',
      'fr': 'Terminé le : 18 avril 2025',
    },
    'k9tz997a': {
      'en': 'Refund credited to your account',
      'fr': 'Remboursement crédité sur votre compte',
    },
    'ekncel5p': {
      'en': 'Completed On: 18 Apr 2025',
      'fr': 'Terminé le : 18 avril 2025',
    },
    'oqcxzbb3': {
      'en': 'Did this Issue resolved',
      'fr': 'Ce problème a-t-il été résolu ?',
    },
    '1uuv3dvc': {
      'en': 'YES',
      'fr': 'OUI',
    },
    'pmmr9mea': {
      'en': 'NO',
      'fr': 'NON',
    },
    'dajev5e7': {
      'en': 'Show Older Refunds',
      'fr': 'Afficher les remboursements plus anciens',
    },
    'mq8133kf': {
      'en': 'Refund Status',
      'fr': 'État du remboursement',
    },
    's1mmzn19': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // Helpandsupportticket
  {
    'lac2jpnw': {
      'en': 'I did not receive this order',
      'fr': 'Je n\'ai pas reçu cette commande',
    },
    'yo7jwm5f': {
      'en': 'My order shows as delivered, but i haven’t received it',
      'fr':
          'Ma commande est indiquée comme livrée, mais je ne l\'ai pas reçue.',
    },
    'b42s8ara': {
      'en': ' ',
      'fr': '',
    },
    'ljwc27sb': {
      'en': 'Chat with Us',
      'fr': 'Discutez avec nous',
    },
    'yrscqiv6': {
      'en': 'Item(s) portion size is not adequate',
      'fr': 'La portion de ce(s) produit(s) n\'est pas adéquate',
    },
    'zi378770': {
      'en': ' ',
      'fr': '',
    },
    '01juj8f9': {
      'en': 'Hello World',
      'fr': 'Bonjour le monde',
    },
    'mb3lignq': {
      'en': 'Report a safety incident',
      'fr': 'Signaler un incident de sécurité',
    },
    'aaofxymf': {
      'en': ' ',
      'fr': '',
    },
    'u2eiv9gf': {
      'en': 'Hello World',
      'fr': 'Bonjour le monde',
    },
    'jwpxryl0': {
      'en': 'Few item(s) are missing in my order',
      'fr': 'Il manque quelques articles dans ma commande',
    },
    'dpbvpvp1': {
      'en': ' ',
      'fr': '',
    },
    'o082eafl': {
      'en': 'Hello World',
      'fr': 'Bonjour le monde',
    },
    'k84z7g5c': {
      'en': 'Item(s) delivered are incorrect or wrong',
      'fr': 'Les articles livrés sont incorrects ou erronés.',
    },
    'k3lsj6j4': {
      'en': ' ',
      'fr': '',
    },
    'by2g747z': {
      'en': 'Hello World',
      'fr': 'Bonjour le monde',
    },
    'nfiog5qi': {
      'en': 'Item(s) quality is poor',
      'fr': 'La qualité des articles est médiocre.',
    },
    'mgu0opsm': {
      'en': ' ',
      'fr': '',
    },
    'l7vtxs5l': {
      'en': 'Hello World',
      'fr': 'Bonjour le monde',
    },
    '2mdrbilr': {
      'en': 'Item(s) has spillage issue',
      'fr': 'Le(s) article(s) présente(nt) un problème de déversement',
    },
    '0323nj9c': {
      'en': ' ',
      'fr': '',
    },
    'gm90zf02': {
      'en': 'Hello World',
      'fr': 'Bonjour le monde',
    },
    '59l0ng06': {
      'en': 'Report a Delivery Partner fraud incident',
      'fr':
          'Signaler un incident de fraude impliquant un partenaire de livraison',
    },
    'fgcmv9e8': {
      'en': ' ',
      'fr': '',
    },
    '27jetrhf': {
      'en': 'Hello World',
      'fr': 'Bonjour le monde',
    },
    '2plfkkb1': {
      'en': 'Payment and billing related query',
      'fr': 'Questionnaire relatif aux paiements et à la facturation',
    },
    'jrb3ozh9': {
      'en': ' ',
      'fr': '',
    },
    '0ca3ucv5': {
      'en': 'Hello World',
      'fr': 'Bonjour le monde',
    },
    'mqg7jdsp': {
      'en': 'Help & Support',
      'fr': 'Aide et assistance',
    },
    'z3xge8vm': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // HelpAndSuppeortConversation
  {
    'owmjk16e': {
      'en': 'Mark as Resolved',
      'fr': 'Marquer comme résolu',
    },
    'si9vp0zg': {
      'en': 'Type your message...',
      'fr': 'Saisissez votre message...',
    },
    '04bui8tl': {
      'en': 'Resolved Issue',
      'fr': 'Problème résolu',
    },
    'vh4hho1t': {
      'en': 'Help & Support',
      'fr': 'Aide et assistance',
    },
    'udwobux9': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // termsAndCondition
  {
    'vvjqzsy9': {
      'en':
          'These Terms of Service (“Terms”) govern access to and use of the Agricou mobile application, website and related services (collectively, the “Platform”).\n\nThe Platform is operated by The Pinnacle Of Data, 8 rue d’Hyères, 31240 L’Union, France (“Agricou”, “we”, “us” or “our”).\n\nBy creating an account or using Agricou, you agree to these Terms. If you do not agree, you must not use the Platform.',
      'fr':
          'Les présentes Conditions Générales d’Utilisation (« Conditions ») régissent l’accès et l’utilisation de l’application mobile, du site web et des services associés d’Agricou (collectivement, la « Plateforme »). \n\nLa Plateforme est exploitée par The Pinnacle Of Data, 8 rue d’Hyères, 31240 L’Union, France (« Agricou », « nous », « notre »). \n\nEn créant un compte ou en utilisant Agricou, vous acceptez les présentes Conditions. Si vous ne les acceptez pas, vous ne devez pas utiliser la Plateforme.',
    },
    'a3smlkq4': {
      'en': '1. Role of Agricou',
      'fr': '1. Rôle de l\'agriculture',
    },
    'm98waeto': {
      'en':
          'Agricou is a digital platform designed to connect consumers with independent farmers, producers and other professional sellers (“Sellers”).\n\nUnless expressly stated otherwise, products displayed on Agricou are offered and sold by the Seller identified on the relevant product or order page, and not by The Pinnacle Of Data.\n\nAgricou provides the technical services facilitating discovery, ordering, payment and, where available, access to pickup or third-party delivery options.\n\nEach Seller remains responsible, to the extent required by applicable law, for the products it offers, the accuracy of its listings, prices, availability, regulatory compliance, product information, preparation and fulfilment of orders, and its obligations toward consumers.\n\nNothing in these Terms excludes any responsibility that Agricou is legally required to assume.',
      'fr':
          'Agricou est une plateforme numérique conçue pour mettre en relation les consommateurs avec des agriculteurs, producteurs et autres vendeurs professionnels indépendants (« Vendeurs »). \n\nSauf mention contraire, les produits affichés sur Agricou sont proposés et vendus par le Vendeur identifié sur la page produit ou de commande correspondante, et non par The Pinnacle Of Data. \n\nAgricou fournit les services techniques facilitant la recherche, la commande, le paiement et, le cas échéant, l\'accès aux options de retrait en magasin ou de livraison par un tiers. \n\nChaque Vendeur demeure responsable, dans la mesure permise par la loi applicable, des produits qu\'il propose, de l\'exactitude de ses annonces, des prix, de la disponibilité, de la conformité réglementaire, des informations produits, de la préparation et de l\'exécution des commandes, ainsi que de ses obligations envers les consommateurs. \n\nAucune disposition des présentes Conditions générales n\'exclut les responsabilités qu\'Agricou est légalement tenue d\'assumer.',
    },
    'clrwdlh7': {
      'en': '2. Eligibility and Accounts',
      'fr': '2. Admissibilité et comptes',
    },
    '3zvymfud': {
      'en':
          'You must have the legal capacity required to enter into a contract to use services involving purchases.\n\nYou agree to provide accurate, current and complete information and to keep your account information up to date.\n\nYou are responsible for maintaining the confidentiality of your login credentials and for activity performed through your account, except where such activity results from circumstances for which you are not legally responsible.\n\nYou must notify Agricou promptly if you suspect unauthorized access to your account.\n\nAgricou may restrict, suspend or terminate an account in the event of fraud, attempted fraud, unlawful activity, abuse of the Platform, serious or repeated violation of these Terms, security risk, or where required by law, subject to any applicable legal requirements.',
      'fr':
          'Vous devez avoir la capacité juridique requise pour conclure un contrat d\'utilisation de services impliquant des achats. \n\nVous vous engagez à fournir des informations exactes, actuelles et complètes et à maintenir à jour les informations de votre compte. \n\nVous êtes responsable de la confidentialité de vos identifiants de connexion et des activités effectuées via votre compte, sauf si ces activités résultent de circonstances dont vous n\'êtes pas légalement responsable. \n\nVous devez informer Agricou sans délai si vous soupçonnez un accès non autorisé à votre compte. \n\nAgricou peut restreindre, suspendre ou résilier un compte en cas de fraude, de tentative de fraude, d\'activité illégale, d\'abus de la Plateforme, de violation grave ou répétée des présentes Conditions, de risque pour la sécurité ou lorsque la loi l\'exige, sous réserve des dispositions légales applicables.',
    },
    'boynsa4i': {
      'en': '3. Sellers and Product Information',
      'fr': '3. Informations sur les vendeurs et les produits',
    },
    '1hhsh6q5': {
      'en':
          'Sellers using Agricou operate independently and are responsible for complying with the laws and regulations applicable to their activities and products.\n\nSellers are responsible for ensuring that product descriptions, origin information, composition, allergens, quantity, price, availability and any other legally required information they provide are accurate and not misleading.\n\nAgricou may perform checks, request supporting documents, remove or restrict listings, or suspend a Seller where reasonably necessary for legal compliance, consumer protection, security or enforcement of Platform rules.\n\nSuch measures do not constitute a general guarantee by Agricou regarding the quality, safety, legality or conformity of every product offered by Sellers.',
      'fr':
          'Les vendeurs utilisant Agricou opèrent de manière indépendante et sont responsables du respect des lois et réglementations applicables à leurs activités et produits. \n\nIls doivent s\'assurer que les descriptions de produits, les informations relatives à l\'origine, la composition, les allergènes, la quantité, le prix, la disponibilité et toute autre information légalement requise sont exactes et non trompeuses. \n\nAgricou peut effectuer des vérifications, demander des justificatifs, supprimer ou restreindre des annonces, ou suspendre un vendeur lorsque cela est raisonnablement nécessaire pour le respect des obligations légales, la protection des consommateurs, la sécurité ou l\'application du règlement de la plateforme. \n\nCes mesures ne constituent pas une garantie générale d\'Agricou quant à la qualité, la sécurité, la légalité ou la conformité de tous les produits proposés par les vendeurs.',
    },
    '3uuaao15': {
      'en': '4. Orders',
      'fr': '4. Commandes',
    },
    'v3e1pr7x': {
      'en':
          'When placing an order, you must review the product description, Seller information, quantities, price, applicable fees, pickup or delivery conditions and total amount before confirming the order.\n\nAn order may be subject to availability and acceptance in accordance with the information presented during checkout.\n\nIf an ordered product becomes unavailable, the consumer will be informed and any amount due for an unavailable product will be handled in accordance with applicable law and the relevant order conditions.\n\nAgricou may cancel or restrict a transaction where reasonably necessary because of suspected fraud, manifest pricing or technical errors, legal requirements, product safety concerns or Platform security.\n\nNothing in this section limits mandatory consumer rights.',
      'fr':
          'Lors de la passation d\'une commande, vous devez vérifier la description du produit, les informations sur le vendeur, les quantités, le prix, les frais applicables, les conditions de retrait ou de livraison et le montant total avant de confirmer la commande. \n\nUne commande peut être soumise à disponibilité et à acceptation conformément aux informations présentées lors du paiement. \n\nSi un produit commandé devient indisponible, le consommateur en sera informé et tout montant dû pour un produit indisponible sera traité conformément à la loi applicable et aux conditions de commande pertinentes. \n\nAgricou peut annuler ou restreindre une transaction lorsque cela est raisonnablement nécessaire en cas de suspicion de fraude, d\'erreurs manifestes de prix ou techniques, d\'obligations légales, de problèmes de sécurité des produits ou de sécurité de la plateforme. \n\nRien dans cette section ne limite les droits obligatoires du consommateur.',
    },
    'jwuatz9d': {
      'en': '5. Prices, Fees and Payments',
      'fr': '5. Prix, frais et paiements',
    },
    'nxge5z6c': {
      'en':
          'Prices, applicable taxes, delivery charges and other fees payable by the consumer will be displayed before the order is confirmed.\n\nPayments may be processed through independent payment service providers. Use of such services may also be subject to the provider’s applicable terms and privacy practices.\n\nAgricou does not store complete payment-card details where payment information is processed directly by an authorized payment service provider.\n\nAny Agricou service fee applicable to an order will be disclosed before payment.',
      'fr':
          'Les prix, les taxes applicables, les frais de livraison et autres frais à la charge du consommateur seront affichés avant la confirmation de la commande. \n\nLes paiements peuvent être traités par des prestataires de services de paiement indépendants. L\'utilisation de ces services peut également être soumise aux conditions générales et à la politique de confidentialité du prestataire. \n\nAgricou ne conserve pas l\'intégralité des informations relatives aux cartes de paiement lorsque ces informations sont traitées directement par un prestataire de services de paiement agréé. \n\nTous les frais de service Agricou applicables à une commande seront indiqués avant le paiement.',
    },
    'xejxcf6a': {
      'en': '6. Pickup and Delivery',
      'fr': '6. Enlèvement et livraison',
    },
    'ubcdzckj': {
      'en':
          'Depending on the Seller and location, orders may be collected directly from a Seller or delivered through an available delivery service.\n\nWhere delivery is performed by an independent third-party delivery provider, that provider is responsible for performing its service in accordance with its contractual and legal obligations.\n\nEstimated collection or delivery times may be affected by circumstances outside Agricou’s reasonable control.\n\nNothing in these Terms limits liability that cannot legally be excluded.',
      'fr':
          'Selon le vendeur et le lieu, les commandes peuvent être retirées directement auprès du vendeur ou livrées par un service de livraison disponible. \n\nLorsque la livraison est effectuée par un prestataire de livraison tiers indépendant, ce dernier est responsable de l\'exécution de sa prestation conformément à ses obligations contractuelles et légales. \n\nLes délais estimés de retrait ou de livraison peuvent être affectés par des circonstances indépendantes de la volonté d\'Agricou. \n\nAucune disposition des présentes Conditions générales ne limite la responsabilité qui ne peut être légalement exclue.',
    },
    'yucw8d7x': {
      'en': '7. Cancellations, Refunds and Consumer Rights',
      'fr': '7. Annulations, remboursements et droits des consommateurs',
    },
    '5wb8gdkm': {
      'en':
          'Cancellation, return, refund and withdrawal rights depend on the nature of the product, the Seller, the stage of the order and applicable law.\n\nConsumers retain all mandatory rights granted to them by applicable consumer-protection legislation.\n\nCertain products may legally be excluded from the right of withdrawal, including, where the statutory requirements are met, goods liable to deteriorate or expire rapidly.\n\nWhere a statutory right of withdrawal applies, information concerning its exercise will be provided in accordance with applicable law.\n\nRefunds, where due, will be processed in accordance with applicable law and the applicable order conditions.',
      'fr':
          'Les droits d\'annulation, de retour, de remboursement et de rétractation dépendent de la nature du produit, du vendeur, de l\'état d\'avancement de la commande et de la législation applicable. \n\nLes consommateurs conservent tous les droits impératifs que leur confère la législation applicable en matière de protection des consommateurs. \n\nCertains produits peuvent être légalement exclus du droit de rétractation, notamment, lorsque les conditions légales sont remplies, les biens susceptibles de se détériorer ou de se périmer rapidement. \n\nLorsqu\'un droit de rétractation légal s\'applique, les informations relatives à son exercice seront fournies conformément à la législation applicable. \n\nLes remboursements, le cas échéant, seront traités conformément à la législation applicable et aux conditions générales de vente.',
    },
    'cdc7vj53': {
      'en': '8. Product Quality, Safety and Complaints',
      'fr': '8. Qualité des produits, sécurité et réclamations',
    },
    '4mkvrsm4': {
      'en':
          'Sellers are responsible for ensuring that products they place on the market comply with applicable requirements, including applicable food-safety, hygiene, labelling and consumer-information requirements.\n\nConsumers should follow storage, preparation, consumption, allergen and safety information supplied with a product.\n\nIf a product is damaged, incorrect, unsafe, non-compliant or otherwise problematic, the consumer should report the issue promptly through Agricou or the available support channel.\n\nAgricou may facilitate communications between the consumer and Seller and may take measures concerning a listing or Seller account where appropriate.\n\nThis does not affect any legal remedies available to the consumer.',
      'fr':
          'Les vendeurs sont responsables de s\'assurer que les produits qu\'ils mettent sur le marché sont conformes aux exigences applicables, notamment en matière de sécurité alimentaire, d\'hygiène, d\'étiquetage et d\'information des consommateurs. \n\nLes consommateurs doivent suivre les instructions de conservation, de préparation, de consommation, d\'allergènes et de sécurité fournies avec le produit. \n\nSi un produit est endommagé, non conforme, dangereux, dangereux ou présente tout autre problème, le consommateur doit le signaler rapidement à Agricou ou via le canal d\'assistance disponible. \n\nAgricou peut faciliter la communication entre le consommateur et le vendeur et prendre les mesures appropriées concernant une annonce ou un compte vendeur. \n\nCeci n\'affecte en rien les recours légaux dont dispose le consommateur.',
    },
    '7eomvy4u': {
      'en': '9. Prohibited Conduct',
      'fr': '9. Comportements interdits',
    },
    'mm3ce4w6': {
      'en':
          'Users may not use Agricou to commit or facilitate unlawful or fraudulent activity; impersonate another person; provide deliberately false information; interfere with Platform security or operation; attempt unauthorized access; distribute malicious software; manipulate reviews or transactions; harass other users or Sellers; or offer, purchase or distribute products prohibited by applicable law or Agricou policies.\n\nAgricou may take proportionate measures to protect users, Sellers, the Platform and third parties.',
      'fr':
          'Les utilisateurs ne peuvent pas utiliser Agricou pour commettre ou faciliter une activité illégale ou frauduleuse ; usurper l’identité d’une autre personne ; fournir des informations délibérément fausses ; interférer avec la sécurité ou le fonctionnement de la plateforme ; tenter un accès non autorisé ; distribuer des logiciels malveillants ; manipuler les avis ou les transactions ; harceler d’autres utilisateurs ou vendeurs ; ou proposer, acheter ou distribuer des produits interdits par la loi applicable ou les politiques d’Agricou. \n\nAgricou peut prendre des mesures proportionnées pour protéger les utilisateurs, les vendeurs, la plateforme et les tiers.',
    },
    't84ee0qo': {
      'en': '10. Reviews and User Content',
      'fr': '10. Avis et contenu utilisateur',
    },
    'zjyfd0ai': {
      'en':
          'Where Agricou permits reviews, photographs, comments or other content, users remain responsible for the content they submit.\n\nContent must not be unlawful, fraudulent, defamatory, threatening, infringing, misleading or otherwise violate the rights of third parties.\n\nAgricou may moderate or remove content where permitted or required by law and in accordance with its applicable moderation policies.\n\nBy submitting content, you grant Agricou the rights reasonably necessary to host, reproduce and display that content for operation and promotion of the Platform, subject to applicable law.',
      'fr':
          'Lorsque Agricou autorise les avis, les photos, les commentaires ou tout autre contenu, les utilisateurs restent responsables du contenu qu\'ils soumettent. \n\nLe contenu ne doit pas être illégal, frauduleux, diffamatoire, menaçant, contrefaisant, trompeur ou enfreindre les droits de tiers. \n\nAgricou peut modérer ou supprimer tout contenu lorsque la loi le permet ou l\'exige et conformément à ses politiques de modération applicables. \n\nEn soumettant du contenu, vous accordez à Agricou les droits raisonnablement nécessaires pour héberger, reproduire et afficher ce contenu aux fins d\'exploitation et de promotion de la Plateforme, sous réserve de la législation applicable.',
    },
    'dh3sv8mw': {
      'en': '11. Third-Party Services',
      'fr': '11. Services tiers',
    },
    'z2anyqse': {
      'en':
          'Agricou may integrate services provided by third parties, including payment, mapping, authentication, communications and delivery services.\n\nThe availability and operation of those services may depend on their respective providers.\n\nAgricou is not responsible for a third party’s independent acts or omissions except where liability is imposed on Agricou by applicable law.\n',
      'fr':
          'Agricou peut intégrer des services fournis par des tiers, notamment des services de paiement, de cartographie, d\'authentification, de communication et de livraison. \n\nLa disponibilité et le fonctionnement de ces services peuvent dépendre de leurs fournisseurs respectifs. \n\nAgricou n\'est pas responsable des actes ou omissions indépendants d\'un tiers, sauf lorsque la responsabilité d\'Agricou est imposée par la loi applicable.',
    },
    'u8tmd3xe': {
      'en': '12. Platform Availability',
      'fr': '12. Disponibilité de la plateforme',
    },
    '2mny3att': {
      'en':
          'Agricou aims to maintain a reliable and secure Platform but does not guarantee uninterrupted or error-free availability.\n\nThe Platform may occasionally be unavailable because of maintenance, updates, security measures, technical incidents or circumstances outside Agricou’s reasonable control.\n\nAgricou may modify or update Platform functionality, provided that mandatory contractual and consumer rights are respected.',
      'fr':
          'Agricou s’efforce de maintenir une plateforme fiable et sécurisée, mais ne garantit pas une disponibilité ininterrompue ni sans erreur. \n\nLa plateforme peut être occasionnellement indisponible en raison de travaux de maintenance, de mises à jour, de mesures de sécurité, d’incidents techniques ou de circonstances indépendantes de la volonté d’Agricou. \n\nAgricou peut modifier ou mettre à jour les fonctionnalités de la plateforme, sous réserve du respect des droits contractuels et des droits des consommateurs.',
    },
    '3dhpeyyk': {
      'en': '13. Liability',
      'fr': '13. Responsabilité',
    },
    '2v85w625': {
      'en':
          'Each party remains responsible for liability imposed upon it by applicable law.\n\nTo the fullest extent permitted by applicable law, The Pinnacle Of Data is not liable for acts, omissions, representations or products of independent Sellers or third-party service providers where those matters are legally their responsibility.\n\nThe Pinnacle Of Data does not exclude or limit liability where such exclusion or limitation is prohibited by law.\n\nNothing in these Terms excludes or restricts mandatory consumer rights.',
      'fr':
          'Chaque partie demeure responsable des obligations qui lui incombent en vertu de la loi applicable. \n\nDans toute la mesure permise par la loi applicable, The Pinnacle Of Data n\'est pas responsable des actes, omissions, déclarations ou produits de vendeurs indépendants ou de fournisseurs de services tiers lorsque ces éléments relèvent de leur responsabilité légale. \n\nThe Pinnacle Of Data n\'exclut ni ne limite sa responsabilité lorsque cette exclusion ou limitation est interdite par la loi. \n\nAucune disposition des présentes Conditions générales n\'exclut ni ne restreint les droits impératifs du consommateur.',
    },
    '8a4xzvh3': {
      'en': '14. Intellectual Property',
      'fr': '14. Propriété intellectuelle',
    },
    'jpv40n9l': {
      'en':
          'The Agricou name, branding, application design, software, databases, graphics and other Platform materials belonging to The Pinnacle Of Data or its licensors are protected by applicable intellectual-property laws.\n\nExcept where expressly permitted, users may not copy, reproduce, distribute, modify, extract, commercially exploit or create derivative works from protected Agricou materials without prior authorization.\n\nNo ownership rights are transferred to users through use of the Platform.',
      'fr':
          'Le nom Agricou, la marque, la conception de l\'application, les logiciels, les bases de données, les graphismes et autres éléments de la Plateforme appartenant à The Pinnacle Of Data ou à ses concédants de licence sont protégés par les lois applicables en matière de propriété intellectuelle. \n\nSauf autorisation expresse, les utilisateurs ne sont pas autorisés à copier, reproduire, distribuer, modifier, extraire, exploiter commercialement ou créer des œuvres dérivées à partir des éléments protégés d\'Agricou sans autorisation préalable. \n\nAucun droit de propriété n\'est transféré aux utilisateurs par l\'utilisation de la Plateforme.',
    },
    'o8vo6uno': {
      'en': '15. Privacy and Location Data',
      'fr': '15. Confidentialité et données de localisation',
    },
    '8gc1wqn3': {
      'en':
          'Personal data is processed as described in the Agricou Privacy Policy.\n\nLocation permission is optional unless a particular feature technically requires location information. Users may manage permissions through their device settings.\n\nAgricou may use location information to provide location-dependent features, such as displaying nearby Sellers or relevant routes, subject to the Privacy Policy and the permissions granted by the user.',
      'fr':
          'Les données personnelles sont traitées conformément à la Politique de confidentialité d\'Agricou. \n\nL\'autorisation de géolocalisation est facultative, sauf si une fonctionnalité particulière requiert techniquement ces informations. Les utilisateurs peuvent gérer les autorisations via les paramètres de leur appareil. \n\nAgricou peut utiliser les informations de géolocalisation pour fournir des fonctionnalités géolocalisées, telles que l\'affichage des vendeurs à proximité ou des itinéraires pertinents, sous réserve de la Politique de confidentialité et des autorisations accordées par l\'utilisateur.',
    },
    '7g3zebyg': {
      'en': '16. Changes to these Terms',
      'fr': '16. Modifications des présentes conditions',
    },
    'oe58p3fh': {
      'en':
          'Agricou may amend these Terms where necessary because of changes to the Platform, applicable law, security requirements or business operations.\n\nWhere required by law or where changes materially affect users’ contractual rights, users will receive appropriate notice before the changes take effect.\n\nThe version applicable to a transaction remains subject to applicable contractual and consumer-protection law.',
      'fr':
          'Agricou peut modifier les présentes Conditions générales si nécessaire en raison de changements apportés à la Plateforme, à la législation applicable, aux exigences de sécurité ou à ses activités. \n\nLorsque la loi l’exige ou que les modifications affectent sensiblement les droits contractuels des utilisateurs, ces derniers seront informés avant leur entrée en vigueur. \n\nLa version applicable à une transaction reste soumise au droit contractuel et au droit de la consommation applicables.',
    },
    'vpi6y1on': {
      'en': '17. Governing Law and Disputes',
      'fr': '17. Droit applicable et litiges',
    },
    'nfogi1ey': {
      'en':
          'These Terms are governed by French law, without depriving consumers residing in another country of mandatory protections that may apply to them under applicable law.\n\nConsumers are encouraged to contact Agricou first so that a complaint can be reviewed and an amicable solution sought.\n\nWhere applicable, consumers may also have access to an independent consumer mediation mechanism.\n\nNothing in these Terms deprives a consumer of the right to bring proceedings before a court having jurisdiction under applicable law.',
      'fr':
          'Les présentes conditions générales sont régies par le droit français, sans pour autant priver les consommateurs résidant dans un autre pays des protections impératives dont ils peuvent bénéficier en vertu de la législation applicable. \n\nLes consommateurs sont invités à contacter Agricou en premier lieu afin que leur réclamation puisse être examinée et qu\'une solution amiable puisse être recherchée. \n\nLe cas échéant, les consommateurs peuvent également avoir accès à un mécanisme indépendant de médiation des consommateurs. \n\nAucune disposition des présentes conditions générales ne prive un consommateur du droit d\'intenter une action devant une juridiction compétente en vertu de la législation applicable.',
    },
    's265kba1': {
      'en': '18. Contact',
      'fr': '18. Contact',
    },
    '24aaxcd4': {
      'en':
          'Agricou is operated by:\n\nThe Pinnacle Of Data\n— \nEURL \nSIREN 929 478 485 \n— \n8 rue d’Hyères\n31240 L’Union\nFrance\n—\nCustomer support: support@agricou.com',
      'fr':
          'Agricou est exploité par : \n\nLe Pinnacle des Données\n— \nEURL \nSIREN 929 478 485 \n— \n8 rue d’Hyères\n31240 L’Union\nFrance\n—\nService client : support@agricou.com',
    },
    'eay558sq': {
      'en': 'Terms & Conditions',
      'fr': 'Conditions générales',
    },
    'iebaeajo': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // PrivacyPolicy
  {
    'phy5wlea': {
      'en':
          'This Privacy Policy explains how personal data is collected, used, shared and protected when you use the Agricou mobile application, website and related services (the “Platform”).\n\nThe data controller is:\n\nThe Pinnacle Of Data – EURL\nSIREN: 929 478 485\n8 rue d’Hyères\n31240 L’Union, France\nEmail: support@agricou.com',
      'fr':
          'La présente Politique de confidentialité explique comment vos données personnelles sont collectées, utilisées, partagées et protégées lorsque vous utilisez l’application mobile, le site web et les services associés d’Agricou (la « Plateforme »).\n\nLe responsable du traitement des données est :\n\nThe Pinnacle Of Data – EURL\n\nSIREN : 929 478 485\n\n8 rue d’Hyères\n\n31240 L’Union, France\n\nCourriel : support@agricou.com',
    },
    '5u3mamda': {
      'en': '1. Personal Data We Collect',
      'fr': '1. Données personnelles que nous collectons',
    },
    'id5cedqn': {
      'en':
          'Depending on how you use Agricou, we may process the following categories of personal data:\n\nAccount and identity data: name, email address, telephone number, account identifier, profile information, user role (consumer or producer), authentication information and account settings.\n\nProducer information: farm or business name, contact details, business information, address, product listings, photographs, availability and other information necessary to operate a producer account or comply with applicable legal requirements.\n\nLocation and route data: with the appropriate device permissions where required, Agricou may process your location, selected addresses, departure and destination points, routes and related location information to display nearby producers, provide map functions, search for producers along a route, calculate relevant routes or detours and enable location-dependent services.\n\nOrder and transaction data: products ordered, quantities, prices, Seller information, order history, pickup or delivery choices, delivery addresses, transaction status, refunds and information necessary to manage orders and customer support.\n\nPayment information: payments are processed using third-party payment service providers such as Stripe. Agricou may receive transaction identifiers, payment status and limited payment-related information necessary to manage transactions. Complete payment-card details are handled by the relevant payment provider rather than stored directly by Agricou where the payment integration operates in this manner.\n\nCommunications: messages exchanged through Agricou, communications with customer support, complaints, reports and other information you voluntarily provide.\n\nPhotos and content: profile pictures, producer/product photographs, reviews and other content uploaded through the Platform.\n\nTechnical and usage data: device information, operating system, app version, IP address, identifiers, logs, app interactions, diagnostic information, performance information and crash data where collected by the services used by Agricou.\n\nNotification information: notification preferences and technical identifiers required to send push notifications.\n\nWe do not intentionally request special-category personal data unless it is necessary and lawful for a specific purpose. Please avoid including unnecessary sensitive personal information in messages, reviews or other free-text fields.',
      'fr':
          'Selon votre utilisation d\'Agricou, nous pouvons traiter les catégories de données personnelles suivantes :\n\nDonnées de compte et d\'identité : nom, adresse e-mail, numéro de téléphone, identifiant de compte, informations de profil, rôle de l\'utilisateur (consommateur ou producteur), informations d\'authentification et paramètres du compte.\n\nInformations sur le producteur : nom de l\'exploitation ou de l\'entreprise, coordonnées, informations sur l\'entreprise, adresse, liste des produits, photos, disponibilité et autres informations nécessaires à la gestion d\'un compte producteur ou au respect des obligations légales applicables.\n\nDonnées de localisation et d\'itinéraire : avec les autorisations requises de votre appareil, Agricou peut traiter votre localisation, les adresses sélectionnées, les points de départ et d\'arrivée, les itinéraires et les informations de localisation associées afin d\'afficher les producteurs à proximité, de fournir des fonctionnalités cartographiques, de rechercher des producteurs le long d\'un itinéraire, de calculer les itinéraires ou détours pertinents et d\'activer les services géolocalisés.\n\nDonnées de commande et de transaction : produits commandés, quantités, prix, informations sur le vendeur, historique des commandes, choix de retrait ou de livraison, adresses de livraison, statut des transactions, remboursements et informations nécessaires à la gestion des commandes et au service client.\n\nInformations de paiement : les paiements sont traités par des prestataires de services de paiement tiers tels que Stripe. Agricou peut recevoir les identifiants de transaction, le statut du paiement et certaines informations nécessaires à la gestion des transactions. Les données complètes des cartes de paiement sont traitées par le prestataire de paiement concerné et non stockées directement par Agricou lorsque l\'intégration des paiements fonctionne de cette manière.\n\nCommunications : messages échangés via Agricou, communications avec le service client, réclamations, signalements et autres informations que vous fournissez volontairement.\n\nPhotos et contenu : photos de profil, photos du producteur/produit, avis et autres contenus téléchargés via la plateforme.\n\nDonnées techniques et d\'utilisation : informations sur l\'appareil, système d\'exploitation, version de l\'application, adresse IP, identifiants, journaux, interactions avec l\'application, informations de diagnostic, informations de performance et données de plantage, lorsqu\'elles sont collectées par les services utilisés par Agricou.\n\nInformations de notification : préférences de notification et identifiants techniques nécessaires à l\'envoi de notifications push.\n\nNous ne demandons pas intentionnellement de données personnelles sensibles, sauf si cela est nécessaire et légal pour une finalité spécifique. Veuillez éviter d\'inclure des informations personnelles sensibles inutiles dans vos messages, avis ou autres champs de texte libre.',
    },
    'mtf8a3lp': {
      'en': '2. Why We Use Your Personal Data',
      'fr': '2. Pourquoi nous utilisons vos données personnelles',
    },
    'dkglok78': {
      'en':
          'We process personal data where necessary to:\n\n• create, authenticate and manage your Agricou account;\n• provide the Platform and its features;\n• connect consumers with producers and Sellers;\n• display nearby producers and products;\n• provide maps, route searches and location-based functionality;\n• process and manage orders, payments, pickup and delivery;\n• enable communications between relevant users;\n• provide customer support and handle complaints;\n• send transactional and service-related notifications;\n• maintain Platform security and prevent fraud or misuse;\n• diagnose crashes, maintain performance and improve the Platform;\n• comply with accounting, tax, consumer-protection, regulatory and other legal obligations; and\n• where legally permitted and subject to applicable choices or consent requirements, send marketing communications and measure or improve our services.',
      'fr':
          'Nous traitons vos données personnelles lorsque cela est nécessaire pour :\n\n• créer, authentifier et gérer votre compte Agricou ;\n\n• fournir la Plateforme et ses fonctionnalités ;\n\n• mettre en relation les consommateurs avec les producteurs et les vendeurs ;\n\n• afficher les producteurs et les produits à proximité ;\n\n• fournir des cartes, des outils de recherche d’itinéraires et des fonctionnalités de géolocalisation ;\n\n• traiter et gérer les commandes, les paiements, les retraits et les livraisons ;\n\n• permettre la communication entre les utilisateurs concernés ;\n\n• assurer le support client et traiter les réclamations ;\n\n• envoyer des notifications transactionnelles et relatives au service ;\n\n• garantir la sécurité de la Plateforme et prévenir la fraude et les utilisations abusives ;\n\n• diagnostiquer les dysfonctionnements, maintenir les performances et améliorer la Plateforme ;\n\n• respecter nos obligations comptables, fiscales, de protection des consommateurs, réglementaires et autres obligations légales ; et\n\n• lorsque la loi le permet et sous réserve des choix ou des exigences de consentement applicables, envoyer des communications marketing et mesurer ou améliorer nos services.',
    },
    'do5wqefk': {
      'en': '3. Legal Bases for Processing',
      'fr': '3. Bases juridiques du traitement',
    },
    'bxt3pb3g': {
      'en':
          'Depending on the relevant processing activity, Agricou relies on one or more legal bases permitted by applicable data-protection law:\n\nPerformance of a contract: where processing is necessary to create and manage your account, provide requested Platform functionality, process an order or provide services requested by you.\n\nLegal obligation: where processing is necessary to comply with legal, regulatory, accounting, tax, consumer-protection or other obligations applicable to The Pinnacle Of Data.\n\nLegitimate interests: where necessary for purposes such as Platform security, fraud prevention, service administration, troubleshooting and improvement, provided those interests are not overridden by your rights and freedoms.\n\nConsent: where consent is required, including for certain permissions, marketing communications or other processing for which applicable law requires consent. Where processing is based on consent, you may withdraw it at any time without affecting processing lawfully carried out before withdrawal.',
      'fr':
          'Selon l\'activité de traitement concernée, Agricou s\'appuie sur une ou plusieurs bases légales autorisées par la législation applicable en matière de protection des données :\n\nExécution d\'un contrat : lorsque le traitement est nécessaire à la création et à la gestion de votre compte, à la fourniture des fonctionnalités demandées sur la Plateforme, au traitement d\'une commande ou à la fourniture des services que vous avez sollicités.\n\nObligation légale : lorsque le traitement est nécessaire au respect des obligations légales, réglementaires, comptables, fiscales, de protection des consommateurs ou autres applicables à The Pinnacle Of Data.\n\nIntérêts légitimes : lorsque le traitement est nécessaire à des fins telles que la sécurité de la Plateforme, la prévention de la fraude, l\'administration du service, le dépannage et l\'amélioration, à condition que ces intérêts ne portent pas atteinte à vos droits et libertés.\n\nConsentement : lorsque le consentement est requis, notamment pour certaines autorisations, les communications marketing ou tout autre traitement pour lequel la loi applicable exige un consentement. Lorsque le traitement est fondé sur le consentement, vous pouvez le retirer à tout moment sans que cela n\'affecte la licéité du traitement effectué avant ce retrait.',
    },
    '4nsdjex4': {
      'en': '4. Location Data',
      'fr': '4. Données de localisation',
    },
    'wt3k0cye': {
      'en':
          'Agricou uses location information to provide location-dependent features, including displaying nearby producers and products, map functionality and searching for producers in relation to a journey or route.\n\nWhere device permission is required, you can allow or refuse location access and later change your choice through your device settings.\n\nRefusing or disabling location access will not prevent you from using features that do not require location data, although certain map, nearby-search or route-related features may become unavailable or less accurate.\n\nAgricou does not use location information for purposes unrelated to those disclosed to you without an appropriate legal basis.',
      'fr':
          'Agricou utilise les données de géolocalisation pour fournir des fonctionnalités adaptées à la proximité, comme l\'affichage des producteurs et produits à proximité, la cartographie et la recherche de producteurs en lien avec un trajet ou un itinéraire.\n\nLorsque l\'autorisation de votre appareil est requise, vous pouvez autoriser ou refuser l\'accès à votre position et modifier votre choix ultérieurement dans les paramètres de votre appareil.\n\nRefuser ou désactiver l\'accès à la géolocalisation ne vous empêchera pas d\'utiliser les fonctionnalités qui ne nécessitent pas de données de localisation, mais certaines fonctionnalités liées à la carte, à la recherche de proximité ou aux itinéraires pourraient devenir indisponibles ou moins précises.\n\nAgricou n\'utilise pas les données de géolocalisation à des fins autres que celles qui vous ont été communiquées sans base légale appropriée.',
    },
    '6l2n62ah': {
      'en': '5. Payments',
      'fr': '5. Paiements',
    },
    '8zvkhu5b': {
      'en':
          'Agricou uses third-party payment services, including Stripe, to facilitate payment processing.\n\nPayment providers may process personal and payment information in accordance with their own privacy policies and applicable legal obligations.\n\nThe Pinnacle Of Data may retain transaction references, amounts, payment status and other information necessary for order administration, accounting, fraud prevention, refunds and legal compliance.',
      'fr':
          'Agricou utilise des services de paiement tiers, notamment Stripe, pour faciliter le traitement des paiements.\n\nLes prestataires de paiement peuvent traiter les données personnelles et bancaires conformément à leurs propres politiques de confidentialité et aux obligations légales applicables.\n\nPinnacle Of Data peut conserver les références de transaction, les montants, le statut des paiements et toute autre information nécessaire à la gestion des commandes, à la comptabilité, à la prévention de la fraude, aux remboursements et au respect des obligations légales.',
    },
    '1asgx6lz': {
      'en': '6. Delivery Services',
      'fr': '6. Services de livraison',
    },
    '3e3ixx4o': {
      'en':
          'Where you request delivery through an integrated delivery service, including services provided through Uber or an applicable Uber delivery service, information necessary to arrange and perform the delivery may be transmitted to the relevant delivery provider.\n\nThis may include the pickup and delivery addresses, recipient information, contact information and order or delivery details reasonably necessary to perform the service.\n\nThe delivery provider may process personal data in accordance with its own privacy documentation and legal obligations.',
      'fr':
          'Lorsque vous demandez une livraison via un service de livraison intégré, y compris les services fournis par Uber ou un service de livraison Uber applicable, les informations nécessaires à l\'organisation et à l\'exécution de la livraison peuvent être transmises au prestataire de livraison concerné. \n\nCes informations peuvent inclure les adresses de prise en charge et de livraison, les informations du destinataire, les coordonnées et les détails de la commande ou de la livraison raisonnablement nécessaires à l\'exécution du service. \n\nLe prestataire de livraison peut traiter les données personnelles conformément à sa propre politique de confidentialité et à ses obligations légales.',
    },
    'c1yvc7r5': {
      'en': '7. Authentication',
      'fr': '7. Authentification',
    },
    'jnp27tz2': {
      'en':
          'Agricou may provide authentication through Firebase/Google, Google Sign-In and Sign in with Apple.\n\nWhen you choose a third-party sign-in method, the relevant provider may process authentication and account information under its own privacy terms. Agricou receives the information necessary to create or authenticate your Agricou account according to the permissions and settings applicable to that service.\n\nAgricou does not claim to receive or store your Google or Apple account password.',
      'fr':
          'Agricou peut proposer une authentification via Firebase/Google, la connexion Google et la connexion avec Apple. \n\nLorsque vous choisissez une méthode de connexion tierce, le fournisseur concerné peut traiter les informations d\'authentification et de compte conformément à sa propre politique de confidentialité. Agricou reçoit les informations nécessaires à la création ou à l\'authentification de votre compte \n\nAgricou, selon les autorisations et paramètres applicables à ce service. Agricou ne déclare pas recevoir ni stocker le mot de passe de votre compte Google ou Apple.',
    },
    'ry04oixn': {
      'en': '8. Service Providers and Recipients',
      'fr': '8. Prestataires de services et bénéficiaires',
    },
    '8gmxg7cy': {
      'en':
          'Personal data may be disclosed, where necessary and proportionate, to service providers supporting Agricou, including providers of:\n\n• cloud hosting, databases and authentication, including Google/Firebase;\n• payment processing, including Stripe;\n• mapping and location functionality;\n• delivery services, including applicable Uber services;\n• push notifications and communications;\n• analytics, diagnostics and crash reporting; and\n• technical infrastructure and support.\n\nRelevant information may also be shared with a Seller or producer where necessary to fulfil an order, arrange pickup or delivery, resolve a complaint or otherwise perform a transaction requested by the user.\n\nPersonal data may also be disclosed where required by law, a competent authority or legal proceedings, or where legally permitted and necessary to establish, exercise or defend legal claims.\n\nAgricou does not sell your personal data.',
      'fr':
          'Les données personnelles peuvent être divulguées, lorsque cela est nécessaire et proportionné, aux prestataires de services d\'Agricou, notamment les fournisseurs de : \n- hébergement cloud, bases de données et authentification (y compris Google/Firebase) ; \n- traitement des paiements (y compris Stripe) ; \n- fonctionnalités de cartographie et de géolocalisation ; \n- services de livraison (y compris les services Uber applicables) ; \n- notifications push et communications ; \n- analyses, diagnostics et rapports d\'incidents ; \n- et infrastructure et assistance techniques. \n\nLes informations pertinentes peuvent également être partagées avec un vendeur ou un producteur lorsque cela est nécessaire pour exécuter une commande, organiser un enlèvement ou une livraison, résoudre une réclamation ou effectuer toute autre transaction demandée par l\'utilisateur. \n\nLes données personnelles peuvent également être divulguées lorsque la loi, une autorité compétente ou une procédure judiciaire l\'exigent, ou lorsque la loi le permet et que cela est nécessaire pour établir, exercer ou défendre des droits en justice. \n\nAgricou ne vend pas vos données personnelles.',
    },
    'nxvm6jrj': {
      'en': '9. International Data Transfers',
      'fr': '9. Transferts internationaux de données',
    },
    '2cs2w8p0': {
      'en':
          'Some service providers used by Agricou may process personal data outside France or the European Economic Area.\n\nWhere personal data is transferred internationally, The Pinnacle Of Data will rely on an applicable transfer mechanism and safeguards required by data-protection law, where such safeguards are required. These may include an adequacy decision of the European Commission or appropriate contractual safeguards.\n\nFurther information about applicable safeguards may be requested using the contact details below.',
      'fr':
          'Certains prestataires de services utilisés par Agricou peuvent traiter des données personnelles en dehors de la France ou de l\'Espace économique européen. \n\nEn cas de transfert international de données personnelles, The Pinnacle Of Data s\'appuiera sur un mécanisme de transfert applicable et sur les garanties requises par la législation en matière de protection des données, lorsque ces garanties sont nécessaires. Il peut s\'agir notamment d\'une décision d\'adéquation de la Commission européenne ou de garanties contractuelles appropriées. \n\nPour plus d\'informations sur les garanties applicables, veuillez utiliser les coordonnées ci-dessous.',
    },
    'an5oyu5i': {
      'en': '10. Data Retention',
      'fr': '10. Conservation des données',
    },
    'gzb2jryo': {
      'en':
          'We retain personal data only for as long as necessary for the purposes for which it was collected and as required to meet applicable legal obligations.\n\nRetention periods vary depending on the nature of the information and the reason for processing. Account information is generally retained while the account remains active and may subsequently be retained for a limited period where necessary to establish, exercise or defend legal claims or comply with legal obligations.\n\nTransaction, invoice and accounting information may be retained for the periods required by applicable tax, accounting and commercial law.\n\nSupport requests, security logs and technical information are retained only for periods reasonably necessary for their respective purposes, subject to applicable legal requirements.\n\nWhen information is no longer required, it is deleted, anonymized or otherwise handled in accordance with applicable law.',
      'fr':
          'Nous conservons les données personnelles uniquement pendant la durée nécessaire aux fins pour lesquelles elles ont été collectées et conformément aux obligations légales applicables. \n\nLes durées de conservation varient selon la nature des informations et la finalité du traitement. Les informations de compte sont généralement conservées tant que le compte est actif et peuvent être conservées ultérieurement pendant une période limitée si nécessaire pour la constatation, l\'exercice ou la défense de droits en justice ou pour le respect des obligations légales. \n\nLes informations relatives aux transactions, aux factures et à la comptabilité peuvent être conservées pendant les durées requises par la législation fiscale, comptable et commerciale applicable. \n\nLes demandes d\'assistance, les journaux de sécurité et les informations techniques sont conservés uniquement pendant les durées raisonnablement nécessaires à leurs finalités respectives, sous réserve des exigences légales applicables. \n\nLorsque les informations ne sont plus nécessaires, elles sont supprimées, anonymisées ou traitées conformément à la législation applicable.',
    },
    'vipn2coe': {
      'en': '11. Security',
      'fr': '11. Sécurité',
    },
    'tnx2lnzq': {
      'en':
          'The Pinnacle Of Data implements appropriate technical and organizational measures intended to protect personal data against unauthorized access, loss, alteration, disclosure or destruction, taking into account the nature of the data, risks and available technologies.\n\nNo online system can guarantee absolute security. Users should therefore also protect their login credentials and promptly report suspected unauthorized access.',
      'fr':
          'Pinnacle Of Data met en œuvre des mesures techniques et organisationnelles appropriées visant à protéger les données personnelles contre tout accès non autorisé, perte, altération, divulgation ou destruction, en tenant compte de la nature des données, des risques et des technologies disponibles. \n\nAucun système en ligne ne peut garantir une sécurité absolue. Les utilisateurs doivent donc protéger leurs identifiants de connexion et signaler rapidement tout accès non autorisé suspecté.',
    },
    'r9dk0pn6': {
      'en': '12. Your Data Protection Rights',
      'fr': '12. Vos droits en matière de protection des données',
    },
    'kt6mfjio': {
      'en':
          'Subject to the conditions provided by applicable law, you may have the right to:\n\n• access your personal data;\n• correct inaccurate or incomplete data;\n• request deletion of your personal data;\n• request restriction of processing;\n• object to certain processing;\n• receive certain personal data in a portable format;\n• withdraw consent where processing is based on consent; and\n• provide instructions concerning your personal data where applicable under French law.\n\nYou may exercise applicable rights by contacting:\n\nsupport@agricou.com\n\nWe may need to verify your identity before responding to certain requests. Requests will be handled within the time limits required by applicable law.\n\nYou also have the right to lodge a complaint with the Commission Nationale de l\'Informatique et des Libertés (CNIL) or, where applicable, another competent data-protection authority.',
      'fr':
          'Sous réserve des conditions prévues par la loi applicable, vous disposez des droits suivants : \n- accéder à vos données personnelles ; \n- rectifier les données inexactes ou incomplètes ; \n- demander l’effacement de vos données personnelles ; \n- demander la limitation du traitement ; \n- vous opposer à certains traitements ; \n- recevoir certaines données personnelles dans un format portable ; \n- retirer votre consentement lorsque le traitement est fondé sur celui-ci ; \n- et donner des instructions concernant vos données personnelles lorsque la loi française l’exige. \n\nVous pouvez exercer vos droits en contactant : support@agricou.com. Nous pourrions avoir besoin de vérifier votre identité avant de répondre à certaines demandes. Les demandes seront traitées dans les délais prévus par la loi applicable. \n\nVous avez également le droit de déposer une plainte auprès de la Commission Nationale de l\'Informatique et des Libertés (CNIL) ou, le cas échéant, auprès d\'une autre autorité compétente en matière de protection des données.',
    },
    'bnc8alyg': {
      'en': '13. Account Deletion',
      'fr': '13. Suppression du compte',
    },
    '4biobyn4': {
      'en':
          'Where available, users may request deletion of their Agricou account through the application\'s account or privacy settings or by contacting support@agricou.com.\n\nAccount deletion does not necessarily result in immediate deletion of every item of personal data. Certain information may need to be retained where required by law or where a lawful basis exists for continued retention, including accounting, fraud prevention, dispute resolution or the establishment, exercise or defence of legal claims.\n\nData that no longer needs to be retained will be deleted or anonymized in accordance with applicable requirements.',
      'fr':
          'Lorsque cette option est disponible, les utilisateurs peuvent demander la suppression de leur compte Agricou via les paramètres de compte ou de confidentialité de l\'application ou en contactant support@agricou.com. \n\nLa suppression d\'un compte n\'entraîne pas nécessairement la suppression immédiate de toutes les données personnelles. Certaines informations peuvent devoir être conservées lorsque la loi l\'exige ou lorsqu\'il existe une base légale justifiant leur conservation, notamment à des fins comptables, de prévention de la fraude, de résolution des litiges ou pour la constatation, l\'exercice ou la défense de droits en justice. \n\nLes données qui n\'ont plus besoin d\'être conservées seront supprimées ou anonymisées conformément à la réglementation applicable.',
    },
    'pk7vlzlj': {
      'en': '14. Marketing and Notifications',
      'fr': '14. Marketing et notifications',
    },
    'l5vpqt4f': {
      'en':
          'Service communications necessary for account security, orders, transactions or important Platform information may be sent where permitted by law.\n\nMarketing communications will be handled in accordance with applicable consent and electronic-marketing requirements. Where applicable, users can unsubscribe from marketing emails using the unsubscribe mechanism provided.\n\nPush-notification permissions may be managed through the user\'s device settings.',
      'fr':
          'Les communications de service nécessaires à la sécurité du compte, aux commandes, aux transactions ou aux informations importantes concernant la plateforme peuvent être envoyées lorsque la loi le permet. \n\nLes communications marketing seront traitées conformément aux exigences applicables en matière de consentement et de marketing électronique. Le cas échéant, les utilisateurs peuvent se désabonner des e-mails marketing en utilisant le mécanisme de désabonnement prévu à cet effet. \n\nLes autorisations de notifications push peuvent être gérées via les paramètres de l\'appareil de l\'utilisateur.',
    },
    'uvbzcpxz': {
      'en': '15. Children',
      'fr': '15. Enfants',
    },
    'fwi4snu2': {
      'en':
          'Agricou is not intended to enable minors to independently enter into transactions for which they do not have the required legal capacity.\n\nWe do not knowingly seek to collect children\'s personal data contrary to applicable law. If you believe a child\'s personal data has been processed improperly, please contact us.',
      'fr':
          'Agricou n\'a pas pour but de permettre aux mineurs de conclure de manière autonome des transactions pour lesquelles ils ne disposent pas de la capacité juridique requise.\n\nNous ne cherchons pas sciemment à collecter des données personnelles d\'enfants en violation de la loi applicable. Si vous pensez que les données personnelles d\'un enfant ont été traitées de manière inappropriée, veuillez nous contacter.',
    },
    'txyy9cdi': {
      'en': '16. Changes to this Privacy Policy',
      'fr': '16. Modifications de la présente politique de confidentialité',
    },
    'cryw71wc': {
      'en':
          'We may update this Privacy Policy to reflect changes to Agricou, our processing activities, service providers or applicable legal requirements.\n\nWhere required, users will be informed of material changes and consent will be requested where a new processing activity requires it.\n\nThe current version will remain accessible through Agricou.',
      'fr':
          'Nous pouvons mettre à jour la présente Politique de confidentialité afin de refléter les changements apportés à Agricou, à nos activités de traitement, à nos fournisseurs de services ou aux exigences légales applicables. \n\nLe cas échéant, les utilisateurs seront informés des modifications importantes et leur consentement sera demandé lorsqu\'une nouvelle activité de traitement l\'exige. \n\nLa version actuelle restera accessible via Agricou.',
    },
    'srv1qcre': {
      'en': '17. Contact',
      'fr': '17. Contact',
    },
    'cjqjxhco': {
      'en':
          'For questions concerning this Privacy Policy or the processing of your personal data:\n\nThe Pinnacle Of Data – EURL\nSIREN: 929 478 485\n8 rue d’Hyères\n31240 L’Union, France\nEmail: support@agricou.com',
      'fr':
          'Pour toute question concernant cette politique de confidentialité ou le traitement de vos données personnelles : \n\nThe Pinnacle Of Data – EURL\nSIREN : 929 478 485\n8 rue d’Hyères\n31240 L’Union, France\nCourriel : support@agricou.com',
    },
    'ujuvnhjq': {
      'en': 'Privacy Policy',
      'fr': 'Politique de confidentialité',
    },
    '2uwvwwfo': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // farmerOnbording
  {
    '6ql646a0': {
      'en': 'Welcome to Agricou!',
      'fr': 'Bienvenue chez Agricoo !',
    },
    'f1xt5ap1': {
      'en':
          'Connect with local customers and grow your farm business. Let\'s get your farm profile set up.',
      'fr':
          'Développez votre clientèle locale et votre exploitation agricole. Créons ensemble le profil de votre ferme.',
    },
    'fvxsz5zv': {
      'en': 'Get Started',
      'fr': 'Commencer',
    },
    'jbkuw87o': {
      'en': '1',
      'fr': '1',
    },
    'spygp3c4': {
      'en': 'Set up your farm profile',
      'fr': 'Configurez votre profil d\'exploitation agricole',
    },
    '1k39droo': {
      'en': 'Add photos, details, and verification documents',
      'fr': 'Ajoutez des photos, des détails et des documents de vérification',
    },
    'tw4bvjjb': {
      'en': '2',
      'fr': '2',
    },
    'xeeo3aqj': {
      'en': 'Wait for verification',
      'fr': 'Veuillez patienter pour la vérification.',
    },
    'qje61gtf': {
      'en': 'We\'ll review your profile (24-48 hours)',
      'fr': 'Nous examinerons votre profil (24 à 48 heures).',
    },
    'mrsupb4d': {
      'en': '3',
      'fr': '3',
    },
    '0hhkyru4': {
      'en': 'Add your products',
      'fr': 'Ajoutez vos produits',
    },
    '2xquxgoi': {
      'en': 'List products after farm verification',
      'fr': 'Liste des produits après vérification de la ferme',
    },
    'vnbf157y': {
      'en': '4',
      'fr': '4',
    },
    '42xtigmp': {
      'en': 'Start selling!',
      'fr': 'Commencez à vendre !',
    },
    'tdfk6joe': {
      'en': 'Connect with local customers',
      'fr': 'Entrez en contact avec les clients locaux',
    },
    'wqxjvoom': {
      'en': 'What You\'ll Need',
      'fr': 'Ce dont vous aurez besoin',
    },
    '6sk4utkr': {
      'en': 'Farm photos and information',
      'fr': 'Photos et informations sur la ferme',
    },
    'vezvr3yq': {
      'en': 'Farm license or registration documents',
      'fr': 'documents de licence ou d\'enregistrement agricole',
    },
    'mwydmyjd': {
      'en': 'Government-issued ID',
      'fr': 'Pièce d\'identité officielle',
    },
    'mo6eboyt': {
      'en': 'Certifications (if applicable)',
      'fr': 'Certifications (le cas échéant)',
    },
    'ny2n33wj': {
      'en': 'Start Setup',
      'fr': 'Configuration de démarrage',
    },
    '4124chg8': {
      'en': 'Farmer Onboarding',
      'fr': 'Intégration des agriculteurs',
    },
    'wr1l0og8': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // farmerdetailsEntry
  {
    'zwkp7ob1': {
      'en': 'Farm Profile Photo',
      'fr': 'Photo de profil de la ferme',
    },
    'b2c7qper': {
      'en': 'JPG, PNG (max. 5MB)',
      'fr': 'JPG, PNG (max. 5 Mo)',
    },
    '3rozdqmn': {
      'en': 'Farm Photos',
      'fr': 'Photos de ferme',
    },
    '5vx0sv0c': {
      'en': 'Add Photos',
      'fr': 'Ajouter des photos',
    },
    'qab6f19e': {
      'en':
          'Add photos of your farm, crops, and facilities. High-quality photos build trust with customers.',
      'fr':
          'Ajoutez des photos de votre ferme, de vos cultures et de vos installations. Des photos de haute qualité inspirent confiance à vos clients.',
    },
    'd23g54my': {
      'en': 'Basic Information',
      'fr': 'Informations de base',
    },
    '2hcr1eoy': {
      'en': 'Farm name',
      'fr': 'Nom de la ferme',
    },
    'rt1c6yf9': {
      'en': 'eg., Sunshine farms',
      'fr': 'par exemple, Sunshine Farms',
    },
    'd0bhpoh2': {
      'en': 'Farm Type',
      'fr': 'Type de ferme',
    },
    '9l838jm0': {
      'en': 'eg., Organic vegetable farm',
      'fr': 'par exemple, une ferme maraîchère biologique',
    },
    'oh4yg0so': {
      'en': 'Year Established',
      'fr': 'Année de création',
    },
    'zlxv3xiq': {
      'en': 'eg., 2019',
      'fr': 'par exemple, 2019',
    },
    'o6prkvsg': {
      'en': 'Farm Size (acres)',
      'fr': 'Superficie de la ferme (acres)',
    },
    'vuib83jy': {
      'en': 'eg., 25',
      'fr': 'par exemple, 25',
    },
    '6733a39o': {
      'en': 'About Your Farm',
      'fr': 'À propos de votre ferme',
    },
    'g5oxtk9s': {
      'en': 'Description',
      'fr': 'Description',
    },
    'rr1l2oip': {
      'en': 'Tell customers about your farm...',
      'fr': 'Parlez de votre ferme à vos clients...',
    },
    'lupxnauv': {
      'en': 'A compelling description helps customers connect with your farm',
      'fr':
          'Une description attrayante aide les clients à se sentir proches de votre ferme.',
    },
    'k98az11y': {
      'en': 'Farm Specialities',
      'fr': 'Spécialités de la ferme',
    },
    's6cecdbl': {
      'en': 'eg., Organic vegetable farm,fruites ',
      'fr': 'ex., ferme maraîchère biologique, fruits',
    },
    '6zxo292j': {
      'en': 'Farm Practices',
      'fr': 'Pratiques agricoles',
    },
    'zgkvgx72': {
      'en': 'eg., Organic vegetable farm,fruites',
      'fr': 'ex., ferme maraîchère biologique, fruits',
    },
    'zrb0fvid': {
      'en': 'Farm Location',
      'fr': 'Emplacement de la ferme',
    },
    'p6bsrjqe': {
      'en': 'Select your farm location from Google maps',
      'fr': 'Sélectionnez l\'emplacement de votre ferme sur Google Maps.',
    },
    'wjpt78xw': {
      'en': 'Location Preview',
      'fr': 'Aperçu du lieu',
    },
    'cqr4bgai': {
      'en': 'Edit',
      'fr': 'Modifier',
    },
    'nyxwkq3k': {
      'en': 'Contact Information',
      'fr': 'Coordonnées',
    },
    'ef7bfof4': {
      'en': 'Phone Number',
      'fr': 'Numéro de téléphone',
    },
    'jknsr913': {
      'en': 'IN',
      'fr': 'DANS',
    },
    'l9uyv2l1': {
      'en': 'Email Address',
      'fr': 'Adresse email',
    },
    'wvkwm7uv': {
      'en': 'info@example.com',
      'fr': 'info@example.com',
    },
    'hwrzi7am': {
      'en': 'Continue',
      'fr': 'Continuer',
    },
    'u22txoh7': {
      'en': ' farms name is required',
      'fr': 'Le nom de la ferme est requis.',
    },
    'tne3uedv': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    '11mnlajr': {
      'en': ' farm type is required',
      'fr': 'Le type de ferme est requis.',
    },
    'l7283tvp': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'mxtfcb18': {
      'en': 'establiesh year is required',
      'fr': 'L\'année d\'établissement est requise.',
    },
    '9m6z8lar': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'zwzloewt': {
      'en': 'farm size ois required',
      'fr': 'La taille de la ferme est requise',
    },
    'rkinnhnj': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    '3bz2gs5j': {
      'en': ' Phone Number is required',
      'fr': 'Un numéro de téléphone est requis.',
    },
    'f8txam4p': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'xw92q8bz': {
      'en': 'Tell customers about your farm... is required',
      'fr': 'Parlez de votre ferme à vos clients... est obligatoire',
    },
    'a3itvmi8': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'l45bt6ad': {
      'en': 'farm specialities is required',
      'fr': 'Les spécialités agricoles sont requises',
    },
    '7jzs5mr5': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'niinh2sx': {
      'en': ' farm practices  is required',
      'fr': 'Les pratiques agricoles sont requises',
    },
    'z8qe74mh': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'fj3hi5g7': {
      'en': 'Farm address is required',
      'fr': 'L\'adresse de la ferme est requise.',
    },
    'hvp8hrpb': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'ri9n6e4i': {
      'en': 'farm city is required',
      'fr': 'une ville agricole est nécessaire',
    },
    'yx1ff2tq': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'iber1070': {
      'en': 'zip code is required',
      'fr': 'Le code postal est requis.',
    },
    '5mixbjak': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    '7ngjz5l5': {
      'en': '(555) 123-34545 is required',
      'fr': '(555) 123-34545 est requis',
    },
    'iiczsac0': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'ewfmcayq': {
      'en': 'email is required',
      'fr': 'L\'adresse e-mail est requise.',
    },
    'r1cispv7': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    '8y6obr6f': {
      'en': 'Farm license/ Registration',
      'fr': 'Licence/enregistrement agricole',
    },
    '0p2i83ld': {
      'en': 'Click to Upload \nPDF, JPG, PNG (max 10MB)',
      'fr': 'Cliquez pour téléverser un fichier \nPDF, JPG, PNG (10 Mo max.)',
    },
    'lo037rdv': {
      'en': 'Organic certification',
      'fr': 'Certification biologique',
    },
    'bo0u29wh': {
      'en': 'Click to Upload\nPDF, JPG, PNG (max 10MB)',
      'fr': 'Cliquez pour téléverser\n\nPDF, JPG, PNG (10 Mo max.)',
    },
    '0hyxvax9': {
      'en': 'Government ID',
      'fr': 'Carte d\'identité gouvernementale',
    },
    '5xnk02e1': {
      'en': 'Click to upload\nPDF, JPG, PNG (max 10MB)',
      'fr': 'Cliquez pour téléverser\n\nPDF, JPG, PNG (10 Mo max.)',
    },
    '9wsdzuw9': {
      'en': 'Verification Process',
      'fr': 'Processus de vérification',
    },
    '5piyi4ml': {
      'en': 'Your profile will be reviewed by our team within 24-48 hours',
      'fr':
          'Votre profil sera examiné par notre équipe dans un délai de 24 à 48 heures.',
    },
    'eyeet26d': {
      'en': 'You\'ll receive an email notification once verified',
      'fr':
          'Vous recevrez une notification par e-mail une fois la vérification effectuée.',
    },
    '95tzle5b': {
      'en': 'After verification, you can start adding products',
      'fr': 'Après vérification, vous pourrez commencer à ajouter des produits',
    },
    '41shd7lu': {
      'en': 'Each product will also require verification before going live',
      'fr':
          'Chaque produit devra également être vérifié avant sa mise en service.',
    },
    '3llaib8s': {
      'en': 'Submit for Verification',
      'fr': 'Soumettre pour vérification',
    },
    'b7d3ec3i': {
      'en': 'What Happens Next?',
      'fr': 'Que va-t-il se passer ensuite ?',
    },
    'vc00iaak': {
      'en': 'Our team will review your farm profile and documents',
      'fr':
          'Notre équipe examinera le profil et les documents de votre exploitation.',
    },
    'nprx85xh': {
      'en': 'You\'ll receive an email within 24-48 hours',
      'fr': 'Vous recevrez un courriel dans les 24 à 48 heures.',
    },
    'm211r5l3': {
      'en': 'Once approved, you can add products to your catalog',
      'fr':
          'Une fois votre demande approuvée, vous pourrez ajouter des produits à votre catalogue.',
    },
    'fkdh7sng': {
      'en': 'Each product will also need verification before going live',
      'fr':
          'Chaque produit devra également être vérifié avant sa mise en ligne.',
    },
    '53cpotq0': {
      'en': 'Next Steps',
      'fr': 'Prochaines étapes',
    },
    '9x2q9cie': {
      'en': 'Add more products to your catalog',
      'fr': 'Ajoutez d\'autres produits à votre catalogue.',
    },
    '37toahik': {
      'en': 'Set up your harvest schedule',
      'fr': 'Établissez votre calendrier de récolte',
    },
    'b3e6hue8': {
      'en': 'Configure delivery options',
      'fr': 'Configurer les options de livraison',
    },
    'xvp40f45': {
      'en': 'Log Out',
      'fr': 'Déconnexion',
    },
    '5mf1ftt5': {
      'en': 'Go to Dashboard',
      'fr': 'Accéder au tableau de bord',
    },
    'elymiq38': {
      'en': 'Profile Details',
      'fr': 'Détails du profil',
    },
    'pu83498j': {
      'en': 'We need basic details',
      'fr': 'Nous avons besoin de quelques informations de base.',
    },
    'ei3t0q47': {
      'en': 'KYC information',
      'fr': 'Informations KYC',
    },
    'e7j4onbl': {
      'en': 'We need to verify your farm and identity',
      'fr': 'Nous devons vérifier votre ferme et votre identité.',
    },
    'mgq4fco3': {
      'en': 'Farmer Onboarding',
      'fr': 'Intégration des agriculteurs',
    },
    'xm18ov2l': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // farmerdetailsEntrylast
  {
    '9so449fd': {
      'en': 'All Set!',
      'fr': 'Tout est prêt !',
    },
    'gj7ucu1a': {
      'en':
          'Your farm profile is ready. Start listing products and connecting with local customers.',
      'fr':
          'Votre profil agricole est prêt. Commencez à référencer vos produits et à entrer en contact avec les clients locaux.',
    },
    'aczqex1g': {
      'en': 'Next Steps',
      'fr': 'Prochaines étapes',
    },
    'bgiiq5i3': {
      'en': 'Add more products to your catalog',
      'fr': 'Ajoutez d\'autres produits à votre catalogue.',
    },
    '75q72g0k': {
      'en': 'Set up your harvest schedule',
      'fr': 'Établissez votre calendrier de récolte',
    },
    'v4tj2qlm': {
      'en': 'Once approved, you can add products to your catalog',
      'fr':
          'Une fois votre demande approuvée, vous pourrez ajouter des produits à votre catalogue.',
    },
    'd13ovqlx': {
      'en': 'Configure delivery options',
      'fr': 'Configurer les options de livraison',
    },
    'mh6ox89j': {
      'en': 'Go to Dashboard',
      'fr': 'Accéder au tableau de bord',
    },
    '0zze5nof': {
      'en': 'Profile Details',
      'fr': 'Détails du profil',
    },
    'cpr5valq': {
      'en': 'We need basic details',
      'fr': 'Nous avons besoin de quelques informations de base.',
    },
    'w1n3fzuj': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // producerHome
  {
    'zott9570': {
      'en': 'Products Listed',
      'fr': 'Produits listés',
    },
    'aoqd95nd': {
      'en': 'Active Orders',
      'fr': 'Commandes en cours',
    },
    'd6b6u9b0': {
      'en': 'Total Customers',
      'fr': 'Nombre total de clients',
    },
    'axogw25p': {
      'en': '\$',
      'fr': '\$',
    },
    'ntazoutk': {
      'en': '€',
      'fr': '€',
    },
    'o5tvoab2': {
      'en': 'Total Revenue',
      'fr': 'Revenu total',
    },
    'vyrxh6xt': {
      'en': 'Quick Actions',
      'fr': 'Actions rapides',
    },
    'fwheiik1': {
      'en': 'Manage Products',
      'fr': 'Gérer les produits',
    },
    'pkc5xf08': {
      'en': 'Got fresh harvest today? Add it now — it takes 1 minute.',
      'fr':
          'Vous avez récolté des produits frais aujourd\'hui ? Ajoutez-les maintenant — cela ne prend qu\'une minute.',
    },
    'ha0c14jw': {
      'en': 'View Products',
      'fr': 'Voir les produits',
    },
    'vw84g3u4': {
      'en': 'Manage Orders',
      'fr': 'Gérer les commandes',
    },
    'ta1yhoew': {
      'en': 'View, accept, or mark orders as completed.',
      'fr': 'Consulter, accepter ou marquer les commandes comme terminées.',
    },
    'a18ps0zs': {
      'en': 'View Orders',
      'fr': 'Afficher les commandes',
    },
    'm4o7pcpt': {
      'en': 'Production schedule',
      'fr': 'Calendrier de production',
    },
    'irpyid1s': {
      'en': 'Plan your crops for the highest yield.',
      'fr': 'Planifiez vos cultures pour obtenir le rendement le plus élevé.',
    },
    'ulphco87': {
      'en': 'View the calendar',
      'fr': 'Consultez le calendrier',
    },
    'f69ut8y7': {
      'en': 'Recent orders',
      'fr': 'Commandes récentes',
    },
    'odfk7kxl': {
      'en': 'View all',
      'fr': 'Afficher tout',
    },
    '01us9urq': {
      'en': '\$',
      'fr': '\$',
    },
    'zeymp39y': {
      'en': '€',
      'fr': '€',
    },
    'swdc6c7y': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // product
  {
    'hclmo1qn': {
      'en': 'Organic',
      'fr': 'Organique',
    },
    '1n5yxfe0': {
      'en': '\$',
      'fr': '\$',
    },
    '5kxu8mm7': {
      'en': '€',
      'fr': '€',
    },
    'mro4n2pk': {
      'en': 'No products found',
      'fr': 'Aucun produit trouvé',
    },
    'xbuoevdm': {
      'en': 'Your farm hasn\'t listed any items for sale yet.',
      'fr': 'Votre ferme n\'a encore mis aucun article en vente.',
    },
    'acnefpq5': {
      'en': 'Products',
      'fr': 'Produits',
    },
    'atzxuknk': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // Ordermanegement
  {
    'r9a3unzf': {
      'en': 'Search by  order id or name',
      'fr': 'Recherche par numéro de commande ou par nom',
    },
    '7ofkziyg': {
      'en': 'All',
      'fr': 'Tous',
    },
    '4kg76kib': {
      'en': 'Pending',
      'fr': 'En attente',
    },
    'yrd9heqb': {
      'en': 'Confirmed',
      'fr': 'Confirmé',
    },
    'cxim8jtn': {
      'en': 'Ready',
      'fr': 'Prêt',
    },
    'jm74jy1r': {
      'en': 'Picked Up',
      'fr': 'Ramassé',
    },
    'euuatml6': {
      'en': 'In Transit',
      'fr': 'En transit',
    },
    's8uh2zxl': {
      'en': 'Rejected',
      'fr': 'Rejeté',
    },
    '8c0ksdz1': {
      'en': 'Delivered',
      'fr': 'Livré',
    },
    '8l2hqmbi': {
      'en': '\$',
      'fr': '\$',
    },
    's6tuxxn8': {
      'en': '€',
      'fr': '€',
    },
    'k2jx6o84': {
      'en': 'No orders yet!',
      'fr': 'Aucune commande pour le moment !',
    },
    'ajsay6c3': {
      'en':
          'You don\'t have any orders in this category at the moment. Check back later or view your other tabs',
      'fr':
          'Vous n\'avez aucune commande dans cette catégorie pour le moment. Réessayez plus tard ou consultez vos autres onglets.',
    },
    'hv379lx5': {
      'en': 'Order Management',
      'fr': 'Gestion des commandes',
    },
    'o72x1280': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // scadule
  {
    'r8z4y6t7': {
      'en': 'Harvest Schedule',
      'fr': 'Calendrier des récoltes',
    },
    'rtib44az': {
      'en': 'Search',
      'fr': 'Recherche',
    },
    'a0jn53db': {
      'en': 'Ready to Harvest',
      'fr': 'Prêt à récolter',
    },
    'guxl71s8': {
      'en': 'Currently Growing',
      'fr': 'En cours de croissance',
    },
    '51zll2qw': {
      'en': 'All products',
      'fr': 'Tous les produits',
    },
    '1eke4rb2': {
      'en': 'Planted',
      'fr': 'Planté',
    },
    '5t8r3m2f': {
      'en': 'Expected Harvest',
      'fr': 'Récolte prévue',
    },
    'zimg3d0y': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // insights
  {
    'kyma505l': {
      'en': '\$',
      'fr': '\$',
    },
    '84m0jt8i': {
      'en': '€',
      'fr': '€',
    },
    'qnynujxy': {
      'en': 'Total Revenue',
      'fr': 'Revenu total',
    },
    '3m64nz9w': {
      'en': 'Total Orders',
      'fr': 'Commandes totales',
    },
    '2c4k1xq1': {
      'en': 'Customers',
      'fr': 'Clients',
    },
    'b97gv2q0': {
      'en': 'Avg Rating',
      'fr': 'Note moyenne',
    },
    '8csc4ghy': {
      'en': 'Customer Insights',
      'fr': 'Connaissances clients',
    },
    '8q09w8nk': {
      'en': 'Repeat \nCustomers',
      'fr': 'Clients réguliers\n',
    },
    '18p21kwm': {
      'en': 'Avg Order \nValue',
      'fr': 'Valeur moyenne de la commande \n',
    },
    'mdn0h40p': {
      'en': '\$',
      'fr': '\$',
    },
    '9javlu1n': {
      'en': '€',
      'fr': '€',
    },
    'arvqin0x': {
      'en': 'Performance Metrics',
      'fr': 'Indicateurs de performance',
    },
    'm6eeovun': {
      'en': 'On-Time Delivery',
      'fr': 'Livraison à temps',
    },
    '2bih7aj8': {
      'en': 'Product Quality Rating',
      'fr': 'Évaluation de la qualité du produit',
    },
    'fvp7gflh': {
      'en': 'Insights',
      'fr': 'Stats',
    },
    '80i4gtpa': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // producerProfile
  {
    '403djvxc': {
      'en': 'Profile',
      'fr': 'Profil',
    },
    '2tdq9j8s': {
      'en':
          'We couldn\'t process your latest subscription payment. Please update your payment method to keep your account active.',
      'fr':
          'Nous n\'avons pas pu traiter votre dernier paiement d\'abonnement. Veuillez mettre à jour votre mode de paiement pour que votre compte reste actif.',
    },
    'xw9gzvx7': {
      'en': 'Update now',
      'fr': 'Mettez à jour maintenant',
    },
    'smjpluuu': {
      'en': 'Products',
      'fr': 'Produits',
    },
    'dg0iqstw': {
      'en': 'Customers',
      'fr': 'Clients',
    },
    'z3zddq31': {
      'en': 'Rating',
      'fr': 'Notation',
    },
    'mj61b97y': {
      'en': 'Farm Settings',
      'fr': 'Paramètres de la ferme',
    },
    'wa5gefrl': {
      'en': 'Farm Information',
      'fr': 'Informations agricoles',
    },
    'nhb3v936': {
      'en': 'Farm Location',
      'fr': 'Emplacement de la ferme',
    },
    'l12m5lgt': {
      'en': 'Certifications',
      'fr': 'Certifications',
    },
    '4uwzran2': {
      'en': 'Delivery Setting',
      'fr': 'Cadre de livraison',
    },
    'cwtwwpfp': {
      'en': 'Account',
      'fr': 'Compte',
    },
    'ryrw5a81': {
      'en': 'Personal Information',
      'fr': 'Informations personnelles',
    },
    'ii6ny4ig': {
      'en': 'Subscription',
      'fr': 'Abonnement',
    },
    '82ybiib8': {
      'en': 'stripe connect',
      'fr': 'Stripe Connect',
    },
    '5sfe85if': {
      'en': 'Stripe Connect',
      'fr': 'Bande Connecter',
    },
    'ago0cfry': {
      'en': 'Complete Stripe Process',
      'fr': 'Processus Stripe complet',
    },
    '250v1v29': {
      'en': 'Enable payout and charge',
      'fr': 'Activer le paiement et la facturation',
    },
    'p4fubqs8': {
      'en': 'Account ID :',
      'fr': 'Identifiant du compte :',
    },
    'okfa9z6f': {
      'en': 'Business Type',
      'fr': 'Type d\'entreprise',
    },
    '4st1kxjx': {
      'en': 'Delete connect account',
      'fr': 'Supprimer le compte de connexion',
    },
    'jo02ks9k': {
      'en': 'Business Hours',
      'fr': 'Heures d\'ouverture',
    },
    '7so1bk0u': {
      'en': 'Break',
      'fr': 'Du lundi au vendredi',
    },
    'gxxz5zpo': {
      'en': 'Edit Hours',
      'fr': 'Heures de modification',
    },
    'a4hhbqud': {
      'en': 'Legal & Privacy',
      'fr': 'Mentions légales et confidentialité',
    },
    'xu7coy0z': {
      'en': 'Terms & Conditions',
      'fr': 'Conditions générales',
    },
    '5jsk9foe': {
      'en': 'Help & Support',
      'fr': 'Aide et assistance',
    },
    'ofmt82ao': {
      'en': 'Privacy Policy',
      'fr': 'politique de confidentialité',
    },
    's8gqzi60': {
      'en': 'Logout',
      'fr': 'Déconnexion',
    },
    'j99qr43o': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // FarmInformation
  {
    'okfsq72n': {
      'en': 'Farm Information',
      'fr': 'Informations agricoles',
    },
    '9z460myd': {
      'en': 'Change Photo',
      'fr': 'Changer de photo',
    },
    '96f9jac1': {
      'en': 'Basic Information',
      'fr': 'Informations de base',
    },
    'ebm1grhd': {
      'en': 'Farm Name',
      'fr': 'Nom de la ferme',
    },
    'ezjvdf4b': {
      'en': 'Enter Farm Name',
      'fr': 'Saisissez le nom de la ferme',
    },
    'er1u1up7': {
      'en': 'Farm Type',
      'fr': 'Type de ferme',
    },
    'e1xhdvyf': {
      'en': 'Enter Farm Type',
      'fr': 'Saisissez le type de ferme',
    },
    'q9zurmnq': {
      'en': 'Established Year',
      'fr': 'Année de création',
    },
    'mmlsftb0': {
      'en': 'Enter Established Year',
      'fr': 'Indiquez l\'année de création',
    },
    'zuuys14c': {
      'en': 'Farm Size',
      'fr': 'Taille de la ferme',
    },
    '993phjh6': {
      'en': 'Enter Farm Size',
      'fr': 'Saisissez la taille de l\'exploitation',
    },
    'gjhjc2ab': {
      'en': 'Acres',
      'fr': 'Acres',
    },
    'mgc2gok1': {
      'en': 'About Your Farm Availabity',
      'fr': 'À propos de la disponibilité de votre ferme',
    },
    'w46cp4ap': {
      'en': 'Farm Food Delivery areas',
      'fr': 'Zones de livraison de produits agricoles',
    },
    '3ica7ul9': {
      'en': 'Tap To Add Area',
      'fr': 'Appuyez pour ajouter une zone',
    },
    'uwd9hmdr': {
      'en': 'About Your Farm',
      'fr': 'À propos de votre ferme',
    },
    'pzzem911': {
      'en': 'Description',
      'fr': 'Description',
    },
    'hoqyfqei': {
      'en': 'Enter Description',
      'fr': 'Saisissez la description',
    },
    'z78mpdq4': {
      'en': 'Farm Specialities',
      'fr': 'Spécialités de la ferme',
    },
    'br70xnan': {
      'en': 'Enter Farm Specialitieson',
      'fr': 'Entrez les spécialités de la ferme sur',
    },
    'qb2k5veu': {
      'en': 'Farm Practices',
      'fr': 'Pratiques agricoles',
    },
    'wky0blzk': {
      'en': 'Enter Farm Practices',
      'fr': 'Saisir les pratiques agricoles',
    },
    '7ave9r9d': {
      'en': 'Farming methods',
      'fr': 'Méthodes agricoles',
    },
    '0cwgdakh': {
      'en': 'Farm methods seprate using comma(,)',
      'fr': 'Les méthodes agricoles sont séparées par une virgule (,)',
    },
    'ygop0p8b': {
      'en': 'Contact Information',
      'fr': 'Coordonnées',
    },
    'lq2nv9ry': {
      'en': 'Phone Number',
      'fr': 'Numéro de téléphone',
    },
    'c9sbinim': {
      'en': 'in',
      'fr': 'dans',
    },
    '1s9on3iv': {
      'en': 'Email',
      'fr': 'E-mail',
    },
    'b74ecwxu': {
      'en': 'Enter Email',
      'fr': 'Saisissez votre adresse e-mail',
    },
    'ce1i2fbh': {
      'en': 'Website',
      'fr': 'Site web',
    },
    'wneonbgw': {
      'en': 'Enter Website',
      'fr': 'Accéder au site web',
    },
    'c3ik5hj1': {
      'en': 'Save Changes',
      'fr': 'Enregistrer les modifications',
    },
    'mojs0qk7': {
      'en': 'farm_name is required',
      'fr': 'Le champ farm_name est requis.',
    },
    'u2wb6g1n': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    '9bd9tzc9': {
      'en': 'farm_type is required',
      'fr': 'Le type de ferme est requis.',
    },
    'nvkvl9yr': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    '6yipra1y': {
      'en': 'established_year is required',
      'fr': 'L\'année d\'établissement est requise.',
    },
    'lypz3owb': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'ld3cnugh': {
      'en': 'farm_size is required',
      'fr': 'La taille de la ferme est requise.',
    },
    'dn9m32n2': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'g0fssh83': {
      'en': 'about_farm is required',
      'fr': 'about_farm est requis',
    },
    'w7q3n8au': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'ni7xihi8': {
      'en': 'Enter Farm Specialitieson is required',
      'fr': 'Saisir la spécialité de la ferme est requis',
    },
    'ut81dqr8': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'b5o45g2v': {
      'en': 'Enter Farm Practices is required',
      'fr': 'Saisir les pratiques agricoles est requis',
    },
    'ciuin1w0': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'hkjrm9j9': {
      'en': 'Farm methods seprate using comma(,) is required',
      'fr': 'Les méthodes agricoles doivent être séparées par une virgule (,).',
    },
    'voz0yuwh': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'w4lqkpr5': {
      'en': 'phone_number is required',
      'fr': 'Le numéro de téléphone est requis.',
    },
    '2rubo9cj': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'j4nb1b8c': {
      'en': 'contact_email is required',
      'fr': 'L\'adresse e-mail de contact est requise.',
    },
    'dal2ck6q': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'zg2an1hp': {
      'en': 'website is required',
      'fr': 'Le site web est requis.',
    },
    'n69fhab4': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    '62gpcd79': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // producerpersonalInformation
  {
    'fxay6jje': {
      'en': 'Personal Information',
      'fr': 'Informations personnelles',
    },
    '2lrvv3ew': {
      'en': 'Change Photo',
      'fr': 'Changer de photo',
    },
    'wa6vei5e': {
      'en': 'Basic Information',
      'fr': 'Informations de base',
    },
    'ibbdt702': {
      'en': 'Display Name',
      'fr': 'Nom d\'affichage',
    },
    'ultzz0ik': {
      'en': 'Enter Full Name',
      'fr': 'Veuillez saisir votre nom complet.',
    },
    'k2w0dgpp': {
      'en': 'Email',
      'fr': 'E-mail',
    },
    'enkvzdo8': {
      'en': 'Enter Email',
      'fr': 'Saisissez votre adresse e-mail',
    },
    'zbak205x': {
      'en': 'Preferences',
      'fr': 'Préférences',
    },
    'lq3uho0b': {
      'en': 'Language',
      'fr': 'Langue',
    },
    'dzvqk8k2': {
      'en': 'Enter Language',
      'fr': 'Saisissez la langue',
    },
    'rpfq9rop': {
      'en': 'Update Profile',
      'fr': 'Mettre à jour le profil',
    },
    't7ial1aj': {
      'en': 'Delete Account',
      'fr': 'Supprimer le compte',
    },
    'g0dpt81u': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // FarmLocation
  {
    '5a2fiok6': {
      'en': 'Farm Location',
      'fr': 'Emplacement de la ferme',
    },
    '2j5ma8xo': {
      'en': 'Location Preview',
      'fr': 'Aperçu du lieu',
    },
    '8dzj5uo9': {
      'en': 'Edit',
      'fr': 'Modifier',
    },
    'nrqqzufv': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // certification
  {
    'z7s102b5': {
      'en': 'Add New Certification',
      'fr': 'Ajouter une nouvelle certification',
    },
    'tmcfui6e': {
      'en': 'Certificate Type',
      'fr': 'Type de certificat',
    },
    'i60f4dm3': {
      'en': 'eg., Rainfall Affricate',
      'fr': 'par exemple, l\'affriquée de la pluie',
    },
    '69gvcyza': {
      'en': 'Certificate ID',
      'fr': 'Identifiant du certificat',
    },
    'inlwivi3': {
      'en': 'eg., #GAP-2023-45678',
      'fr': 'par exemple, #GAP-2023-45678',
    },
    'arhkhaia': {
      'en': 'Issue Date',
      'fr': 'Date d\'émission',
    },
    'xjpxv5r3': {
      'en': 'Expire Date',
      'fr': 'Date d\'expiration',
    },
    'tqbp2b9u': {
      'en': 'Upload Document',
      'fr': 'Téléverser un document',
    },
    'ia46asyd': {
      'en': 'Click to upload\nJPG, PNG (max 10MB)',
      'fr': 'Cliquez pour téléverser\nJPG, PNG (10 Mo max.)',
    },
    'ou3mkqau': {
      'en': 'Submit',
      'fr': 'Soumettre',
    },
    '6gfqulpo': {
      'en': 'eg., Rainfall Affricate is required',
      'fr': 'Par exemple, l\'affriqué de pluie est requis',
    },
    'e6kg7huz': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'nkql40fq': {
      'en': 'eg., #GAP-2023-45678 is required',
      'fr': 'Par exemple, le numéro GAP-2023-45678 est requis.',
    },
    'ww0lo6r0': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    '8vcds91u': {
      'en': 'Why Add Certifications?',
      'fr': 'Pourquoi obtenir des certifications ?',
    },
    'jqoea4kh': {
      'en': 'Build trust with customers',
      'fr': 'Établir une relation de confiance avec les clients',
    },
    '79ypzxv0': {
      'en': 'Increase product visibility',
      'fr': 'Accroître la visibilité du produit',
    },
    '0fjh9ujm': {
      'en': 'Command premium prices',
      'fr': 'Commandez des prix premium',
    },
    'y3caxepd': {
      'en': 'Stand out from competitors',
      'fr': 'Démarquez-vous de la concurrence',
    },
    'kbilyv3d': {
      'en': 'Active Certifications',
      'fr': 'Certifications actives',
    },
    'q86grfdg': {
      'en': 'Verified',
      'fr': 'Vérifié',
    },
    'zdkm6y9n': {
      'en': 'Issued',
      'fr': 'Émis',
    },
    'tsamu709': {
      'en': 'Expires',
      'fr': 'Expire',
    },
    '5txlcapm': {
      'en': 'View Certificate image',
      'fr': 'Voir l\'image du certificat',
    },
    'vtdadq02': {
      'en': 'Pending Verification',
      'fr': 'En attente de vérification',
    },
    'l6pxonb8': {
      'en': 'Pending',
      'fr': 'En attente',
    },
    'qxkx9395': {
      'en': 'Application submitted',
      'fr': 'Demande soumise',
    },
    'v7ypznae': {
      'en': 'Estimated approval',
      'fr': 'Approbation estimée',
    },
    '5a4q8h10': {
      'en': '2-4 weeks',
      'fr': '2 à 4 semaines',
    },
    'bsu82adu': {
      'en':
          'Your application is under review. We\'ll notify you once it\'s processed.',
      'fr':
          'Votre demande est en cours d\'examen. Nous vous informerons dès qu\'elle sera traitée.',
    },
    '43fz3s85': {
      'en': 'Certifications',
      'fr': 'Certifications',
    },
    'f5plfm2r': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // Subscription
  {
    'w9hdv6la': {
      'en': 'Free',
      'fr': 'Gratuit',
    },
    'sfl9p0ns': {
      'en': 'Root Plan',
      'fr': 'Plan racine',
    },
    'a8ybaty1': {
      'en': 'Harvest Plan',
      'fr': 'Plan de récolte',
    },
    'ic1zppfi': {
      'en': 'Flavour Plan',
      'fr': 'Plan de saveurs',
    },
    'xe4z6qf7': {
      'en': 'Free',
      'fr': 'Gratuit',
    },
    'tw5eps3m': {
      'en': 'Start, Grow, and Get Noticed',
      'fr': 'Démarrez, développez-vous et faites-vous remarquer',
    },
    'f27umj6b': {
      'en': 'Free Trial',
      'fr': 'Essai gratuit',
    },
    'fwxgzj6t': {
      'en': 'Started',
      'fr': 'Commencé',
    },
    '5y2ddm82': {
      'en': 'Trial Ends',
      'fr': 'Fin du procès',
    },
    'j2bln5xb': {
      'en': 'Started',
      'fr': 'Commencé',
    },
    'n9b9lum3': {
      'en': 'Next Billing Date',
      'fr': 'Prochaine date de facturation',
    },
    'zg0vfqo7': {
      'en': 'View All Plans',
      'fr': 'Voir tous les forfaits',
    },
    '74jwn2jm': {
      'en': 'Cancel Subscription',
      'fr': 'Annuler l\'abonnement',
    },
    'nm3dl4sm': {
      'en': 'Billing History',
      'fr': 'Historique de facturation',
    },
    'mjzxtcx6': {
      'en': 'view invoice',
      'fr': 'voir la facture',
    },
    'fe0bw570': {
      'en': 'No billing history yet',
      'fr': 'Aucun historique de facturation pour le moment',
    },
    't4i8inbb': {
      'en': 'Features Included',
      'fr': 'Caractéristiques incluses',
    },
    'fuut9v50': {
      'en': 'Complete producer profile',
      'fr': 'Profil complet du producteur',
    },
    'vu2zdu70': {
      'en': 'Photos, logo, description, contact details',
      'fr': 'Photos, logo, description, coordonnées',
    },
    'itfqatpl': {
      'en': 'Personalized farm page',
      'fr': 'page de ferme personnalisée',
    },
    '8m368qqx': {
      'en': 'Presentation, opening hours, pickup points, type of production',
      'fr':
          'Présentation, horaires d\'ouverture, points de retrait, type de production',
    },
    'hp3ypvse': {
      'en': 'Agricoo map listing',
      'fr': 'Liste des cartes d\'Agricoo',
    },
    'g3hwx4d6': {
      'en': 'Your location visible to consumers',
      'fr': 'Votre localisation est visible par les consommateurs.',
    },
    'zjd4thdw': {
      'en': 'Farm visit communication',
      'fr': 'communication lors des visites à la ferme',
    },
    '02m4cx44': {
      'en': 'Indicate if farm is open to visitors and when',
      'fr':
          'Indiquez si la ferme est ouverte aux visiteurs et à quelles dates.',
    },
    'nvfskku4': {
      'en': 'Markets & partner stores visibility',
      'fr': 'visibilité des marchés et des magasins partenaires',
    },
    '83asbzki': {
      'en': 'Indicate if farm is open to visitors and when',
      'fr':
          'Indiquez si la ferme est ouverte aux visiteurs et à quelles dates.',
    },
    '3pmbfrxc': {
      'en': 'Social media & website links',
      'fr': 'Liens vers les réseaux sociaux et le site web',
    },
    'oab0n8g5': {
      'en': 'Specify where your products can be found',
      'fr': 'Précisez où vos produits peuvent être trouvés',
    },
    'g0t1epvc': {
      'en': '0% commission on direct sales',
      'fr': 'Commission de 0 % sur les ventes directes',
    },
    'vkgxf1wa': {
      'en': 'Excluding external Stripe fees',
      'fr': 'Hors frais Stripe externes',
    },
    'mupmwmf1': {
      'en': 'Basic email support',
      'fr': 'Assistance par e-mail de base',
    },
    '4bmdgv49': {
      'en': 'Need Help?',
      'fr': 'Besoin d\'aide ?',
    },
    'ai8mpl3a': {
      'en':
          'Have questions about your subscription? Contact our support team for assistance.',
      'fr':
          'Vous avez des questions concernant votre abonnement ? Contactez notre équipe d’assistance.',
    },
    'bkwrp4ae': {
      'en': 'Contact Support',
      'fr': 'Contacter l\'assistance',
    },
    '5g3d33xi': {
      'en': 'Subscription',
      'fr': 'Abonnement',
    },
    'j0mxipsc': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // SubscriptionPlans
  {
    'mgupjuz2': {
      'en': 'Launch Offer',
      'fr': 'Offre de lancement',
    },
    'aqakw5uu': {
      'en': 'Get the Roots Plan free for 3 months!',
      'fr': 'Obtenez le programme Roots gratuitement pendant 3 mois !',
    },
    'gotlmgwl': {
      'en': 'Monthly',
      'fr': 'Mensuel',
    },
    '7f5zkpg8': {
      'en': 'Yearly (save 20%)',
      'fr': 'Annuel (économisez 20 %)',
    },
    '89123gu5': {
      'en': 'Roots Plan',
      'fr': 'Plan Racines',
    },
    'l9o1oqct': {
      'en': 'Start, Grow, and Get Noticed',
      'fr': 'Démarrez, développez-vous et faites-vous remarquer',
    },
    '5jppmme8': {
      'en': 'Discovery, visibility, and first steps on the platform.',
      'fr': 'Découverte, visibilité et premiers pas sur la plateforme.',
    },
    'xcp8k9rb': {
      'en': 'Free for 3 months',
      'fr': 'Gratuit pendant 3 mois',
    },
    'kusjvayh': {
      'en': 'Features Included',
      'fr': 'Caractéristiques incluses',
    },
    '1d9oesbs': {
      'en': 'Complete producer profile',
      'fr': 'Profil complet du producteur',
    },
    'cqpuu5ow': {
      'en': 'Photos, logo, description, contact details',
      'fr': 'Photos, logo, description, coordonnées',
    },
    '4bepl0ne': {
      'en': 'Personalized farm page',
      'fr': 'page de ferme personnalisée',
    },
    'moyv8qkn': {
      'en': 'Presentation, opening hours, pickup points, type of production',
      'fr':
          'Présentation, horaires d\'ouverture, points de retrait, type de production',
    },
    '69lg1d9z': {
      'en': 'Agricoo map listing',
      'fr': 'Liste des cartes d\'Agricoo',
    },
    'k1ee04ae': {
      'en': 'Your location visible to consumers',
      'fr': 'Votre localisation est visible par les consommateurs.',
    },
    'plofdm8r': {
      'en': 'Farm visit communication',
      'fr': 'communication lors des visites à la ferme',
    },
    '9lfuol14': {
      'en': 'Indicate if farm is open to visitors and when',
      'fr':
          'Indiquez si la ferme est ouverte aux visiteurs et à quelles dates.',
    },
    'yepnpq8b': {
      'en': 'Markets & partner stores visibility',
      'fr': 'visibilité des marchés et des magasins partenaires',
    },
    '44wdampn': {
      'en': 'Indicate if farm is open to visitors and when',
      'fr':
          'Indiquez si la ferme est ouverte aux visiteurs et à quelles dates.',
    },
    'gb3f1umo': {
      'en': 'Social media & website links',
      'fr': 'Liens vers les réseaux sociaux et le site web',
    },
    'hpep5x7o': {
      'en': 'Specify where your products can be found',
      'fr': 'Précisez où vos produits peuvent être trouvés',
    },
    '6twesr9b': {
      'en': '0% commission on direct sales',
      'fr': 'Commission de 0 % sur les ventes directes',
    },
    'x9xx34p2': {
      'en': 'Excluding external Stripe fees',
      'fr': 'Hors frais Stripe externes',
    },
    '44ph31dg': {
      'en': 'Basic email support',
      'fr': 'Assistance par e-mail de base',
    },
    'ifm1gwp9': {
      'en': 'Click & Collect',
      'fr': 'Click & Collect',
    },
    'c5qua86r': {
      'en': 'Loyalty tools',
      'fr': 'Outils de fidélisation',
    },
    'imjbow17': {
      'en': 'Most Popular',
      'fr': 'Les plus populaires',
    },
    'cfkeug8o': {
      'en': 'Harvest Plan',
      'fr': 'Plan de récolte',
    },
    'mwknbi2r': {
      'en': 'Grow, Sell, and Reap the Benefits',
      'fr': 'Cultivez, vendez et récoltez les fruits',
    },
    'o88lpet4': {
      'en': 'Sales management, Click & Collect, and basic statistics.',
      'fr': 'Gestion des ventes, Click & Collect et statistiques de base.',
    },
    'chtlg936': {
      'en': 'Features Included',
      'fr': 'Caractéristiques incluses',
    },
    'y8ibjxjp': {
      'en': 'Everything from Roots Plan',
      'fr': 'Tout du plan Roots',
    },
    'run35q5h': {
      'en': 'Order history & tracking',
      'fr': 'Historique et suivi des commandes',
    },
    '4ad43pdh': {
      'en': 'Integrated sales management',
      'fr': 'Gestion intégrée des ventes',
    },
    '3y45vn29': {
      'en': 'Orders, inventory, prices, seasonal products',
      'fr': 'Commandes, inventaire, prix, produits saisonniers',
    },
    'pvroe7qx': {
      'en': 'Click & Collect',
      'fr': 'Click & Collect',
    },
    'tnaeh2oq': {
      'en': 'Farm pickup or meeting point deliveries',
      'fr': 'ramassage à la ferme ou livraisons à un point de rencontre',
    },
    'hf5mf6xo': {
      'en': 'Basic sales statistics',
      'fr': 'Statistiques de vente de base',
    },
    'd4mzaixh': {
      'en': 'Popular products, busy periods, total volume',
      'fr': 'Produits populaires, périodes de forte activité, volume total',
    },
    '0gy1ab9l': {
      'en': 'Automatic notifications',
      'fr': 'Notifications automatiques',
    },
    'xp0hyllu': {
      'en': 'New orders, customer messages',
      'fr': 'Nouvelles commandes, messages clients',
    },
    '8hzs6aqt': {
      'en': 'Secure payments via Stripe',
      'fr': 'Paiements sécurisés via Stripe',
    },
    'umkln345': {
      'en': 'Reduced fees, full transparency',
      'fr': 'Frais réduits, transparence totale',
    },
    'cbphgr3g': {
      'en': 'Loyalty & communication tools',
      'fr': 'Outils de fidélisation et de communication',
    },
    'j85d1od1': {
      'en': 'Advanced statistics',
      'fr': 'Statistiques avancées',
    },
    'txavnf8l': {
      'en': 'Premium Producer badge',
      'fr': 'badge Producteur Premium',
    },
    '5j0osb2u': {
      'en': 'Flavour Plan',
      'fr': 'Plan de saveurs',
    },
    'yhm4qjs1': {
      'en': 'Shine, Retain, and Showcase Your Expertise',
      'fr': 'Faites briller, conservez et mettez en valeur votre expertise',
    },
    'ppjg0x23': {
      'en': 'Delivery, promotions, and international visibility.',
      'fr': 'Livraison, promotions et visibilité internationale.',
    },
    'rx3w60l4': {
      'en': 'Features Included',
      'fr': 'Caractéristiques incluses',
    },
    'qgc8vpbs': {
      'en': 'Everything from Harvest Plan',
      'fr': 'Tout du plan de récolte',
    },
    'x5sfyy4c': {
      'en': 'Local, national, or international delivery',
      'fr': 'Livraison locale, nationale ou internationale',
    },
    'yo2n4pwl': {
      'en': 'Depending on available options',
      'fr': 'Selon les options disponibles',
    },
    'z1ye1lp5': {
      'en': 'Promo codes & customer discounts',
      'fr': 'Codes promotionnels et réductions client',
    },
    '7ntup7qw': {
      'en': 'Create and manage promotional campaigns',
      'fr': 'Créer et gérer des campagnes promotionnelles',
    },
    '5ygx4kv6': {
      'en': 'Automatic customer follow-ups',
      'fr': 'Suivi automatique des clients',
    },
    'b12f0dk1': {
      'en': 'For returning customers',
      'fr': 'Pour les clients fidèles',
    },
    '1frodqfg': {
      'en': 'Advanced statistics',
      'fr': 'Statistiques avancées',
    },
    'n53eu7fr': {
      'en': 'Average basket, repeat purchases, top areas, best-sellers',
      'fr':
          'Panier moyen, achats répétés, meilleures ventes, meilleures catégories',
    },
    '1ev42ecd': {
      'en': 'Workshop & farm visit bookings',
      'fr': 'Réservations d\'ateliers et de visites de fermes',
    },
    '3bdtmf5m': {
      'en': 'Free or paid events',
      'fr': 'événements gratuits ou payants',
    },
    'v4u6jcyq': {
      'en': 'Premium Producer badge',
      'fr': 'badge Producteur Premium',
    },
    '7bh2ekk7': {
      'en': 'Displayed on the Agricoo map',
      'fr': 'Affiché sur la carte Agricoo',
    },
    'i5khvjh7': {
      'en': 'Priority promotion',
      'fr': 'Promotion prioritaire',
    },
    'qgrsc06n': {
      'en': 'In Agricoo campaigns (website, social media, newsletters)',
      'fr':
          'Dans les campagnes Agricoo (site web, réseaux sociaux, newsletters)',
    },
    'ym84icz6': {
      'en': 'Flexible Plans',
      'fr': 'Plans flexibles',
    },
    'ncvq31jw': {
      'en':
          'You can upgrade, downgrade, or cancel your subscription at any time. Changes take effect at the start of your next billing cycle.',
      'fr':
          'Vous pouvez modifier votre abonnement à tout moment (passer à une formule supérieure, rétrograder ou l\'annuler). Les modifications prendront effet au début de votre prochain cycle de facturation.',
    },
    'f93d8ggt': {
      'en': 'Launch Special',
      'fr': 'Offre de lancement',
    },
    'kpwts88s': {
      'en':
          'All producers joining during our launch period get the Roots Plan completely free for the first 3 months. No credit card required to start!',
      'fr':
          'Tous les producteurs qui s\'inscrivent pendant notre période de lancement bénéficient du forfait Roots entièrement gratuit pendant les 3 premiers mois. Aucune carte de crédit n\'est requise pour commencer !',
    },
    '8ggx0oxp': {
      'en': 'Which plan is right for you?',
      'fr': 'Quel forfait vous convient le mieux ?',
    },
    'jr7n6dqd': {
      'en': 'Roots Plan',
      'fr': 'Plan Racines',
    },
    '3lpul80p': {
      'en':
          'Ideal for small producers, new farms, or artisans who want to test the platform, gain local visibility, and make their products known.',
      'fr':
          'Idéal pour les petits producteurs, les nouvelles exploitations agricoles ou les artisans qui souhaitent tester la plateforme, gagner en visibilité locale et faire connaître leurs produits.',
    },
    'wl3oecyn': {
      'en': 'Harvest Plan',
      'fr': 'Plan de récolte',
    },
    'lruayaar': {
      'en':
          'Ideal for producers who already sell locally and want to simplify their management, boost direct sales, and stay in control of their business.',
      'fr':
          'Idéal pour les producteurs qui vendent déjà localement et souhaitent simplifier leur gestion, dynamiser leurs ventes directes et garder le contrôle de leur entreprise.',
    },
    'cujy65k1': {
      'en': 'Flavors Plan',
      'fr': 'Plan de saveurs',
    },
    '2un511cx': {
      'en':
          'Ideal for farms, cooperatives, and artisans who want to grow their brand, build customer loyalty, and showcase their expertise - locally and internationally.',
      'fr':
          'Idéal pour les exploitations agricoles, les coopératives et les artisans qui souhaitent développer leur marque, fidéliser leur clientèle et mettre en valeur leur savoir-faire, tant au niveau local qu\'international.',
    },
    'i4k8ir5j': {
      'en': 'Need Help?',
      'fr': 'Besoin d\'aide ?',
    },
    'lmfvf92k': {
      'en':
          'Have questions about your subscription? Contact our support team for assistance.',
      'fr':
          'Vous avez des questions concernant votre abonnement ? Contactez notre équipe d’assistance.',
    },
    '47rc4ei1': {
      'en': 'Contact Support',
      'fr': 'Contacter l\'assistance',
    },
    '9vuig573': {
      'en': 'Subscription Plans',
      'fr': 'Formules d\'abonnement',
    },
    'b79q7gx0': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // splashpage1
  {
    'cxe9pb96': {
      'en': 'Agricoo',
      'fr': 'Agricoo',
    },
    '7k6t9xst': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // producerchat
  {
    'tfmi7zxx': {
      'en': 'Messages',
      'fr': 'Messages',
    },
    'kqi5g21d': {
      'en': 'Chat',
      'fr': 'Chat',
    },
  },
  // allfarms
  {
    'j8qn5kjw': {
      'en': 'Search..',
      'fr': 'Recherche..',
    },
    'i2dmztcc': {
      'en': 'View Farm',
      'fr': 'Voir la ferme',
    },
    '340sslio': {
      'en': 'No farms available',
      'fr': 'Aucune ferme disponible',
    },
    'ox18vkeg': {
      'en':
          'It looks like there aren\'t any farms registered in this location yet.',
      'fr':
          'Il semblerait qu\'aucune ferme ne soit encore enregistrée à cet endroit.',
    },
    'htc4j9xf': {
      'en': 'Filter',
      'fr': 'Filtre',
    },
    'd7w3q42f': {
      'en': 'Avaible days',
      'fr': 'Jours disponibles',
    },
    '0plb04q0': {
      'en': '',
      'fr': '',
    },
    '9cpa4n10': {
      'en': 'Farming Method',
      'fr': 'Méthode agricole',
    },
    'jlnf68yo': {
      'en': '',
      'fr': '',
    },
    'tr47lqky': {
      'en': 'Update',
      'fr': 'Mise à jour',
    },
    'wugjz7m8': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // producerproductDetailsPage
  {
    'd6u1so6v': {
      'en': '\$',
      'fr': '\$',
    },
    'd1cm2n0q': {
      'en': '€',
      'fr': '€',
    },
    'tulxxrgv': {
      'en': '4.9 (420 reviews)',
      'fr': '4,9 (420 avis)',
    },
    '78iq9mxg': {
      'en': 'Variety:',
      'fr': 'Variété:',
    },
    'bc5fbks5': {
      'en': 'Heirloom',
      'fr': 'Héritage',
    },
    'awmmf6nj': {
      'en': 'Origin:',
      'fr': 'Origine:',
    },
    'jypp1o2n': {
      'en': 'Paris, France',
      'fr': 'Paris, France',
    },
    '92stmatd': {
      'en': 'Season:',
      'fr': 'Saison:',
    },
    'mh4sal3j': {
      'en': 'Storage:',
      'fr': 'Stockage:',
    },
    '51yhjeih': {
      'en': 'Preparation:',
      'fr': 'Préparation:',
    },
    'bhwtbn5h': {
      'en': 'Same day',
      'fr': 'Le même jour',
    },
    'ta0cacts': {
      'en': 'Stock:',
      'fr': 'Action:',
    },
    '3mlligkg': {
      'en': 'Batch Information',
      'fr': 'Informations sur le lot',
    },
    'qy0yplz2': {
      'en': 'Customer Reviews',
      'fr': 'Avis clients',
    },
    'dr94vudb': {
      'en': 'Edit Product',
      'fr': 'Modifier le produit',
    },
    'kiaxj6uw': {
      'en': 'Delete Product',
      'fr': 'Supprimer le produit',
    },
    'revgunbn': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // ProducerChatConversation
  {
    'otmbq3w4': {
      'en': 'Type your message...',
      'fr': 'Saisissez votre message...',
    },
    'cif63zfp': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // mapsroutpage
  {
    'wzgtwqk6': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // mapsPageCopy
  {
    '2o2txk02': {
      'en': 'Filter',
      'fr': 'Filtre',
    },
    'm3urz4y3': {
      'en': 'Category',
      'fr': 'Catégorie',
    },
    '53wksj35': {
      'en': '',
      'fr': '',
    },
    'glfw325p': {
      'en': 'Farming Method',
      'fr': 'Méthode agricole',
    },
    'kgzqeel5': {
      'en': '',
      'fr': '',
    },
    '4ztl4j6y': {
      'en': 'Update',
      'fr': 'Mise à jour',
    },
    'infgd36r': {
      'en': 'Map',
      'fr': 'Panier',
    },
  },
  // farmAvailability
  {
    'lnxhx8gt': {
      'en': 'Weekly operating hours',
      'fr': 'Horaires d\'ouverture hebdomadaires',
    },
    'tbpgyigo': {
      'en':
          'Set your weekly operating hours for visitor access and deliveries.',
      'fr':
          'Définissez vos horaires d\'ouverture hebdomadaires pour l\'accès des visiteurs et les livraisons.',
    },
    'qegrd82d': {
      'en': 'Monday',
      'fr': 'Lundi',
    },
    'x88uzxwi': {
      'en': 'Start Time',
      'fr': 'Heure de début',
    },
    'ayfv5bzs': {
      'en': 'End Time',
      'fr': 'Fin des temps',
    },
    'z05orie9': {
      'en': 'Break',
      'fr': 'Casser',
    },
    'iqo2xare': {
      'en': 'Start Time',
      'fr': 'Heure de début',
    },
    's9466184': {
      'en': 'End Time',
      'fr': 'Fin des temps',
    },
    '4np62l6f': {
      'en': 'Closed for Visitors',
      'fr': 'Fermé aux visiteurs',
    },
    'q6u9gbjw': {
      'en': 'Tuesday',
      'fr': 'Mardi',
    },
    'on67tz5j': {
      'en': 'Start Time',
      'fr': 'Heure de début',
    },
    '9bidb8s7': {
      'en': 'End Time',
      'fr': 'Fin des temps',
    },
    'wb9v3otz': {
      'en': 'Break',
      'fr': 'Casser',
    },
    'nmj1prxu': {
      'en': 'Start Time',
      'fr': 'Heure de début',
    },
    'mcv9fv2q': {
      'en': 'End Time',
      'fr': 'Fin des temps',
    },
    'y5q6b4yh': {
      'en': 'Closed for Visitors',
      'fr': 'Fermé aux visiteurs',
    },
    '6bly46eb': {
      'en': 'Wednesday',
      'fr': 'Mercredi',
    },
    'ivdx3wk0': {
      'en': 'Start Time',
      'fr': 'Heure de début',
    },
    'u12d5q9w': {
      'en': 'End Time',
      'fr': 'Fin des temps',
    },
    'xcmp4c89': {
      'en': 'Break',
      'fr': 'Casser',
    },
    '04lr8jwi': {
      'en': 'Start Time',
      'fr': 'Heure de début',
    },
    '3qjneqzs': {
      'en': 'End Time',
      'fr': 'Fin des temps',
    },
    '90ln2t50': {
      'en': 'Closed for Visitors',
      'fr': 'Fermé aux visiteurs',
    },
    '0hmnovi5': {
      'en': 'Thursday',
      'fr': 'Jeudi',
    },
    '33yj9g88': {
      'en': 'Start Time',
      'fr': 'Heure de début',
    },
    '4vfyc3il': {
      'en': 'End Time',
      'fr': 'Fin des temps',
    },
    'ig82w5p1': {
      'en': 'Break',
      'fr': 'Casser',
    },
    '70welg78': {
      'en': 'Start Time',
      'fr': 'Heure de début',
    },
    '8b95lz42': {
      'en': 'End Time',
      'fr': 'Fin des temps',
    },
    '9xwkd7xy': {
      'en': 'Closed for Visitors',
      'fr': 'Fermé aux visiteurs',
    },
    '66lpe3if': {
      'en': 'Friday',
      'fr': 'Vendredi',
    },
    '9aogv7bt': {
      'en': 'Start Time',
      'fr': 'Heure de début',
    },
    'z5pest63': {
      'en': 'End Time',
      'fr': 'Fin des temps',
    },
    'te1o6uj6': {
      'en': 'Break',
      'fr': 'Casser',
    },
    'wt74wsrr': {
      'en': 'Start Time',
      'fr': 'Heure de début',
    },
    'h2ochrpy': {
      'en': 'End Time',
      'fr': 'Fin des temps',
    },
    'oni423eq': {
      'en': 'Closed for Visitors',
      'fr': 'Fermé aux visiteurs',
    },
    'w8v64drb': {
      'en': 'Saturday',
      'fr': 'Samedi',
    },
    'ssmo1u3u': {
      'en': 'Start Time',
      'fr': 'Heure de début',
    },
    'e07aqnfd': {
      'en': 'End Time',
      'fr': 'Fin des temps',
    },
    'psn5u7tc': {
      'en': 'Break',
      'fr': 'Casser',
    },
    '5nh1k98b': {
      'en': 'Start Time',
      'fr': 'Heure de début',
    },
    'ws8manqg': {
      'en': 'End Time',
      'fr': 'Fin des temps',
    },
    'ik3t8puz': {
      'en': 'Closed for Visitors',
      'fr': 'Fermé aux visiteurs',
    },
    'lvz1nxmf': {
      'en': 'Sunday',
      'fr': 'Dimanche',
    },
    'zmbauhoa': {
      'en': 'Start Time',
      'fr': 'Heure de début',
    },
    'qgp0394r': {
      'en': 'End Time',
      'fr': 'Fin des temps',
    },
    'kvrk1hu8': {
      'en': 'Break',
      'fr': 'Casser',
    },
    'ft1ldyz2': {
      'en': 'Start Time',
      'fr': 'Heure de début',
    },
    'u5czcqxl': {
      'en': 'End Time',
      'fr': 'Fin des temps',
    },
    'x02nlvqd': {
      'en': 'Closed for Visitors',
      'fr': 'Fermé aux visiteurs',
    },
    '3vueo042': {
      'en': 'Save',
      'fr': 'Sauvegarder',
    },
    'kutdzo6j': {
      'en': 'Farm Availability',
      'fr': 'Disponibilité à la ferme',
    },
    '58yc0wla': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // demo
  {
    'cbl30gm5': {
      'en': 'Select Location',
      'fr': 'Sélectionner l\'emplacement',
    },
    'xttmdxjn': {
      'en': 'Button',
      'fr': 'Bouton',
    },
    'kz0y9kyv': {
      'en': 'Page Title',
      'fr': 'Titre de la page',
    },
    '9mkjt1vk': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // Notifications
  {
    '67vgeyih': {
      'en': 'No Notification Found',
      'fr': 'Aucune notification trouvée',
    },
    '1eha970t': {
      'en': 'Notifications',
      'fr': 'Notifications',
    },
    'yf6afjgu': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // harvestdeliverysetting
  {
    'pncyr288': {
      'en': 'Set how customers receive your products',
      'fr': 'Définissez la manière dont vos clients reçoivent vos produits',
    },
    'jbrqjnz7': {
      'en': 'Pickup from Farm',
      'fr': 'Ramassage à la ferme',
    },
    'tutjr1lz': {
      'en': 'Enable customers to pick up orders directly from your farm.',
      'fr':
          'Permettez à vos clients de récupérer leurs commandes directement à la ferme.',
    },
    'fyx5oy7z': {
      'en':
          'Set your business hours for each day in your farm’s availability settings.',
      'fr':
          'Définissez vos heures d\'ouverture pour chaque jour dans les paramètres de disponibilité de votre ferme.',
    },
    'u41xzidr': {
      'en': 'Producer Delivery',
      'fr': 'Livraison du producteur',
    },
    'sngj0xyd': {
      'en': 'Deliver orders yourself using your own delivery method.',
      'fr':
          'Livrez vous-même les commandes en utilisant votre propre mode de livraison.',
    },
    'nbsun0wc': {
      'en': 'Delivery Radius (km)',
      'fr': 'Rayon de livraison (km)',
    },
    'uybfwk5i': {
      'en': '25',
      'fr': '25',
    },
    '4hzrlr9j': {
      'en': 'Flat Delivery Fee (\$)',
      'fr': 'Frais de livraison fixes (\$)',
    },
    'o5dfgf0d': {
      'en': '10.00',
      'fr': '10,00',
    },
    '9gkm8omk': {
      'en': 'Minimum Order Amount(\$)',
      'fr': 'Montant minimum de commande (\$)',
    },
    'hux7oxw3': {
      'en': '10.00',
      'fr': '10,00',
    },
    'vsibyem9': {
      'en': 'Free delivery above a certain amount (optional)(\$)',
      'fr':
          'Livraison gratuite au-delà d\'un certain montant (facultatif) (\$)',
    },
    'hesod48b': {
      'en': '10.00',
      'fr': '10,00',
    },
    'isy8v5cz': {
      'en': 'DeliveryRadiuskm is required',
      'fr': 'Le rayon de livraison (en km) est requis.',
    },
    'vbgakmih': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'wifmgipv': {
      'en': 'FlatDeliveryFee is required',
      'fr': 'Des frais de livraison fixes sont requis',
    },
    'axave6ym': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    '6bx0lrtm': {
      'en': 'MinimumAmmount is required',
      'fr': 'Un montant minimum est requis',
    },
    'vvyiz9wv': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'mk0tzfhr': {
      'en': 'freedelievryAmmount is required',
      'fr': 'freedelievryAmmount est requis',
    },
    'vw1x7sen': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'ey5dfrag': {
      'en': 'Save Delivery Settings',
      'fr': 'Enregistrer les paramètres de livraison',
    },
    '6re8ua60': {
      'en': 'Delivery Settings',
      'fr': 'Paramètres de livraison',
    },
    'icvwh3rt': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // rootdeliverysetting
  {
    'cv25uwwm': {
      'en': 'Roots Plan',
      'fr': 'Plan Racines',
    },
    '9j32dnk4': {
      'en': 'Showcase your farm and products to the Agricoo community.',
      'fr': 'Présentez votre ferme et vos produits à la communauté Agricoo.',
    },
    'phdcwu2c': {
      'en': 'Free',
      'fr': 'Gratuit',
    },
    'dehns2wo': {
      'en': 'Products visible only.',
      'fr': 'Produits visibles uniquement.',
    },
    'kau7l5g6': {
      'en':
          'Your products will be visible in the marketplace but customers cannot purchase them.',
      'fr':
          'Vos produits seront visibles sur la plateforme, mais les clients ne pourront pas les acheter.',
    },
    'x8c9lryk': {
      'en': 'Upgrade to Harvest to start selling',
      'fr': 'Passez à Harvest pour commencer à vendre',
    },
    '1jabf78f': {
      'en': 'Delivery Settings',
      'fr': 'Paramètres de livraison',
    },
    'a4y8cvqt': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // flavourdeliverysetting
  {
    'nbcp9juj': {
      'en': 'Set how customers receive your products',
      'fr': 'Définissez la manière dont vos clients reçoivent vos produits',
    },
    's8ra2eka': {
      'en': 'Pickup from Farm',
      'fr': 'Ramassage à la ferme',
    },
    'r730y9n8': {
      'en': 'Enable customers to pick up orders directly from your farm.',
      'fr':
          'Permettez à vos clients de récupérer leurs commandes directement à la ferme.',
    },
    'wvh18ad4': {
      'en':
          'Set your business hours for each day in your farm’s availability settings.',
      'fr':
          'Définissez vos heures d\'ouverture pour chaque jour dans les paramètres de disponibilité de votre ferme.',
    },
    'zvfopr7l': {
      'en': 'Producer Delivery',
      'fr': 'Livraison du producteur',
    },
    'inbkt2wa': {
      'en': 'Deliver orders yourself using your own delivery method.',
      'fr':
          'Livrez vous-même les commandes en utilisant votre propre mode de livraison.',
    },
    'g9ww80y5': {
      'en': 'Delivery Radius (km)',
      'fr': 'Rayon de livraison (km)',
    },
    'ksequ29d': {
      'en': '25',
      'fr': '25',
    },
    '4k7i9e3c': {
      'en': 'Flat Delivery Fee (\$)',
      'fr': 'Frais de livraison fixes (\$)',
    },
    'gwxoi4a3': {
      'en': '10.00',
      'fr': '10,00',
    },
    'yh7ujxks': {
      'en': 'Minimum Order Amount(\$)',
      'fr': 'Montant minimum de commande (\$)',
    },
    'kx5ne7fg': {
      'en': '10.00',
      'fr': '10,00',
    },
    'pqlhxql9': {
      'en': 'Free delivery above a certain amount (optional)(\$)',
      'fr':
          'Livraison gratuite au-delà d\'un certain montant (facultatif) (\$)',
    },
    '466qa3sz': {
      'en': '10.00',
      'fr': '10,00',
    },
    '7c0wm0zd': {
      'en': 'DeliveryRadiuskm is required',
      'fr': 'Le rayon de livraison (en km) est requis.',
    },
    'y1c9tca6': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'ndrdprlx': {
      'en': 'FlatDeliveryFee is required',
      'fr': 'Des frais de livraison fixes sont requis',
    },
    '8uyncxbs': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'obukqzsb': {
      'en': 'MinimumAmmount is required',
      'fr': 'Un montant minimum est requis',
    },
    'n9a5xdl2': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'jynq0gmn': {
      'en': 'freedelievryAmmount is required',
      'fr': 'freedelievryAmmount est requis',
    },
    '8cmvk7jo': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'g3pomufd': {
      'en': 'Agricoo Delivery',
      'fr': 'Livraison Agricoo',
    },
    'cmfa2w4v': {
      'en': 'Agricoo handles delivery and logistics for your orders.',
      'fr':
          'Agricoo se charge de la livraison et de la logistique de vos commandes.',
    },
    '0a5tm7oq': {
      'en':
          'The service will be activated in your area once a sufficient number of interested users is reached.',
      'fr':
          'Le service sera activé dans votre région dès qu\'un nombre suffisant d\'utilisateurs intéressés sera atteint.',
    },
    's6hbgbj5': {
      'en': 'Save Delivery Settings',
      'fr': 'Enregistrer les paramètres de livraison',
    },
    'otcsrrv8': {
      'en': 'Delivery Settings',
      'fr': 'Paramètres de livraison',
    },
    'ru5wdacy': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // selectOptionCopy
  {
    '64nikvk1': {
      'en': 'Welcome to Agricoo',
      'fr': 'Bienvenue chez Agricoo',
    },
    'qiza5nhp': {
      'en': 'I’m a Producer',
      'fr': 'Je suis producteur',
    },
    '0fmbvpii': {
      'en': 'sell my farm produce & grow\nmy reach',
      'fr':
          'Vendre les produits de ma ferme et étendre ma portée\n\nmon réseau',
    },
    '4u7ogjiv': {
      'en': 'I’m a Consumer',
      'fr': 'Je suis un consommateur',
    },
    '5l3774co': {
      'en': 'discover fresh produce & buy directly from farmers',
      'fr':
          'Découvrez des produits frais et achetez directement auprès des agriculteurs',
    },
    'p3sqzglo': {
      'en': 'Continue',
      'fr': 'Continuer',
    },
    '78zzideh': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // checkoutCopy
  {
    'pvk7zkq8': {
      'en': 'Delivery Method',
      'fr': 'Méthode de livraison',
    },
    'viziwc7w': {
      'en': 'Farm Pickup',
      'fr': 'Ramassage agricole',
    },
    '4frfnms5': {
      'en': 'Pick up directly',
      'fr': 'Retrait direct',
    },
    'hrjsuo8m': {
      'en': 'Free',
      'fr': 'Gratuit',
    },
    '6r0240qz': {
      'en': 'Farm Delivery',
      'fr': 'Livraison à la ferme',
    },
    '5e6ttsal': {
      'en': 'Delivered by the Farm directly',
      'fr': 'Livré directement par la ferme',
    },
    'rere5ey2': {
      'en': 'Charges',
      'fr': 'Frais',
    },
    '9rbrx4z0': {
      'en': 'Agricoo delivery',
      'fr': 'Livraison Agricoo',
    },
    'q8w6k508': {
      'en': 'Delivered by the Uber directly',
      'fr': 'Livraison directe par Uber',
    },
    '29uwzn1j': {
      'en': 'Charges',
      'fr': 'Frais',
    },
    'ewnbjzz3': {
      'en': 'Delivery Address',
      'fr': 'Adresse de livraison',
    },
    'zib5jqxy': {
      'en': 'Full Name',
      'fr': 'Nom et prénom',
    },
    '409xrzih': {
      'en': 'Enter your Name',
      'fr': 'Entrez votre nom',
    },
    'kteipcz5': {
      'en': 'Street Address',
      'fr': 'Adresse de la rue',
    },
    'nmthxfiw': {
      'en': 'Enter Street Address',
      'fr': 'Saisissez l\'adresse de la rue',
    },
    '0b29xww9': {
      'en': 'Phone Number',
      'fr': 'Numéro de téléphone',
    },
    't1md1wqu': {
      'en': 'Enter Phone Number',
      'fr': 'Saisissez le numéro de téléphone',
    },
    's470a0bq': {
      'en': 'change address',
      'fr': 'changer d\'adresse',
    },
    'ckonw3sq': {
      'en': 'Add address',
      'fr': 'Ajouter une adresse',
    },
    '337wdjp1': {
      'en': 'Continue',
      'fr': 'Continuer',
    },
    '19cxvvwp': {
      'en': 'Bill Details',
      'fr': 'Détails de la facture',
    },
    'h3zwc6yl': {
      'en': 'To Pay',
      'fr': 'Payer',
    },
    'yoo4kn2k': {
      'en': 'To Platform Fees',
      'fr': 'Frais de plateforme',
    },
    'ds6axn9v': {
      'en': '\$',
      'fr': '\$',
    },
    'i75nxd2l': {
      'en': '€',
      'fr': '€',
    },
    'jk7boj0x': {
      'en': 'Delivery Fees',
      'fr': 'Frais de livraison',
    },
    'pzbo7knj': {
      'en': '\$',
      'fr': '\$',
    },
    'l589o7ji': {
      'en': '€',
      'fr': '€',
    },
    'ppi6ezyn': {
      'en': 'Delivery Partner Fee',
      'fr': 'Frais du partenaire de livraison',
    },
    '5xh2jrku': {
      'en': '\$2.00',
      'fr': '2,00 \$',
    },
    'jm69g61c': {
      'en': 'GST and Charges',
      'fr': 'TPS et frais',
    },
    'kfe50txd': {
      'en': '\$1.10',
      'fr': '1,10 \$',
    },
    's9k9ai3t': {
      'en': 'Total Pay',
      'fr': 'Rémunération totale',
    },
    'kc2l9xmg': {
      'en': '\$',
      'fr': '\$',
    },
    'l51fwpx1': {
      'en': '€',
      'fr': '€',
    },
    '4ip438yj': {
      'en': 'Pay',
      'fr': 'Payer',
    },
    'm0ql2ox2': {
      'en': 'Checkout',
      'fr': 'Vérifier',
    },
    '0ugxy2xw': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // ProducerTerm
  {
    'b8xvir77': {
      'en':
          'AGRICOU – PRODUCER TERMS & CONDITIONS\nLast updated: 20 September 2026\n\nThese Producer Terms & Conditions (“Producer Terms”) govern the contractual relationship between The Pinnacle Of Data, operator of the Agricou platform (“Agricou”, “we”, “us” or “our”), and any farmer, producer or other professional seller who creates or uses a producer account on Agricou (“Producer”, “you” or “your”).\n\nThese Producer Terms supplement Agricou’s general Terms of Service and Privacy Policy. In the event of a conflict concerning the Producer’s professional use of Agricou, these Producer Terms shall prevail to the extent of that conflict.\n\nBy creating a Producer account, subscribing to a Producer plan or using Agricou to promote or sell products, you acknowledge that you have read and accepted these Producer Terms.',
      'fr':
          'AGRICOU – CONDITIONS GÉNÉRALES PRODUCTEURS\nDernière mise à jour : 20 septembre 2026\n\nLes présentes Conditions Générales Producteurs (« Conditions Producteurs ») régissent la relation contractuelle entre The Pinnacle Of Data, opérateur de la plateforme Agricou (« Agricou », « nous », « notre »), et tout agriculteur, producteur ou autre vendeur professionnel créant ou utilisant un compte producteur sur Agricou (« Producteur », « vous », « votre »).\n\nCes Conditions Producteurs complètent les Conditions Générales d’Utilisation et la Politique de Confidentialité d’Agricou. En cas de conflit relatif à l’utilisation professionnelle d’Agricou par le Producteur, les présentes Conditions Producteurs prévaudront.\n\nEn créant un compte Producteur, en souscrivant à un abonnement Producteur ou en utilisant Agricou pour promouvoir ou vendre des produits, vous reconnaissez avoir lu et accepté les présentes Conditions Producteurs.',
    },
    'aem1gaa0': {
      'en': '1. Purpose and Scope',
      'fr': '1. Objet et portée',
    },
    'wv2loefv': {
      'en':
          'These Producer Terms & Conditions (“Producer Terms”) govern the use of Agricou by farmers, agricultural producers and other professional sellers (“Producer”, “you” or “your”).\n\nAgricou is operated by The Pinnacle Of Data – EURL, SIREN 929 478 485, registered at 8 rue d’Hyères, 31240 L’Union, France (“Agricou”, “we”, “us” or “our”).\n\nAgricou provides a digital platform enabling Producers to present their activity and products and, depending on the subscription plan selected, offer products for sale to consumers, manage orders and access pickup and delivery functionalities.\n\nUnless expressly stated otherwise, Agricou acts as an intermediary platform and is not the seller, producer, manufacturer or owner of the products offered by Producers.\n\nThese Producer Terms supplement Agricou’s general Terms of Service and Privacy Policy. In the event of a conflict concerning professional use of Agricou by a Producer, these Producer Terms shall prevail to the extent of that conflict.',
      'fr':
          'Les présentes Conditions Générales Producteurs (« Conditions Producteurs ») régissent l’utilisation d’Agricou par les agriculteurs, producteurs agricoles et autres vendeurs professionnels (« Producteur », « vous » ou « votre »).\n\nAgricou est exploité par The Pinnacle Of Data – EURL, SIREN 929 478 485, immatriculée au 8 rue d’Hyères, 31240 L’Union, France (« Agricou », « nous », « notre »).\n\nAgricou fournit une plateforme numérique permettant aux Producteurs de présenter leur activité et leurs produits et, selon la formule d’abonnement choisie, de proposer leurs produits à la vente aux consommateurs, de gérer leurs commandes et d’accéder aux services de retrait et de livraison.\n\nSauf mention contraire, Agricou agit en tant que plateforme d’intermédiation et n’est ni le vendeur, ni le producteur, ni le fabricant, ni le propriétaire des produits proposés par les Producteurs.\n\nLes présentes Conditions Producteurs complètent les Conditions Générales d’Utilisation et la Politique de Confidentialité d’Agricou. En cas de conflit concernant l’utilisation professionnelle d’Agricou par un Producteur, les présentes Conditions Producteur prévaudront dans la mesure de ce conflit.',
    },
    'y70l5ihm': {
      'en': '2. Producer Eligibility and Account',
      'fr': '2. Admissibilité et compte du producteur',
    },
    'rcfd57e1': {
      'en':
          'A Producer account is intended for persons or entities acting in the course of a professional or commercial activity.\n\nThe Producer represents and warrants that they have the legal capacity and all registrations, authorisations, licences, certifications and other requirements necessary to carry out their activity and sell the products offered through Agricou.\n\nThe Producer must provide accurate, complete and current information when creating and maintaining their account.\n\nAgricou may request reasonable documents or information necessary to verify the Producer’s identity, professional activity, payment information or compliance with applicable requirements.\n\nThe Producer is responsible for maintaining the confidentiality and security of their account credentials and for activity conducted through their account, except where responsibility cannot legally be attributed to the Producer.\n\nThe Producer must promptly update any information that becomes inaccurate or incomplete.',
      'fr':
          'Un compte Producteur est destiné aux personnes physiques ou morales exerçant une activité professionnelle ou commerciale.\n\nLe Producteur déclare et garantit avoir la capacité juridique et posséder toutes les inscriptions, autorisations, licences, certifications et autres qualifications nécessaires à l’exercice de son activité et à la vente des produits proposés par Agricou.\n\nLe Producteur doit fournir des informations exactes, complètes et à jour lors de la création et de la gestion de son compte.\n\nAgricou peut demander les documents ou informations nécessaires à la vérification de l’identité du Producteur, de son activité professionnelle, de ses informations de paiement ou de sa conformité aux exigences applicables.\n\nLe Producteur est responsable de la confidentialité et de la sécurité de ses identifiants de compte et des activités menées par son intermédiaire, sauf lorsque la responsabilité ne peut lui être légalement imputée.\n\nLe Producteur doit mettre à jour sans délai toute information inexacte ou incomplète.',
    },
    '4jd264kb': {
      'en': '3. Producer Subscription Plans',
      'fr': '3. Formules d\'abonnement pour producteurs',
    },
    '20bh0yad': {
      'en':
          'Agricou currently offers the following Producer plans:\n\nRoots Plan\n\n€4.90 per month or €49 per year.\n\nThe Roots Plan provides visibility for the Producer and their products on Agricou. Products may be displayed but cannot be purchased through Agricou under this plan.\n\nSelling, Click & Collect, Farmer Delivery and Agricou Delivery are not included.\n\nHarvest Plan\n\n€29.90 per month or €299 per year.\n\nThe Harvest Plan allows the Producer to offer products for sale through Agricou and includes Click & Collect and Farmer Delivery according to the functionalities and rules made available by Agricou.\n\nWhere Farmer Delivery is used, the Producer is responsible for performing or organising the delivery and the applicable delivery fee is intended for the Producer, subject to the payment arrangements displayed on the Platform.\n\nAgricou Delivery is not included in the Harvest Plan.\n\nFlavors Plan\n\n€69.90 per month or €699 per year.\n\nThe Flavors Plan includes selling through Agricou, Click & Collect and Farmer Delivery, together with access to Agricou Delivery where that service is available and subject to the applicable conditions, geographical coverage, operational capacity and delivery rules.\n\nWhere Agricou Delivery is selected, the applicable delivery fee is intended for Agricou to cover or contribute to the delivery service.\n\nThe availability and precise functionality of each plan may depend on technical, operational and geographical conditions.',
      'fr':
          'Agricou propose actuellement les formules Producteur suivantes :\n\nFormule Racines\n\n4,90 € par mois ou 49 € par an.\n\nLa formule Racines offre une visibilité au Producteur et à ses produits sur Agricou. Les produits peuvent être affichés, mais ne peuvent pas être achetés via Agricou avec cette formule.\n\nLa vente, le Click & Collect, la livraison par le Producteur et la livraison Agricou ne sont pas inclus.\n\nFormule Récolte\n\n29,90 € par mois ou 299 € par an.\n\nLa formule Récolte permet au Producteur de proposer ses produits à la vente via Agricou et inclut le Click & Collect et la livraison par le Producteur, conformément aux fonctionnalités et règles mises à disposition par Agricou.\n\nEn cas de livraison par le Producteur, ce dernier est responsable de l’exécution ou de l’organisation de la livraison et les frais de livraison applicables lui sont destinés, sous réserve des modalités de paiement affichées sur la plateforme.\n\nLa livraison Agricou n’est pas incluse dans la formule Récolte.\n\nFormule Saveurs\n\n69,90 € par mois ou 699 € par an.\n\nLe forfait Saveurs inclut la vente via Agricou, le Click & Collect et la livraison par le producteur, ainsi que l\'accès à la livraison Agricou là où ce service est disponible et sous réserve des conditions applicables, de la couverture géographique, des capacités opérationnelles et des règles de livraison.\n\nSi la livraison Agricou est choisie, les frais de livraison applicables sont destinés à être pris en charge par Agricou, en totalité ou en partie.\n\nLa disponibilité et les fonctionnalités précises de chaque forfait peuvent dépendre de conditions techniques, opérationnelles et géographiques.',
    },
    'nyzurbn9': {
      'en': '4. Subscription Billing, Renewal and Changes',
      'fr': '4. Facturation, renouvellement et modifications des abonnements',
    },
    'xg00iwxj': {
      'en':
          'The applicable subscription price and billing frequency are displayed before subscription.\n\nDepending on the option selected, subscriptions may be billed monthly or annually.\n\nWhere automatic renewal is offered and selected, the subscription will renew for the applicable billing period unless cancelled in accordance with the cancellation mechanism made available by Agricou.\n\nAny applicable taxes will be handled in accordance with applicable law and the information displayed at the time of subscription.\n\nAgricou may change subscription prices or the content of its plans prospectively. Where legally required, affected Producers will receive prior notice before the changes take effect and will have any termination rights required by applicable law.\n\nExcept where required by law or expressly stated otherwise, amounts already due for an elapsed subscription period are not refundable merely because the Producer stops using the Platform during that period.',
      'fr':
          'Le prix de l\'abonnement et la fréquence de facturation sont affichés avant la souscription.\n\nSelon l\'option choisie, l\'abonnement peut être facturé mensuellement ou annuellement.\n\nEn cas de renouvellement automatique, l\'abonnement sera reconduit pour la période de facturation en cours, sauf annulation selon la procédure mise à disposition par Agricou.\n\nLes taxes applicables seront gérées conformément à la législation en vigueur et aux informations affichées lors de la souscription.\n\nAgricou se réserve le droit de modifier les prix des abonnements ou le contenu de ses offres. Lorsque la loi l\'exige, les producteurs concernés seront informés au préalable et disposeront des droits de résiliation prévus par la loi.\n\nSauf disposition légale contraire ou mention expresse, les sommes déjà dues pour une période d\'abonnement écoulée ne sont pas remboursables du seul fait de l\'arrêt d\'utilisation de la plateforme par le producteur pendant cette période.',
    },
    '6cf4mjwp': {
      'en': '5. Sales and Relationship with Consumers',
      'fr': '5. Ventes et relations avec les consommateurs',
    },
    'fceu29e6': {
      'en':
          'Where selling is enabled under the Producer’s plan, the Producer is the seller of the products purchased by the consumer.\n\nThe sales contract for the products is concluded between the Producer and the consumer. Agricou facilitates the transaction but does not become the seller or owner of the Producer’s products merely by providing the Platform.\n\nThe Producer is responsible for fulfilling all obligations applicable to the Producer-consumer relationship, including mandatory pre-contractual information, product conformity, product safety, pricing, invoicing where required, fulfilment, applicable consumer rights and handling of complaints relating to the products.\n\nNothing in these Producer Terms limits any mandatory rights available to consumers under applicable law.',
      'fr':
          'Lorsque la vente est autorisée dans le cadre du plan du Producteur, ce dernier est le vendeur des produits achetés par le consommateur.\n\nLe contrat de vente des produits est conclu entre le Producteur et le consommateur. Agricou facilite la transaction, mais ne devient ni le vendeur ni le propriétaire des produits du Producteur du simple fait de fournir la Plateforme.\n\nLe Producteur est responsable du respect de toutes les obligations applicables à la relation producteur-consommateur, notamment l’information précontractuelle obligatoire, la conformité et la sécurité des produits, la tarification, la facturation le cas échéant, l’exécution des commandes, les droits des consommateurs et le traitement des réclamations relatives aux produits.\n\nAucune disposition des présentes Conditions du Producteur ne limite les droits impératifs dont disposent les consommateurs en vertu de la loi applicable.',
    },
    '42cenl3w': {
      'en': '6. Prices, Product Payments and Agricou Service Fee',
      'fr': '6. Prix, paiements des produits et frais de service agricole',
    },
    'ju6varcu': {
      'en':
          'The Producer determines the selling price of their products, subject to applicable law and the technical rules of the Platform.\n\nAgricou currently charges the Producer 0% platform commission on the value of products sold through Agricou.\n\nAccordingly, the product sale amount is intended to be paid to the Producer, subject to payment processing, refunds, disputes, chargebacks, taxes and other adjustments that may lawfully apply.\n\nSeparately, Agricou may charge the consumer a service fee equal to 1% of the relevant order amount, capped at €3 per order.\n\nThis consumer service fee is charged by Agricou and is separate from the Producer’s product price. It does not constitute a commission deducted from the Producer’s product sale price.\n\nApplicable delivery fees may also be charged separately according to the delivery method selected.\n\nAgricou may modify its fee structure in the future subject to applicable notice requirements and these Producer Terms.',
      'fr':
          'Le producteur fixe le prix de vente de ses produits, conformément à la législation applicable et aux règles techniques de la plateforme.\n\nActuellement, Agricou ne prélève aucune commission auprès du producteur sur la valeur des produits vendus via sa plateforme.\n\nLe montant de la vente est donc destiné au producteur, sous réserve du traitement des paiements, des remboursements, des litiges, des annulations de paiement, des taxes et autres ajustements légaux.\n\nPar ailleurs, Agricou peut facturer au consommateur des frais de service équivalant à 1 % du montant de la commande, plafonnés à 3 € par commande.\n\nCes frais de service sont facturés par Agricou et sont distincts du prix du produit. Ils ne constituent pas une commission déduite du prix de vente du produit.\n\nDes frais de livraison peuvent également être facturés séparément selon le mode de livraison choisi.\n\nAgricou se réserve le droit de modifier sa grille tarifaire ultérieurement, sous réserve des préavis applicables et des présentes Conditions générales du producteur.',
    },
    'v8ui54p4': {
      'en': '7. Payment Processing',
      'fr': '7. Traitement des paiements',
    },
    'dw77eldc': {
      'en':
          'Payments may be processed through third-party payment service providers, including Stripe.\n\nThe Producer may be required to create, connect or maintain an account with the relevant payment provider and provide any identity, banking, tax or business information required by that provider.\n\nPayment services may also be governed by the payment provider’s own terms and conditions.\n\nAgricou does not guarantee that a payment will be authorised, completed or free from disputes, chargebacks, technical failures or regulatory review.\n\nThe Producer must cooperate reasonably in the investigation of payment disputes, suspected fraud, refunds and chargebacks relating to their transactions.',
      'fr':
          'Les paiements peuvent être traités par des prestataires de services de paiement tiers, tels que Stripe.\n\nLe Producteur peut être amené à créer, connecter ou gérer un compte auprès du prestataire de paiement concerné et à fournir les informations d\'identité, bancaires, fiscales ou commerciales requises par ce dernier.\n\nLes services de paiement peuvent également être soumis aux conditions générales du prestataire de paiement.\n\nAgricou ne garantit pas l\'autorisation, la finalisation ni l\'absence de litiges, de rejets de paiement, de défaillances techniques ou de contrôles réglementaires liés aux paiements.\n\nLe Producteur est tenu de coopérer pleinement aux enquêtes relatives aux litiges de paiement, aux suspicions de fraude, aux remboursements et aux rejets de paiement concernant ses transactions.',
    },
    'yhc8f1xa': {
      'en': '8. Product Listings and Producer Information',
      'fr': '8. Liste des produits et informations sur les producteurs',
    },
    'gr1cfriw': {
      'en':
          'The Producer is solely responsible for the accuracy, legality and completeness of information supplied concerning their activity and products.\n\nProduct listings must accurately describe the product offered, including where applicable its nature, quantity, weight or weight range, unit, price, origin, availability and any information required by applicable law.\n\nWhere products are sold according to variable weight or quantity, the Producer must comply with the applicable functionality and pricing rules implemented by Agricou and provide accurate information to the consumer.\n\nThe Producer must not publish misleading, deceptive, unlawful or materially inaccurate information.\n\nProducts that are unavailable must be marked unavailable or removed within a reasonable period.',
      'fr':
          'Le producteur est seul responsable de l’exactitude, de la légalité et de l’exhaustivité des renseignements fournis concernant son activité et ses produits.\n\nLes fiches de produits doivent décrire avec précision le produit offert, y compris, le cas échéant, sa nature, la quantité, le poids ou la fourchette de poids, l’unité de mesure, le prix, l’origine, la disponibilité et tout renseignement exigé par la loi applicable.\n\nLorsque les produits sont vendus selon un poids ou une quantité variable, le producteur doit se conformer aux règles de fonctionnalité et de tarification applicables mises en œuvre par Agricou et fournir des renseignements exacts au consommateur.\n\nLe producteur ne doit pas publier de renseignements trompeurs, mensongers, illégaux ou matériellement inexacts.\n\nLes produits indisponibles doivent être signalés comme tels ou retirés dans un délai raisonnable.',
    },
    'yqsu1ueb': {
      'en': '9. Food Safety and Regulatory Compliance',
      'fr': '9. Sécurité alimentaire et conformité réglementaire',
    },
    'tep07fb3': {
      'en':
          'The Producer remains responsible for compliance with all laws and regulations applicable to their activity and products.\n\nDepending on the products concerned, this may include requirements relating to food safety and hygiene, traceability, labelling, allergens, storage, temperature control, packaging, weights and measures, product origin, agricultural production, taxation and any required professional registration or authorisation.\n\nThe Producer must not offer products whose sale is prohibited or for which they do not possess the necessary legal authorisation.\n\nAgricou may remove or restrict a listing where reasonably necessary for legal compliance, consumer safety, Platform security or enforcement of these Producer Terms.',
      'fr':
          'Le producteur demeure responsable du respect de toutes les lois et réglementations applicables à son activité et à ses produits.\n\nSelon les produits concernés, cela peut inclure des exigences relatives à la sécurité et à l\'hygiène alimentaires, à la traçabilité, à l\'étiquetage, aux allergènes, au stockage, au contrôle de la température, à l\'emballage, aux poids et mesures, à l\'origine des produits, à la production agricole, à la fiscalité et à toute inscription ou autorisation professionnelle requise.\n\nLe producteur ne doit pas proposer de produits dont la vente est interdite ou pour lesquels il ne possède pas l\'autorisation légale requise.\n\nAgricou peut supprimer ou restreindre une annonce lorsque cela est raisonnablement nécessaire pour des raisons de conformité légale, de sécurité des consommateurs, de sécurité de la plateforme ou d\'application des présentes Conditions générales du producteur.',
    },
    'cab20j5g': {
      'en': '10. Orders and Availability',
      'fr': '10. Commandes et disponibilité',
    },
    'n3c4th1r': {
      'en':
          'The Producer is responsible for keeping product availability and relevant information reasonably up to date.\n\nWhen a valid order is accepted or otherwise becomes binding under the applicable purchasing process, the Producer must prepare and fulfil the order in accordance with the information communicated to the consumer.\n\nIf the Producer cannot fulfil an order, they must use the available Platform functionality or contact the relevant parties as soon as reasonably possible.\n\nRepeated unjustified cancellations, persistent inaccurate availability or failure to fulfil confirmed orders may result in restrictions or suspension in accordance with these Producer Terms.',
      'fr':
          'Le Producteur est responsable de la mise à jour régulière des informations relatives à la disponibilité des produits et à leur contenu.\n\nLorsqu\'une commande valide est acceptée ou devient contraignante conformément au processus d\'achat applicable, le Producteur doit la préparer et l\'honorer conformément aux informations communiquées au consommateur.\n\nSi le Producteur est dans l\'impossibilité d\'honorer une commande, il doit utiliser les fonctionnalités de la Plateforme ou contacter les parties concernées dans les meilleurs délais.\n\nDes annulations injustifiées et répétées, des informations de disponibilité constamment erronées ou le non-respect des commandes confirmées peuvent entraîner des restrictions ou une suspension conformément aux présentes Conditions Générales du Producteur.',
    },
    '3p12znso': {
      'en': '11. Click & Collect',
      'fr': '11. Click & Collect',
    },
    '7upwd6eb': {
      'en':
          'Where Click & Collect is available under the Producer’s plan, the Producer is responsible for preparing the order and making it available at the agreed location and within the communicated collection arrangements.\n\nThe Producer must provide accurate collection information and take reasonable steps to ensure that the correct order is provided to the correct customer.\n\nAny specific food preservation or safety requirements remain the Producer’s responsibility until responsibility for the products passes in accordance with applicable law.',
      'fr':
          'Lorsque le service Click & Collect est disponible dans le cadre du plan du producteur, ce dernier est responsable de la préparation de la commande et de sa mise à disposition à l\'endroit convenu, selon les modalités de retrait communiquées.\n\nLe producteur doit fournir des informations de retrait exactes et prendre les mesures raisonnables pour s\'assurer que la bonne commande est remise au bon client.\n\nLe respect des exigences spécifiques en matière de conservation et de sécurité alimentaire demeure la responsabilité du producteur jusqu\'à ce que la responsabilité des produits soit transférée conformément à la législation applicable.',
    },
    'irdbo6ux': {
      'en': '12. Farmer Delivery',
      'fr': '12. Livraison par l\'agriculteur',
    },
    '011mtr0c': {
      'en':
          'Where Farmer Delivery is available and selected, the Producer is responsible for organising and performing the delivery in accordance with the information presented to the consumer.\n\nThe Producer is responsible for defining and complying with any delivery conditions made available through Agricou, including applicable geographical areas, availability and operational conditions.\n\nThe applicable Farmer Delivery fee is intended for the Producer, subject to the payment arrangements displayed on the Platform.\n\nThe Producer remains responsible for appropriate transportation and handling of the products, including compliance with applicable food safety or temperature requirements.',
      'fr':
          'Lorsque la livraison par le producteur est disponible et sélectionnée, ce dernier est responsable de l\'organisation et de la réalisation de la livraison conformément aux informations fournies au consommateur.\n\nLe producteur est responsable de la définition et du respect des conditions de livraison proposées par Agricou, notamment en ce qui concerne les zones géographiques, la disponibilité et les conditions opérationnelles.\n\nLes frais de livraison par le producteur sont à la charge du producteur, selon les modalités de paiement affichées sur la plateforme.\n\nLe producteur demeure responsable du transport et de la manutention appropriés des produits, y compris du respect des exigences applicables en matière de sécurité alimentaire et de température.',
    },
    'n06c7e1h': {
      'en': '13. Agricou Delivery',
      'fr': '13. Livraison agricole',
    },
    'xgpdj4so': {
      'en':
          'The Flavors Plan may provide access to an Agricou-organised delivery solution (“Agricou Delivery”) in eligible locations.\n\nAgricou Delivery may involve grouping orders and may rely on independent third-party delivery providers, including services provided through third-party delivery platforms.\n\nAvailability is not guaranteed for every Producer, consumer, address, product, date or time.\n\nThe delivery fee applicable to Agricou Delivery is intended for Agricou and may be used to cover or contribute to delivery and operational costs.\n\nThe Producer remains responsible for correctly preparing, packaging and identifying the products before collection and for complying with applicable requirements concerning the products.\n\nAgricou is not responsible for acts or omissions of independent third-party providers beyond the extent to which responsibility may legally be attributed to Agricou.',
      'fr':
          'Le Plan Saveurs peut donner accès à un service de livraison organisé par Agricou (« Livraison Agricou ») dans les zones éligibles.\n\nLa Livraison Agricou peut impliquer le regroupement des commandes et faire appel à des prestataires de livraison tiers indépendants, notamment via des plateformes de livraison tierces.\n\nLa disponibilité n\'est pas garantie pour tous les producteurs, consommateurs, adresses, produits, dates ou heures.\n\nLes frais de livraison applicables à la Livraison Agricou sont destinés à Agricou et peuvent servir à couvrir ou à contribuer à ses coûts de livraison et d\'exploitation.\n\nLe producteur demeure responsable de la préparation, de l\'emballage et de l\'identification corrects des produits avant leur enlèvement, ainsi que du respect des exigences applicables.\n\nAgricou décline toute responsabilité pour les actes ou omissions des prestataires tiers indépendants, au-delà de la limite de responsabilité qui lui est légalement imputée.',
    },
    '9df4puaz': {
      'en': '14. Cancellations, Refunds and Complaints',
      'fr': '14. Annulations, remboursements et réclamations',
    },
    'ne1mjle9': {
      'en':
          'Cancellations and refunds must be handled in accordance with applicable law, the nature of the product, the circumstances of the transaction and the rules displayed on Agricou.\n\nCertain products, including some perishable goods, may be subject to exceptions from statutory withdrawal rights where the legal conditions for those exceptions are satisfied.\n\nThe Producer is responsible for complaints concerning the quality, conformity, description, quantity or safety of products sold by the Producer.\n\nAgricou may facilitate communications, refunds or dispute resolution but doing so does not make Agricou the seller of the products.\n\nWhere a refund, chargeback or other adjustment results from the Producer’s breach, failure to fulfil an order, inaccurate listing or other circumstance attributable to the Producer, corresponding amounts may be recovered or adjusted to the extent permitted by law and the applicable payment arrangements.',
      'fr':
          'Les annulations et les remboursements doivent être traités conformément à la législation applicable, à la nature du produit, aux circonstances de la transaction et aux règles affichées sur Agricou.\n\nCertains produits, notamment certains produits périssables, peuvent faire l\'objet d\'exceptions au droit de rétractation légal lorsque les conditions légales applicables sont remplies.\n\nLe producteur est responsable des réclamations relatives à la qualité, la conformité, la description, la quantité ou la sécurité des produits qu\'il vend.\n\nAgricou peut faciliter la communication, les remboursements ou le règlement des litiges, mais cette intervention ne fait pas d\'Agricou le vendeur des produits.\n\nSi un remboursement, une rétrofacturation ou tout autre ajustement résulte d\'un manquement du producteur, d\'un défaut d\'exécution de commande, d\'une fiche produit inexacte ou de toute autre circonstance imputable au producteur, les montants correspondants peuvent être recouvrés ou ajustés dans la mesure permise par la loi et les modalités de paiement applicables.',
    },
    'pmeecr99': {
      'en': '15. Ranking, Search and Visibility',
      'fr': '15. Classement, recherche et visibilité',
    },
    'c7bfl903': {
      'en':
          'Products and Producers may be displayed or ranked according to parameters used by Agricou to provide relevant results to consumers.\n\nDepending on the functionality concerned, the principal parameters may include geographical proximity or relevance to a user’s selected location or route, product category and filters selected by the user, product availability, opening or collection availability, compatibility with the requested delivery or collection method, and other criteria directly selected by the user.\n\nTechnical or operational factors may also affect whether and where a listing appears.\n\nSubscription plans affect access to functionality as expressly described in these Producer Terms. For example, Roots provides visibility without selling functionality, while Harvest and Flavors provide additional commercial functionalities.\n\nUnless expressly identified on the Platform, payment of a subscription does not guarantee a particular position in search results, a minimum level of visibility, traffic, orders or sales.\n\nAgricou may modify its ranking systems over time. Material changes affecting Producers will be handled in accordance with applicable transparency requirements.',
      'fr':
          'Les produits et les producteurs peuvent être affichés ou classés selon les paramètres utilisés par Agricou afin de fournir des résultats pertinents aux consommateurs.\n\nSelon la fonctionnalité concernée, les principaux paramètres peuvent inclure la proximité géographique ou la pertinence par rapport au lieu ou à l\'itinéraire sélectionné par l\'utilisateur, la catégorie de produit et les filtres sélectionnés par ce dernier, la disponibilité du produit, les horaires d\'ouverture ou de retrait, la compatibilité avec le mode de livraison ou de retrait demandé, ainsi que d\'autres critères directement sélectionnés par l\'utilisateur.\n\nDes facteurs techniques ou opérationnels peuvent également influencer l\'affichage et le positionnement d\'une annonce.\n\nLes formules d\'abonnement ont une incidence sur l\'accès aux fonctionnalités, comme indiqué dans les présentes Conditions générales pour les producteurs. Par exemple, l\'abonnement Roots offre une visibilité sans fonctionnalité de vente, tandis que les abonnements Harvest et Flavors offrent des fonctionnalités commerciales supplémentaires.\n\nSauf mention contraire sur la Plateforme, le paiement d\'un abonnement ne garantit pas un positionnement particulier dans les résultats de recherche, un niveau minimal de visibilité, de trafic, de commandes ou de ventes.\n\nAgricou se réserve le droit de modifier ses systèmes de classement. Les modifications importantes affectant les producteurs seront traitées conformément aux exigences de transparence applicables.',
    },
    '2qbdbp1z': {
      'en': '16. Reviews and Consumer Content',
      'fr': '16. Avis et contenu des consommateurs',
    },
    '1ozwiaby': {
      'en':
          'Agricou may allow consumers to publish ratings, reviews or other content concerning Producers or transactions.\n\nAgricou does not guarantee that reviews will be positive.\n\nAgricou may moderate or remove reviews or other content where reasonably necessary to enforce Platform rules, comply with law, address fraud or abuse, or protect users and the integrity of the Platform.\n\nProducers must not manipulate reviews, create false reviews, offer undisclosed incentives for misleading reviews or improperly pressure consumers to alter legitimate feedback.',
      'fr':
          'Agricou peut permettre aux consommateurs de publier des évaluations, des commentaires ou d\'autres contenus concernant les producteurs ou les transactions.\n\nAgricou ne garantit pas que les commentaires seront positifs.\n\nAgricou peut modérer ou supprimer les commentaires ou autres contenus lorsque cela est raisonnablement nécessaire pour faire respecter les règles de la plateforme, se conformer à la loi, lutter contre la fraude ou les abus, ou protéger les utilisateurs et l\'intégrité de la plateforme.\n\nLes producteurs ne doivent pas manipuler les commentaires, créer de faux commentaires, offrir des incitations non divulguées pour des commentaires trompeurs ni exercer de pression indue sur les consommateurs pour qu\'ils modifient des commentaires légitimes.',
    },
    'pbtpb91o': {
      'en': '17. Producer Content and Intellectual Property',
      'fr': '17. Contenu du producteur et propriété intellectuelle',
    },
    'ts81g92w': {
      'en':
          'The Producer retains ownership of intellectual property rights they hold in photographs, logos, trademarks, descriptions and other content supplied to Agricou.\n\nBy uploading or submitting such content, the Producer grants Agricou a non-exclusive, worldwide, royalty-free licence, for the duration necessary to provide and promote the Agricou services, to host, store, reproduce, display, format and technically adapt that content for operation and promotion of the Platform and the Producer’s listings.\n\nThis licence does not transfer ownership of the Producer’s intellectual property to Agricou.\n\nThe Producer represents that they possess the rights necessary to provide and authorise use of the submitted content.\n\nAgricou retains all rights in the Agricou name, trademarks, software, interface, design, databases and other proprietary elements belonging to Agricou or its licensors.',
      'fr':
          'Le Producteur conserve la propriété des droits de propriété intellectuelle qu\'il détient sur les photographies, logos, marques, descriptions et autres contenus fournis à Agricou.\n\nEn téléchargeant ou en soumettant ces contenus, le Producteur concède à Agricou une licence non exclusive, mondiale et gratuite, pour la durée nécessaire à la fourniture et à la promotion des services Agricou, autorisant l\'hébergement, le stockage, la reproduction, l\'affichage, la mise en forme et l\'adaptation technique de ces contenus pour le fonctionnement et la promotion de la Plateforme et des annonces du Producteur.\n\nCette licence n\'entraîne aucun transfert de propriété intellectuelle du Producteur à Agricou.\n\nLe Producteur déclare détenir les droits nécessaires pour fournir et autoriser l\'utilisation des contenus soumis.\n\nAgricou conserve tous les droits sur son nom, ses marques, ses logiciels, son interface, son design, ses bases de données et autres éléments propriétaires appartenant à Agricou ou à ses concédants de licence.',
    },
    'f5yq0uro': {
      'en': '18. Data and Access to Data',
      'fr': '18. Données et accès aux données',
    },
    '0wotk3tj': {
      'en':
          'Personal data is processed in accordance with Agricou’s Privacy Policy and applicable data protection law.\n\nThrough the Platform, Producers may have access to information necessary to manage their activity, such as information relating to their products, orders and transactions, subject to applicable law, privacy requirements and the functionality of their plan.\n\nProducers must use consumer information obtained through Agricou only for legitimate purposes connected with the relevant transaction, customer service, legal obligations or another lawful basis.\n\nConsumer data obtained through Agricou must not be sold, misused or used for unrelated unsolicited marketing where such use is not lawful.\n\nAgricou may access and process data generated through use of the Platform for operating, securing, maintaining and improving its services, preventing fraud, providing support, performing analytics and complying with legal obligations, in accordance with applicable law and the Privacy Policy.\n\nFollowing termination, access to Platform data may cease. Agricou may retain certain information where required or permitted by law, including for accounting, security, fraud prevention, dispute management, legal claims and regulatory compliance, in accordance with applicable retention periods.',
      'fr':
          'Les données personnelles sont traitées conformément à la Politique de confidentialité d\'Agricou et à la législation applicable en matière de protection des données.\n\nPar le biais de la Plateforme, les Producteurs peuvent accéder aux informations nécessaires à la gestion de leur activité, telles que les informations relatives à leurs produits, commandes et transactions, sous réserve de la législation applicable, des exigences en matière de protection des données et des fonctionnalités de leur abonnement.\n\nLes Producteurs doivent utiliser les informations des consommateurs obtenues via Agricou uniquement à des fins légitimes liées à la transaction concernée, au service client, aux obligations légales ou à tout autre fondement juridique.\n\nLes données des consommateurs obtenues via Agricou ne doivent pas être vendues, utilisées à mauvais escient ni utilisées à des fins de prospection commerciale non sollicitée et sans lien avec l\'activité, lorsque cette utilisation est illégale.\n\nAgricou peut accéder aux données générées par l\'utilisation de la Plateforme et les traiter afin d\'exploiter, de sécuriser, de maintenir et d\'améliorer ses services, de prévenir la fraude, de fournir une assistance, d\'effectuer des analyses et de se conformer à ses obligations légales, conformément à la législation applicable et à la Politique de confidentialité.\n\nAprès la résiliation de l\'abonnement, l\'accès aux données de la Plateforme peut être interrompu. Agricou peut conserver certaines informations lorsque la loi l\'exige ou le permet, notamment à des fins comptables, de sécurité, de prévention de la fraude, de gestion des litiges, de réclamations et de conformité réglementaire, conformément aux durées de conservation applicables.',
    },
    'tkwly2wn': {
      'en': '19. Third-Party Services',
      'fr': '19. Services de tiers',
    },
    'oht64cjx': {
      'en':
          'Agricou may integrate or rely upon services provided by third parties, including payment, authentication, mapping, analytics, notification, hosting and delivery providers.\n\nUse of certain functionality may therefore also be subject to the relevant third party’s terms, policies, availability and technical requirements.\n\nAgricou does not control independent third-party services and cannot guarantee their uninterrupted availability.',
      'fr':
          'Agricou peut intégrer ou utiliser des services fournis par des tiers, notamment des prestataires de paiement, d\'authentification, de cartographie, d\'analyse, de notification, d\'hébergement et de livraison.\n\nL\'utilisation de certaines fonctionnalités peut donc être soumise aux conditions générales, politiques, disponibilités et exigences techniques des tiers concernés.\n\nAgricou n\'exerce aucun contrôle sur les services de tiers indépendants et ne peut garantir leur disponibilité continue.',
    },
    '6gj4lsvc': {
      'en': '20. Prohibited Conduct',
      'fr': '20. Comportements interdits',
    },
    'v5k4b6he': {
      'en':
          'Producers must not use Agricou to:\n\n- offer unlawful, prohibited, unsafe, fraudulent or misleading products;\n- impersonate another person or business;\n- provide intentionally false professional or product information;\n- manipulate orders, payments, reviews or Platform functionality;\n- interfere with the security or operation of Agricou;\n- introduce malware or malicious code;\nmisuse consumer personal data;\n- infringe intellectual property or other rights of third parties;\n- circumvent fees or technical restrictions through fraudulent or abusive means; or \n- use Agricou in violation of applicable law.',
      'fr':
          'Les producteurs ne doivent pas utiliser Agricou pour :\n\n- proposer des produits illégaux, interdits, dangereux, frauduleux ou trompeurs ;\n\n- usurper l’identité d’une autre personne ou entreprise ;\n\n- fournir intentionnellement de fausses informations professionnelles ou relatives aux produits ;\n\n- manipuler les commandes, les paiements, les avis ou les fonctionnalités de la plateforme ;\n\n- nuire à la sécurité ou au fonctionnement d’Agricou ;\n\n- introduire des logiciels malveillants ou des codes malveillants ;\n\n- utiliser abusivement les données personnelles des consommateurs ;\n\n- enfreindre les droits de propriété intellectuelle ou autres droits de tiers ;\n\n- contourner les frais ou les restrictions techniques par des moyens frauduleux ou abusifs ; ou\n\n- utiliser Agricou en violation de la loi applicable.',
    },
    'r9avo8ka': {
      'en': '21. Restriction and Suspension',
      'fr': '21. Restriction et suspension',
    },
    'w7x4804t': {
      'en':
          'Agricou may restrict particular listings, functionality or access to an account where there are reasonable grounds relating to, among other things:\n\n- violation of these Producer Terms or the general Terms of Service;\n- unlawful or unsafe products;\nsuspected fraud or payment abuse;\n- material or repeated consumer complaints;\n- inaccurate or misleading information;\nrepeated failure to fulfil confirmed orders;\nmisuse of personal data;\n- infringement of third-party rights;\ncybersecurity or Platform integrity risks;\n- failure to pay amounts lawfully due to Agricou; or\n- a legal or regulatory requirement.\n\nWhere required by applicable law, Agricou will provide the Producer with the reasons for a restriction or suspension on a durable medium before or when the measure takes effect and provide an opportunity to clarify the relevant facts through the available complaint process.',
      'fr':
          'Agricou peut restreindre la publication de certaines annonces, l\'accès à certaines fonctionnalités ou à un compte pour des motifs raisonnables, notamment :\n\n- violation des présentes Conditions Producteur ou des Conditions Générales d\'Utilisation ;\n\n- produits illégaux ou dangereux ;\n\n- suspicion de fraude ou d\'abus de paiement ;\n\n- plaintes importantes ou répétées de consommateurs ;\n\n- informations inexactes ou trompeuses ;\n\n- non-respect répété des commandes confirmées ;\n\n- utilisation abusive de données personnelles ;\n\n- atteinte aux droits de tiers ;\n\nrisques liés à la cybersécurité ou à l\'intégrité de la Plateforme ;\n\n- défaut de paiement des sommes légitimement dues à Agricou ; ou\n- obligation légale ou réglementaire.\n\nLorsque la loi applicable l\'exige, Agricou communiquera au Producteur les motifs de la restriction ou de la suspension sur un support durable avant ou au moment de la prise d\'effet de la mesure et lui offrira la possibilité de clarifier les faits pertinents via la procédure de réclamation prévue à cet effet.',
    },
    '5ermbq8c': {
      'en': '22. Termination',
      'fr': '22. Résiliation',
    },
    'd7tiu3sn': {
      'en':
          'The Producer may terminate their relationship with Agricou and cancel their subscription using the mechanisms made available by Agricou, subject to any applicable billing period and amounts already due.\n\nAgricou may terminate the entire service relationship for the grounds described in these Producer Terms.\n\nWhere the EU Platform-to-Business rules require it, Agricou will provide a statement of reasons on a durable medium at least 30 days before termination of the entire intermediation service.\n\nThat notice period may not apply in circumstances permitted by applicable law, including certain legal or regulatory obligations, imperative reasons recognised by law or repeated violations of the applicable terms.\n\nTermination does not affect rights or obligations that arose before termination or provisions that by their nature are intended to survive termination.',
      'fr':
          'Le Producteur peut résilier sa relation avec Agricou et annuler son abonnement via les mécanismes mis à sa disposition, sous réserve des périodes de facturation applicables et des montants déjà dus.\n\nAgricou peut résilier l\'intégralité de la relation de service pour les motifs décrits dans les présentes Conditions Producteur.\n\nLorsque la réglementation européenne relative aux plateformes et aux entreprises l\'exige, Agricou fournira un exposé des motifs sur un support durable au moins 30 jours avant la résiliation de l\'intégralité du service d\'intermédiation.\n\nCe délai de préavis peut ne pas s\'appliquer dans certaines circonstances autorisées par la loi applicable, notamment en cas d\'obligations légales ou réglementaires, de motifs impérieux reconnus par la loi ou de violations répétées des conditions applicables.\n\nLa résiliation n\'affecte pas les droits et obligations nés avant la résiliation ni les dispositions qui, par leur nature, sont destinées à survivre à la résiliation.',
    },
    '4ieion1f': {
      'en': '23. Internal Complaints',
      'fr': '23. Plaintes internes',
    },
    't91tj3rl': {
      'en':
          'A Producer may contact Agricou regarding a decision affecting their account, a technical issue, payment matter or another issue relating to the provision of Agricou services at:\n\nsupport@agricou.com\n\nAgricou will review complaints in good faith and may request additional information reasonably necessary to investigate the matter.\n\nWhere applicable law requires a specific internal complaint-handling procedure or mediation mechanism, Agricou will provide the information required by that law.',
      'fr':
          'Un producteur peut contacter Agricou concernant une décision affectant son compte, un problème technique, une question de paiement ou tout autre problème relatif à la prestation des services d\'Agricou à l\'adresse suivante :\n\nsupport@agricou.com\n\nAgricou examinera les réclamations de bonne foi et pourra demander des informations complémentaires raisonnablement nécessaires à l\'enquête.\n\nLorsque la loi applicable exige une procédure interne spécifique de traitement des réclamations ou un mécanisme de médiation, Agricou fournira les informations requises par cette loi.',
    },
    '4wvln33f': {
      'en': '24. Platform Availability',
      'fr': '24. Disponibilité de la plateforme',
    },
    '55dwyrg5': {
      'en':
          'Agricou aims to provide a reliable service but does not guarantee that the Platform or any particular functionality will be available without interruption or error.\n\nThe Platform may be temporarily unavailable because of maintenance, updates, security incidents, third-party failures or circumstances beyond Agricou’s reasonable control.\n\nAgricou may develop, modify or discontinue functionality, subject to applicable contractual and legal requirements.\n\nNo subscription plan guarantees a minimum number of views, customers, orders, revenue or sales.',
      'fr':
          'Agricou s\'efforce de fournir un service fiable, mais ne garantit pas la disponibilité ininterrompue et sans erreur de la Plateforme ni de ses fonctionnalités.\n\nLa Plateforme peut être temporairement indisponible en raison de travaux de maintenance, de mises à jour, d\'incidents de sécurité, de défaillances de tiers ou de circonstances indépendantes de la volonté d\'Agricou.\n\nAgricou se réserve le droit de développer, modifier ou interrompre certaines fonctionnalités, sous réserve des dispositions contractuelles et légales applicables.\n\nAucun abonnement ne garantit un nombre minimum de vues, de clients, de commandes, de revenus ou de ventes.',
    },
    'vp62gs08': {
      'en': '25. Producer Responsibility and Indemnification',
      'fr': '25. Responsabilité et indemnisation du producteur',
    },
    'ndysu3t1': {
      'en':
          'The Producer is responsible for their professional activity, products, listings and fulfilment of sales and for compliance with obligations applicable to them.\n\nTo the extent permitted by applicable law, the Producer shall indemnify and hold Agricou harmless against third-party claims, losses, liabilities, damages and reasonable costs arising from the Producer’s unlawful conduct, products, breach of these Producer Terms, infringement of third-party rights or failure to comply with obligations legally incumbent upon the Producer.\n\nThis provision does not apply to the extent that the relevant loss or liability is caused by Agricou or where such limitation or allocation of responsibility is prohibited by applicable law.',
      'fr':
          'Le Producteur est responsable de son activité professionnelle, de ses produits, de ses annonces et de l\'exécution des ventes, ainsi que du respect des obligations qui lui incombent.\n\nDans la mesure permise par la loi applicable, le Producteur indemnisera Agricou et le dégagera de toute responsabilité en cas de réclamations, pertes, responsabilités, dommages et frais raisonnables de tiers découlant d\'une conduite illicite du Producteur, de ses produits, d\'une violation des présentes Conditions du Producteur, d\'une atteinte aux droits de tiers ou d\'un manquement à ses obligations légales.\n\nCette disposition ne s\'applique pas si la perte ou la responsabilité en question est causée par Agricou ou si une telle limitation ou répartition de responsabilité est interdite par la loi applicable.',
    },
    '6pap5lby': {
      'en': '26. Agricou Liability',
      'fr': '26. Responsabilité agricole',
    },
    'xmm1jge9': {
      'en':
          'Nothing in these Producer Terms excludes or limits liability where such exclusion or limitation is prohibited by applicable law.\n\nSubject to mandatory law, Agricou is responsible for providing the Platform services falling within its contractual obligations but is not responsible for the Producer’s products, professional activity, product information or obligations as seller.\n\nAgricou does not guarantee commercial success, consumer demand, sales volumes, uninterrupted availability of third-party services or a particular position in search results.\n\nTo the extent permitted by applicable law, Agricou shall not be liable for indirect or consequential losses that were not reasonably foreseeable as a result of a breach attributable to Agricou.\n\nAny contractual limitation of liability will apply only to the extent permitted by applicable law and will not exclude liability that cannot lawfully be excluded.',
      'fr':
          'Aucune disposition des présentes Conditions Producteur n\'exclut ni ne limite la responsabilité lorsque cette exclusion ou limitation est interdite par la loi applicable.\n\nSous réserve des dispositions légales impératives, Agricou est responsable de la fourniture des services de la Plateforme relevant de ses obligations contractuelles, mais n\'est pas responsable des produits, de l\'activité professionnelle, des informations relatives aux produits ou des obligations du Producteur en tant que vendeur.\n\nAgricou ne garantit ni le succès commercial, ni la demande des consommateurs, ni les volumes de vente, ni la disponibilité ininterrompue des services tiers, ni un positionnement particulier dans les résultats de recherche.\n\nDans la mesure permise par la loi applicable, Agricou ne saurait être tenue responsable des dommages indirects ou consécutifs qui n\'étaient pas raisonnablement prévisibles et qui résultent d\'un manquement qui lui est imputable.\n\nToute limitation de responsabilité contractuelle ne s\'appliquera que dans la mesure permise par la loi applicable et n\'exclura pas la responsabilité qui ne peut être légalement exclue.',
    },
    'peiwpwpr': {
      'en': '27. Changes to These Producer Terms',
      'fr':
          '27. Modifications des présentes conditions générales du producteur',
    },
    'ko9i6ckm': {
      'en':
          'Agricou may amend these Producer Terms to reflect changes to the Platform, its commercial model, legal requirements, security requirements or other legitimate operational needs.\n\nAffected Producers will be informed of proposed changes on a durable medium.\n\nWhere the EU Platform-to-Business rules apply, changes will generally not take effect before the expiry of a reasonable and proportionate notice period of at least 15 days, with a longer period where necessary to allow Producers to make significant technical or commercial adaptations.\n\nExceptions may apply where permitted by law, including where an immediate change is required by a legal or regulatory obligation or to address an unforeseen and imminent security risk.',
      'fr':
          'Agricou peut modifier les présentes Conditions Producteurs afin de tenir compte des évolutions de la Plateforme, de son modèle commercial, des exigences légales, des impératifs de sécurité ou de tout autre besoin opérationnel légitime.\n\nLes Producteurs concernés seront informés des modifications envisagées sur un support durable.\n\nLorsque la réglementation européenne relative aux transferts entre plateformes et entreprises s\'applique, les modifications n\'entreront généralement pas en vigueur avant l\'expiration d\'un préavis raisonnable et proportionné d\'au moins 15 jours, ce délai pouvant être plus long si nécessaire pour permettre aux Producteurs d\'effectuer des adaptations techniques ou commerciales significatives.\n\nDes exceptions peuvent s\'appliquer lorsque la loi le permet, notamment lorsqu\'une modification immédiate est requise par une obligation légale ou réglementaire ou pour faire face à un risque de sécurité imprévu et imminent.',
    },
    '9g3cio99': {
      'en': '28. Governing Law and Disputes',
      'fr': '28. Droit applicable et litiges',
    },
    'xkfee3dh': {
      'en':
          'These Producer Terms are governed by French law, subject to any mandatory rules that may apply.\n\nThe parties should first attempt to resolve disputes concerning the Agricou service amicably by contacting:\n\nsupport@agricou.com\n\nAny dispute that cannot be resolved amicably may be submitted to the competent courts determined in accordance with applicable law.\n\nNothing in this section deprives a party of rights or remedies that cannot lawfully be excluded by contract.',
      'fr':
          'Les présentes Conditions Générales de Vente sont régies par le droit français, sous réserve des dispositions impératives applicables.\n\nEn cas de litige relatif au service Agricou, les parties sont invitées à tenter de le résoudre à l\'amiable en contactant :\n\nsupport@agricou.com\n\nTout litige ne pouvant être résolu à l\'amiable pourra être soumis aux juridictions compétentes, conformément au droit applicable.\n\nAucune disposition du présent article ne prive une partie des droits ou recours qui ne peuvent être légitimement exclus par contrat.',
    },
    '8oickkp8': {
      'en': '29. Contact',
      'fr': '29. Contact',
    },
    'm30c5ql7': {
      'en':
          'Agricou is operated by:\n\nThe Pinnacle Of Data – EURL\nSIREN: 929 478 485\n8 rue d’Hyères\n31240 L’Union, France\n\nEmail: support@agricou.com',
      'fr':
          'Agricou est exploité par :\n\nThe Pinnacle Of Data – EURL\n\nSIREN : 929 478 485\n\n8 rue d’Hyères\n\n31240 L’Union, France\n\nCourriel : support@agricou.com',
    },
    'olrni0kz': {
      'en': 'Producer Terms & Conditions',
      'fr': 'Conditions générales du producteur',
    },
    'pq89lpm5': {
      'en': 'Home',
      'fr': 'Accueil',
    },
  },
  // commancard
  {
    'c42ws7zs': {
      'en': '4.5 km • 0.2 lbs CO₂ saved',
      'fr': '4,5 km • 0,2 lb de CO₂ économisé',
    },
  },
  // ViewCart
  {
    'gntchmn4': {
      'en': 'Review Items',
      'fr': 'Articles à examiner',
    },
    '8huhwz8x': {
      'en': '\$',
      'fr': '\$',
    },
    'z3ubuezz': {
      'en': '€',
      'fr': '€',
    },
    'k0p7n6vz': {
      'en': '\$',
      'fr': '\$',
    },
    'y7f9fv1b': {
      'en': '€',
      'fr': '€',
    },
    'p5wfeh53': {
      'en': 'View Cart',
      'fr': 'Voir le panier',
    },
  },
  // findproductrout
  {
    '7dadt07o': {
      'en': 'Find producers along your route',
      'fr': 'Trouvez des producteurs le long de votre itinéraire',
    },
    'mun0e2if': {
      'en': 'Your Location',
      'fr': 'Votre emplacement',
    },
    'oqefslrl': {
      'en': 'Destination Location',
      'fr': 'Lieu de destination',
    },
    '9xpe2fgw': {
      'en': 'Update',
      'fr': 'Mise à jour',
    },
  },
  // reviewcomponnet
  {
    'xrjmm94s': {
      'en': 'Leave a Review',
      'fr': 'Laisser un avis',
    },
    'm6f4sqzh': {
      'en': 'Rate your experience',
      'fr': 'Évaluez votre expérience',
    },
    '32tht2fh': {
      'en': 'Write a review…',
      'fr': 'Rédiger un avis…',
    },
    'cwsl8892': {
      'en': 'Write a review…',
      'fr': 'Rédiger un avis…',
    },
    'j86t96vm': {
      'en': 'Submit Review',
      'fr': 'Soumettre un avis',
    },
  },
  // AddAddress
  {
    'vcqnwn8z': {
      'en': 'Add new address',
      'fr': 'Ajouter une nouvelle adresse',
    },
    'cex5a76l': {
      'en': 'Search delivery address',
      'fr': 'Étiquette',
    },
    '89s7t6bt': {
      'en': 'Label',
      'fr': 'Étiquette',
    },
    'iupvc3hc': {
      'en': 'Enter Label',
      'fr': 'Saisir l\'étiquette',
    },
    '1qpe1094': {
      'en': 'Full Name',
      'fr': 'Nom et prénom',
    },
    'frrblbsm': {
      'en': 'Enter Full Name',
      'fr': 'Veuillez saisir votre nom complet.',
    },
    '846fzk79': {
      'en': 'Apartment, floor, building, landmark',
      'fr': 'Adresse de la rue',
    },
    '97otv2qf': {
      'en': 'Enter apartment, floor, or landmark',
      'fr': 'Saisissez l\'adresse de la rue',
    },
    '3e1zbe3n': {
      'en': 'postal Code',
      'fr': 'Adresse de la rue',
    },
    'h6ick0d1': {
      'en': 'Enter postal code',
      'fr': 'Saisissez l\'adresse de la rue',
    },
    '47gd432c': {
      'en': 'Phone Number',
      'fr': 'Numéro de téléphone',
    },
    'lilj3agx': {
      'en': 'in',
      'fr': 'dans',
    },
    'uhldtbuq': {
      'en': 'Instructions (optional)',
      'fr': 'Instructions (facultatives)',
    },
    'i627ttfq': {
      'en': 'Enter Instructions (optional)',
      'fr': 'Saisissez les instructions (facultatif)',
    },
    'cym6ivl9': {
      'en': 'Cancel',
      'fr': 'Annuler',
    },
    'kl283p42': {
      'en': 'Add',
      'fr': 'Ajouter',
    },
    'yppvii4h': {
      'en': 'Enter Label is required',
      'fr': '',
    },
    'yb4mq2y7': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'e5ag9ycj': {
      'en': 'Enter Full Name is required',
      'fr': 'Le nom complet est obligatoire.',
    },
    'beekt8q8': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'gokrv6hr': {
      'en': 'Enter Street Address is required',
      'fr': 'L\'adresse postale est obligatoire.',
    },
    'ugr72n1q': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'vdy3kokl': {
      'en': 'Enter postal code is required',
      'fr': '',
    },
    '': {
      'en': 'Please choose an option from the dropdown',
      'fr': '',
    },
    'q75m6fhd': {
      'en': 'Enter Instructions (optional) is required',
      'fr': 'Saisir les instructions (facultatif) est requis',
    },
    'pr64oeff': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
  },
  // logOut
  {
    'vpel5aqp': {
      'en': 'Logout',
      'fr': 'Déconnexion',
    },
    'rgls9u5j': {
      'en':
          'Are you sure you want to log out? You can always sign back in anytime.',
      'fr':
          'Êtes-vous sûr de vouloir vous déconnecter ? Vous pouvez vous reconnecter à tout moment.',
    },
    'faedzuoo': {
      'en': 'Yes, Logout',
      'fr': 'Oui, déconnexion',
    },
    'yxuwkw8u': {
      'en': 'Cancel',
      'fr': 'Annuler',
    },
  },
  // deleteAccount
  {
    'tkff1k45': {
      'en': 'Delete Account',
      'fr': 'Supprimer le compte',
    },
    'xpbs2lvo': {
      'en':
          'Deleting your account is permanent. All your analysis history will be erased. This action cannot be undone.',
      'fr':
          'La suppression de votre compte est définitive. Tout votre historique d\'analyses sera effacé. Cette action est irréversible.',
    },
    '3032wnse': {
      'en': 'Yes, Delete',
      'fr': 'Oui, supprimer',
    },
    'agtec0g4': {
      'en': 'Cancel',
      'fr': 'Annuler',
    },
  },
  // AddProduct
  {
    'tjroido7': {
      'en': 'Add Product',
      'fr': 'Ajouter un produit',
    },
    'aix9rj8z': {
      'en': 'Product name',
      'fr': 'Nom du produit',
    },
    'wrp76h6s': {
      'en': 'eg., Mangos',
      'fr': 'par exemple, les mangues',
    },
    '8fxdip9u': {
      'en': 'Description',
      'fr': 'Description',
    },
    'u9u738j0': {
      'en': 'Describe your product',
      'fr': 'Décrivez votre produit',
    },
    '8debgycf': {
      'en': 'Stock Quantity',
      'fr': 'Quantité en stock',
    },
    '7qix2zrc': {
      'en': 'Enter Stock Quantity',
      'fr': 'Saisir la quantité en stock',
    },
    '1fzmgalw': {
      'en': 'Batch Information',
      'fr': 'Informations sur le lot',
    },
    'qrvy2cmp': {
      'en': 'eg., Batch #2025-10-A',
      'fr': 'Par exemple, lot n° 2025-10-A',
    },
    'h1y0h6sq': {
      'en': 'Price',
      'fr': 'Prix',
    },
    '6lkpusek': {
      'en': 'Unit',
      'fr': 'Unité',
    },
    'md3vzd7o': {
      'en': '',
      'fr': 'unité',
    },
    'mnjg6zfw': {
      'en': 'unit',
      'fr': 'unité',
    },
    'yw8ymm86': {
      'en': 'Search...',
      'fr': 'Recherche...',
    },
    'fz8m2lnk': {
      'en': 'Option 1',
      'fr': 'Option 1',
    },
    'vpmov9w8': {
      'en': 'lbs',
      'fr': 'livres',
    },
    'p4dg50mf': {
      'en': 'Option 3',
      'fr': 'Option 3',
    },
    'hwyk2779': {
      'en': 'Product category',
      'fr': 'Catégorie de produits',
    },
    'e11xkvs6': {
      'en': 'Vegetables',
      'fr': 'Légumes',
    },
    'ej4ek7iq': {
      'en': 'product category',
      'fr': 'catégorie de produits',
    },
    'lpqiwuzq': {
      'en': 'Search...',
      'fr': 'Recherche...',
    },
    'oym198gb': {
      'en': 'Fruits',
      'fr': 'Fruits',
    },
    'n8k6t4ma': {
      'en': 'Vegetables',
      'fr': 'Légumes',
    },
    '42b88e7x': {
      'en': 'Meat',
      'fr': 'Viande',
    },
    '9ia63uip': {
      'en': 'Milk',
      'fr': 'Lait',
    },
    'lyy7vmnm': {
      'en': 'Grains',
      'fr': 'Grains',
    },
    'hi0rcwz4': {
      'en': 'Variable Weight Product',
      'fr': '',
    },
    'px40bd2t': {
      'en':
          'Sold by weight bracket. Customer pays 30% deposit; balance collected upon delivery.',
      'fr': '',
    },
    'zjub8rso': {
      'en': 'Min Weight (kg)',
      'fr': 'Quantité en stock',
    },
    'psxxhgcl': {
      'en': 'eg. 2.0',
      'fr': 'Saisir la quantité en stock',
    },
    'p9hihk4m': {
      'en': 'Max Weight (kg)',
      'fr': 'Quantité en stock',
    },
    '5vsdomqp': {
      'en': 'eg.3.0',
      'fr': 'Saisir la quantité en stock',
    },
    'xhht7u4h': {
      'en': 'Max weight must be greater than Min weight',
      'fr': '',
    },
    'k1xjnrbl': {
      'en': 'Price  per kg',
      'fr': 'Prix',
    },
    'ge5t7npx': {
      'en': 'Live Pricing Breakdown',
      'fr': '',
    },
    'e0ydd297': {
      'en': 'Est. Weight Range:',
      'fr': '',
    },
    '0e6xbxpj': {
      'en': 'Estimated Average Price:',
      'fr': '',
    },
    'fpp2fuoz': {
      'en': 'Add weight bracket',
      'fr': 'Annuler',
    },
    'ryicj1ga': {
      'en': 'Storage',
      'fr': 'Stockage',
    },
    'c5kwyue4': {
      'en': 'Fresh',
      'fr': 'Frais',
    },
    'wtgf78y1': {
      'en': 'storage Type',
      'fr': 'Type de stockage',
    },
    'iorv5jsu': {
      'en': 'Search...',
      'fr': 'Recherche...',
    },
    '6wqo75du': {
      'en': 'Option 1',
      'fr': 'Option 1',
    },
    'q1v3745h': {
      'en': 'lbs',
      'fr': 'livres',
    },
    'uxe2g1ky': {
      'en': 'Option 3',
      'fr': 'Option 3',
    },
    'pi621gk0': {
      'en': 'Season',
      'fr': 'Saison',
    },
    'ldl4rn87': {
      'en': 'Production Method',
      'fr': 'Méthode de production',
    },
    'x2c1rklw': {
      'en': 'Product Image',
      'fr': 'Image du produit',
    },
    'nrd7dalc': {
      'en': 'Click to upload\nJPG, PNG (max 10MB)',
      'fr': 'Cliquez pour téléverser\nJPG, PNG (10 Mo max.)',
    },
    '30wvyjfg': {
      'en': 'Cancel',
      'fr': 'Annuler',
    },
    'lktprfys': {
      'en': 'Add',
      'fr': 'Ajouter',
    },
    'cehjqqq5': {
      'en': 'Enter Label is required',
      'fr': 'Saisir l\'étiquette est requis',
    },
    'po6h7ab3': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    '661q93op': {
      'en': 'Enter Full Name is required',
      'fr': 'Le nom complet est obligatoire.',
    },
    'shubtn4w': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    '58l206o6': {
      'en': 'Enter Street Address is required',
      'fr': 'L\'adresse postale est obligatoire.',
    },
    'bg7qlbhq': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    '58307nhj': {
      'en': 'eg., Batch #2025-10-A is required',
      'fr': 'Par exemple, le lot n° 2025-10-A est requis.',
    },
    'nkv923aq': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'qbo7uskq': {
      'en': 'eg. 2.0 is required',
      'fr': '',
    },
    '1vsdwhdo': {
      'en': 'Please choose an option from the dropdown',
      'fr': '',
    },
    'rhu2si2u': {
      'en': 'eg.3.0 is required',
      'fr': '',
    },
    '7vfcclz6': {
      'en': 'Please choose an option from the dropdown',
      'fr': '',
    },
    'ol6ah28c': {
      'en': 'price  is required',
      'fr': '',
    },
    '5ia5vm4e': {
      'en': 'Please choose an option from the dropdown',
      'fr': '',
    },
  },
  // EditProduct
  {
    'p8t85dr9': {
      'en': 'Edit Product',
      'fr': 'Modifier le produit',
    },
    's62iea1d': {
      'en': 'Tap to upload new Product Image',
      'fr': 'Appuyez pour télécharger une nouvelle image du produit',
    },
    'e216gx16': {
      'en': 'Product name',
      'fr': 'Nom du produit',
    },
    'x56x7vpm': {
      'en': 'eg., Mangos',
      'fr': 'par exemple, les mangues',
    },
    'w4wishf2': {
      'en': 'Description',
      'fr': 'Description',
    },
    '9d3p1x98': {
      'en': 'Describe your product',
      'fr': 'Décrivez votre produit',
    },
    'tdlv4dt1': {
      'en': 'Stock Quantity',
      'fr': 'Quantité en stock',
    },
    'b2cq9j6f': {
      'en': 'Enter Stock Quantity',
      'fr': 'Saisir la quantité en stock',
    },
    'zkgg2zvz': {
      'en': 'Batch Information',
      'fr': 'Informations sur le lot',
    },
    'vis63exv': {
      'en': 'eg., Batch #2025-10-A',
      'fr': 'Par exemple, lot n° 2025-10-A',
    },
    'ffyxrjk0': {
      'en': 'Product category',
      'fr': 'Catégorie de produits',
    },
    'yt980wlm': {
      'en': 'product category',
      'fr': 'catégorie de produits',
    },
    'c2o3cj8m': {
      'en': 'Search...',
      'fr': 'Recherche...',
    },
    '6yan6mqr': {
      'en': 'Fruits',
      'fr': 'Fruits',
    },
    '8w14lqpa': {
      'en': 'Vegetables',
      'fr': 'Légumes',
    },
    'eh8jkxwi': {
      'en': 'Meat',
      'fr': 'Viande',
    },
    'yhh39ukz': {
      'en': 'Milk',
      'fr': 'Lait',
    },
    '702t5u2c': {
      'en': 'Grains',
      'fr': 'Grains',
    },
    '0x6f6onf': {
      'en': 'Price',
      'fr': 'Prix',
    },
    '83bhr28x': {
      'en': 'Unit',
      'fr': 'Unité',
    },
    'mjreaxgr': {
      'en': 'unit',
      'fr': 'unité',
    },
    't1dzfxef': {
      'en': 'Search...',
      'fr': 'Recherche...',
    },
    'byq66esf': {
      'en': 'Option 1',
      'fr': 'Option 1',
    },
    '37b5o3mg': {
      'en': 'lbs',
      'fr': 'livres',
    },
    '0fnnu3jt': {
      'en': 'Option 3',
      'fr': 'Option 3',
    },
    'e760e6r4': {
      'en': 'Storage',
      'fr': 'Stockage',
    },
    'yttnozyb': {
      'en': 'storage Type',
      'fr': 'Type de stockage',
    },
    'mvl2gfew': {
      'en': 'Search...',
      'fr': 'Recherche...',
    },
    'sbi0rn7r': {
      'en': 'Option 1',
      'fr': 'Option 1',
    },
    'tvq3favo': {
      'en': 'lbs',
      'fr': 'livres',
    },
    '00cko4jp': {
      'en': 'Option 3',
      'fr': 'Option 3',
    },
    'aw80za3d': {
      'en': 'Season',
      'fr': 'session',
    },
    '6ivhurv2': {
      'en': 'Active Product ',
      'fr': 'Produit actif',
    },
    '73a1naw5': {
      'en': 'Badge',
      'fr': 'Badge',
    },
    'abqv4rem': {
      'en': 'Cancel',
      'fr': 'Annuler',
    },
    '0jnhn74b': {
      'en': 'Save changes',
      'fr': 'Enregistrer les modifications',
    },
    '06g16n6c': {
      'en': 'Enter Label is required',
      'fr': 'Saisir l\'étiquette est requis',
    },
    '4fvczu37': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    '1dbjx94p': {
      'en': 'Enter Full Name is required',
      'fr': 'Le nom complet est obligatoire.',
    },
    'nt1b7p03': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    '25ixmnjl': {
      'en': 'Enter Street Address is required',
      'fr': 'L\'adresse postale est obligatoire.',
    },
    'c9womd4l': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'ry16hug4': {
      'en': 'batch_information is required',
      'fr': '',
    },
    'c6894ru3': {
      'en': 'Please choose an option from the dropdown',
      'fr': '',
    },
    '70liijvr': {
      'en': 'Enter Postal Code is required',
      'fr': 'Le code postal est obligatoire.',
    },
    'ibmnp10j': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
  },
  // RemoveProduct
  {
    'qp46q46i': {
      'en': 'Remove Product',
      'fr': 'Retirer le produit',
    },
    'fvojpx21': {
      'en': 'Are you sure you want to remove  from your list?',
      'fr': 'Êtes-vous sûr de vouloir le supprimer de votre liste ?',
    },
    'wuwhx1zi': {
      'en': 'Yes, Remove',
      'fr': 'Oui, supprimer',
    },
    'i40ygh70': {
      'en': 'Cancel',
      'fr': 'Annuler',
    },
  },
  // orderdatails
  {
    'bi48h8n2': {
      'en': 'Order Details',
      'fr': 'Détails de la commande',
    },
    'e18f0ft6': {
      'en': 'Order Information',
      'fr': 'Informations sur la commande',
    },
    'i193f5n2': {
      'en': 'Order ID',
      'fr': 'Numéro de commande',
    },
    'wbu8xx5u': {
      'en': 'Date',
      'fr': 'Date',
    },
    '6dnyxfen': {
      'en': 'Status',
      'fr': 'Statut',
    },
    'm8rttk2n': {
      'en': 'Customer Information',
      'fr': 'Informations client',
    },
    'iophzt4u': {
      'en': 'Name',
      'fr': 'Nom',
    },
    'b7ug97ir': {
      'en': 'Email',
      'fr': 'E-mail',
    },
    'hhqnypx5': {
      'en': 'Phone',
      'fr': 'Téléphone',
    },
    'eetmkfh9': {
      'en': 'Delivery Information',
      'fr': 'Informations de livraison',
    },
    '1ym2xmhw': {
      'en': 'Method',
      'fr': 'Méthode',
    },
    'ikya4ttb': {
      'en': 'Address',
      'fr': 'Adresse',
    },
    'eujldiyd': {
      'en': 'Order Items',
      'fr': 'Articles commandés',
    },
    '3bt3xmg9': {
      'en': '\$',
      'fr': '\$',
    },
    'drm85sfv': {
      'en': '€',
      'fr': '€',
    },
    'rvmyafq9': {
      'en': 'Deposit paid',
      'fr': 'Total',
    },
    'bf2rlx74': {
      'en': '\$',
      'fr': '\$',
    },
    '8zrk58s6': {
      'en': '€',
      'fr': '€',
    },
    '1r1xugwj': {
      'en': 'Total for order',
      'fr': '',
    },
    'y1hs73k7': {
      'en': '\$',
      'fr': '\$',
    },
    'ztvsrv1m': {
      'en': '€',
      'fr': '€',
    },
    'ibnt910m': {
      'en': 'Track Delivery',
      'fr': 'Suivi de livraison',
    },
    'ahn95aps': {
      'en': 'Reject Order',
      'fr': 'Rejeter la commande',
    },
    '8h35v4mt': {
      'en': 'Contact Customer',
      'fr': 'Contacter le client',
    },
  },
  // NewPlaningscadule
  {
    '2uykvqms': {
      'en': 'New Planting Schedule',
      'fr': 'Nouveau calendrier de plantation',
    },
    'ur8tetoq': {
      'en': 'Product name',
      'fr': 'Nom du produit',
    },
    'w99j24sf': {
      'en': 'eg., Mangos',
      'fr': 'par exemple, les mangues',
    },
    'eoelxv0i': {
      'en': 'Planted Date',
      'fr': 'Date de plantation',
    },
    '4xopcpak': {
      'en': 'Expected Harvest Date',
      'fr': 'Date de récolte prévue',
    },
    '6rnzoh7q': {
      'en': 'Location',
      'fr': 'Emplacement',
    },
    'y9v2vc9o': {
      'en': 'eg., Plot 1A',
      'fr': 'par exemple, parcelle 1A',
    },
    'mkmtzgqu': {
      'en': 'Product category',
      'fr': 'Catégorie de produits',
    },
    'jyuise5l': {
      'en': 'Vegetables',
      'fr': 'Légumes',
    },
    '9waoddp1': {
      'en': 'product category',
      'fr': 'catégorie de produits',
    },
    'mq4zaj5g': {
      'en': 'Search...',
      'fr': 'Recherche...',
    },
    'obu2zqzq': {
      'en': 'Fruits',
      'fr': 'Fruits',
    },
    'ct2va1ak': {
      'en': 'Vegetables',
      'fr': 'Légumes',
    },
    '6ghty9q6': {
      'en': 'Meat',
      'fr': 'Viande',
    },
    'y1unfvk4': {
      'en': 'Milk',
      'fr': 'Lait',
    },
    'qxlvip99': {
      'en': 'Grains',
      'fr': 'Grains',
    },
    '502buxkv': {
      'en': 'Product Status',
      'fr': 'État du produit',
    },
    'd51s0485': {
      'en': '',
      'fr': 'Légumes',
    },
    'eusalk0q': {
      'en': 'product status',
      'fr': 'état du produit',
    },
    '87ndzto8': {
      'en': 'Search...',
      'fr': 'Recherche...',
    },
    'vv95kifx': {
      'en': 'Growing',
      'fr': 'Croissance',
    },
    'xnv5zvy3': {
      'en': 'Ready',
      'fr': 'Prêt',
    },
    'yc7npyoq': {
      'en': 'Planning',
      'fr': 'Planification',
    },
    '1ec75ouh': {
      'en': 'Expected Quantity',
      'fr': 'Quantité attendue',
    },
    'w7ze0svz': {
      'en': '50',
      'fr': '50',
    },
    'p5n8g6kz': {
      'en': 'Unit',
      'fr': 'Unité',
    },
    'teetxg1x': {
      'en': 'Kilograms (kg)',
      'fr': 'Kilogrammes (kg)',
    },
    'c68gnerg': {
      'en': 'unit',
      'fr': 'unité',
    },
    '0n3r3kyv': {
      'en': 'Search...',
      'fr': 'Recherche...',
    },
    '1t924xtd': {
      'en': 'Option 1',
      'fr': 'Option 1',
    },
    'sxs4lqu9': {
      'en': 'lbs',
      'fr': 'livres',
    },
    'ebakjodo': {
      'en': 'Option 3',
      'fr': 'Option 3',
    },
    'jg0kgcp2': {
      'en': 'Product Image',
      'fr': 'Image du produit',
    },
    'gy58pbep': {
      'en': 'Click to upload\nJPG, PNG (max 10MB)',
      'fr': 'Cliquez pour téléverser\nJPG, PNG (10 Mo max.)',
    },
    'tk60856f': {
      'en': 'Cancel',
      'fr': 'Annuler',
    },
    'k2w3fkf3': {
      'en': 'Add to calendar',
      'fr': 'Ajouter au calendrier',
    },
    'sxj89m3f': {
      'en': 'Enter Name is required',
      'fr': 'Le nom est obligatoire.',
    },
    '94ohan1u': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'p0rh9x13': {
      'en': 'Enter Street Address is required',
      'fr': 'L\'adresse postale est obligatoire.',
    },
    'xz2qlaq3': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'eopyhr77': {
      'en': 'Enter Quatity is required',
      'fr': 'La quantité est obligatoire.',
    },
    'zm0wmeli': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
  },
  // ConsumerNavbar
  {
    'ilek9clf': {
      'en': 'Home',
      'fr': 'Accueil',
    },
    '8vh5of1n': {
      'en': 'Map',
      'fr': 'Carte',
    },
    '8571g23a': {
      'en': 'Chat',
      'fr': 'Chat',
    },
    '2prll3qn': {
      'en': 'Cart',
      'fr': 'Chariot',
    },
    'c51tyr90': {
      'en': 'Profile',
      'fr': 'Profil',
    },
  },
  // ProducerNavbar
  {
    'd9myslwe': {
      'en': 'Home',
      'fr': 'Accueil',
    },
    '3o3olmjy': {
      'en': 'Insights',
      'fr': 'Stats',
    },
    'pdli8qaq': {
      'en': 'Chat',
      'fr': 'Chat',
    },
    '2fojvjug': {
      'en': 'Profile',
      'fr': 'Profil',
    },
  },
  // AddDelivery
  {
    'jpdzy7xr': {
      'en': 'Delivery Area',
      'fr': 'Zone de livraison',
    },
    '29uuchdc': {
      'en': 'Enetr Deliver Area',
      'fr': 'Zone de livraison d\'Entrée',
    },
    'pjw4agry': {
      'en': 'Add Area',
      'fr': 'Ajouter une zone',
    },
  },
  // upload
  {
    'tjf6q3ec': {
      'en': 'Upload Pdf',
      'fr': 'Télécharger un PDF',
    },
    'coob0z9v': {
      'en': 'Upload Image',
      'fr': 'Télécharger une image',
    },
  },
  // editscadule
  {
    'l4fo5ar6': {
      'en': 'Edit Planting Schedule',
      'fr': 'Modifier le calendrier de plantation',
    },
    'ax0xau20': {
      'en': 'Product name',
      'fr': 'Nom du produit',
    },
    '8xfpaha5': {
      'en': 'eg., Mangos',
      'fr': 'par exemple, les mangues',
    },
    'cgw0k67n': {
      'en': 'Planted Date',
      'fr': 'Date de plantation',
    },
    'rdh5lyp9': {
      'en': 'Expcted Harvest Date',
      'fr': 'Date de récolte prévue',
    },
    '8annlf3j': {
      'en': 'Location',
      'fr': 'Emplacement',
    },
    'xsve6n5g': {
      'en': 'eg., Plot 1A',
      'fr': 'par exemple, parcelle 1A',
    },
    'ya5y2ufn': {
      'en': 'Product category',
      'fr': 'Catégorie de produits',
    },
    '9aukmgrm': {
      'en': 'product category',
      'fr': 'catégorie de produits',
    },
    'l8kfdyx3': {
      'en': 'Search...',
      'fr': 'Recherche...',
    },
    'he8dcleu': {
      'en': 'Fruits',
      'fr': 'Fruits',
    },
    '0mk6vbjq': {
      'en': 'Vegetables',
      'fr': 'Légumes',
    },
    'w0g7tl00': {
      'en': 'Meat',
      'fr': 'Viande',
    },
    'licoanjc': {
      'en': 'Milk',
      'fr': 'Lait',
    },
    'juxcfnd4': {
      'en': 'Grains',
      'fr': 'Grains',
    },
    '5tinsx6u': {
      'en': 'Product Status',
      'fr': 'État du produit',
    },
    'bu04ywi4': {
      'en': 'product status',
      'fr': 'état du produit',
    },
    'xf326t3p': {
      'en': 'Search...',
      'fr': 'Recherche...',
    },
    '5msdpjq1': {
      'en': 'Growing',
      'fr': 'Croissance',
    },
    'ht16h6qw': {
      'en': 'Ready',
      'fr': 'Prêt',
    },
    'ubdcemth': {
      'en': 'Planning',
      'fr': 'Planification',
    },
    'u8oat659': {
      'en': 'Expected Quantity',
      'fr': 'Quantité attendue',
    },
    '9g7ow9nt': {
      'en': '50',
      'fr': '50',
    },
    'y3bww1gb': {
      'en': 'Unit',
      'fr': 'Unité',
    },
    'h1sv8i9n': {
      'en': 'unit',
      'fr': 'unité',
    },
    'r0kaudm3': {
      'en': 'Search...',
      'fr': 'Recherche...',
    },
    'g2n1qmq7': {
      'en': 'Option 1',
      'fr': 'Option 1',
    },
    'ge81ogsp': {
      'en': 'lbs',
      'fr': 'livres',
    },
    'tntzxgf7': {
      'en': 'Option 3',
      'fr': 'Option 3',
    },
    'b6ldt5ok': {
      'en': 'Product Image',
      'fr': 'Image du produit',
    },
    'l5ps113h': {
      'en': 'Cancel',
      'fr': 'Annuler',
    },
    'fv1n85uq': {
      'en': 'Save ',
      'fr': 'Sauvegarder',
    },
    '8w7vxb6d': {
      'en': 'Enter product name is required',
      'fr': 'Le nom du produit est obligatoire.',
    },
    'zsfmglz0': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'ig83tnnh': {
      'en': 'Enter Street Address is required',
      'fr': 'L\'adresse postale est obligatoire.',
    },
    'h8hmyql5': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'owanl9zh': {
      'en': 'questity is reqyured',
      'fr': 'Une quête est requise',
    },
    'cf801i2x': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
  },
  // suspend
  {
    'oqh7gqon': {
      'en': 'Account Suspended',
      'fr': 'Compte suspendu',
    },
    'wa5qa55r': {
      'en':
          'Your account is currently suspended and access has been restricted.\nIf you believe this is a mistake, please reach out to our support team.',
      'fr':
          'Votre compte est actuellement suspendu et l\'accès est restreint.\n\nSi vous pensez qu\'il s\'agit d\'une erreur, veuillez contacter notre équipe d\'assistance.',
    },
    'c22cjwim': {
      'en': 'Talk to Support',
      'fr': 'Contactez le service d\'assistance.',
    },
  },
  // editaddress
  {
    'i2kg7tg0': {
      'en': 'Edit address',
      'fr': 'Modifier l\'adresse',
    },
    'bbfnlh2l': {
      'en': 'Search delivery address',
      'fr': 'Rechercher l\'adresse de livraison',
    },
    'puoozfrm': {
      'en': 'Label',
      'fr': 'Étiquette',
    },
    'hpzxy6so': {
      'en': 'Enter Label',
      'fr': 'Saisir l\'étiquette',
    },
    'h8j8ve32': {
      'en': 'Full Name',
      'fr': 'Nom et prénom',
    },
    '0dqqs09e': {
      'en': 'Enter Full Name',
      'fr': 'Veuillez saisir votre nom complet.',
    },
    'dljq0ric': {
      'en': 'Apartment, floor, building, landmark',
      'fr': 'Appartement, étage, immeuble, point de repère',
    },
    'onpxs8y0': {
      'en': 'Enter apartment, floor, or landmark',
      'fr':
          'Saisissez le numéro d\'appartement, d\'étage ou de point de repère.',
    },
    'vkpfate2': {
      'en': 'postal Code',
      'fr': 'Code Postal',
    },
    'j2ycw46k': {
      'en': 'Enter postal code',
      'fr': 'Saisissez le code postal',
    },
    'ikk3vrru': {
      'en': 'Phone Number',
      'fr': 'Numéro de téléphone',
    },
    'h0oq0h51': {
      'en': 'in',
      'fr': 'dans',
    },
    '05natjgi': {
      'en': 'Instructions (optional)',
      'fr': 'Instructions (facultatives)',
    },
    '39gwhgs4': {
      'en': 'Enter Instructions (optional)',
      'fr': 'Saisissez les instructions (facultatif)',
    },
    'gk3svbb3': {
      'en': 'Cancel',
      'fr': 'Annuler',
    },
    'hv6uuo3p': {
      'en': 'Update',
      'fr': 'Mise à jour',
    },
    'ief5wv7z': {
      'en': 'Enter Label is required',
      'fr': 'Saisir l\'étiquette est requis',
    },
    'iaxcqqxl': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'n38rk816': {
      'en': 'Enter Full Name is required',
      'fr': 'Le nom complet est obligatoire.',
    },
    'isjmd58d': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'qhanp203': {
      'en': 'street_adress is required',
      'fr': 'L\'adresse postale est requise.',
    },
    'mzvaw77i': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'xrci9ytk': {
      'en': 'Enter postal code is required',
      'fr': 'Saisir le code postal est obligatoire',
    },
    'tiyhu1ey': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
    'zljhsmnk': {
      'en': 'Enter Instructions (optional) is required',
      'fr': 'Saisir les instructions (facultatif) est requis',
    },
    'rme13lmd': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
    },
  },
  // deleteconfirmationdialog
  {
    'wbkv05c9': {
      'en': 'Alert ',
      'fr': 'Alerte',
    },
    'g9k38s4o': {
      'en': 'Are you sure you want to delete address ?',
      'fr': 'Êtes-vous sûr de vouloir supprimer cette adresse ?',
    },
    'lik4dq1y': {
      'en': 'Cancel',
      'fr': 'Annuler',
    },
    '6sl8acyi': {
      'en': 'Delete',
      'fr': 'Supprimer',
    },
  },
  // cancelsubscriptiondialog
  {
    '79ys4m32': {
      'en': 'Alert ',
      'fr': 'Alerte',
    },
    'dr8uvz1k': {
      'en': 'Are you sure you want to cancel subscription ?',
      'fr': 'Êtes-vous sûr de vouloir annuler votre abonnement ?',
    },
    'wo38ufsl': {
      'en': 'Cancel',
      'fr': 'Annuler',
    },
    '7buyb6g6': {
      'en': 'Submit',
      'fr': 'Soumettre',
    },
  },
  // FlavorsPlan
  {
    '4wlj6guu': {
      'en': '🌿 Agricoo Delivery – Coming Soon in Your Area',
      'fr': '🌿 Livraison Agricoo – Bientôt disponible dans votre région',
    },
    'hsuklm7z': {
      'en':
          'We are preparing the launch of Agricoo, a solution that will allow:',
      'fr':
          'Nous préparons le lancement d\'Agricoo, une solution qui permettra :',
    },
    'jbpth4u8': {
      'en': '• Receiving multiple producers in one single delivery',
      'fr': '• Réception de plusieurs producteurs dans une seule livraison',
    },
    'cvzelehe': {
      'en': '• Simplified logistics',
      'fr': '• Logistique simplifiée',
    },
    'nkaks2g1': {
      'en': '• Extended selling areas',
      'fr': '• Zones de vente étendues',
    },
    '7ithehfi': {
      'en': '• Optimized transport costs',
      'fr': '• Coûts de transport optimisés',
    },
    'gu8b3fr7': {
      'en':
          'The service will be activated in your area once a sufficient number of interested users is reached.',
      'fr':
          'Le service sera activé dans votre région dès qu\'un nombre suffisant d\'utilisateurs intéressés sera atteint.',
    },
    '3xu90t2c': {
      'en': '👉 Would you like to be notified first when it launches?',
      'fr':
          '👉 Souhaitez-vous être averti(e) en premier lors de son lancement ?',
    },
    'wjsmrsxe': {
      'en': 'Yes, I\'m interested',
      'fr': 'Oui, ça m\'intéresse.',
    },
  },
  // nochatfarmlist
  {
    'yv3fwfx8': {
      'en': 'search Farm Name',
      'fr': 'rechercher le nom de la ferme',
    },
  },
  // nochatusertlist
  {
    'wimvd7yb': {
      'en': 'search Producer Name',
      'fr': 'Nom du producteur',
    },
  },
  // RemovescaduleProduct
  {
    'qphyyseg': {
      'en': 'Remove the product from the calendar',
      'fr': 'Retirez le produit du calendrier',
    },
    'ahl2vfj3': {
      'en': 'Are you sure you want to remove this   from your list?',
      'fr': 'Êtes-vous sûr de vouloir supprimer ceci de votre liste ?',
    },
    '6szlbeor': {
      'en': 'Yes, Remove',
      'fr': 'Oui, supprimer',
    },
    'dd5h3xqo': {
      'en': 'Cancel',
      'fr': 'Annuler',
    },
  },
  // confirmationdeleteaccount
  {
    '4yotvi5z': {
      'en': 'Alert',
      'fr': 'Alerte',
    },
    'ika42znp': {
      'en': 'Are you sure you want to Delete connect account ? ',
      'fr': 'Êtes-vous sûr de vouloir supprimer votre compte Connect ?',
    },
    'nb00hqd1': {
      'en': 'Cancel',
      'fr': 'Annuler',
    },
    't42yrek5': {
      'en': 'Delete',
      'fr': 'Supprimer',
    },
  },
  // Restricted
  {
    '489kxv0f': {
      'en': 'Account Restricted',
      'fr': 'Compte restreint',
    },
    'r2r1phop': {
      'en':
          'Your account is currently Restricted. to use this functionality  purchase plan .',
      'fr':
          'Votre compte est actuellement restreint. Pour utiliser cette fonctionnalité, veuillez souscrire un abonnement.',
    },
    '68ga4ni8': {
      'en': 'Purchase plan',
      'fr': 'Plan d\'achat',
    },
  },
  // Rejectorder
  {
    '2e1ixppi': {
      'en': 'Reject Order',
      'fr': 'Rejeter la commande',
    },
    'gq95n2u7': {
      'en': 'Are you sure you want to Reject Order?',
      'fr': 'Êtes-vous sûr de vouloir refuser la commande ?',
    },
    'c7gs4n4i': {
      'en': 'Yes, Reject',
      'fr': 'Oui, refuser',
    },
    'g3bm68av': {
      'en': 'Cancel',
      'fr': 'Annuler',
    },
  },
  // DeleteReview
  {
    '52h2jp0i': {
      'en': 'Delete Review',
      'fr': 'Supprimer l\'avis',
    },
    '5ici0kds': {
      'en': 'Are you sure you want to Delete Review?',
      'fr': 'Êtes-vous sûr de vouloir supprimer cet avis ?',
    },
    'cgzbt8qo': {
      'en': 'Yes, Delete',
      'fr': 'Oui, supprimer',
    },
    '502unck6': {
      'en': 'Cancel',
      'fr': 'Annuler',
    },
  },
  // demo11
  {
    'x5h6gyfi': {
      'en':
          'Hello World hnkjgnkfjgnjkhnfjlhnelfkhnerlhnerlrlkjhnerlkjhnerlkhnerlkjhnerlkhthteeth',
      'fr':
          'Bonjour le monde hnkjgnkfjgnjkhnfjlhnelfkhnerlhnerlrlkjhnerlkjhnerlkjhnerlkhthteeth',
    },
  },
  // FlavorsPlansave
  {
    '3prtsb3q': {
      'en': '🌿 Agricoo Delivery – Coming Soon in Your Area',
      'fr': '🌿 Livraison Agricoo – Bientôt disponible dans votre région',
    },
    '136ole7a': {
      'en':
          'We are preparing the launch of Agricoo Grouped Delivery, a solution that will allow:',
      'fr':
          'Nous préparons le lancement d\'Agricoo Grouped Delivery, une solution qui permettra :',
    },
    '98t6cmxl': {
      'en': '• Receiving multiple producers in one single delivery',
      'fr': '• Réception de plusieurs producteurs dans une seule livraison',
    },
    '8ryk0had': {
      'en': '• Simplified logistics',
      'fr': '• Logistique simplifiée',
    },
    '8ojz468w': {
      'en': '• Extended selling areas',
      'fr': '• Zones de vente étendues',
    },
    'ej61g9ri': {
      'en': '• Optimized transport costs',
      'fr': '• Coûts de transport optimisés',
    },
    'sbvuqqms': {
      'en':
          'The service will be activated in your area once a sufficient number of interested users is reached.',
      'fr':
          'Le service sera activé dans votre région dès qu\'un nombre suffisant d\'utilisateurs intéressés sera atteint.',
    },
    'kl2nanrg': {
      'en': '👉 Would you like to be notified first when it launches?',
      'fr':
          '👉 Souhaitez-vous être averti(e) en premier lors de son lancement ?',
    },
    'aj2l2h2p': {
      'en': 'Yes, I\'m interested',
      'fr': 'Oui, ça m\'intéresse.',
    },
  },
  // AddWeightOrder
  {
    'lasqzwp3': {
      'en': 'Product weight',
      'fr': 'Zone de livraison',
    },
    '38vhln6u': {
      'en': 'Enter Product Weight',
      'fr': 'Zone de livraison d\'Entrée',
    },
    'vif6oghs': {
      'en': 'Add',
      'fr': 'Ajouter une zone',
    },
    'w8w9m18u': {
      'en': 'Product Weight is required',
      'fr': '',
    },
    'ubh5f05j': {
      'en': 'Please choose an option from the dropdown',
      'fr': '',
    },
  },
  // Miscellaneous
  {
    '7v72rj62': {
      'en': 'Button',
      'fr': 'Bouton',
    },
    'iyeyj4ij': {
      'en': '',
      'fr': '',
    },
    'w24idwk6': {
      'en': '',
      'fr': '',
    },
    'ohbtixqp': {
      'en': '',
      'fr': '',
    },
    '1nnornry': {
      'en': '',
      'fr': '',
    },
    'y9xil9u0': {
      'en': '',
      'fr': '',
    },
    '5an4ggus': {
      'en': '',
      'fr': '',
    },
    'fyfr62zy': {
      'en': '',
      'fr': '',
    },
    'pfb99fep': {
      'en': '',
      'fr': '',
    },
    '9qkomqwj': {
      'en': '',
      'fr': '',
    },
    'vtlalv3z': {
      'en': '',
      'fr': '',
    },
    '8877llcy': {
      'en': '',
      'fr': '',
    },
    'z4bfbnag': {
      'en': '',
      'fr': '',
    },
    't405eqmy': {
      'en': '',
      'fr': '',
    },
    '86jnnwoe': {
      'en': '',
      'fr': '',
    },
    '84obch5s': {
      'en': '',
      'fr': '',
    },
    'vtu7vf11': {
      'en': '',
      'fr': '',
    },
    '6t9ro4tr': {
      'en': '',
      'fr': '',
    },
    '8arxu7hy': {
      'en': '',
      'fr': '',
    },
    '24ds4tbp': {
      'en': '',
      'fr': '',
    },
    '44gp2wtg': {
      'en': '',
      'fr': '',
    },
    'qj8w2f7g': {
      'en': '',
      'fr': '',
    },
    'f4ufai54': {
      'en': '',
      'fr': '',
    },
    'bme4mvpp': {
      'en': '',
      'fr': '',
    },
    '8x0xh1sf': {
      'en': '',
      'fr': '',
    },
    'cynrg76n': {
      'en': '',
      'fr': '',
    },
    'egto49uo': {
      'en': '',
      'fr': '',
    },
    '8f0s3neg': {
      'en': '',
      'fr': '',
    },
    'v507x9c3': {
      'en': '',
      'fr': '',
    },
    'jqlam1qc': {
      'en': '',
      'fr': '',
    },
  },
].reduce((a, b) => a..addAll(b));
