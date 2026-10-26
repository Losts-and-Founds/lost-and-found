// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Lost and Found';

  @override
  String get close => 'Close';

  @override
  String get cancel => 'Cancel';

  @override
  String get yes => 'Yes';

  @override
  String get ok => 'OK';

  @override
  String get singIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String item(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Items',
      zero: 'Item',
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
      other: 'Found',
      zero: 'Found',
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
      other: 'Lost',
      zero: 'Lost',
    );
    return '$_temp0';
  }

  @override
  String get retry => 'Retry';

  @override
  String get gallery => 'Gallery';

  @override
  String get camera => 'Camera';

  @override
  String get date => 'Date';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get user => 'Email or Username';

  @override
  String get email => 'Email Address';

  @override
  String get username => 'Username';

  @override
  String get send => 'Send';

  @override
  String claim(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Claims',
      zero: 'Claim',
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
      other: 'Messages',
      zero: 'Message',
    );
    return '$_temp0';
  }

  @override
  String get homeBottomBarTab => 'Home';

  @override
  String get accept => 'Accept';

  @override
  String get decline => 'Decline';

  @override
  String get searchBottomBarTab => 'Search';

  @override
  String get insertBottomBarTab => 'Insert';

  @override
  String get inboxBottomBarTab => 'Inbox';

  @override
  String get profileBottomBarTab => 'Profile';

  @override
  String get cameraPermissionDialogTitle => 'Camera Permission Required';

  @override
  String get cameraPermissionDialogContentPermanentlyDenied =>
      'To take pictures you need to allow camera permissions.\n\nPlease go to the app settings and enable it.';

  @override
  String get cameraPermissionDialogContentDenied =>
      'Camera permission is required to use your camera.';

  @override
  String get categoryPageTitle => 'Choose a category';

  @override
  String get categoryFormEntryTitle => 'Category';

  @override
  String get positionPageTitle => 'Select position';

  @override
  String get positionUseCurrentLocation => 'Use my current location';

  @override
  String get positionUseSelected => 'Choose this position';

  @override
  String get locationPermissionDialogTitle => 'Location Permission Required';

  @override
  String get locationPermissionDialogContentPermanentlyDenied =>
      'Location permission is required to use your current location.\n\nPlease go to app settings and enable it.';

  @override
  String get locationPermissionDialogContentDenied =>
      'Location permission is required to use your current location.';

  @override
  String get noConnectionDialogTitle => 'No Connection';

  @override
  String get noConnectionDialogContent =>
      'Please check your internet connectivity';

  @override
  String get positionDialogTitle => 'Position Service Disabled';

  @override
  String get positionDialogContent => 'Please enable your position service';

  @override
  String get tutorialInitialPage1Title => 'Report a Lost Item';

  @override
  String get tutorialInitialPage1Content =>
      'Input the item details in the app to report it as lost.';

  @override
  String get tutorialInitialPage2Title => 'Report a Found Item';

  @override
  String get tutorialInitialPage2Content =>
      'Notify others by reporting a found item through the app.';

  @override
  String get tutorialInitialPage3Title => 'Arrange Item Return';

  @override
  String get tutorialInitialPage3Content =>
      'Connect with the finder via messaging to arrange a safe meetup location for item return.';

  @override
  String get confirmExitDialogTitle => 'Confirm Exit';

  @override
  String get confirmExitDialogContent =>
      'By exiting this page you will lose your current progress. Are you sure you want to exit?';

  @override
  String get stayInPage => 'No, stay in the page';

  @override
  String get errorPageTitle => 'An error occurred while loading the data.';

  @override
  String get errorPageSubtitle => 'Please try again later';

  @override
  String get mediaSelectionDialogTitle => 'Please select a media option';

  @override
  String get dateFormEntrySubtitle => 'Date of upload';

  @override
  String dateFormEntryValue(String date) {
    return 'After $date';
  }

  @override
  String get positionFormEntryTitle => 'Position';

  @override
  String get positionFormEntrySubtitle =>
      'Where the item has been found or lost';

  @override
  String get positionFormEntryNotSelected => 'Position not chosen yet';

  @override
  String get signUpText => 'Don\'t have an account?';

  @override
  String get signInText => 'Already have an account?';

  @override
  String get failureInvalidCredentials =>
      'Invalid credentials. Please try again.';

  @override
  String get failureGeneric => 'Server error. Please try again later.';

  @override
  String get failureNetwork =>
      'No internet connection available. Check your internet connection.';

  @override
  String get failureUnknown => 'Unknown error';

  @override
  String get failureInvalidPassword =>
      'Invalid password. Password must contain at least 8 characters, using uppercase, lowercase and numeric characters.';

  @override
  String get failureInvalidUser => 'Invalid username or email.';

  @override
  String get failureConfirmPassword =>
      'Field doesn\'t match the original password.';

  @override
  String get failureEmailDuplicate => 'Email already used.';

  @override
  String get failureEmailInvalid => 'Invalid email format.';

  @override
  String get failureInvalidPasswordCreation =>
      'Password must contain at least 8 characters, using uppercase, lowercase and numeric characters.';

  @override
  String get successSignUp => 'Successful sign up';

  @override
  String get successAnswerClaim => 'Claim successfully managed';

  @override
  String get successAnswerQuestion => 'Claim successfully created';

  @override
  String get failureUsernameDuplicate => 'Username already used.';

  @override
  String get failureInvalidUsername =>
      'Username can contain up to 30 alphanumeric digits.';

  @override
  String get noContentInboxTitle => 'No active chats';

  @override
  String get noContentInboxSubtitle => 'Chat with someone to see the chat list';

  @override
  String get answerClaimTitle => 'Answer to claim';

  @override
  String get answerClaimTutorialClosedManaged =>
      'You have already managed this claim.';

  @override
  String get answerClaimTutorialClosedUnmanaged =>
      'You are deciding whether to accept or deny this claim.';

  @override
  String get answerClaimTutorialOpenManaged =>
      'On this page, you can find the information about this received claim.';

  @override
  String get answerClaimTutorialOpenUnmanaged =>
      'Please review the answer received and make a decision to either accept or decline this claim. If you accept this claim, all the other claims for this item will be automatically rejected and the item won\'t be visible anymore by others.';

  @override
  String itemClaimedBy(String username) {
    return 'Item claimed by $username';
  }

  @override
  String get yourQuestion => 'Your question';

  @override
  String answerOf(String username) {
    return 'Answer of $username';
  }

  @override
  String get claimStatus => 'Claim status';

  @override
  String acceptedAnswerClaim(String username) {
    return 'You have accepted this claim. Get in touch with $username through the chat to arrange the item\'s return.';
  }

  @override
  String get rejectedClaim => 'You have rejected this claim.';

  @override
  String get validateClaim => 'Validate the claim.';

  @override
  String get answerQuestionTitle => 'Answer claim question';

  @override
  String get answerQuestionTutorialClosedManaged =>
      'You have claimed this item.';

  @override
  String get answerQuestionTutorialClosedUnmanaged =>
      'You are claiming this item.';

  @override
  String get answerQuestionTutorialOpenManaged =>
      'On this page, you can find information about this claim you have made.';

  @override
  String get answerQuestionTutorialOpenUnmanaged =>
      'To claim the item, please answer the following question correctly. If you can provide the correct answer, the user who found the item will approve your claim and then you can have your item back.';

  @override
  String get itemClaiming => 'Item you are claiming';

  @override
  String questionOf(String username) {
    return 'Question of $username';
  }

  @override
  String get yourAnswer => 'Your answer';

  @override
  String get failureInvalidQuestion => 'Answer is required.';

  @override
  String acceptedQuestionClaim(String username) {
    return 'Your claim has been accepted! Get in touch with $username through the chat to arrange the item\'s return.';
  }

  @override
  String rejectedQuestionClaim(String username) {
    return 'Unfortunately, your claim has been rejected by $username.';
  }

  @override
  String waitQuestionClaim(String username) {
    return 'Wait for $username to validate to your claim.';
  }

  @override
  String get receivedClaims => 'Received claims';

  @override
  String get yourClaims => 'Your claims';

  @override
  String get noContentClaimReceivedTitle => 'No received claims to manage';

  @override
  String get noContentClaimReceivedSubtitle =>
      'Claims will be displayed as soon as someone claims one of your found items';

  @override
  String get claimReceivedTutorial =>
      'In this section there are the claims, made by other users, for the items you have found.';

  @override
  String get noContentClaimSentTitle => 'No open claims';

  @override
  String get noContentClaimSentSubtitle =>
      'Your claims will be displayed as soon as you claim a found item';

  @override
  String get claimSentTutorial =>
      'In this section there are the claims you have made for items founded by other users.';

  @override
  String claimedBy(String username) {
    return 'Claimed by $username';
  }

  @override
  String get claimStatusSpaced => 'Claim status ';

  @override
  String get seeDetails => 'See Details';

  @override
  String get sendMessage => 'Send a Message';

  @override
  String get filtersPageTitle => 'Manage Filters';

  @override
  String get filters => 'Filters';

  @override
  String get deleteAll => 'DELETE ALL';

  @override
  String get failureInvalidType => 'Check at least one of the two options.';

  @override
  String get failureInvalidPosition => 'Select the position of the item.';

  @override
  String get failureInvalidCategory => 'Select a category.';

  @override
  String get search => 'Search';

  @override
  String get home => 'Home';

  @override
  String get tooltipNews => 'news';

  @override
  String get tooltipClaims => 'claims';

  @override
  String get homeTutorialClosedTitle =>
      'Have you lost or found an item?\nWhat should you do now?';

  @override
  String get homeTutorialOpenLostItem => 'I lost an Item';

  @override
  String get homeTutorialOpenFoundItem => 'I found an Item';

  @override
  String get successInsertItem => 'Item successfully created';

  @override
  String get titleFieldTitle => 'Title';

  @override
  String get titleFieldHint => 'Recognizable name for the item';

  @override
  String get failureInvalidTitle =>
      'Title must have between 1 and 50 characters.';

  @override
  String get itemType => 'The item has been';

  @override
  String get questionFieldTitle => 'Question to verify the ownership';

  @override
  String get questionFieldHint => 'Clear and precise question';

  @override
  String get failureInvalidQuestionField => 'Safe question is required.';

  @override
  String get create => 'Create';

  @override
  String get insertItemTitle => 'Insert an Item';

  @override
  String get successSolveItem => 'Item successfully solved';

  @override
  String get successDeleteItem => 'Item successfully deleted';

  @override
  String get itemPageTitle => 'Item Details';

  @override
  String get itemMenu1 => 'Mark as solved';

  @override
  String get itemMenu2 => 'Edit';

  @override
  String get itemMenu3 => 'Delete';

  @override
  String get lostBy => 'Lost by';

  @override
  String get foundBy => 'Found by';

  @override
  String get claimsForItem => 'Claims for this item';

  @override
  String get noClaimsForItem => 'No claims received yet.';

  @override
  String get claimItemButton => 'Claim the item';

  @override
  String get newsPageTitle => 'News';

  @override
  String get successItemUpdate => 'Item successfully updated';

  @override
  String get updateItemPageTitle => 'Edit Item';

  @override
  String get update => 'Update';

  @override
  String openClaims(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString claims',
      one: '1 claim',
    );
    return '$_temp0';
  }

  @override
  String get resolved => 'Resolved';

  @override
  String get yourFoundItems => 'Your found items';

  @override
  String get yourLostItems => 'Your lost items';

  @override
  String get noFoundItemContent => 'No found items yet, keep searching!';

  @override
  String get noFoundItemButton => 'Insert a found item';

  @override
  String get noLostItemContent => 'You have no lost item!';

  @override
  String get noLostItemButton => 'Insert a lost item';

  @override
  String get uploadImageButton => 'Upload a photo';

  @override
  String get foundNear => 'Found near';

  @override
  String get lostNear => 'Lost near';

  @override
  String get noMapAppTitle => 'No Map App Found';

  @override
  String get noMapAppContent =>
      'Oops! It looks like there\'s no map app on your device to open this link. Please install a mapping app like Google Maps and try again.';

  @override
  String get dateInsertion => 'Date of insertion';

  @override
  String get category => 'Category';

  @override
  String get question => 'Question to verify the ownership';

  @override
  String get openMap => 'Open map';

  @override
  String get hey => 'Hey, ';

  @override
  String get mightFound => 'might have found your';

  @override
  String get mightLost => 'might be the owner of';

  @override
  String get noContentNewsTitle => 'No news waiting for you';

  @override
  String get noContentNewsSubtitle =>
      'News will be displayed as soon as someone inserts an item that may match one of yours';

  @override
  String metersAway(num meters) {
    final intl.NumberFormat metersNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String metersString = metersNumberFormat.format(meters);

    return '${metersString}m away';
  }

  @override
  String get noContentSearchResultTitle =>
      'No matching items found with these parameters';

  @override
  String get noContentSearchResultSubtitle =>
      'Try again with more general ones';

  @override
  String get selectSortingDialogTitle => 'Select a sorting method.';

  @override
  String get successPasswordChange => 'Password successfully updated';

  @override
  String get changePasswordButton => 'Change Password';

  @override
  String get passwordCreate1 => 'To create a secure password:';

  @override
  String get passwordCreate2 => 'Use at least 8 characters;';

  @override
  String get passwordCreate3 =>
      'Use a combination of uppercase letters, lowercase letters and numbers.';

  @override
  String get passwordFormCurrentHint => 'Current password';

  @override
  String get failureInvalidOldPasswordNotMatching =>
      'Old password doesn\'t correspond to actual password.';

  @override
  String get failureInvalidOldPassword => 'Old password is required.';

  @override
  String get newPasswordHint => 'New password';

  @override
  String get failureInvalidNewPassword =>
      'Password must contain at least 8 characters, using uppercase, lowercase and numeric characters.';

  @override
  String get confirmNewPasswordField => 'Confirm new password';

  @override
  String get invalidConfirmNewPassword =>
      'Field doesn\'t match the new password.';

  @override
  String get tutorial => 'Tutorial';

  @override
  String get lostItems => 'Lost items';

  @override
  String get foundItems => 'Found items';

  @override
  String get successUploadImage => 'Image uploaded successfully';

  @override
  String get successLogout => 'Successful logout';

  @override
  String get profile => 'Profile';

  @override
  String get logout => 'Logout';

  @override
  String get logoutDialogContent => 'Are you sure you want to log out?';

  @override
  String get logoutDialogNo => 'No, stay connected';

  @override
  String get logoutDialogYes => 'Yes, log out';

  @override
  String get tutorialFoundItemTitle1 => 'Report a Found Item';

  @override
  String get tutorialFoundItemContent1 =>
      'Input the item details such as title, position, category, safe question and create a new report.\nThis would notify all the users that have reported a lost item that could match the features of the one you have inserted.';

  @override
  String get tutorialFoundItemTitle2 => 'Manage received Claims';

  @override
  String get tutorialFoundItemContent2 =>
      'Wait for users to open claims for your found item. Manage all of them, approve the most correct one. If you approve a claim for your found item, nobody will be able to see that item again and all the other claims will be automatically rejected.';

  @override
  String get tutorialFoundItemTitle3 => 'Chat to Arrange Item Return';

  @override
  String get tutorialFoundItemContent3 =>
      'Get in touch, through the chat, with the user who filled the claim you have approved, to arrange the item\'s return.';

  @override
  String get tutorialFoundItemTitle4 => 'Mark Found Item as Solved';

  @override
  String get tutorialFoundItemContent4 =>
      'Everything went smooth, and the item came back to the legitimate owner!\nMark your found item as solved to remove it from the app.';

  @override
  String get tutorialLostItemTitle1 => 'Report a Lost Item';

  @override
  String get tutorialLostItemContent1 =>
      'Input the item details such as title, position, category and create a new report.\nThis would notify all the users that have reported a found item that could match the features of the one you have inserted.';

  @override
  String get tutorialLostItemTitle2 => 'Create a Claim';

  @override
  String get tutorialLostItemContent2 =>
      'Browse found items of the other users or check if there are news for your lost item.\nOnce you find an item that could match your lost one, create a claim by answering to the safe question.\nWait for the other user to validate your claim.';

  @override
  String get tutorialLostItemTitle3 => 'Chat to Arrange Item Return';

  @override
  String get tutorialLostItemContent3 =>
      'If your claim has been approved, then get in touch with the other user, through the chat, to arrange the item\'s return.';

  @override
  String get tutorialLostItemTitle4 => 'Mark Lost Item as Solved';

  @override
  String get tutorialLostItemContent4 =>
      'Everything went smooth, and the item came back to the legitimate owner!\nMark your lost item as solved to remove it from the app.';

  @override
  String get claimStatusPending => 'pending';

  @override
  String get claimStatusApproved => 'approved';

  @override
  String get claimStatusRejected => 'rejected';

  @override
  String get itemTypeLost => 'lost';

  @override
  String get itemTypeFound => 'found';

  @override
  String get orderAZ => 'A to Z';

  @override
  String get orderZA => 'Z to A';

  @override
  String get orderOldestNewest => 'Oldest to Newest';

  @override
  String get orderNewestOldest => 'Newest to Oldest';

  @override
  String get orderFarthestNearest => 'Farthest to Nearest';

  @override
  String get orderNearestFarthest => 'Nearest to Farthest';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get selectLanguageDialogTitle => 'Select Language';

  @override
  String get selectDate => 'Select Date';

  @override
  String get categoryAllTitle => 'All';

  @override
  String get categoryAllDescription => 'All possible categories';

  @override
  String get markAsSolvedDialogDescription =>
      'Are you sure you want to mark this report as solved? \n\nIf you mark it as solved, the report will no longer be visible.';

  @override
  String get notMarkAsSolved => 'No, don\'t mark it as solved';

  @override
  String get deleteReportDialogDescription =>
      'Are you sure you want to delete this report? \n\nIf you delete it, the report will no longer be visible and the chats associated with it will be deleted.';

  @override
  String get noDeleteReport => 'No, don\'t delete the report';

  @override
  String get goToMapTitle => 'See in Maps';

  @override
  String get goToMapsDialogDescription =>
      'You are about to be redirected to your maps app to view this location.\n\nAre you sure you want to exit the app?';

  @override
  String get noStayInApp => 'No, stay in the app';

  @override
  String get yesSeeMaps => 'Yes, see in Maps';

  @override
  String get next => 'Next';

  @override
  String get itemAlreadySolvedToast =>
      'Cannot access item\'s details, the item is not visible anymore.';

  @override
  String get tutorialCompleted => 'Tutorial completed!';

  @override
  String get changeTheme => 'Change Theme';

  @override
  String get themeSystem => 'System default';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get selectThemeDialogTitle => 'Select Theme';

  @override
  String get login => 'Login';

  @override
  String get registration => 'Registration';

  @override
  String get newsForFoundItem => 'Matching lost items';

  @override
  String get newsForLostItem => 'Matching found items';

  @override
  String get noNewsForItem => 'No news received yet';

  @override
  String get searchPosition => 'Search a position';

  @override
  String get insertCityOrAddress => 'Insert a city or an address';

  @override
  String get failureInvalidAddress =>
      'Address is required, only letters and numbers are allowed.';

  @override
  String get positionNotFound => 'Unable to find the position of this address.';
}
