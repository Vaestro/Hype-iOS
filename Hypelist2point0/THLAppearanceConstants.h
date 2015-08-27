//
//  THLAppearanceConstants.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#ifndef Hypelist2point0_THLAppearanceConstants_h
#define Hypelist2point0_THLAppearanceConstants_h

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

static float const kTHLGoldenRatio = 1.61803398875f;
static float const kTHLGoldenRatioInverse = 0.61803398875f;

static CGFloat const kTHLCornerRadius = 5;
static CGFloat const kTHLBaseUnit = 5;

static NSString *const kTHLNUIUndef = nil;

typedef NS_ENUM(NSInteger, THLUnit) {
	THLUnitNone = 0,
	THLUnitLow,
	THLUnitHigh
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
	return THLPadding(THLUnitNone);
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
