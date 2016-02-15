//
//  THLCreditsExplanationView.h
//  HypeUp
//
//  Created by Edgar Li on 2/14/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"

@interface THLCreditsExplanationView : FXBlurView
@property (nonatomic, strong) RACCommand *discoverEventsCommand;
@property (nonatomic, strong) RACCommand *inviteFriendsCommand;

- (void)show;
@end