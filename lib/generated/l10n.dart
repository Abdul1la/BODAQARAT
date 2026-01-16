// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `English`
  String get En {
    return Intl.message(
      'English',
      name: 'En',
      desc: '',
      args: [],
    );
  }

  /// `العربیة`
  String get Ar {
    return Intl.message(
      'العربیة',
      name: 'Ar',
      desc: '',
      args: [],
    );
  }

  /// `کوردی بادینی`
  String get Bd {
    return Intl.message(
      'کوردی بادینی',
      name: 'Bd',
      desc: '',
      args: [],
    );
  }

  /// `کوردی سۆرانی`
  String get So {
    return Intl.message(
      'کوردی سۆرانی',
      name: 'So',
      desc: '',
      args: [],
    );
  }

  /// `Real Estate`
  String get realEstate {
    return Intl.message(
      'Real Estate',
      name: 'realEstate',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get Search {
    return Intl.message(
      'Search',
      name: 'Search',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Purches`
  String get Purches {
    return Intl.message(
      'Purches',
      name: 'Purches',
      desc: '',
      args: [],
    );
  }

  /// `BookMark`
  String get BookMark {
    return Intl.message(
      'BookMark',
      name: 'BookMark',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get Settings {
    return Intl.message(
      'Settings',
      name: 'Settings',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get Price {
    return Intl.message(
      'Price',
      name: 'Price',
      desc: '',
      args: [],
    );
  }

  /// `Bedroom`
  String get Bedroom {
    return Intl.message(
      'Bedroom',
      name: 'Bedroom',
      desc: '',
      args: [],
    );
  }

  /// `Bathroom`
  String get Bathroom {
    return Intl.message(
      'Bathroom',
      name: 'Bathroom',
      desc: '',
      args: [],
    );
  }

  /// `Area`
  String get Area {
    return Intl.message(
      'Area',
      name: 'Area',
      desc: '',
      args: [],
    );
  }

  /// `Interface`
  String get Interface {
    return Intl.message(
      'Interface',
      name: 'Interface',
      desc: '',
      args: [],
    );
  }

  /// `Condition`
  String get Condition {
    return Intl.message(
      'Condition',
      name: 'Condition',
      desc: '',
      args: [],
    );
  }

  /// `Floors`
  String get Floors {
    return Intl.message(
      'Floors',
      name: 'Floors',
      desc: '',
      args: [],
    );
  }

  /// `Discription`
  String get Discription {
    return Intl.message(
      'Discription',
      name: 'Discription',
      desc: '',
      args: [],
    );
  }

  /// `You need to SignUp or Login to see Purches`
  String get needToLoginPurches {
    return Intl.message(
      'You need to SignUp or Login to see Purches',
      name: 'needToLoginPurches',
      desc: '',
      args: [],
    );
  }

  /// `SignUp`
  String get SignUp {
    return Intl.message(
      'SignUp',
      name: 'SignUp',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get LoginIn {
    return Intl.message(
      'Login',
      name: 'LoginIn',
      desc: '',
      args: [],
    );
  }

  /// `You need to SignUp or Login to see and Set BookMark`
  String get needToLoginBookMark {
    return Intl.message(
      'You need to SignUp or Login to see and Set BookMark',
      name: 'needToLoginBookMark',
      desc: '',
      args: [],
    );
  }

  /// `Login To Your Account`
  String get LoginToYourAccount {
    return Intl.message(
      'Login To Your Account',
      name: 'LoginToYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get Email {
    return Intl.message(
      'Email',
      name: 'Email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get Password {
    return Intl.message(
      'Password',
      name: 'Password',
      desc: '',
      args: [],
    );
  }

  /// `Forget Password`
  String get ForgetPassword {
    return Intl.message(
      'Forget Password',
      name: 'ForgetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Dont Have Account?`
  String get DontHaveAccount {
    return Intl.message(
      'Dont Have Account?',
      name: 'DontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Have Account?`
  String get HaveAccount {
    return Intl.message(
      'Have Account?',
      name: 'HaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Email`
  String get EnterYourEmail {
    return Intl.message(
      'Enter Your Email',
      name: 'EnterYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Password`
  String get EnterYourPassword {
    return Intl.message(
      'Enter Your Password',
      name: 'EnterYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Fill this Field Please`
  String get FillthisFieldPlease {
    return Intl.message(
      'Fill this Field Please',
      name: 'FillthisFieldPlease',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get FirstName {
    return Intl.message(
      'First Name',
      name: 'FirstName',
      desc: '',
      args: [],
    );
  }

  /// `Second Name`
  String get SecondName {
    return Intl.message(
      'Second Name',
      name: 'SecondName',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get PhoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'PhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter First Name`
  String get EnterFirstName {
    return Intl.message(
      'Enter First Name',
      name: 'EnterFirstName',
      desc: '',
      args: [],
    );
  }

  /// `Enter Second Name`
  String get EnterSecondName {
    return Intl.message(
      'Enter Second Name',
      name: 'EnterSecondName',
      desc: '',
      args: [],
    );
  }

  /// `Enter Phone Number`
  String get EnterPhoneNumber {
    return Intl.message(
      'Enter Phone Number',
      name: 'EnterPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `CreateAccount`
  String get createAccount {
    return Intl.message(
      'CreateAccount',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to create Aqar Office Account or Noraml user Account?`
  String get UserOrAqarOwner {
    return Intl.message(
      'Do you want to create Aqar Office Account or Noraml user Account?',
      name: 'UserOrAqarOwner',
      desc: '',
      args: [],
    );
  }

  /// `User Account`
  String get User {
    return Intl.message(
      'User Account',
      name: 'User',
      desc: '',
      args: [],
    );
  }

  /// `Aqar Owner Account`
  String get AqarOwner {
    return Intl.message(
      'Aqar Owner Account',
      name: 'AqarOwner',
      desc: '',
      args: [],
    );
  }

  /// `Avilable`
  String get Avilable {
    return Intl.message(
      'Avilable',
      name: 'Avilable',
      desc: '',
      args: [],
    );
  }

  /// `Posts`
  String get Posts {
    return Intl.message(
      'Posts',
      name: 'Posts',
      desc: '',
      args: [],
    );
  }

  /// `Call Now`
  String get CallNow {
    return Intl.message(
      'Call Now',
      name: 'CallNow',
      desc: '',
      args: [],
    );
  }

  /// `Owner Phone Number`
  String get OwnerPhoneNumber {
    return Intl.message(
      'Owner Phone Number',
      name: 'OwnerPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `WatsApp`
  String get WatsApp {
    return Intl.message(
      'WatsApp',
      name: 'WatsApp',
      desc: '',
      args: [],
    );
  }

  /// `To Create an Account please Contact the Admin.\nContact Information are written Below`
  String get OfficeCreateAccount {
    return Intl.message(
      'To Create an Account please Contact the Admin.\nContact Information are written Below',
      name: 'OfficeCreateAccount',
      desc: '',
      args: [],
    );
  }

  /// `Search By Location`
  String get SearchByLocation {
    return Intl.message(
      'Search By Location',
      name: 'SearchByLocation',
      desc: '',
      args: [],
    );
  }

  /// `Property Type`
  String get PropertyType {
    return Intl.message(
      'Property Type',
      name: 'PropertyType',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get City {
    return Intl.message(
      'City',
      name: 'City',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get Address {
    return Intl.message(
      'Address',
      name: 'Address',
      desc: '',
      args: [],
    );
  }

  /// `Search Result is `
  String get SearchResult {
    return Intl.message(
      'Search Result is ',
      name: 'SearchResult',
      desc: '',
      args: [],
    );
  }

  /// `No Propertyies Fount`
  String get NoPropertyiesFound {
    return Intl.message(
      'No Propertyies Fount',
      name: 'NoPropertyiesFound',
      desc: '',
      args: [],
    );
  }

  /// `Book Marked : `
  String get BookMarked {
    return Intl.message(
      'Book Marked : ',
      name: 'BookMarked',
      desc: '',
      args: [],
    );
  }

  /// `Apartment`
  String get Apartment {
    return Intl.message(
      'Apartment',
      name: 'Apartment',
      desc: '',
      args: [],
    );
  }

  /// `Not Avilable`
  String get NotAvilable {
    return Intl.message(
      'Not Avilable',
      name: 'NotAvilable',
      desc: '',
      args: [],
    );
  }

  /// `Price: Low To High`
  String get PriceLowToHigh {
    return Intl.message(
      'Price: Low To High',
      name: 'PriceLowToHigh',
      desc: '',
      args: [],
    );
  }

  /// `Price: High To Low`
  String get PriceHighToLow {
    return Intl.message(
      'Price: High To Low',
      name: 'PriceHighToLow',
      desc: '',
      args: [],
    );
  }

  /// `Bedrooms: Low To High`
  String get BedroomsLowToHigh {
    return Intl.message(
      'Bedrooms: Low To High',
      name: 'BedroomsLowToHigh',
      desc: '',
      args: [],
    );
  }

  /// `Bedrooms: High To Low`
  String get BedroomsHighToLow {
    return Intl.message(
      'Bedrooms: High To Low',
      name: 'BedroomsHighToLow',
      desc: '',
      args: [],
    );
  }

  /// `Bathrooms: Low To High`
  String get BathroomsLowToHigh {
    return Intl.message(
      'Bathrooms: Low To High',
      name: 'BathroomsLowToHigh',
      desc: '',
      args: [],
    );
  }

  /// `Bathrooms: High To Low`
  String get BathroomsHighToLow {
    return Intl.message(
      'Bathrooms: High To Low',
      name: 'BathroomsHighToLow',
      desc: '',
      args: [],
    );
  }

  /// `Location : A-Z`
  String get LocationAToZ {
    return Intl.message(
      'Location : A-Z',
      name: 'LocationAToZ',
      desc: '',
      args: [],
    );
  }

  /// `Date: Newest First`
  String get DateNewToOld {
    return Intl.message(
      'Date: Newest First',
      name: 'DateNewToOld',
      desc: '',
      args: [],
    );
  }

  /// `Date: Oldest First`
  String get DateOLdtoNew {
    return Intl.message(
      'Date: Oldest First',
      name: 'DateOLdtoNew',
      desc: '',
      args: [],
    );
  }

  /// `Sorted By`
  String get SortedBy {
    return Intl.message(
      'Sorted By',
      name: 'SortedBy',
      desc: '',
      args: [],
    );
  }

  /// `Sort By Newest Added`
  String get AddSortByNewest {
    return Intl.message(
      'Sort By Newest Added',
      name: 'AddSortByNewest',
      desc: '',
      args: [],
    );
  }

  /// `Sort By Price High to Low`
  String get SortByPriceAddedHighToLow {
    return Intl.message(
      'Sort By Price High to Low',
      name: 'SortByPriceAddedHighToLow',
      desc: '',
      args: [],
    );
  }

  /// `sort by Price Low to High`
  String get SortByPriceAddedLowToHigh {
    return Intl.message(
      'sort by Price Low to High',
      name: 'SortByPriceAddedLowToHigh',
      desc: '',
      args: [],
    );
  }

  /// `Tower Number`
  String get TowerAddress {
    return Intl.message(
      'Tower Number',
      name: 'TowerAddress',
      desc: '',
      args: [],
    );
  }

  /// `In Which Floor`
  String get InWhichFloor {
    return Intl.message(
      'In Which Floor',
      name: 'InWhichFloor',
      desc: '',
      args: [],
    );
  }

  /// `Room Number`
  String get RoomNumber {
    return Intl.message(
      'Room Number',
      name: 'RoomNumber',
      desc: '',
      args: [],
    );
  }

  /// `Process`
  String get ProcessPurches {
    return Intl.message(
      'Process',
      name: 'ProcessPurches',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get Type {
    return Intl.message(
      'Type',
      name: 'Type',
      desc: '',
      args: [],
    );
  }

  /// `Data of Purches`
  String get DateOfPurches {
    return Intl.message(
      'Data of Purches',
      name: 'DateOfPurches',
      desc: '',
      args: [],
    );
  }

  /// `Date of Birth`
  String get DateOfBirth {
    return Intl.message(
      'Date of Birth',
      name: 'DateOfBirth',
      desc: '',
      args: [],
    );
  }

  /// `District`
  String get District {
    return Intl.message(
      'District',
      name: 'District',
      desc: '',
      args: [],
    );
  }

  /// `Bio`
  String get Bio {
    return Intl.message(
      'Bio',
      name: 'Bio',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get Name {
    return Intl.message(
      'Name',
      name: 'Name',
      desc: '',
      args: [],
    );
  }

  /// `Change  Photo`
  String get ChangePhoto {
    return Intl.message(
      'Change  Photo',
      name: 'ChangePhoto',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get Cancel {
    return Intl.message(
      'Cancel',
      name: 'Cancel',
      desc: '',
      args: [],
    );
  }

  /// `Save Changes`
  String get SaveChanges {
    return Intl.message(
      'Save Changes',
      name: 'SaveChanges',
      desc: '',
      args: [],
    );
  }

  /// `See Acount`
  String get SeeAcount {
    return Intl.message(
      'See Acount',
      name: 'SeeAcount',
      desc: '',
      args: [],
    );
  }

  /// `Edit and See Your Account`
  String get EditAndSeeAccount {
    return Intl.message(
      'Edit and See Your Account',
      name: 'EditAndSeeAccount',
      desc: '',
      args: [],
    );
  }

  /// `See Plans`
  String get SeePlans {
    return Intl.message(
      'See Plans',
      name: 'SeePlans',
      desc: '',
      args: [],
    );
  }

  /// `See Your Plans and Subscription`
  String get PlansAndSubscription {
    return Intl.message(
      'See Your Plans and Subscription',
      name: 'PlansAndSubscription',
      desc: '',
      args: [],
    );
  }

  /// `New Post`
  String get NewOne {
    return Intl.message(
      'New Post',
      name: 'NewOne',
      desc: '',
      args: [],
    );
  }

  /// `Sequre Payment Getaway`
  String get SequrePayment {
    return Intl.message(
      'Sequre Payment Getaway',
      name: 'SequrePayment',
      desc: '',
      args: [],
    );
  }

  /// `Pay savely with FIB`
  String get PaySavelyWithFIB {
    return Intl.message(
      'Pay savely with FIB',
      name: 'PaySavelyWithFIB',
      desc: '',
      args: [],
    );
  }

  /// `Plans`
  String get Plans {
    return Intl.message(
      'Plans',
      name: 'Plans',
      desc: '',
      args: [],
    );
  }

  /// `BOD REAL ESTATE`
  String get BODREALESTATE {
    return Intl.message(
      'BOD REAL ESTATE',
      name: 'BODREALESTATE',
      desc: '',
      args: [],
    );
  }

  /// `Choose The Best Plan`
  String get ChooseTheBestPlan {
    return Intl.message(
      'Choose The Best Plan',
      name: 'ChooseTheBestPlan',
      desc: '',
      args: [],
    );
  }

  /// `Service Price`
  String get ServicesPrice {
    return Intl.message(
      'Service Price',
      name: 'ServicesPrice',
      desc: '',
      args: [],
    );
  }

  /// `Get Plan`
  String get GetPlan {
    return Intl.message(
      'Get Plan',
      name: 'GetPlan',
      desc: '',
      args: [],
    );
  }

  /// `Payment Via The App`
  String get PaymentViaApp {
    return Intl.message(
      'Payment Via The App',
      name: 'PaymentViaApp',
      desc: '',
      args: [],
    );
  }

  /// `The Amount`
  String get TheAmount {
    return Intl.message(
      'The Amount',
      name: 'TheAmount',
      desc: '',
      args: [],
    );
  }

  /// `Preparing Payment....`
  String get PreparingPayment {
    return Intl.message(
      'Preparing Payment....',
      name: 'PreparingPayment',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get Amount {
    return Intl.message(
      'Amount',
      name: 'Amount',
      desc: '',
      args: [],
    );
  }

  /// `Payment Created successfully ✅`
  String get PaymentSuccess {
    return Intl.message(
      'Payment Created successfully ✅',
      name: 'PaymentSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Payment`
  String get Payment {
    return Intl.message(
      'Payment',
      name: 'Payment',
      desc: '',
      args: [],
    );
  }

  /// `Amount (IQD)`
  String get AmountIQD {
    return Intl.message(
      'Amount (IQD)',
      name: 'AmountIQD',
      desc: '',
      args: [],
    );
  }

  /// `Proceed to Pay`
  String get ProceedToPay {
    return Intl.message(
      'Proceed to Pay',
      name: 'ProceedToPay',
      desc: '',
      args: [],
    );
  }

  /// `Secured by 256-bit encryption`
  String get SecuredBy256_bitEncryption {
    return Intl.message(
      'Secured by 256-bit encryption',
      name: 'SecuredBy256_bitEncryption',
      desc: '',
      args: [],
    );
  }

  /// `✅ Payment successful!`
  String get PaymentSuccessfull {
    return Intl.message(
      '✅ Payment successful!',
      name: 'PaymentSuccessfull',
      desc: '',
      args: [],
    );
  }

  /// `FIBPayment`
  String get FIBPayment {
    return Intl.message(
      'FIBPayment',
      name: 'FIBPayment',
      desc: '',
      args: [],
    );
  }

  /// `Personal Detail`
  String get PersonalDetail {
    return Intl.message(
      'Personal Detail',
      name: 'PersonalDetail',
      desc: '',
      args: [],
    );
  }

  /// `Edit Information`
  String get EditInformation {
    return Intl.message(
      'Edit Information',
      name: 'EditInformation',
      desc: '',
      args: [],
    );
  }

  /// `There is no Purches Yet`
  String get ThereisnoPurchesYet {
    return Intl.message(
      'There is no Purches Yet',
      name: 'ThereisnoPurchesYet',
      desc: '',
      args: [],
    );
  }

  /// `There is no BookMark Yet`
  String get ThereisnoBookMarkYet {
    return Intl.message(
      'There is no BookMark Yet',
      name: 'ThereisnoBookMarkYet',
      desc: '',
      args: [],
    );
  }

  /// `Nothing Here Yet`
  String get NothingHereYet {
    return Intl.message(
      'Nothing Here Yet',
      name: 'NothingHereYet',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get Loading {
    return Intl.message(
      'Loading...',
      name: 'Loading',
      desc: '',
      args: [],
    );
  }

  /// `Be ready for a Different Real Estate World!`
  String get Fetching_The_Last_Update_To_You {
    return Intl.message(
      'Be ready for a Different Real Estate World!',
      name: 'Fetching_The_Last_Update_To_You',
      desc: '',
      args: [],
    );
  }

  /// `Pull To Refresh`
  String get PullToRefresh {
    return Intl.message(
      'Pull To Refresh',
      name: 'PullToRefresh',
      desc: '',
      args: [],
    );
  }

  /// `Refreshing The Content ...`
  String get RefreshingContent {
    return Intl.message(
      'Refreshing The Content ...',
      name: 'RefreshingContent',
      desc: '',
      args: [],
    );
  }

  /// `Swipe down slightly to refresh the feed`
  String get SwipeDownToRefresh {
    return Intl.message(
      'Swipe down slightly to refresh the feed',
      name: 'SwipeDownToRefresh',
      desc: '',
      args: [],
    );
  }

  /// `We are fetching the latest listings for you`
  String get FetchingTheLatest {
    return Intl.message(
      'We are fetching the latest listings for you',
      name: 'FetchingTheLatest',
      desc: '',
      args: [],
    );
  }

  /// `BookMark Loaded`
  String get BookMarkLoaded {
    return Intl.message(
      'BookMark Loaded',
      name: 'BookMarkLoaded',
      desc: '',
      args: [],
    );
  }

  /// `Error Loading BookMark`
  String get ErrorLoadingBook {
    return Intl.message(
      'Error Loading BookMark',
      name: 'ErrorLoadingBook',
      desc: '',
      args: [],
    );
  }

  /// `BookMark Removed`
  String get BookMarkRemoved {
    return Intl.message(
      'BookMark Removed',
      name: 'BookMarkRemoved',
      desc: '',
      args: [],
    );
  }

  /// `BookMark Added`
  String get BookMarkAdded {
    return Intl.message(
      'BookMark Added',
      name: 'BookMarkAdded',
      desc: '',
      args: [],
    );
  }

  /// `Request Picture Session`
  String get RequestPictureSession {
    return Intl.message(
      'Request Picture Session',
      name: 'RequestPictureSession',
      desc: '',
      args: [],
    );
  }

  /// `''Let our team capture best pictures for your property''`
  String get LetOurTeamCapture {
    return Intl.message(
      '\'\'Let our team capture best pictures for your property\'\'',
      name: 'LetOurTeamCapture',
      desc: '',
      args: [],
    );
  }

  /// `Request Form`
  String get RequestForm {
    return Intl.message(
      'Request Form',
      name: 'RequestForm',
      desc: '',
      args: [],
    );
  }

  /// `Preffered Date`
  String get PrefferedDate {
    return Intl.message(
      'Preffered Date',
      name: 'PrefferedDate',
      desc: '',
      args: [],
    );
  }

  /// `Preffered Time`
  String get PrefferedTime {
    return Intl.message(
      'Preffered Time',
      name: 'PrefferedTime',
      desc: '',
      args: [],
    );
  }

  /// `Upload Property Images (optional)`
  String get UploadPropertyImage {
    return Intl.message(
      'Upload Property Images (optional)',
      name: 'UploadPropertyImage',
      desc: '',
      args: [],
    );
  }

  /// `Select address on Map`
  String get SelectAddressOnMap {
    return Intl.message(
      'Select address on Map',
      name: 'SelectAddressOnMap',
      desc: '',
      args: [],
    );
  }

  /// `Open selected location`
  String get OpenSelectedLocation {
    return Intl.message(
      'Open selected location',
      name: 'OpenSelectedLocation',
      desc: '',
      args: [],
    );
  }

  /// `Manual Address / Notes`
  String get ManualAddressSet {
    return Intl.message(
      'Manual Address / Notes',
      name: 'ManualAddressSet',
      desc: '',
      args: [],
    );
  }

  /// `Send request`
  String get SendRequest {
    return Intl.message(
      'Send request',
      name: 'SendRequest',
      desc: '',
      args: [],
    );
  }

  /// `Property Informations`
  String get PropertyInformations {
    return Intl.message(
      'Property Informations',
      name: 'PropertyInformations',
      desc: '',
      args: [],
    );
  }

  /// `Area / District`
  String get AreaDistrict {
    return Intl.message(
      'Area / District',
      name: 'AreaDistrict',
      desc: '',
      args: [],
    );
  }

  /// `Tap to select location from the map`
  String get TapToSelectFromTheMap {
    return Intl.message(
      'Tap to select location from the map',
      name: 'TapToSelectFromTheMap',
      desc: '',
      args: [],
    );
  }

  /// `Building Name`
  String get BuildingName {
    return Intl.message(
      'Building Name',
      name: 'BuildingName',
      desc: '',
      args: [],
    );
  }

  /// `Sunrise Residency`
  String get SunriseResidency {
    return Intl.message(
      'Sunrise Residency',
      name: 'SunriseResidency',
      desc: '',
      args: [],
    );
  }

  /// `Property Details`
  String get PropertyDetails {
    return Intl.message(
      'Property Details',
      name: 'PropertyDetails',
      desc: '',
      args: [],
    );
  }

  /// `Write a description about the property...`
  String get ShortDiscription {
    return Intl.message(
      'Write a description about the property...',
      name: 'ShortDiscription',
      desc: '',
      args: [],
    );
  }

  /// `Add More +`
  String get AddMore {
    return Intl.message(
      'Add More +',
      name: 'AddMore',
      desc: '',
      args: [],
    );
  }

  /// `Upload Property Images`
  String get UploadPropertyImages {
    return Intl.message(
      'Upload Property Images',
      name: 'UploadPropertyImages',
      desc: '',
      args: [],
    );
  }

  /// `Publish Property`
  String get PublishProperty {
    return Intl.message(
      'Publish Property',
      name: 'PublishProperty',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get Location {
    return Intl.message(
      'Location',
      name: 'Location',
      desc: '',
      args: [],
    );
  }

  /// `Price Here`
  String get PriceHere {
    return Intl.message(
      'Price Here',
      name: 'PriceHere',
      desc: '',
      args: [],
    );
  }

  /// `Images`
  String get Images {
    return Intl.message(
      'Images',
      name: 'Images',
      desc: '',
      args: [],
    );
  }

  /// `Access to App`
  String get AccessToApp {
    return Intl.message(
      'Access to App',
      name: 'AccessToApp',
      desc: '',
      args: [],
    );
  }

  /// `Add & Ful Access for Posts`
  String get AddAccessPost {
    return Intl.message(
      'Add & Ful Access for Posts',
      name: 'AddAccessPost',
      desc: '',
      args: [],
    );
  }

  /// `Request Cammera Session`
  String get RequestCammeraSession {
    return Intl.message(
      'Request Cammera Session',
      name: 'RequestCammeraSession',
      desc: '',
      args: [],
    );
  }

  /// `Show Your Post at Top`
  String get ShowYourPostsAtTop {
    return Intl.message(
      'Show Your Post at Top',
      name: 'ShowYourPostsAtTop',
      desc: '',
      args: [],
    );
  }

  /// `Better appearance for Your Office`
  String get BetterAppearence {
    return Intl.message(
      'Better appearance for Your Office',
      name: 'BetterAppearence',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get LogOut {
    return Intl.message(
      'Log Out',
      name: 'LogOut',
      desc: '',
      args: [],
    );
  }

  /// `LogOut From Account`
  String get LogOutFromAccount {
    return Intl.message(
      'LogOut From Account',
      name: 'LogOutFromAccount',
      desc: '',
      args: [],
    );
  }

  /// `Upgrade`
  String get Upgrade {
    return Intl.message(
      'Upgrade',
      name: 'Upgrade',
      desc: '',
      args: [],
    );
  }

  /// `Upgrade to Office Account`
  String get UpgradeToOfficeAccount {
    return Intl.message(
      'Upgrade to Office Account',
      name: 'UpgradeToOfficeAccount',
      desc: '',
      args: [],
    );
  }

  /// `Warning`
  String get Warning {
    return Intl.message(
      'Warning',
      name: 'Warning',
      desc: '',
      args: [],
    );
  }

  /// `You will need to sign in again to access your account. `
  String get YouWillNeedSignIn {
    return Intl.message(
      'You will need to sign in again to access your account. ',
      name: 'YouWillNeedSignIn',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to continue?`
  String get Areyousureyouwanttocontinue {
    return Intl.message(
      'Are you sure you want to continue?',
      name: 'Areyousureyouwanttocontinue',
      desc: '',
      args: [],
    );
  }

  /// `User Not Found!`
  String get UserNotFound {
    return Intl.message(
      'User Not Found!',
      name: 'UserNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get Retry {
    return Intl.message(
      'Retry',
      name: 'Retry',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get Profile {
    return Intl.message(
      'Profile',
      name: 'Profile',
      desc: '',
      args: [],
    );
  }

  /// `Office Information`
  String get OfficeInformation {
    return Intl.message(
      'Office Information',
      name: 'OfficeInformation',
      desc: '',
      args: [],
    );
  }

  /// `Change Saved`
  String get ChangesSaved {
    return Intl.message(
      'Change Saved',
      name: 'ChangesSaved',
      desc: '',
      args: [],
    );
  }

  /// `Aparmtment Floor Number`
  String get AparmtmentFloorNumber {
    return Intl.message(
      'Aparmtment Floor Number',
      name: 'AparmtmentFloorNumber',
      desc: '',
      args: [],
    );
  }

  /// `Couldnt Open Map Link`
  String get CouldntOpenMapLink {
    return Intl.message(
      'Couldnt Open Map Link',
      name: 'CouldntOpenMapLink',
      desc: '',
      args: [],
    );
  }

  /// `Error Refreshing Post`
  String get ErrorRefreshingPost {
    return Intl.message(
      'Error Refreshing Post',
      name: 'ErrorRefreshingPost',
      desc: '',
      args: [],
    );
  }

  /// `Refreshing your office feed...`
  String get RefreshingYourofficefeed {
    return Intl.message(
      'Refreshing your office feed...',
      name: 'RefreshingYourofficefeed',
      desc: '',
      args: [],
    );
  }

  /// `Preparing your office dashboard`
  String get PreparingYourOfficeDashboard {
    return Intl.message(
      'Preparing your office dashboard',
      name: 'PreparingYourOfficeDashboard',
      desc: '',
      args: [],
    );
  }

  /// `Curating the latest opportunities for your company.`
  String get CuratingTheLatestOpportunitiesForYourCompany {
    return Intl.message(
      'Curating the latest opportunities for your company.',
      name: 'CuratingTheLatestOpportunitiesForYourCompany',
      desc: '',
      args: [],
    );
  }

  /// `Personalizing your dashboard`
  String get PersonalizingYourDashboard {
    return Intl.message(
      'Personalizing your dashboard',
      name: 'PersonalizingYourDashboard',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get Clear {
    return Intl.message(
      'Clear',
      name: 'Clear',
      desc: '',
      args: [],
    );
  }

  /// `Search by Office Name`
  String get SearchByName {
    return Intl.message(
      'Search by Office Name',
      name: 'SearchByName',
      desc: '',
      args: [],
    );
  }

  /// `SortBy`
  String get SortBy {
    return Intl.message(
      'SortBy',
      name: 'SortBy',
      desc: '',
      args: [],
    );
  }

  /// `Selected`
  String get Selected {
    return Intl.message(
      'Selected',
      name: 'Selected',
      desc: '',
      args: [],
    );
  }

  /// `House`
  String get House {
    return Intl.message(
      'House',
      name: 'House',
      desc: '',
      args: [],
    );
  }

  /// `Added`
  String get Added {
    return Intl.message(
      'Added',
      name: 'Added',
      desc: '',
      args: [],
    );
  }

  /// `m ago`
  String get mAgo {
    return Intl.message(
      'm ago',
      name: 'mAgo',
      desc: '',
      args: [],
    );
  }

  /// `h ago`
  String get hAgo {
    return Intl.message(
      'h ago',
      name: 'hAgo',
      desc: '',
      args: [],
    );
  }

  /// `d ago`
  String get dAgo {
    return Intl.message(
      'd ago',
      name: 'dAgo',
      desc: '',
      args: [],
    );
  }

  /// `Yesterday`
  String get Yesterday {
    return Intl.message(
      'Yesterday',
      name: 'Yesterday',
      desc: '',
      args: [],
    );
  }

  /// `Failed To Load Location`
  String get FailedToLoadLocation {
    return Intl.message(
      'Failed To Load Location',
      name: 'FailedToLoadLocation',
      desc: '',
      args: [],
    );
  }

  /// `Failed To Load state Types : `
  String get FailedToLoadStateTypes {
    return Intl.message(
      'Failed To Load state Types : ',
      name: 'FailedToLoadStateTypes',
      desc: '',
      args: [],
    );
  }

  /// `Fetched`
  String get Fetched {
    return Intl.message(
      'Fetched',
      name: 'Fetched',
      desc: '',
      args: [],
    );
  }

  /// `Options`
  String get Options {
    return Intl.message(
      'Options',
      name: 'Options',
      desc: '',
      args: [],
    );
  }

  /// `Error : `
  String get Error {
    return Intl.message(
      'Error : ',
      name: 'Error',
      desc: '',
      args: [],
    );
  }

  /// `Search failed`
  String get SearchFailed {
    return Intl.message(
      'Search failed',
      name: 'SearchFailed',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get Delete {
    return Intl.message(
      'Delete',
      name: 'Delete',
      desc: '',
      args: [],
    );
  }

  /// `Delete Post`
  String get DeletePost {
    return Intl.message(
      'Delete Post',
      name: 'DeletePost',
      desc: '',
      args: [],
    );
  }

  /// `Enter UserName`
  String get EnterYourUserName {
    return Intl.message(
      'Enter UserName',
      name: 'EnterYourUserName',
      desc: '',
      args: [],
    );
  }

  /// `User Name`
  String get UserName {
    return Intl.message(
      'User Name',
      name: 'UserName',
      desc: '',
      args: [],
    );
  }

  /// `Create New Account`
  String get CreateNewAccount {
    return Intl.message(
      'Create New Account',
      name: 'CreateNewAccount',
      desc: '',
      args: [],
    );
  }

  /// `About Us`
  String get AboutUs {
    return Intl.message(
      'About Us',
      name: 'AboutUs',
      desc: '',
      args: [],
    );
  }

  /// `Learn More About Us`
  String get LearnMoreAboutUs {
    return Intl.message(
      'Learn More About Us',
      name: 'LearnMoreAboutUs',
      desc: '',
      args: [],
    );
  }

  /// `We are a startup real-estate company dedicated to making Duhok properties fully accessible at your fingertips through a modern and user-friendly app. By combining deep industry experience with advanced software capabilities, we are building a new real-estate ecosystem designed around convenience, innovation, and real value—creating a smarter property world that serves you better.`
  String get AboutUsContent {
    return Intl.message(
      'We are a startup real-estate company dedicated to making Duhok properties fully accessible at your fingertips through a modern and user-friendly app. By combining deep industry experience with advanced software capabilities, we are building a new real-estate ecosystem designed around convenience, innovation, and real value—creating a smarter property world that serves you better.',
      name: 'AboutUsContent',
      desc: '',
      args: [],
    );
  }

  /// `Developer WebSite`
  String get DeveloperWebSite {
    return Intl.message(
      'Developer WebSite',
      name: 'DeveloperWebSite',
      desc: '',
      args: [],
    );
  }

  /// `Our Story`
  String get OurStory {
    return Intl.message(
      'Our Story',
      name: 'OurStory',
      desc: '',
      args: [],
    );
  }

  /// `Couldnt Open WebSite`
  String get CouldntOpenWebsite {
    return Intl.message(
      'Couldnt Open WebSite',
      name: 'CouldntOpenWebsite',
      desc: '',
      args: [],
    );
  }

  /// `Back-End Developer`
  String get BackEndDeveloper {
    return Intl.message(
      'Back-End Developer',
      name: 'BackEndDeveloper',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get PrivacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'PrivacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Welcome! As a guest user, you can explore many parts of the app without creating an account. Your privacy and safety are highly important to us. This policy explains how we collect, use, and protect information inside the application.\n\n1. Information We May Collect\n\nEven without registration, the app may collect limited technical data such as:\n\n- Device type, operating system, and app version\n- Actions inside the app (clicks, pages visited, searches performed)\n- Locally saved property preferences (only stored on your device)\n\nWe do not collect personal details like name, email, or phone number unless you choose to register later.\n\n2. How We Use Data\n\nThe collected data helps us:\n\n- Improve the application experience\n- Fix errors and optimize performance\n- Show relevant properties and nearby offices\n- Remember your temporary wishlist and choices on your device\n\n3. Property Images and Office Content\n\nIf you browse property listings or office uploads:\n\n- Images are displayed from secured storage servers\n- We do not modify or analyze image content beyond presenting it in the app\n- No personal metadata is extracted from images\n\n4. Wishlist and Temporary Storage\n\nAs a guest:\n\n- You can save properties to wishlist, stored only locally on your device\n- If you later create an account, the system may offer to transfer them to your profile (with your approval)\n\n5. Data Sharing\n\nWe never:\n\n- Sell or share your personal data for marketing\n- Provide guest activity logs to third parties\n- Share office contact details beyond what the office already publishes inside the app\n\nWe may only share anonymous, non-identifiable analytics data to measure general app usage trends.\n\n6. Security Measures\n\nTo keep your data safe, we use:\n\n- Encrypted connections (HTTPS)\n- Protected image storage with secure access rules\n- Regular server security checks\n- Restricted database access only for authorized developers\n\n7. External Links\n\nThe app may contain links to:\n\n- Office websites\n- Maps or call buttons\n\nOpening these services will follow their privacy policies. We are not responsible for data handled outside the app.\n\n8. Your Rights\n\nYou can:\n\n- Browse safely without being tracked personally\n- Clear your wishlist any time from the app\n- Choose to not provide any personal data until you register\n\n9. Consent\n\nBy using the app, you agree that:\n\n- Guest browsing data is collected anonymously\n- Wishlist data is only stored on your device\n\n10. Updates To This Policy\n\nWe may update this policy to improve clarity or security. Updates will appear inside the app. Continued usage means acceptance of the updated terms.\n\nContact\n\nIf you have questions about privacy or security, you can reach support from the app’s “Contact Us” section.`
  String get PrivacyPolicyDetails {
    return Intl.message(
      'Welcome! As a guest user, you can explore many parts of the app without creating an account. Your privacy and safety are highly important to us. This policy explains how we collect, use, and protect information inside the application.\n\n1. Information We May Collect\n\nEven without registration, the app may collect limited technical data such as:\n\n- Device type, operating system, and app version\n- Actions inside the app (clicks, pages visited, searches performed)\n- Locally saved property preferences (only stored on your device)\n\nWe do not collect personal details like name, email, or phone number unless you choose to register later.\n\n2. How We Use Data\n\nThe collected data helps us:\n\n- Improve the application experience\n- Fix errors and optimize performance\n- Show relevant properties and nearby offices\n- Remember your temporary wishlist and choices on your device\n\n3. Property Images and Office Content\n\nIf you browse property listings or office uploads:\n\n- Images are displayed from secured storage servers\n- We do not modify or analyze image content beyond presenting it in the app\n- No personal metadata is extracted from images\n\n4. Wishlist and Temporary Storage\n\nAs a guest:\n\n- You can save properties to wishlist, stored only locally on your device\n- If you later create an account, the system may offer to transfer them to your profile (with your approval)\n\n5. Data Sharing\n\nWe never:\n\n- Sell or share your personal data for marketing\n- Provide guest activity logs to third parties\n- Share office contact details beyond what the office already publishes inside the app\n\nWe may only share anonymous, non-identifiable analytics data to measure general app usage trends.\n\n6. Security Measures\n\nTo keep your data safe, we use:\n\n- Encrypted connections (HTTPS)\n- Protected image storage with secure access rules\n- Regular server security checks\n- Restricted database access only for authorized developers\n\n7. External Links\n\nThe app may contain links to:\n\n- Office websites\n- Maps or call buttons\n\nOpening these services will follow their privacy policies. We are not responsible for data handled outside the app.\n\n8. Your Rights\n\nYou can:\n\n- Browse safely without being tracked personally\n- Clear your wishlist any time from the app\n- Choose to not provide any personal data until you register\n\n9. Consent\n\nBy using the app, you agree that:\n\n- Guest browsing data is collected anonymously\n- Wishlist data is only stored on your device\n\n10. Updates To This Policy\n\nWe may update this policy to improve clarity or security. Updates will appear inside the app. Continued usage means acceptance of the updated terms.\n\nContact\n\nIf you have questions about privacy or security, you can reach support from the app’s “Contact Us” section.',
      name: 'PrivacyPolicyDetails',
      desc: '',
      args: [],
    );
  }

  /// `Learn more about our Privacy Policy Details`
  String get LearnMoreAboutPrivacy {
    return Intl.message(
      'Learn more about our Privacy Policy Details',
      name: 'LearnMoreAboutPrivacy',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get ContactUs {
    return Intl.message(
      'Contact Us',
      name: 'ContactUs',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us for more Information`
  String get ContactUsForMore {
    return Intl.message(
      'Contact Us for more Information',
      name: 'ContactUsForMore',
      desc: '',
      args: [],
    );
  }

  /// `You can contact us for more information about us`
  String get YouCanContact {
    return Intl.message(
      'You can contact us for more information about us',
      name: 'YouCanContact',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get Message {
    return Intl.message(
      'Message',
      name: 'Message',
      desc: '',
      args: [],
    );
  }

  /// `For sending Message`
  String get ForSendingMessage {
    return Intl.message(
      'For sending Message',
      name: 'ForSendingMessage',
      desc: '',
      args: [],
    );
  }

  /// `View our Location on the Map`
  String get ViewlocationOnMap {
    return Intl.message(
      'View our Location on the Map',
      name: 'ViewlocationOnMap',
      desc: '',
      args: [],
    );
  }

  /// `Are You Sure To continue`
  String get AreYouSureToContinue {
    return Intl.message(
      'Are You Sure To continue',
      name: 'AreYouSureToContinue',
      desc: '',
      args: [],
    );
  }

  /// `Are You Sure You Want to Request this Aqar?`
  String get AreYouSureForRequesting {
    return Intl.message(
      'Are You Sure You Want to Request this Aqar?',
      name: 'AreYouSureForRequesting',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get Confirm {
    return Intl.message(
      'Confirm',
      name: 'Confirm',
      desc: '',
      args: [],
    );
  }

  /// `Login Failed`
  String get LoginFailed {
    return Intl.message(
      'Login Failed',
      name: 'LoginFailed',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Password or User Name`
  String get InvalidPassOrUser {
    return Intl.message(
      'Invalid Password or User Name',
      name: 'InvalidPassOrUser',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get Ok {
    return Intl.message(
      'OK',
      name: 'Ok',
      desc: '',
      args: [],
    );
  }

  /// `Application Designed By`
  String get ApplicationDesigner {
    return Intl.message(
      'Application Designed By',
      name: 'ApplicationDesigner',
      desc: '',
      args: [],
    );
  }

  /// `Click to Show Posts`
  String get SearchInListing {
    return Intl.message(
      'Click to Show Posts',
      name: 'SearchInListing',
      desc: '',
      args: [],
    );
  }

  /// `Request this Real Estate`
  String get RequestThis {
    return Intl.message(
      'Request this Real Estate',
      name: 'RequestThis',
      desc: '',
      args: [],
    );
  }

  /// `Renew your office subscription to keep publishing`
  String get Renew {
    return Intl.message(
      'Renew your office subscription to keep publishing',
      name: 'Renew',
      desc: '',
      args: [],
    );
  }

  /// `Subscription expired`
  String get Expired {
    return Intl.message(
      'Subscription expired',
      name: 'Expired',
      desc: '',
      args: [],
    );
  }

  /// `Renew Now`
  String get RenwNow {
    return Intl.message(
      'Renew Now',
      name: 'RenwNow',
      desc: '',
      args: [],
    );
  }

  /// `Return to App after Payment`
  String get ReturnAfterPayment {
    return Intl.message(
      'Return to App after Payment',
      name: 'ReturnAfterPayment',
      desc: '',
      args: [],
    );
  }

  /// `Tap the button below once you have completed the payment ro Refresh`
  String get TapAfterCompleteingPayment {
    return Intl.message(
      'Tap the button below once you have completed the payment ro Refresh',
      name: 'TapAfterCompleteingPayment',
      desc: '',
      args: [],
    );
  }

  /// `Checking...`
  String get Checking {
    return Intl.message(
      'Checking...',
      name: 'Checking',
      desc: '',
      args: [],
    );
  }

  /// `Check Payment Status`
  String get CheckPaymentStatus {
    return Intl.message(
      'Check Payment Status',
      name: 'CheckPaymentStatus',
      desc: '',
      args: [],
    );
  }

  /// `Payment Verified Successfully`
  String get PaymentVefified {
    return Intl.message(
      'Payment Verified Successfully',
      name: 'PaymentVefified',
      desc: '',
      args: [],
    );
  }

  /// `Please select an area/district.`
  String get PleaseSelectAreaDistrict {
    return Intl.message(
      'Please select an area/district.',
      name: 'PleaseSelectAreaDistrict',
      desc: '',
      args: [],
    );
  }

  /// `Please select the property location from the map.`
  String get PleaseSelectProperty {
    return Intl.message(
      'Please select the property location from the map.',
      name: 'PleaseSelectProperty',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the bedroom count.`
  String get EnterBedroom {
    return Intl.message(
      'Please enter the bedroom count.',
      name: 'EnterBedroom',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the bathroom count.`
  String get EnterBathroom {
    return Intl.message(
      'Please enter the bathroom count.',
      name: 'EnterBathroom',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the total area.`
  String get EnterArea {
    return Intl.message(
      'Please enter the total area.',
      name: 'EnterArea',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the floor information.`
  String get EnterInformatioin {
    return Intl.message(
      'Please enter the floor information.',
      name: 'EnterInformatioin',
      desc: '',
      args: [],
    );
  }

  /// `Please add a short description.`
  String get AddDiscription {
    return Intl.message(
      'Please add a short description.',
      name: 'AddDiscription',
      desc: '',
      args: [],
    );
  }

  /// `Please upload at least one property image.`
  String get PleaseUploadPropertyImages {
    return Intl.message(
      'Please upload at least one property image.',
      name: 'PleaseUploadPropertyImages',
      desc: '',
      args: [],
    );
  }

  /// `See Your Subscription State`
  String get SeeSubscriptionState {
    return Intl.message(
      'See Your Subscription State',
      name: 'SeeSubscriptionState',
      desc: '',
      args: [],
    );
  }

  /// `Learn More Aboud Your Subscription State`
  String get LearnMoreAboudYourSubscriptionState {
    return Intl.message(
      'Learn More Aboud Your Subscription State',
      name: 'LearnMoreAboudYourSubscriptionState',
      desc: '',
      args: [],
    );
  }

  /// `Last Payment`
  String get LastPayment {
    return Intl.message(
      'Last Payment',
      name: 'LastPayment',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number Copied`
  String get PhoneNumberCopied {
    return Intl.message(
      'Phone Number Copied',
      name: 'PhoneNumberCopied',
      desc: '',
      args: [],
    );
  }

  /// `Expires On`
  String get ExpiresOn {
    return Intl.message(
      'Expires On',
      name: 'ExpiresOn',
      desc: '',
      args: [],
    );
  }

  /// `Cycle Length(Days)`
  String get CycleLength {
    return Intl.message(
      'Cycle Length(Days)',
      name: 'CycleLength',
      desc: '',
      args: [],
    );
  }

  /// `Day`
  String get Day {
    return Intl.message(
      'Day',
      name: 'Day',
      desc: '',
      args: [],
    );
  }

  /// `On Track`
  String get onTrack {
    return Intl.message(
      'On Track',
      name: 'onTrack',
      desc: '',
      args: [],
    );
  }

  /// `Time line`
  String get TimeLine {
    return Intl.message(
      'Time line',
      name: 'TimeLine',
      desc: '',
      args: [],
    );
  }

  /// `Paid`
  String get Paid {
    return Intl.message(
      'Paid',
      name: 'Paid',
      desc: '',
      args: [],
    );
  }

  /// `days left in this cycle.`
  String get DaysLeft {
    return Intl.message(
      'days left in this cycle.',
      name: 'DaysLeft',
      desc: '',
      args: [],
    );
  }

  /// `Subscription expired. Renew to unlock premium access.`
  String get SubscriptionExpired {
    return Intl.message(
      'Subscription expired. Renew to unlock premium access.',
      name: 'SubscriptionExpired',
      desc: '',
      args: [],
    );
  }

  /// `Need to make changes?`
  String get NeedToMakeChanges {
    return Intl.message(
      'Need to make changes?',
      name: 'NeedToMakeChanges',
      desc: '',
      args: [],
    );
  }

  /// `Manage your plan, change payment method or upgrade to unlock more features.`
  String get ManageYourSubscription {
    return Intl.message(
      'Manage your plan, change payment method or upgrade to unlock more features.',
      name: 'ManageYourSubscription',
      desc: '',
      args: [],
    );
  }

  /// `Manage Subscription`
  String get ManageSubscription {
    return Intl.message(
      'Manage Subscription',
      name: 'ManageSubscription',
      desc: '',
      args: [],
    );
  }

  /// `SignupSuccessful`
  String get SignupSuccessful {
    return Intl.message(
      'SignupSuccessful',
      name: 'SignupSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Complete The Payment In FIB App`
  String get CompleteThePaymentInFibApp {
    return Intl.message(
      'Complete The Payment In FIB App',
      name: 'CompleteThePaymentInFibApp',
      desc: '',
      args: [],
    );
  }

  /// `Payment failed`
  String get PaymentFailed {
    return Intl.message(
      'Payment failed',
      name: 'PaymentFailed',
      desc: '',
      args: [],
    );
  }

  /// `Payment Still Processing`
  String get PaymentStillProcessing {
    return Intl.message(
      'Payment Still Processing',
      name: 'PaymentStillProcessing',
      desc: '',
      args: [],
    );
  }

  /// `Successfully opened browser`
  String get SuccessfullyOpenedBrowser {
    return Intl.message(
      'Successfully opened browser',
      name: 'SuccessfullyOpenedBrowser',
      desc: '',
      args: [],
    );
  }

  /// `Payment Verifiyed`
  String get PaymentVerifiyed {
    return Intl.message(
      'Payment Verifiyed',
      name: 'PaymentVerifiyed',
      desc: '',
      args: [],
    );
  }

  /// `Request Confirmed`
  String get RequestConfirmed {
    return Intl.message(
      'Request Confirmed',
      name: 'RequestConfirmed',
      desc: '',
      args: [],
    );
  }

  /// `Engagement Updates`
  String get Engagementupdates {
    return Intl.message(
      'Engagement Updates',
      name: 'Engagementupdates',
      desc: '',
      args: [],
    );
  }

  /// `The property you bookmarked`
  String get ThePropertyYOuBookMarked {
    return Intl.message(
      'The property you bookmarked',
      name: 'ThePropertyYOuBookMarked',
      desc: '',
      args: [],
    );
  }

  /// `Revisit your bookmarked properties to see the latest updates and offers.`
  String get RevisitYourBookMarked {
    return Intl.message(
      'Revisit your bookmarked properties to see the latest updates and offers.',
      name: 'RevisitYourBookMarked',
      desc: '',
      args: [],
    );
  }

  /// `Take Another Look`
  String get TakeAnotherLook {
    return Intl.message(
      'Take Another Look',
      name: 'TakeAnotherLook',
      desc: '',
      args: [],
    );
  }

  /// `There are`
  String get ThereAre {
    return Intl.message(
      'There are',
      name: 'ThereAre',
      desc: '',
      args: [],
    );
  }

  /// `new updates watiing You`
  String get NewUpdates {
    return Intl.message(
      'new updates watiing You',
      name: 'NewUpdates',
      desc: '',
      args: [],
    );
  }

  /// `Check back today for fresh real estate opportunities.`
  String get CheckBackTodayForfreshResl {
    return Intl.message(
      'Check back today for fresh real estate opportunities.',
      name: 'CheckBackTodayForfreshResl',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'ps'),
      Locale.fromSubtags(languageCode: 'ur'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
