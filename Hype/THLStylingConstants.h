//
//  THLStylingConstants.h
//  HypeList
//
//  Created by Phil Meyers IV on 8/6/15.
//  Copyright (c) 2015 HypeList. All rights reserved.
//

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

#ifndef HypeList_THLStylingConstants_h
#define HypeList_THLStylingConstants_h

static CGFloat const kTHLCornerRadius = 5;
static float const kTHLGoldenRatio = 1.61803398875f;
static float const kTHLGoldenRatioInverse = 0.61803398875f;

static CGFloat const kTHLBorderWidth = 1;
static CGFloat const kTHLInset = 20;
static CGFloat const kTHLPadding = 10;
static UIEdgeInsets const kTHLEdgeInsets = {kTHLInset, kTHLInset, kTHLInset, kTHLInset};
static UIEdgeInsets const kTHLEdgePadding = {kTHLPadding, kTHLPadding, kTHLPadding, kTHLPadding};
static UIEdgeInsets const kTHLSLPagingViewInsets = {0,0,64,0};


#define kTHLNUITintColor [UIColor colorWithRed:0.169 green:0.769 blue:0.592 alpha:1]
#define kTHLNUIContrastColor [UIColor colorWithRed:0.969 green:0.114 blue:0.333 alpha:1]
#define kTHLNUIPrimaryFontColor [THLStyleKit lightTextColor]

#define kTHLNUIAccentLabel					@"AccentLabel"
#define kTHLNUIButton                       @"Button"
#define kTHLNUIBarButtonLabel				@"BarButtonLabel"
#define kTHLNUIDetailLabel					@"DetailLabel"
#define kTHLNUILabel                        @"Label"
#define kTHLNUINavbarTitle					@"NavbarTitle"
#define kTHLNUINumberValidationTextField	@"NumberValidationTextField"
#define kTHLNUISectionTitle					@"SectionTitle"
#define kTHLNUITableCell                    @"TableCell"
#define kTHLNUITableCellDetail              @"TableCellDetail"
#define kTHLNUITextField                    @"TextField"
#define kTHLNUITitleBold					@"TitleBold"
#define kTHLNUITitleRegular					@"TitleRegular"

#endif
