import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const apiKey = "38f41cea1c4144e1abb41934cd67264d";
const baseUrl = "https://newsapi.org/v2/everything";
const cnnBaseUrl = "https://search.api.cnn.com/content";
// ?q=football&size=10&from=30&page=4&sort=newest
const localBaseUrl = " http://192.168.1.15";

const emotionMap = {
  "anger": 0,
  "sadness": 1,
  "fear": 1,
  "love": 3,
  "joy": 3,
  "surprise": 4,
};

const firstColor = Color.fromARGB(255, 177, 155, 142);
const secondColor = Color(0xFF457B9D);
const thirdColor = Color(0xFFF1FAEE);
const fourthColor = Color(0xFFA8DADC);
const fifthColor = Color(0xFFE64946);
const sixthColor = Colors.black;
const seventhColor = Color(0xFFA17C6B);
const backgroundColor = Color.fromARGB(255, 246, 245, 245);

TextStyle appbarTextStyle = GoogleFonts.abrilFatface(
  fontSize: 21.0,
  fontWeight: FontWeight.w300,
  color: sixthColor,
);
