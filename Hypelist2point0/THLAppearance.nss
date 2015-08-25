@primaryBoldFontName: Raleway-Bold;
@primaryMediumFontName: Raleway-Medium;
@primaryRegularFontName: Raleway-Regular;
@secondaryRegularFontName: HelveticaNeue-Regular;
@primaryFontColor: #FFFFFF;
@secondaryFontColor: #2BC497;
@primaryBackgroundColor: #1A1F25;
@secondaryBackgroundColor: #060606;
@primaryBorderColor: #FFFFFF;
@primaryBorderWidth: 0.5;
@cornerRadius : 10;

AccentLabel {
font-color: @secondaryFontColor;
font-name: @secondaryRegularFontName;
font-size: 18;
}

Button {
font-color: @primaryBackgroundColor;
font-color-highlighted: @primaryFontColor;
font-name: @secondaryRegularFontName;
font-size: 22;
exclude-views: UIAlertButton;
exclude-subviews: UITableViewCell,UITextField;
}

BarButtonLabel {
font-color: @primaryFontColor;
font-name: @secondaryRegularFontName;
font-size: 20;
}


DetailLabel {
font-color: @primaryFontColor;
font-name: @secondaryRegularFontName;
font-size: 22;
}

Label {
font-name: @secondaryRegularFontName;
font-size: 24;
font-color: @primaryFontColor;
background-color: clear;
}

NavbarTitle {
font-color: @primaryFontColor;
font-name: @primaryRegularFontName;
font-size: 24;
}

NumberValidationTextField {
font-color: @primaryFontColor;
font-name: @primaryBoldFontName;
font-size: 40;
}

SectionTitle {
text-alpha: 70;
font-color: @primaryFontColor;
font-name: @primaryRegularFontName;
font-size: 18;
}

TableCell {
font-color: @primaryFontColor;
font-name: @secondaryRegularFontName;
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

TitleBold {
font-color: @primaryFontColor;
font-name: @primaryBoldFontName;
font-size: 28;
}

TitleRegular {
font-color: @primaryFontColor;
font-name: @primaryRegularFontName;
font-size: 22;
}