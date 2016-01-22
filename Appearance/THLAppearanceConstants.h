//
//  THLAppearanceConstants.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#ifndef HypeUp_THLAppearanceConstants_h
#define HypeUp_THLAppearanceConstants_h

#import "CommonMacros.h"
#import "UIImageView+WebCache.h"
//NUI
#import "NUIAppearance.h"
#import "UIButton+NUI.h"
#import "UIControl+NUI.h"
#import "UILabel+NUI.h"
#import "UINavigationBar+NUI.h"
#import "UINavigationItem+NUI.h"
#import "UITabBarItem+NUI.h"
#import "UITableViewCell+NUI.h"
#import "UITextField+NUI.h"
#import "UITextView+NUI.h"
#import "UIView+NUI.h"

//Template
//#define kTHLNUI<#Style Name#>    @"<#Style Name#>";
static CGFloat const kTHLInset = 20;

static float const kTHLGoldenRatio = 1.61803398875f;
static float const kTHLGoldenRatioInverse = 0.61803398875f;

static CGFloat const kTHLCornerRadius = 5;
static CGFloat const kTHLBaseUnit = 5;

static NSString *const kTHLNUIUndef = @"";
static NSString *const kTHLNUIBoldTitle = @"BoldTitle";
static NSString *const kTHLNUINavBarTitle = @"NavBarTitle";
static NSString *const kTHLNUIRegularTitle = @"RegularTitle";
static NSString *const kTHLNUIDetailTitle = @"DetailTitle";
static NSString *const kTHLNUIRegularDetailTitle = @"RegularDetailTitle";
static NSString *const kTHLNUIButtonTitle = @"ButtonTitle";
static NSString *const kTHLNUISectionTitle = @"SectionTitle";
static NSString *const kTHLNUIBackgroundView = @"BackgroundView";
static NSString *const kTHLNUITableCell = @"TableCell";
static NSString *const kTHLNUITableCellDetail = @"TableCellDetail";

#define kTHLNUIAccentColor [UIColor colorWithRed:0.773 green:0.702 blue:0.345 alpha:1]  /*#c5b358*/
#define kTHLNUIActionColor [UIColor colorWithRed:0.169 green:0.769 blue:0.592 alpha:1] /*#2bc497*/
#define kTHLNUIPendingColor [UIColor colorWithRed:0.984 green:0.89 blue:0.22 alpha:1] /*#fbe338*/
#define kTHLNUIRedColor [UIColor colorWithRed:0.969 green:0.114 blue:0.333 alpha:1] /*#f71d55*/
#define kTHLNUIBlueColor [UIColor colorWithRed:0.23 green:0.35 blue:0.60 alpha:1.0]; /*#3A5A99*/
#define kTHLNUIPrimaryBackgroundColor [UIColor colorWithRed:0.055 green:0.051 blue:0.071 alpha:1] /*#0e0d12*/
#define kTHLNUISecondaryBackgroundColor [UIColor colorWithRed:0.102 green:0.122 blue:0.145 alpha:1] /*#1a1f25*/
#define kTHLNUIPrimaryFontColor [UIColor colorWithRed:1 green:1 blue:1 alpha:1] /*#ffffff*/
#define kTHLNUISecondaryFontColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.67] /*#000000*/
#define kTHLNUIGrayFontColor [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7] /*#ffffff*/

typedef NS_ENUM(NSInteger, THLUnit) {
	THLUnitNone = 0,
	THLUnitLow,
	THLUnitHigh,
    THLUnitSuperHigh,
    THLUnitInsanelyHigh
};

NS_INLINE UIView*
SV(UIView *view) {
	return view.superview;
}

CG_INLINE CGFloat
THLPadding(THLUnit unit) {
	switch (unit) {
		case THLUnitNone: return 0;
		case THLUnitLow: return kTHLBaseUnit;
		case THLUnitHigh: return kTHLBaseUnit * 2;
        case THLUnitSuperHigh: return kTHLBaseUnit * 4;
        case THLUnitInsanelyHigh: return kTHLBaseUnit * 8;
		default: return THLPadding(THLUnitHigh);
	}
}

CG_INLINE CGFloat
kTHLPaddingNone() {
	return THLPadding(THLUnitNone);
}


CG_INLINE CGFloat
kTHLPaddingLow() {
	return THLPadding(THLUnitLow);
}

CG_INLINE CGFloat
kTHLPaddingHigh() {
	return THLPadding(THLUnitHigh);
}


UIKIT_STATIC_INLINE UIEdgeInsets
THLEdgeInsets(THLUnit unit) {
	return UIEdgeInsetsMake1(THLPadding(unit));
}

UIKIT_STATIC_INLINE UIEdgeInsets
kTHLEdgeInsetsNone() {
	return THLEdgeInsets(THLUnitNone);
}

UIKIT_STATIC_INLINE UIEdgeInsets
kTHLEdgeInsetsLow() {
	return THLEdgeInsets(THLUnitLow);
}

UIKIT_STATIC_INLINE UIEdgeInsets
kTHLEdgeInsetsHigh() {
	return THLEdgeInsets(THLUnitHigh);
}

UIKIT_STATIC_INLINE UIEdgeInsets
kTHLEdgeInsetsSuperHigh() {
    return THLEdgeInsets(THLUnitSuperHigh);
}

UIKIT_STATIC_INLINE UIEdgeInsets
kTHLEdgeInsetsInsanelyHigh() {
    return THLEdgeInsets(THLUnitInsanelyHigh);
}

UIKIT_STATIC_INLINE UILabel*
THLNUILabel(NSString *nuiClass) {
	UILabel *label = [UILabel new];
	if (nuiClass && nuiClass.length) {
		label.nuiClass = nuiClass;
	}
	return label;
}

UIKIT_STATIC_INLINE UIButton*
THLNUIButton(NSString *nuiClass) {
	UIButton *button = [UIButton new];
	if (nuiClass && nuiClass.length) {
		button.nuiClass = nuiClass;
	}
	return button;
}

UIKIT_STATIC_INLINE UIView*
THLNUIView(NSString *nuiClass) {
	UIView *view = [UIView new];
	if (nuiClass && nuiClass.length) {
		view.nuiClass = nuiClass;
	}
	return view;
}

UIKIT_STATIC_INLINE UITextView*
THLNUITextView(NSString *nuiClass) {
	UITextView *textView = [UITextView new];
	textView.backgroundColor = [UIColor clearColor];
	if (nuiClass && nuiClass.length) {
		textView.nuiClass = nuiClass;
	}
	return textView;
}

UIKIT_STATIC_INLINE UITextField*
THLNUITextField(NSString *nuiClass) {
	UITextField *textField = [UITextField new];
	if (nuiClass && nuiClass.length) {
		textField.nuiClass = nuiClass;
	}
	return textField;
}
#endif
