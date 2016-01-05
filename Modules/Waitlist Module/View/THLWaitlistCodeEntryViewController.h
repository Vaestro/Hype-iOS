//
//  THLWaitlistCodeEntryViewController.h
//  Hype
//
//  Created by Phil Meyers IV on 12/31/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THLWaitlistCodeEntryViewController;
@protocol THLWaitlistCodeEntryViewDelegate <NSObject>
- (void)view:(THLWaitlistCodeEntryViewController *)codeEntryView didRecieveCode:(NSString *)code;
@end

@interface THLWaitlistCodeEntryViewController : UIViewController
@property (nonatomic, weak) id<THLWaitlistCodeEntryViewDelegate> delegate;

@property (nonatomic) NSInteger codeLength;
@end
