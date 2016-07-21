//
//  THLTextEntryViewController.h
//  Hype
//
//  Created by Edgar Li on 3/14/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THLActionButton.h"

@class THLTextEntryViewController;

typedef NS_ENUM(NSInteger, THLTextEntryType)
{
    THLTextEntryTypeEmail,
    THLTextEntryTypeRedeemCode
};

@protocol THLTextEntryViewDelegate <NSObject>
- (void)emailEntryView:(THLTextEntryViewController *)view userDidSubmitEmail:(NSString *)email;
- (void)codeEntryView:(THLTextEntryViewController *)view userDidSubmitRedemptionCode:(NSString *)code;
@end


@interface THLTextEntryViewController : UIViewController
@property (nonatomic, weak) id<THLTextEntryViewDelegate> delegate;

- (instancetype)initWithType:(THLTextEntryType)type title:(NSString *)title description:(NSString *)description buttonText:(NSString *)buttonText;

@property (nonatomic) NSInteger textLength;

@end
