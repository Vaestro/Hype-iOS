//
//  THLStatusView.m
//  Hypelist2point0
//
//  Created by Edgar Li on 11/5/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLStatusView.h"
#import "THLAppearanceConstants.h"

@interface THLStatusView ()
@property (nonatomic, strong) UIImageView *shapeView;
@end

@implementation THLStatusView
- (instancetype)initWithStatus:(THLStatus)status {
    if (self = [super initWithFrame:CGRectZero]) {
        self.status = status;
        [self drawingForStatus];
    }
    return self;
}

- (void)drawingForStatus {
    switch (_status) {
        case THLStatusPending: {
            self.image = [UIImage imageNamed:@"pending_icon"];
            break;
        }
        case THLStatusAccepted: {
            self.image = [UIImage imageNamed:@"accepted_icon"];

            break;
        }
        case THLStatusCheckedIn: {
            self.image = [UIImage imageNamed:@"checked_in_icon"];

            break;
        }
        case THLStatusDeclined: {
            self.image = [UIImage imageNamed:@"decline_icon"];
            
            break;
        }
        case THLStatusNone: {

            break;
        }
        default: {
            break;
        }
    }
}

@end
