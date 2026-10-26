// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appName => 'Lost and Found';

  @override
  String get close => 'Chiudi';

  @override
  String get cancel => 'Cancella';

  @override
  String get yes => 'Si';

  @override
  String get ok => 'OK';

  @override
  String get singIn => 'Effettua l\'accesso';

  @override
  String get signUp => 'Registrati';

  @override
  String item(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Oggetti',
      zero: 'Oggetto',
    );
    return '$_temp0';
  }

  @override
  String get lostAndFound => 'Lost&Found';

  @override
  String found(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Trovati',
      zero: 'Trovato',
    );
    return '$_temp0';
  }

  @override
  String lost(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Persi',
      zero: 'Perso',
    );
    return '$_temp0';
  }

  @override
  String get retry => 'Riprova';

  @override
  String get gallery => 'Galleria';

  @override
  String get camera => 'Fotocamera';

  @override
  String get date => 'Data';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Conferma password';

  @override
  String get user => 'Email o Username';

  @override
  String get email => 'Indirizzo Email';

  @override
  String get username => 'Username';

  @override
  String get send => 'Invia';

  @override
  String claim(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Richieste',
      zero: 'Richiesta',
    );
    return '$_temp0';
  }

  @override
  String message(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Messaggi',
      zero: 'Messaggio',
    );
    return '$_temp0';
  }

  @override
  String get homeBottomBarTab => 'Home';

  @override
  String get accept => 'Accetta';

  @override
  String get decline => 'Rifiuta';

  @override
  String get searchBottomBarTab => 'Ricerca';

  @override
  String get insertBottomBarTab => 'Inserisci';

  @override
  String get inboxBottomBarTab => 'Posta';

  @override
  String get profileBottomBarTab => 'Profilo';

  @override
  String get cameraPermissionDialogTitle => 'Permesso Fotocamera Richiesto';

  @override
  String get cameraPermissionDialogContentPermanentlyDenied =>
      'Il permesso per usare la fotocamera è richiesto per scattare la foto.\n\nPer favore abilita il permesso dalle impostazioni dell\'app.';

  @override
  String get cameraPermissionDialogContentDenied =>
      'Il permesso per usare la fotocamera è richiesto per scattare la foto.';

  @override
  String get categoryPageTitle => 'Seleziona una categoria';

  @override
  String get categoryFormEntryTitle => 'Categoria';

  @override
  String get positionPageTitle => 'Seleziona posizione';

  @override
  String get positionUseCurrentLocation => 'Usa la mia attuale posizione';

  @override
  String get positionUseSelected => 'Seleziona questa posizione';

  @override
  String get locationPermissionDialogTitle => 'Permesso Posizione Richiesto';

  @override
  String get locationPermissionDialogContentPermanentlyDenied =>
      'Il permesso per usare la geolocalizzazione è richiesto per calcolare la tua posizione attuale.\n\nPer favore abilita il permesso dalle impostazioni dell\'app.';

  @override
  String get locationPermissionDialogContentDenied =>
      'Il permesso per usare la geolocalizzazione è richiesto per calcolare la tua posizione attuale.';

  @override
  String get noConnectionDialogTitle => 'Connessione mancante';

  @override
  String get noConnectionDialogContent =>
      'Per favore controllare la tua connessione internet';

  @override
  String get positionDialogTitle => 'Geolocalizzazione Disabilitata';

  @override
  String get positionDialogContent => 'Per favore abilita la geolocalizzazione';

  @override
  String get tutorialInitialPage1Title => 'Inserisci un Oggetto Perso';

  @override
  String get tutorialInitialPage1Content =>
      'Inserisci i dettagli dell\'oggetto perso nell\'app.';

  @override
  String get tutorialInitialPage2Title => 'Inserisci un Oggetto Trovato';

  @override
  String get tutorialInitialPage2Content =>
      'Notifica gli altri utenti inserendo un oggetto che hai trovato nell\'app.';

  @override
  String get tutorialInitialPage3Title => 'Concorda Restituzione Oggetto';

  @override
  String get tutorialInitialPage3Content =>
      'Contatta la persona che ho trovato l\'oggetto per concordare un incontro al fine di restituire lo stesso.';

  @override
  String get confirmExitDialogTitle => 'Conferma Uscita';

  @override
  String get confirmExitDialogContent =>
      'Uscendo da questa pagina perderai tutti i dati che hai inserito finora. Sei sicuro di voler uscire?';

  @override
  String get stayInPage => 'No, rimani nella pagina';

  @override
  String get errorPageTitle =>
      'Si è verificato un errore durante il caricamento';

  @override
  String get errorPageSubtitle => 'Per favore riprova più tardi';

  @override
  String get mediaSelectionDialogTitle => 'Per favore selezione un\'opzione';

  @override
  String get dateFormEntrySubtitle => 'Data di caricamento';

  @override
  String dateFormEntryValue(String date) {
    return 'Dopo $date';
  }

  @override
  String get positionFormEntryTitle => 'Posizione';

  @override
  String get positionFormEntrySubtitle =>
      'Dove l\'oggetto è stato perso o trovato';

  @override
  String get positionFormEntryNotSelected => 'Posizione non ancora selezionata';

  @override
  String get signUpText => 'Non hai un account?';

  @override
  String get signInText => 'Hai già un account?';

  @override
  String get failureInvalidCredentials =>
      'Credenziali non valide. Per favore prova di nuovo.';

  @override
  String get failureGeneric => 'Errore server. Per favore riprovare più tardi.';

  @override
  String get failureNetwork =>
      'Connessione internet non disponibile. Controlla la tua connessione e riprova.';

  @override
  String get failureUnknown => 'Errore sconosciuto';

  @override
  String get failureInvalidPassword =>
      'Password non valida. La password deve contenere almeno 8 caratteri, con caratteri maiuscoli, minuscole e numerici.';

  @override
  String get failureInvalidUser => 'Username o Email non valido.';

  @override
  String get failureConfirmPassword =>
      'Il campo non ha lo stesso valore della password originale.';

  @override
  String get failureEmailDuplicate => 'Email già in uso.';

  @override
  String get failureEmailInvalid => 'Formato email non valido.';

  @override
  String get failureInvalidPasswordCreation =>
      'La password deve contenere almeno 8 caratteri, con caratteri maiuscoli, minuscole e numerici.';

  @override
  String get successSignUp => 'Registrazione avvenuta con successo';

  @override
  String get successAnswerClaim => 'Richiesta gestita con successo';

  @override
  String get successAnswerQuestion => 'Richiesta creata con successo';

  @override
  String get failureUsernameDuplicate => 'Username già in uso.';

  @override
  String get failureInvalidUsername =>
      'Username può contente fino a 30 caratteri alfanumerici.';

  @override
  String get noContentInboxTitle => 'Non ci sono chat attive';

  @override
  String get noContentInboxSubtitle =>
      'Chatta con qualcuno per vedere la lista delle conversazioni';

  @override
  String get answerClaimTitle => 'Valida la richiesta';

  @override
  String get answerClaimTutorialClosedManaged =>
      'Hai già validato questa richiesta.';

  @override
  String get answerClaimTutorialClosedUnmanaged =>
      'Devi decidere se accettare o rifiutare questa richiesta.';

  @override
  String get answerClaimTutorialOpenManaged =>
      'In questa pagina, puoi trovare le informazioni relative a questa richiesta.';

  @override
  String get answerClaimTutorialOpenUnmanaged =>
      'Per favore valida questa richiesta decidendo se accettarla o rifiutarla. Se la accetti, tutte le altre richiesta per questo oggetto verranno automaticamente rifiutate e l\'oggetto non sarà più visibile agli altri.';

  @override
  String itemClaimedBy(String username) {
    return 'Oggetto richiesto da $username';
  }

  @override
  String get yourQuestion => 'La tua domanda';

  @override
  String answerOf(String username) {
    return 'Risposta di $username';
  }

  @override
  String get claimStatus => 'Stato richiesta';

  @override
  String acceptedAnswerClaim(String username) {
    return 'Hai accetto questa richiesta. Contatta $username per organizzare un incontro per la restituzione dell\'oggetto.';
  }

  @override
  String get rejectedClaim => 'Hai rifiutato questa richiesta.';

  @override
  String get validateClaim => 'Valida la richiesta.';

  @override
  String get answerQuestionTitle => 'Crea nuova richiesta';

  @override
  String get answerQuestionTutorialClosedManaged =>
      'Hai già richiesto questo oggetto.';

  @override
  String get answerQuestionTutorialClosedUnmanaged =>
      'Stai richiedendo questo oggetto.';

  @override
  String get answerQuestionTutorialOpenManaged =>
      'In questa pagina, puoi trovare le informazioni sulla richiesta che hai creato.';

  @override
  String get answerQuestionTutorialOpenUnmanaged =>
      'Per create la richiesta di restituzione dell\'oggetto risponde alla sequente domanda correttamente. Se la risposta è corretta, l\'utente che ha trovato l\'oggetto la approverè e potrai riavere il tuo oggetto.';

  @override
  String get itemClaiming => 'Oggetto che stai richiedendo';

  @override
  String questionOf(String username) {
    return 'Domanda di $username';
  }

  @override
  String get yourAnswer => 'La tua risposta';

  @override
  String get failureInvalidQuestion => 'Una risposta è richiesta.';

  @override
  String acceptedQuestionClaim(String username) {
    return 'La tua richiesta è stata accettata! Contatta $username usando la chat per concordare la restituzione dell\'oggetto.';
  }

  @override
  String rejectedQuestionClaim(String username) {
    return 'Purtroppo la tua richiesta è stata rifiutata da $username.';
  }

  @override
  String waitQuestionClaim(String username) {
    return 'Attendi che $username validi la tua richiesta.';
  }

  @override
  String get receivedClaims => 'Richieste ricevute';

  @override
  String get yourClaims => 'Richieste create';

  @override
  String get noContentClaimReceivedTitle => 'Non hai richieste da validare';

  @override
  String get noContentClaimReceivedSubtitle =>
      'Le richiesta verranno mostrate qui non appena un utente ne creerà una per un oggetto trovato che hai inserito';

  @override
  String get claimReceivedTutorial =>
      'In questa sezione ci sono le richiesta fatte da altri utenti, per gli oggetti che hai trovato.';

  @override
  String get noContentClaimSentTitle => 'Non ci sono richieste pendenti';

  @override
  String get noContentClaimSentSubtitle =>
      'Le tue richieste verranno mostrate qui non appena ne creerai una';

  @override
  String get claimSentTutorial =>
      'In questa sezione ci sono le richiesta che hai creato per oggetti trovati da altri.';

  @override
  String claimedBy(String username) {
    return 'Richiesto da $username';
  }

  @override
  String get claimStatusSpaced => 'Stato richiesta ';

  @override
  String get seeDetails => 'Vedi Dettagli';

  @override
  String get sendMessage => 'Scrivi Messaggio';

  @override
  String get filtersPageTitle => 'Gestione Filtri';

  @override
  String get filters => 'Filtri';

  @override
  String get deleteAll => 'ELIMINA TUTTO';

  @override
  String get failureInvalidType => 'Seleziona almeno una delle due opzioni.';

  @override
  String get failureInvalidPosition => 'Seleziona la posizione dell\'oggetto.';

  @override
  String get failureInvalidCategory => 'Seleziona la categoria.';

  @override
  String get search => 'Cerca';

  @override
  String get home => 'Home';

  @override
  String get tooltipNews => 'news';

  @override
  String get tooltipClaims => 'richieste';

  @override
  String get homeTutorialClosedTitle =>
      'Hai trovato o perso un oggetto?\nCosa puoi fare ora?';

  @override
  String get homeTutorialOpenLostItem => 'Oggetto perso';

  @override
  String get homeTutorialOpenFoundItem => 'Oggetto trovato';

  @override
  String get successInsertItem => 'Oggetto correttamente creato';

  @override
  String get titleFieldTitle => 'Titolo';

  @override
  String get titleFieldHint => 'Nome riconoscibile per l\'oggetto';

  @override
  String get failureInvalidTitle =>
      'Il titolo deve contenere tra 1 e 50 caratteri.';

  @override
  String get itemType => 'L\'oggetto è stato';

  @override
  String get questionFieldTitle => 'Domanda per verificare la proprietà';

  @override
  String get questionFieldHint => 'Domanda chiara e preciso';

  @override
  String get failureInvalidQuestionField =>
      'La domanda di sicurezza è richiesta.';

  @override
  String get create => 'Crea';

  @override
  String get insertItemTitle => 'Inserisci un Oggetto';

  @override
  String get successSolveItem => 'Oggetto correttamente risolto';

  @override
  String get successDeleteItem => 'Oggetto eliminato con successo';

  @override
  String get itemPageTitle => 'Dettagli Oggetto';

  @override
  String get itemMenu1 => 'Marca come risolto';

  @override
  String get itemMenu2 => 'Modifica';

  @override
  String get itemMenu3 => 'Elimina';

  @override
  String get lostBy => 'Perso da';

  @override
  String get foundBy => 'Trovato da';

  @override
  String get claimsForItem => 'Richieste per questo oggetto';

  @override
  String get noClaimsForItem => 'Non ci sono ancora richieste.';

  @override
  String get claimItemButton => 'Richiedi oggetto';

  @override
  String get newsPageTitle => 'News';

  @override
  String get successItemUpdate => 'Oggetto modificato correttamente';

  @override
  String get updateItemPageTitle => 'Modifica Oggetto';

  @override
  String get update => 'Modifica';

  @override
  String openClaims(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString richieste',
      one: '1 richiesta',
    );
    return '$_temp0';
  }

  @override
  String get resolved => 'Risolto';

  @override
  String get yourFoundItems => 'I tuoi oggetti trovati';

  @override
  String get yourLostItems => 'I tuoi oggetti persi';

  @override
  String get noFoundItemContent =>
      'Non ci sono ancora oggetti trovati, continua a cercare!';

  @override
  String get noFoundItemButton => 'Inserisci un oggetto trovato';

  @override
  String get noLostItemContent => 'Non hai oggetti persi!';

  @override
  String get noLostItemButton => 'Inserisci un oggetto perso';

  @override
  String get uploadImageButton => 'Carica una foto';

  @override
  String get foundNear => 'Trovato vicino';

  @override
  String get lostNear => 'Perso vicino';

  @override
  String get noMapAppTitle => 'Nessuna App di navigazione installata';

  @override
  String get noMapAppContent =>
      'Oops! Sembra che nel dispositivo non ci sia nessuna app per visualizzare questa posizione. Per favore installa un\'app come Google Maps e riprova.';

  @override
  String get dateInsertion => 'Data di inserimento';

  @override
  String get category => 'Categoria';

  @override
  String get question => 'Domanda per verificare la proprietà';

  @override
  String get openMap => 'Apri mappa';

  @override
  String get hey => 'Ehi, ';

  @override
  String get mightFound => 'potrebe aver trovato';

  @override
  String get mightLost => 'potrebbe essere il proprietario di';

  @override
  String get noContentNewsTitle => 'Non ci sono news per te';

  @override
  String get noContentNewsSubtitle =>
      'Le news verranno mostrate qui non appena qualcuno inserirà un oggetto che potrebbe corrispondere a uno dei tuoi';

  @override
  String metersAway(num meters) {
    final intl.NumberFormat metersNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String metersString = metersNumberFormat.format(meters);

    return 'Distante ${metersString}m';
  }

  @override
  String get noContentSearchResultTitle =>
      'Nessun oggetto trovato per i parametri inseriti';

  @override
  String get noContentSearchResultSubtitle =>
      'Prova di nuovo con parametri più generici';

  @override
  String get selectSortingDialogTitle => 'Selezione un ordinamento.';

  @override
  String get successPasswordChange => 'Password aggiornata con successo';

  @override
  String get changePasswordButton => 'Cambia Password';

  @override
  String get passwordCreate1 => 'Per creare una password sicura:';

  @override
  String get passwordCreate2 => 'Usa almeno 8 caratteri;';

  @override
  String get passwordCreate3 =>
      'Usa una combinazione di lettere maiuscole e minuscole e numeri.';

  @override
  String get passwordFormCurrentHint => 'Password attuale';

  @override
  String get failureInvalidOldPasswordNotMatching =>
      'La password non corrisponde alla tua attuale password.';

  @override
  String get failureInvalidOldPassword => 'Password attuale richiesta.';

  @override
  String get newPasswordHint => 'Nuova password';

  @override
  String get failureInvalidNewPassword =>
      'Password deve contenere almeno 8 caratteri maiscuoli, minuscoli e numerici.';

  @override
  String get confirmNewPasswordField => 'Conferma nuova password';

  @override
  String get invalidConfirmNewPassword =>
      'Il campo non corrisponde al valore della nuova password.';

  @override
  String get tutorial => 'Tutorial';

  @override
  String get lostItems => 'Oggetti persi';

  @override
  String get foundItems => 'Oggetti trovati';

  @override
  String get successUploadImage => 'Immagine caricata con successo';

  @override
  String get successLogout => 'Logout eseguito correttamente';

  @override
  String get profile => 'Profilo';

  @override
  String get logout => 'Logout';

  @override
  String get logoutDialogContent => 'Sei sicuro di voler uscire?';

  @override
  String get logoutDialogNo => 'No, rimani collegato';

  @override
  String get logoutDialogYes => 'Si, esci';

  @override
  String get tutorialFoundItemTitle1 => 'Inserisci un Oggetto Trovato';

  @override
  String get tutorialFoundItemContent1 =>
      'Inserisci i dettagli dell\'oggetto trovato come titolo, posizione, categoria, domanda di verifica e crea il report. Questo avviserà tutti gli utenti che hanno inserito un oggetto perso simile a quello che hai appena inserito.';

  @override
  String get tutorialFoundItemTitle2 => 'Gestisci le Richieste ricevute';

  @override
  String get tutorialFoundItemContent2 =>
      'Attendi che gli utenti aprano una richiesta per avere il tuo oggetto trovato. Approva quella che sembra più attendibile. Quando ne approverai una, l\'oggetto non sarà più visibile e tutte le altre richieste saranno automaticamente rifiutate.';

  @override
  String get tutorialFoundItemTitle3 =>
      'Chatta per Organizzare la Restituzione dell\'Oggetto';

  @override
  String get tutorialFoundItemContent3 =>
      'Contatta, attraverso la chat, l\'utente che ha mandato la richiesta da te approvata, in modo da poter organizzare un incontro per la restituzione dell\'oggetto.';

  @override
  String get tutorialFoundItemTitle4 =>
      'Marca il tuo Oggetto Trovato come Risolto';

  @override
  String get tutorialFoundItemContent4 =>
      'Tutto è andato bene e l\'oggetto è ritornato al legittimo proprietario!\nMarca l\'oggetto trovato come risolto per rimuoverlo dall\'app.';

  @override
  String get tutorialLostItemTitle1 => 'Inserisci un Oggetto Perso';

  @override
  String get tutorialLostItemContent1 =>
      'Inserisci i dettagli dell\'oggetto perso come titolo, posizione, categoria e inseriscilo.\nQuesto notificherà tutti gli utenti che hanno inserito un oggetto trovato che potrebbe corrispondere a quello che hai appena inserito.';

  @override
  String get tutorialLostItemTitle2 => 'Crea una Richiesta';

  @override
  String get tutorialLostItemContent2 =>
      'Cerca oggetti trovati di altri utenti e controlla le news. Quando troverai un oggetto che potrebbe corrispondere a quello che hai perso, crea una richiesta.\nAttendi la validazione della richiesta da parte dell\'altro utente.';

  @override
  String get tutorialLostItemTitle3 =>
      'Chatta per Organizzare la Restituzione dell\'Oggetto';

  @override
  String get tutorialLostItemContent3 =>
      'Se la tua richiesta è stata approvata, contatta, attraverso la chat, l\'utente che l\'ha accetta, in modo da organizzare un incontro per la restituzione del tuo oggetto.';

  @override
  String get tutorialLostItemTitle4 =>
      'Marca il tuo Oggetto Perso come Risolto';

  @override
  String get tutorialLostItemContent4 =>
      'Tutto è andato bene e l\'oggetto è ritornato al legittimo proprietario!\nMarca l\'oggetto perso come risolto per rimuoverlo dall\'app.';

  @override
  String get claimStatusPending => 'in attesa';

  @override
  String get claimStatusApproved => 'accettata';

  @override
  String get claimStatusRejected => 'rifiutata';

  @override
  String get itemTypeLost => 'perso';

  @override
  String get itemTypeFound => 'trovato';

  @override
  String get orderAZ => 'A a Z';

  @override
  String get orderZA => 'Z a A';

  @override
  String get orderOldestNewest => 'Più vecchio a più nuovo';

  @override
  String get orderNewestOldest => 'Più nuovo a più vecchio';

  @override
  String get orderFarthestNearest => 'Più lontano a più vicino';

  @override
  String get orderNearestFarthest => 'Più vicino a più lontano';

  @override
  String get changeLanguage => 'Cambia Lingua';

  @override
  String get selectLanguageDialogTitle => 'Seleziona Lingua';

  @override
  String get selectDate => 'Seleziona Data';

  @override
  String get categoryAllTitle => 'Tutte';

  @override
  String get categoryAllDescription => 'Tutte le posibili categorie';

  @override
  String get markAsSolvedDialogDescription =>
      'Sei sicuro di voler contrassegnare questo report come risolto?\n\nSe lo contrassegni come risolto, il report non sarà più visibile.';

  @override
  String get notMarkAsSolved => 'No, non marcare come risolto';

  @override
  String get deleteReportDialogDescription =>
      'Sei sicuro di voler eliminare questo report?\n\nSe lo elimini, il report non sarà più visibile e le chat associate ad esso saranno cancellate.';

  @override
  String get noDeleteReport => 'No, non eliminare report';

  @override
  String get goToMapTitle => 'Visualizza in Mappe';

  @override
  String get goToMapsDialogDescription =>
      'Stai per essere reindirizzato alla tua app delle mappe per visualizzare questa posizione.\n\nSei sicuro di voler uscire dall\'app?';

  @override
  String get noStayInApp => 'No, rimani nell’app';

  @override
  String get yesSeeMaps => 'Sì, visualizza in mappe';

  @override
  String get next => 'Avanti';

  @override
  String get itemAlreadySolvedToast =>
      'Impossibile mostrare i dettagli dell\'oggetto, esso non è più visibile.';

  @override
  String get tutorialCompleted => 'Tutorial completato!';

  @override
  String get changeTheme => 'Cambia Tema';

  @override
  String get themeSystem => 'Default di sistema';

  @override
  String get themeDark => 'Scuro';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get selectThemeDialogTitle => 'Seleziona Tema';

  @override
  String get login => 'Login';

  @override
  String get registration => 'Registrazione';

  @override
  String get newsForFoundItem => 'Oggetti persi simili';

  @override
  String get newsForLostItem => 'Oggetti trovati simili';

  @override
  String get noNewsForItem => 'Non ci sono ancora novità';

  @override
  String get searchPosition => 'Cerca una posizione';

  @override
  String get insertCityOrAddress => 'Inserisci una città o un indirizzo';

  @override
  String get failureInvalidAddress =>
      'L\'indirizzo è richiesto, solo lettere e numeri sono consentiti.';

  @override
  String get positionNotFound =>
      'Impossibile trovare la posizione di questo indirizzo.';
}
