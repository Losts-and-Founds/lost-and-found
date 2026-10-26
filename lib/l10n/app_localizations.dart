import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Lost and Found'**
  String get appName;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @singIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get singIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @item.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Item} other{Items}}'**
  String item(num count);

  /// No description provided for @lostAndFound.
  ///
  /// In en, this message translates to:
  /// **'Lost&Found'**
  String get lostAndFound;

  /// No description provided for @found.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Found} other{Found}}'**
  String found(num count);

  /// No description provided for @lost.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Lost} other{Lost}}'**
  String lost(num count);

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'Email or Username'**
  String get user;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @claim.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Claim} other{Claims}}'**
  String claim(num count);

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Message} other{Messages}}'**
  String message(num count);

  /// No description provided for @homeBottomBarTab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeBottomBarTab;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @searchBottomBarTab.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchBottomBarTab;

  /// No description provided for @insertBottomBarTab.
  ///
  /// In en, this message translates to:
  /// **'Insert'**
  String get insertBottomBarTab;

  /// No description provided for @inboxBottomBarTab.
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get inboxBottomBarTab;

  /// No description provided for @profileBottomBarTab.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileBottomBarTab;

  /// No description provided for @cameraPermissionDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera Permission Required'**
  String get cameraPermissionDialogTitle;

  /// No description provided for @cameraPermissionDialogContentPermanentlyDenied.
  ///
  /// In en, this message translates to:
  /// **'To take pictures you need to allow camera permissions.\n\nPlease go to the app settings and enable it.'**
  String get cameraPermissionDialogContentPermanentlyDenied;

  /// No description provided for @cameraPermissionDialogContentDenied.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required to use your camera.'**
  String get cameraPermissionDialogContentDenied;

  /// No description provided for @categoryPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a category'**
  String get categoryPageTitle;

  /// No description provided for @categoryFormEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryFormEntryTitle;

  /// No description provided for @positionPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Select position'**
  String get positionPageTitle;

  /// No description provided for @positionUseCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use my current location'**
  String get positionUseCurrentLocation;

  /// No description provided for @positionUseSelected.
  ///
  /// In en, this message translates to:
  /// **'Choose this position'**
  String get positionUseSelected;

  /// No description provided for @locationPermissionDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Location Permission Required'**
  String get locationPermissionDialogTitle;

  /// No description provided for @locationPermissionDialogContentPermanentlyDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission is required to use your current location.\n\nPlease go to app settings and enable it.'**
  String get locationPermissionDialogContentPermanentlyDenied;

  /// No description provided for @locationPermissionDialogContentDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission is required to use your current location.'**
  String get locationPermissionDialogContentDenied;

  /// No description provided for @noConnectionDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'No Connection'**
  String get noConnectionDialogTitle;

  /// No description provided for @noConnectionDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connectivity'**
  String get noConnectionDialogContent;

  /// No description provided for @positionDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Position Service Disabled'**
  String get positionDialogTitle;

  /// No description provided for @positionDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Please enable your position service'**
  String get positionDialogContent;

  /// No description provided for @tutorialInitialPage1Title.
  ///
  /// In en, this message translates to:
  /// **'Report a Lost Item'**
  String get tutorialInitialPage1Title;

  /// No description provided for @tutorialInitialPage1Content.
  ///
  /// In en, this message translates to:
  /// **'Input the item details in the app to report it as lost.'**
  String get tutorialInitialPage1Content;

  /// No description provided for @tutorialInitialPage2Title.
  ///
  /// In en, this message translates to:
  /// **'Report a Found Item'**
  String get tutorialInitialPage2Title;

  /// No description provided for @tutorialInitialPage2Content.
  ///
  /// In en, this message translates to:
  /// **'Notify others by reporting a found item through the app.'**
  String get tutorialInitialPage2Content;

  /// No description provided for @tutorialInitialPage3Title.
  ///
  /// In en, this message translates to:
  /// **'Arrange Item Return'**
  String get tutorialInitialPage3Title;

  /// No description provided for @tutorialInitialPage3Content.
  ///
  /// In en, this message translates to:
  /// **'Connect with the finder via messaging to arrange a safe meetup location for item return.'**
  String get tutorialInitialPage3Content;

  /// No description provided for @confirmExitDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Exit'**
  String get confirmExitDialogTitle;

  /// No description provided for @confirmExitDialogContent.
  ///
  /// In en, this message translates to:
  /// **'By exiting this page you will lose your current progress. Are you sure you want to exit?'**
  String get confirmExitDialogContent;

  /// No description provided for @stayInPage.
  ///
  /// In en, this message translates to:
  /// **'No, stay in the page'**
  String get stayInPage;

  /// No description provided for @errorPageTitle.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while loading the data.'**
  String get errorPageTitle;

  /// No description provided for @errorPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please try again later'**
  String get errorPageSubtitle;

  /// No description provided for @mediaSelectionDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Please select a media option'**
  String get mediaSelectionDialogTitle;

  /// No description provided for @dateFormEntrySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Date of upload'**
  String get dateFormEntrySubtitle;

  /// No description provided for @dateFormEntryValue.
  ///
  /// In en, this message translates to:
  /// **'After {date}'**
  String dateFormEntryValue(String date);

  /// No description provided for @positionFormEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get positionFormEntryTitle;

  /// No description provided for @positionFormEntrySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Where the item has been found or lost'**
  String get positionFormEntrySubtitle;

  /// No description provided for @positionFormEntryNotSelected.
  ///
  /// In en, this message translates to:
  /// **'Position not chosen yet'**
  String get positionFormEntryNotSelected;

  /// No description provided for @signUpText.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get signUpText;

  /// No description provided for @signInText.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get signInText;

  /// No description provided for @failureInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials. Please try again.'**
  String get failureInvalidCredentials;

  /// No description provided for @failureGeneric.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later.'**
  String get failureGeneric;

  /// No description provided for @failureNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection available. Check your internet connection.'**
  String get failureNetwork;

  /// No description provided for @failureUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get failureUnknown;

  /// No description provided for @failureInvalidPassword.
  ///
  /// In en, this message translates to:
  /// **'Invalid password. Password must contain at least 8 characters, using uppercase, lowercase and numeric characters.'**
  String get failureInvalidPassword;

  /// No description provided for @failureInvalidUser.
  ///
  /// In en, this message translates to:
  /// **'Invalid username or email.'**
  String get failureInvalidUser;

  /// No description provided for @failureConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Field doesn\'t match the original password.'**
  String get failureConfirmPassword;

  /// No description provided for @failureEmailDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Email already used.'**
  String get failureEmailDuplicate;

  /// No description provided for @failureEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format.'**
  String get failureEmailInvalid;

  /// No description provided for @failureInvalidPasswordCreation.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least 8 characters, using uppercase, lowercase and numeric characters.'**
  String get failureInvalidPasswordCreation;

  /// No description provided for @successSignUp.
  ///
  /// In en, this message translates to:
  /// **'Successful sign up'**
  String get successSignUp;

  /// No description provided for @successAnswerClaim.
  ///
  /// In en, this message translates to:
  /// **'Claim successfully managed'**
  String get successAnswerClaim;

  /// No description provided for @successAnswerQuestion.
  ///
  /// In en, this message translates to:
  /// **'Claim successfully created'**
  String get successAnswerQuestion;

  /// No description provided for @failureUsernameDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Username already used.'**
  String get failureUsernameDuplicate;

  /// No description provided for @failureInvalidUsername.
  ///
  /// In en, this message translates to:
  /// **'Username can contain up to 30 alphanumeric digits.'**
  String get failureInvalidUsername;

  /// No description provided for @noContentInboxTitle.
  ///
  /// In en, this message translates to:
  /// **'No active chats'**
  String get noContentInboxTitle;

  /// No description provided for @noContentInboxSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Chat with someone to see the chat list'**
  String get noContentInboxSubtitle;

  /// No description provided for @answerClaimTitle.
  ///
  /// In en, this message translates to:
  /// **'Answer to claim'**
  String get answerClaimTitle;

  /// No description provided for @answerClaimTutorialClosedManaged.
  ///
  /// In en, this message translates to:
  /// **'You have already managed this claim.'**
  String get answerClaimTutorialClosedManaged;

  /// No description provided for @answerClaimTutorialClosedUnmanaged.
  ///
  /// In en, this message translates to:
  /// **'You are deciding whether to accept or deny this claim.'**
  String get answerClaimTutorialClosedUnmanaged;

  /// No description provided for @answerClaimTutorialOpenManaged.
  ///
  /// In en, this message translates to:
  /// **'On this page, you can find the information about this received claim.'**
  String get answerClaimTutorialOpenManaged;

  /// No description provided for @answerClaimTutorialOpenUnmanaged.
  ///
  /// In en, this message translates to:
  /// **'Please review the answer received and make a decision to either accept or decline this claim. If you accept this claim, all the other claims for this item will be automatically rejected and the item won\'t be visible anymore by others.'**
  String get answerClaimTutorialOpenUnmanaged;

  /// No description provided for @itemClaimedBy.
  ///
  /// In en, this message translates to:
  /// **'Item claimed by {username}'**
  String itemClaimedBy(String username);

  /// No description provided for @yourQuestion.
  ///
  /// In en, this message translates to:
  /// **'Your question'**
  String get yourQuestion;

  /// No description provided for @answerOf.
  ///
  /// In en, this message translates to:
  /// **'Answer of {username}'**
  String answerOf(String username);

  /// No description provided for @claimStatus.
  ///
  /// In en, this message translates to:
  /// **'Claim status'**
  String get claimStatus;

  /// No description provided for @acceptedAnswerClaim.
  ///
  /// In en, this message translates to:
  /// **'You have accepted this claim. Get in touch with {username} through the chat to arrange the item\'s return.'**
  String acceptedAnswerClaim(String username);

  /// No description provided for @rejectedClaim.
  ///
  /// In en, this message translates to:
  /// **'You have rejected this claim.'**
  String get rejectedClaim;

  /// No description provided for @validateClaim.
  ///
  /// In en, this message translates to:
  /// **'Validate the claim.'**
  String get validateClaim;

  /// No description provided for @answerQuestionTitle.
  ///
  /// In en, this message translates to:
  /// **'Answer claim question'**
  String get answerQuestionTitle;

  /// No description provided for @answerQuestionTutorialClosedManaged.
  ///
  /// In en, this message translates to:
  /// **'You have claimed this item.'**
  String get answerQuestionTutorialClosedManaged;

  /// No description provided for @answerQuestionTutorialClosedUnmanaged.
  ///
  /// In en, this message translates to:
  /// **'You are claiming this item.'**
  String get answerQuestionTutorialClosedUnmanaged;

  /// No description provided for @answerQuestionTutorialOpenManaged.
  ///
  /// In en, this message translates to:
  /// **'On this page, you can find information about this claim you have made.'**
  String get answerQuestionTutorialOpenManaged;

  /// No description provided for @answerQuestionTutorialOpenUnmanaged.
  ///
  /// In en, this message translates to:
  /// **'To claim the item, please answer the following question correctly. If you can provide the correct answer, the user who found the item will approve your claim and then you can have your item back.'**
  String get answerQuestionTutorialOpenUnmanaged;

  /// No description provided for @itemClaiming.
  ///
  /// In en, this message translates to:
  /// **'Item you are claiming'**
  String get itemClaiming;

  /// No description provided for @questionOf.
  ///
  /// In en, this message translates to:
  /// **'Question of {username}'**
  String questionOf(String username);

  /// No description provided for @yourAnswer.
  ///
  /// In en, this message translates to:
  /// **'Your answer'**
  String get yourAnswer;

  /// No description provided for @failureInvalidQuestion.
  ///
  /// In en, this message translates to:
  /// **'Answer is required.'**
  String get failureInvalidQuestion;

  /// No description provided for @acceptedQuestionClaim.
  ///
  /// In en, this message translates to:
  /// **'Your claim has been accepted! Get in touch with {username} through the chat to arrange the item\'s return.'**
  String acceptedQuestionClaim(String username);

  /// No description provided for @rejectedQuestionClaim.
  ///
  /// In en, this message translates to:
  /// **'Unfortunately, your claim has been rejected by {username}.'**
  String rejectedQuestionClaim(String username);

  /// No description provided for @waitQuestionClaim.
  ///
  /// In en, this message translates to:
  /// **'Wait for {username} to validate to your claim.'**
  String waitQuestionClaim(String username);

  /// No description provided for @receivedClaims.
  ///
  /// In en, this message translates to:
  /// **'Received claims'**
  String get receivedClaims;

  /// No description provided for @yourClaims.
  ///
  /// In en, this message translates to:
  /// **'Your claims'**
  String get yourClaims;

  /// No description provided for @noContentClaimReceivedTitle.
  ///
  /// In en, this message translates to:
  /// **'No received claims to manage'**
  String get noContentClaimReceivedTitle;

  /// No description provided for @noContentClaimReceivedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Claims will be displayed as soon as someone claims one of your found items'**
  String get noContentClaimReceivedSubtitle;

  /// No description provided for @claimReceivedTutorial.
  ///
  /// In en, this message translates to:
  /// **'In this section there are the claims, made by other users, for the items you have found.'**
  String get claimReceivedTutorial;

  /// No description provided for @noContentClaimSentTitle.
  ///
  /// In en, this message translates to:
  /// **'No open claims'**
  String get noContentClaimSentTitle;

  /// No description provided for @noContentClaimSentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your claims will be displayed as soon as you claim a found item'**
  String get noContentClaimSentSubtitle;

  /// No description provided for @claimSentTutorial.
  ///
  /// In en, this message translates to:
  /// **'In this section there are the claims you have made for items founded by other users.'**
  String get claimSentTutorial;

  /// No description provided for @claimedBy.
  ///
  /// In en, this message translates to:
  /// **'Claimed by {username}'**
  String claimedBy(String username);

  /// No description provided for @claimStatusSpaced.
  ///
  /// In en, this message translates to:
  /// **'Claim status '**
  String get claimStatusSpaced;

  /// No description provided for @seeDetails.
  ///
  /// In en, this message translates to:
  /// **'See Details'**
  String get seeDetails;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send a Message'**
  String get sendMessage;

  /// No description provided for @filtersPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage Filters'**
  String get filtersPageTitle;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @deleteAll.
  ///
  /// In en, this message translates to:
  /// **'DELETE ALL'**
  String get deleteAll;

  /// No description provided for @failureInvalidType.
  ///
  /// In en, this message translates to:
  /// **'Check at least one of the two options.'**
  String get failureInvalidType;

  /// No description provided for @failureInvalidPosition.
  ///
  /// In en, this message translates to:
  /// **'Select the position of the item.'**
  String get failureInvalidPosition;

  /// No description provided for @failureInvalidCategory.
  ///
  /// In en, this message translates to:
  /// **'Select a category.'**
  String get failureInvalidCategory;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @tooltipNews.
  ///
  /// In en, this message translates to:
  /// **'news'**
  String get tooltipNews;

  /// No description provided for @tooltipClaims.
  ///
  /// In en, this message translates to:
  /// **'claims'**
  String get tooltipClaims;

  /// No description provided for @homeTutorialClosedTitle.
  ///
  /// In en, this message translates to:
  /// **'Have you lost or found an item?\nWhat should you do now?'**
  String get homeTutorialClosedTitle;

  /// No description provided for @homeTutorialOpenLostItem.
  ///
  /// In en, this message translates to:
  /// **'I lost an Item'**
  String get homeTutorialOpenLostItem;

  /// No description provided for @homeTutorialOpenFoundItem.
  ///
  /// In en, this message translates to:
  /// **'I found an Item'**
  String get homeTutorialOpenFoundItem;

  /// No description provided for @successInsertItem.
  ///
  /// In en, this message translates to:
  /// **'Item successfully created'**
  String get successInsertItem;

  /// No description provided for @titleFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleFieldTitle;

  /// No description provided for @titleFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Recognizable name for the item'**
  String get titleFieldHint;

  /// No description provided for @failureInvalidTitle.
  ///
  /// In en, this message translates to:
  /// **'Title must have between 1 and 50 characters.'**
  String get failureInvalidTitle;

  /// No description provided for @itemType.
  ///
  /// In en, this message translates to:
  /// **'The item has been'**
  String get itemType;

  /// No description provided for @questionFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Question to verify the ownership'**
  String get questionFieldTitle;

  /// No description provided for @questionFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Clear and precise question'**
  String get questionFieldHint;

  /// No description provided for @failureInvalidQuestionField.
  ///
  /// In en, this message translates to:
  /// **'Safe question is required.'**
  String get failureInvalidQuestionField;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @insertItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Insert an Item'**
  String get insertItemTitle;

  /// No description provided for @successSolveItem.
  ///
  /// In en, this message translates to:
  /// **'Item successfully solved'**
  String get successSolveItem;

  /// No description provided for @successDeleteItem.
  ///
  /// In en, this message translates to:
  /// **'Item successfully deleted'**
  String get successDeleteItem;

  /// No description provided for @itemPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Item Details'**
  String get itemPageTitle;

  /// No description provided for @itemMenu1.
  ///
  /// In en, this message translates to:
  /// **'Mark as solved'**
  String get itemMenu1;

  /// No description provided for @itemMenu2.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get itemMenu2;

  /// No description provided for @itemMenu3.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get itemMenu3;

  /// No description provided for @lostBy.
  ///
  /// In en, this message translates to:
  /// **'Lost by'**
  String get lostBy;

  /// No description provided for @foundBy.
  ///
  /// In en, this message translates to:
  /// **'Found by'**
  String get foundBy;

  /// No description provided for @claimsForItem.
  ///
  /// In en, this message translates to:
  /// **'Claims for this item'**
  String get claimsForItem;

  /// No description provided for @noClaimsForItem.
  ///
  /// In en, this message translates to:
  /// **'No claims received yet.'**
  String get noClaimsForItem;

  /// No description provided for @claimItemButton.
  ///
  /// In en, this message translates to:
  /// **'Claim the item'**
  String get claimItemButton;

  /// No description provided for @newsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get newsPageTitle;

  /// No description provided for @successItemUpdate.
  ///
  /// In en, this message translates to:
  /// **'Item successfully updated'**
  String get successItemUpdate;

  /// No description provided for @updateItemPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Item'**
  String get updateItemPageTitle;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @openClaims.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 claim} other{{count} claims}}'**
  String openClaims(num count);

  /// No description provided for @resolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get resolved;

  /// No description provided for @yourFoundItems.
  ///
  /// In en, this message translates to:
  /// **'Your found items'**
  String get yourFoundItems;

  /// No description provided for @yourLostItems.
  ///
  /// In en, this message translates to:
  /// **'Your lost items'**
  String get yourLostItems;

  /// No description provided for @noFoundItemContent.
  ///
  /// In en, this message translates to:
  /// **'No found items yet, keep searching!'**
  String get noFoundItemContent;

  /// No description provided for @noFoundItemButton.
  ///
  /// In en, this message translates to:
  /// **'Insert a found item'**
  String get noFoundItemButton;

  /// No description provided for @noLostItemContent.
  ///
  /// In en, this message translates to:
  /// **'You have no lost item!'**
  String get noLostItemContent;

  /// No description provided for @noLostItemButton.
  ///
  /// In en, this message translates to:
  /// **'Insert a lost item'**
  String get noLostItemButton;

  /// No description provided for @uploadImageButton.
  ///
  /// In en, this message translates to:
  /// **'Upload a photo'**
  String get uploadImageButton;

  /// No description provided for @foundNear.
  ///
  /// In en, this message translates to:
  /// **'Found near'**
  String get foundNear;

  /// No description provided for @lostNear.
  ///
  /// In en, this message translates to:
  /// **'Lost near'**
  String get lostNear;

  /// No description provided for @noMapAppTitle.
  ///
  /// In en, this message translates to:
  /// **'No Map App Found'**
  String get noMapAppTitle;

  /// No description provided for @noMapAppContent.
  ///
  /// In en, this message translates to:
  /// **'Oops! It looks like there\'s no map app on your device to open this link. Please install a mapping app like Google Maps and try again.'**
  String get noMapAppContent;

  /// No description provided for @dateInsertion.
  ///
  /// In en, this message translates to:
  /// **'Date of insertion'**
  String get dateInsertion;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'Question to verify the ownership'**
  String get question;

  /// No description provided for @openMap.
  ///
  /// In en, this message translates to:
  /// **'Open map'**
  String get openMap;

  /// No description provided for @hey.
  ///
  /// In en, this message translates to:
  /// **'Hey, '**
  String get hey;

  /// No description provided for @mightFound.
  ///
  /// In en, this message translates to:
  /// **'might have found your'**
  String get mightFound;

  /// No description provided for @mightLost.
  ///
  /// In en, this message translates to:
  /// **'might be the owner of'**
  String get mightLost;

  /// No description provided for @noContentNewsTitle.
  ///
  /// In en, this message translates to:
  /// **'No news waiting for you'**
  String get noContentNewsTitle;

  /// No description provided for @noContentNewsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'News will be displayed as soon as someone inserts an item that may match one of yours'**
  String get noContentNewsSubtitle;

  /// No description provided for @metersAway.
  ///
  /// In en, this message translates to:
  /// **'{meters}m away'**
  String metersAway(num meters);

  /// No description provided for @noContentSearchResultTitle.
  ///
  /// In en, this message translates to:
  /// **'No matching items found with these parameters'**
  String get noContentSearchResultTitle;

  /// No description provided for @noContentSearchResultSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try again with more general ones'**
  String get noContentSearchResultSubtitle;

  /// No description provided for @selectSortingDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Select a sorting method.'**
  String get selectSortingDialogTitle;

  /// No description provided for @successPasswordChange.
  ///
  /// In en, this message translates to:
  /// **'Password successfully updated'**
  String get successPasswordChange;

  /// No description provided for @changePasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordButton;

  /// No description provided for @passwordCreate1.
  ///
  /// In en, this message translates to:
  /// **'To create a secure password:'**
  String get passwordCreate1;

  /// No description provided for @passwordCreate2.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters;'**
  String get passwordCreate2;

  /// No description provided for @passwordCreate3.
  ///
  /// In en, this message translates to:
  /// **'Use a combination of uppercase letters, lowercase letters and numbers.'**
  String get passwordCreate3;

  /// No description provided for @passwordFormCurrentHint.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get passwordFormCurrentHint;

  /// No description provided for @failureInvalidOldPasswordNotMatching.
  ///
  /// In en, this message translates to:
  /// **'Old password doesn\'t correspond to actual password.'**
  String get failureInvalidOldPasswordNotMatching;

  /// No description provided for @failureInvalidOldPassword.
  ///
  /// In en, this message translates to:
  /// **'Old password is required.'**
  String get failureInvalidOldPassword;

  /// No description provided for @newPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPasswordHint;

  /// No description provided for @failureInvalidNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least 8 characters, using uppercase, lowercase and numeric characters.'**
  String get failureInvalidNewPassword;

  /// No description provided for @confirmNewPasswordField.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmNewPasswordField;

  /// No description provided for @invalidConfirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Field doesn\'t match the new password.'**
  String get invalidConfirmNewPassword;

  /// No description provided for @tutorial.
  ///
  /// In en, this message translates to:
  /// **'Tutorial'**
  String get tutorial;

  /// No description provided for @lostItems.
  ///
  /// In en, this message translates to:
  /// **'Lost items'**
  String get lostItems;

  /// No description provided for @foundItems.
  ///
  /// In en, this message translates to:
  /// **'Found items'**
  String get foundItems;

  /// No description provided for @successUploadImage.
  ///
  /// In en, this message translates to:
  /// **'Image uploaded successfully'**
  String get successUploadImage;

  /// No description provided for @successLogout.
  ///
  /// In en, this message translates to:
  /// **'Successful logout'**
  String get successLogout;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutDialogContent;

  /// No description provided for @logoutDialogNo.
  ///
  /// In en, this message translates to:
  /// **'No, stay connected'**
  String get logoutDialogNo;

  /// No description provided for @logoutDialogYes.
  ///
  /// In en, this message translates to:
  /// **'Yes, log out'**
  String get logoutDialogYes;

  /// No description provided for @tutorialFoundItemTitle1.
  ///
  /// In en, this message translates to:
  /// **'Report a Found Item'**
  String get tutorialFoundItemTitle1;

  /// No description provided for @tutorialFoundItemContent1.
  ///
  /// In en, this message translates to:
  /// **'Input the item details such as title, position, category, safe question and create a new report.\nThis would notify all the users that have reported a lost item that could match the features of the one you have inserted.'**
  String get tutorialFoundItemContent1;

  /// No description provided for @tutorialFoundItemTitle2.
  ///
  /// In en, this message translates to:
  /// **'Manage received Claims'**
  String get tutorialFoundItemTitle2;

  /// No description provided for @tutorialFoundItemContent2.
  ///
  /// In en, this message translates to:
  /// **'Wait for users to open claims for your found item. Manage all of them, approve the most correct one. If you approve a claim for your found item, nobody will be able to see that item again and all the other claims will be automatically rejected.'**
  String get tutorialFoundItemContent2;

  /// No description provided for @tutorialFoundItemTitle3.
  ///
  /// In en, this message translates to:
  /// **'Chat to Arrange Item Return'**
  String get tutorialFoundItemTitle3;

  /// No description provided for @tutorialFoundItemContent3.
  ///
  /// In en, this message translates to:
  /// **'Get in touch, through the chat, with the user who filled the claim you have approved, to arrange the item\'s return.'**
  String get tutorialFoundItemContent3;

  /// No description provided for @tutorialFoundItemTitle4.
  ///
  /// In en, this message translates to:
  /// **'Mark Found Item as Solved'**
  String get tutorialFoundItemTitle4;

  /// No description provided for @tutorialFoundItemContent4.
  ///
  /// In en, this message translates to:
  /// **'Everything went smooth, and the item came back to the legitimate owner!\nMark your found item as solved to remove it from the app.'**
  String get tutorialFoundItemContent4;

  /// No description provided for @tutorialLostItemTitle1.
  ///
  /// In en, this message translates to:
  /// **'Report a Lost Item'**
  String get tutorialLostItemTitle1;

  /// No description provided for @tutorialLostItemContent1.
  ///
  /// In en, this message translates to:
  /// **'Input the item details such as title, position, category and create a new report.\nThis would notify all the users that have reported a found item that could match the features of the one you have inserted.'**
  String get tutorialLostItemContent1;

  /// No description provided for @tutorialLostItemTitle2.
  ///
  /// In en, this message translates to:
  /// **'Create a Claim'**
  String get tutorialLostItemTitle2;

  /// No description provided for @tutorialLostItemContent2.
  ///
  /// In en, this message translates to:
  /// **'Browse found items of the other users or check if there are news for your lost item.\nOnce you find an item that could match your lost one, create a claim by answering to the safe question.\nWait for the other user to validate your claim.'**
  String get tutorialLostItemContent2;

  /// No description provided for @tutorialLostItemTitle3.
  ///
  /// In en, this message translates to:
  /// **'Chat to Arrange Item Return'**
  String get tutorialLostItemTitle3;

  /// No description provided for @tutorialLostItemContent3.
  ///
  /// In en, this message translates to:
  /// **'If your claim has been approved, then get in touch with the other user, through the chat, to arrange the item\'s return.'**
  String get tutorialLostItemContent3;

  /// No description provided for @tutorialLostItemTitle4.
  ///
  /// In en, this message translates to:
  /// **'Mark Lost Item as Solved'**
  String get tutorialLostItemTitle4;

  /// No description provided for @tutorialLostItemContent4.
  ///
  /// In en, this message translates to:
  /// **'Everything went smooth, and the item came back to the legitimate owner!\nMark your lost item as solved to remove it from the app.'**
  String get tutorialLostItemContent4;

  /// No description provided for @claimStatusPending.
  ///
  /// In en, this message translates to:
  /// **'pending'**
  String get claimStatusPending;

  /// No description provided for @claimStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'approved'**
  String get claimStatusApproved;

  /// No description provided for @claimStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'rejected'**
  String get claimStatusRejected;

  /// No description provided for @itemTypeLost.
  ///
  /// In en, this message translates to:
  /// **'lost'**
  String get itemTypeLost;

  /// No description provided for @itemTypeFound.
  ///
  /// In en, this message translates to:
  /// **'found'**
  String get itemTypeFound;

  /// No description provided for @orderAZ.
  ///
  /// In en, this message translates to:
  /// **'A to Z'**
  String get orderAZ;

  /// No description provided for @orderZA.
  ///
  /// In en, this message translates to:
  /// **'Z to A'**
  String get orderZA;

  /// No description provided for @orderOldestNewest.
  ///
  /// In en, this message translates to:
  /// **'Oldest to Newest'**
  String get orderOldestNewest;

  /// No description provided for @orderNewestOldest.
  ///
  /// In en, this message translates to:
  /// **'Newest to Oldest'**
  String get orderNewestOldest;

  /// No description provided for @orderFarthestNearest.
  ///
  /// In en, this message translates to:
  /// **'Farthest to Nearest'**
  String get orderFarthestNearest;

  /// No description provided for @orderNearestFarthest.
  ///
  /// In en, this message translates to:
  /// **'Nearest to Farthest'**
  String get orderNearestFarthest;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @selectLanguageDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguageDialogTitle;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @categoryAllTitle.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get categoryAllTitle;

  /// No description provided for @categoryAllDescription.
  ///
  /// In en, this message translates to:
  /// **'All possible categories'**
  String get categoryAllDescription;

  /// No description provided for @markAsSolvedDialogDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to mark this report as solved? \n\nIf you mark it as solved, the report will no longer be visible.'**
  String get markAsSolvedDialogDescription;

  /// No description provided for @notMarkAsSolved.
  ///
  /// In en, this message translates to:
  /// **'No, don\'t mark it as solved'**
  String get notMarkAsSolved;

  /// No description provided for @deleteReportDialogDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this report? \n\nIf you delete it, the report will no longer be visible and the chats associated with it will be deleted.'**
  String get deleteReportDialogDescription;

  /// No description provided for @noDeleteReport.
  ///
  /// In en, this message translates to:
  /// **'No, don\'t delete the report'**
  String get noDeleteReport;

  /// No description provided for @goToMapTitle.
  ///
  /// In en, this message translates to:
  /// **'See in Maps'**
  String get goToMapTitle;

  /// No description provided for @goToMapsDialogDescription.
  ///
  /// In en, this message translates to:
  /// **'You are about to be redirected to your maps app to view this location.\n\nAre you sure you want to exit the app?'**
  String get goToMapsDialogDescription;

  /// No description provided for @noStayInApp.
  ///
  /// In en, this message translates to:
  /// **'No, stay in the app'**
  String get noStayInApp;

  /// No description provided for @yesSeeMaps.
  ///
  /// In en, this message translates to:
  /// **'Yes, see in Maps'**
  String get yesSeeMaps;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @itemAlreadySolvedToast.
  ///
  /// In en, this message translates to:
  /// **'Cannot access item\'s details, the item is not visible anymore.'**
  String get itemAlreadySolvedToast;

  /// No description provided for @tutorialCompleted.
  ///
  /// In en, this message translates to:
  /// **'Tutorial completed!'**
  String get tutorialCompleted;

  /// No description provided for @changeTheme.
  ///
  /// In en, this message translates to:
  /// **'Change Theme'**
  String get changeTheme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get themeSystem;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @selectThemeDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get selectThemeDialogTitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @registration.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get registration;

  /// No description provided for @newsForFoundItem.
  ///
  /// In en, this message translates to:
  /// **'Matching lost items'**
  String get newsForFoundItem;

  /// No description provided for @newsForLostItem.
  ///
  /// In en, this message translates to:
  /// **'Matching found items'**
  String get newsForLostItem;

  /// No description provided for @noNewsForItem.
  ///
  /// In en, this message translates to:
  /// **'No news received yet'**
  String get noNewsForItem;

  /// No description provided for @searchPosition.
  ///
  /// In en, this message translates to:
  /// **'Search a position'**
  String get searchPosition;

  /// No description provided for @insertCityOrAddress.
  ///
  /// In en, this message translates to:
  /// **'Insert a city or an address'**
  String get insertCityOrAddress;

  /// No description provided for @failureInvalidAddress.
  ///
  /// In en, this message translates to:
  /// **'Address is required, only letters and numbers are allowed.'**
  String get failureInvalidAddress;

  /// No description provided for @positionNotFound.
  ///
  /// In en, this message translates to:
  /// **'Unable to find the position of this address.'**
  String get positionNotFound;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
