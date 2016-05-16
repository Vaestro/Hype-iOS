@primaryExtraBoldFontName: Raleway-ExtraBold;
@primaryBoldFontName: Raleway-Bold;
@primaryMediumFontName: Raleway-Medium;
@primaryRegularFontName: Raleway-Regular;
@secondaryRegularFontName: OpenSans-Regular;
@secondaryLightFontName: OpenSans-Light;
@primaryFontColor: #FFFFFF;
@secondaryFontColor: #2BC497;
@primaryBackgroundColor: #1A1F25;
@secondaryBackgroundColor: #060606;
@primaryBorderColor: #FFFFFF;
@primaryBorderWidth: 0.5;
@cornerRadius : 10;

Button {
tint-color: @primaryFontColor;
}

BoldTitle {
font-name: @primaryExtraBoldFontName;
font-color: @primaryFontColor;
font-size: 20;
text-transform: uppercase;
}

NavBarTitle {
font-name: @primaryRegularFontName;
font-color: @primaryFontColor;
font-size: 20;
}

RegularTitle {
font-name: @primaryMediumFontName;
font-color: @primaryFontColor;
font-size: 20;
}

DetailTitle {
font-name: @secondaryLightFontName;
font-color: @primaryFontColor;
font-size: 16;
}

DetailBoldTitle {
font-name: @primaryBoldFontName;
font-color: @primaryFontColor;
font-size: 16;
text-transform: uppercase;
}

RegularDetailTitle {
font-name: @secondaryRegularFontName;
font-color: @primaryFontColor;
font-size: 16;
}

ButtonTitle {
font-name: @primaryRegularFontName;
font-color: @primaryFontColor;
font-size: 16;
}

SectionTitle {
font-name: @primaryRegularFontName;
font-color: @primaryFontColor;
font-size: 14;
}

TableCell {
background-color: @primaryBackgroundColor;
font-size: 18;
}

TableCellDetail {
font-name: @secondaryRegularFontName;
font-size: 18;
font-color: @primaryFontColor;
}

TextField {
font-name: @secondaryRegularFontName;
font-size: 18;
font-color: @primaryFontColor;
}

BackgroundView {
background-color: #0e0d12;
}