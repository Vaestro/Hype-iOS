//
//  THLTextEntryViewController.h
//  HypeUp
//
//  Created by Edgar Li on 3/14/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THLTextEntryViewController;

typedef NS_ENUM(NSInteger, THLTextEntryType)
{
    THLTextEntryTypeEmail,
    THLTextEntryTypeCode
};

@protocol THLTextEntryViewDelegate <NSObject>
- (void)emailEntryView:(THLTextEntryViewController *)view userDidSubmitEmail:(NSString *)email;
- (void)codeEntryView:(THLTextEntryViewController *)view userDidSubmitCode:(NSString *)code;
@end


@interface THLTextEntryViewController : UIViewController
@property (nonatomic, weak) id<THLTextEntryViewDelegate> delegate;
@property (nonatomic, assign) THLTextEntryType type;

@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *descriptionText;
@property (nonatomic, strong) NSString *buttonText;

@property (nonatomic) NSInteger textLength;

@end
