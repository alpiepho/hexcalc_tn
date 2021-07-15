import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

const kVersion = '0.1';

const kInputPageBackgroundColor = Colors.black45;

const kMainContainerWidthPortrait = 500.0;
const kMainContainerWidthLandscape = 1000.0;

const kMainColumnHeightPortrait = 80.0;
const kMainColumnHeightLandscape = 80.0;

const kMainColumnWidthPortrait = 80.0;
const kMainColumnWidthLandscape = 80.0;



const kSettingsModalBackgroundColor = Colors.black12;

const kSettingsSizedBoxHeight = 20.0;

const kSettingsTextStyle_fontSize = 18.0;

const kSettingsTextStyle = TextStyle(
  fontSize: kSettingsTextStyle_fontSize,
  color: Colors.black45,
  fontWeight: FontWeight.normal,
);

const kSettingsTextEditStyle = TextStyle(
  fontSize: 20.0,
  color: Colors.black,
  fontWeight: FontWeight.normal,
);


//
// Choices for score_page fonts
//
// look at https://fonts.google.com/?preview.text=0123456&preview.text_type=custom&preview.size=113
//
// enum FontTypes {
//   system,
//   lato,
//   merriweather,
//   montserrat,
//   robotoMono,
//   rockSalt,
// }

const kResultTextStyle = TextStyle(
  fontSize: 30,
  color: Colors.white,
  fontWeight: FontWeight.bold,
  height: 1.2,
);

const kBlueColor = Color(0xFF637D9E);
const kRedColor = Color(0xFFC30000);
const kGreenColor = Color(0xFF00B02B);
const kOrangeColor = Color(0xFFFF985A);
const kDarkColor = Color(0xFFF29292C);
const kLightColor = Color(0xFFACACAC);

const kLabelTextStyle = TextStyle(
  fontSize: 18.0,
  color: Colors.white,
  fontWeight: FontWeight.bold,
);

const kBlueLabelTextStyle = TextStyle(
  fontSize: 18.0,
  color: kBlueColor,
  fontWeight: FontWeight.bold,
);

const kDarkLabelTextStyle = TextStyle(
  fontSize: 18.0,
  color: kDarkColor,
  fontWeight: FontWeight.bold,
);

const kNumberTextStyle = TextStyle(
  fontSize: 36,
  color: Colors.white,
  fontWeight: FontWeight.bold,
  height: 1.1,
);

// // ignore: non_constant_identifier_names
// var kLabelTextStyle_lato = GoogleFonts.lato(
//   fontSize: 50,
//   color: Colors.black,
//   fontWeight: FontWeight.bold,
// );
// // ignore: non_constant_identifier_names
// var kNumberTextStyle_lato = GoogleFonts.lato(
//   fontSize: 25,
//   color: Colors.black,
//   fontWeight: FontWeight.bold,
//   height: 1.1,
// );

// // ignore: non_constant_identifier_names
// var kLabelTextStyle_merriweather = GoogleFonts.merriweather(
//   fontSize: 40,
//   color: Colors.black,
//   fontWeight: FontWeight.bold,
// );
// // ignore: non_constant_identifier_names
// var kNumberTextStyle_merriweather = GoogleFonts.merriweather(
//   fontSize: 25,
//   color: Colors.black,
//   fontWeight: FontWeight.bold,
//   height: 1.1,
// );

// // ignore: non_constant_identifier_names
// var kLabelTextStyle_montserrat = GoogleFonts.montserrat(
//   fontSize: 50,
//   color: Colors.black,
//   fontWeight: FontWeight.bold,
// );
// // ignore: non_constant_identifier_names
// var kNumberTextStyle_montserrat = GoogleFonts.montserrat(
//   fontSize: 25,
//   color: Colors.black,
//   fontWeight: FontWeight.bold,
//   height: 1.1,
// );

// // ignore: non_constant_identifier_names
// var kLabelTextStyle_robotomono = GoogleFonts.robotoMono(
//   fontSize: 30,
//   color: Colors.black,
//   fontWeight: FontWeight.bold,
// );
// // ignore: non_constant_identifier_names
// var kNumberTextStyle_robotomono = GoogleFonts.robotoMono(
//   fontSize: 20,
//   color: Colors.black,
//   fontWeight: FontWeight.bold,
//   height: 1.1,
// );

// // ignore: non_constant_identifier_names
// var kLabelTextStyle_rocksalt = GoogleFonts.rockSalt(
//   fontSize: 30,
//   color: Colors.black,
//   fontWeight: FontWeight.bold,
// );
// // ignore: non_constant_identifier_names
// var kNumberTextStyle_rocksalt = GoogleFonts.rockSalt(
//   fontSize: 12,
//   color: Colors.black,
//   fontWeight: FontWeight.bold,
//   height: 1.1,
// );

// String getFontString(FontTypes fontType) {
//   String t;
//   switch (fontType) {
//     case FontTypes.system:
//       t = 'Default: ex. 0123456789';
//       break;
//     case FontTypes.lato:
//       t = 'Lato: ex. 0123456789';
//       break;
//     case FontTypes.merriweather:
//       t = 'Merriweather: ex. 0123456789';
//       break;
//     case FontTypes.montserrat:
//       t = 'Montserrat: ex. 0123456789';
//       break;
//     case FontTypes.robotoMono:
//       t = 'RobotoMono: ex. 0123456789';
//       break;
//     case FontTypes.rockSalt:
//       t = 'RockSalt: ex. 0123456789';
//       break;
//   }
//   return t;
// }

// TextStyle getLabelFont(FontTypes fontType) {
//   TextStyle t;
//   switch (fontType) {
//     case FontTypes.system:
//       t = kLabelTextStyle_system;
//       break;
//     case FontTypes.lato:
//       t = kLabelTextStyle_lato;
//       break;
//     case FontTypes.merriweather:
//       t = kLabelTextStyle_merriweather;
//       break;
//     case FontTypes.montserrat:
//       t = kLabelTextStyle_montserrat;
//       break;
//     case FontTypes.robotoMono:
//       t = kLabelTextStyle_robotomono;
//       break;
//     case FontTypes.rockSalt:
//       t = kLabelTextStyle_rocksalt;
//       break;
//   }
//   return t;
// }

// TextStyle getNumberFont(FontTypes fontType) {
//   TextStyle t;
//   switch (fontType) {
//     case FontTypes.system:
//       t = kNumberTextStyle_system;
//       break;
//     case FontTypes.lato:
//       t = kNumberTextStyle_lato;
//       break;
//     case FontTypes.merriweather:
//       t = kNumberTextStyle_merriweather;
//       break;
//     case FontTypes.montserrat:
//       t = kNumberTextStyle_montserrat;
//       break;
//     case FontTypes.robotoMono:
//       t = kNumberTextStyle_robotomono;
//       break;
//     case FontTypes.rockSalt:
//       t = kNumberTextStyle_rocksalt;
//       break;
//   }
//   return t;
// }
