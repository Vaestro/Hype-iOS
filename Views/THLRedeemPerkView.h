//
//  THLRedeemPerkView.h
//  Hype
//
//  Created by Daniel Aksenov on 12/19/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"

@interface THLRedeemPerkView : FXBlurView
@property (nonatomic, strong) RACCommand *dismissCommand;
@property (nonatomic, strong) NSString *confirmationDescription;
@end
