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
@property (nonatomic, strong) CAShapeLayer *shapeView;
@end

@implementation THLStatusView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self constructView];
        [self layoutView];
        [self bindView];
        _scale = 0.5;
    }
    return self;
}

- (void)constructView {
    _shapeView = [self newShapeView];
}

- (void)layoutView {
    [self.layer addSublayer:_shapeView];
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//}

- (void)bindView {
    WEAKSELF();
    [RACObserve(self, status) subscribeNext:^(NSNumber *status) {
        [WSELF drawingForStatus];
//        NSLog(@"Status View is now: %ld", self.status);
    }];
}

- (CAShapeLayer *)newShapeView {
    CAShapeLayer *shapeView = [[CAShapeLayer alloc] init];
    return shapeView;
}

- (void)drawingForStatus {
    WEAKSELF();
    switch (_status) {
        case THLStatusPending: {
            [WSELF.shapeView setPath:[self pendingPath].CGPath];
            WSELF.shapeView.fillColor = [kTHLNUIPendingColor CGColor];
            break;
        }
        case THLStatusAccepted: {
            [WSELF.shapeView setPath:[self acceptedPath].CGPath];
            WSELF.shapeView.fillColor = [kTHLNUIActionColor CGColor];
            break;
        }
        case THLStatusDeclined: {
            [WSELF.shapeView setPath:[self declinedPath].CGPath];
            WSELF.shapeView.fillColor = [kTHLNUIRedColor CGColor];
            break;
        }
        case THLStatusNone: {
            [WSELF.shapeView setPath:[self declinedPath].CGPath];
            WSELF.shapeView.fillColor = [kTHLNUIRedColor CGColor];
            break;
        }
        default: {
            break;
        }
    }
}

- (UIBezierPath *)acceptedPath {
    //// Checkmark Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(12.91, 5.07)];
    [bezierPath addLineToPoint: CGPointMake(7.02, 11.1)];
    [bezierPath addLineToPoint: CGPointMake(5.05, 8.95)];
    [bezierPath addLineToPoint: CGPointMake(3.88, 10.24)];
    [bezierPath addLineToPoint: CGPointMake(7.02, 13.69)];
    [bezierPath addLineToPoint: CGPointMake(14.09, 6.36)];
    [bezierPath addLineToPoint: CGPointMake(12.91, 5.07)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(18, 9)];
    [bezierPath addCurveToPoint: CGPointMake(9, 18) controlPoint1: CGPointMake(18, 13.97) controlPoint2: CGPointMake(13.97, 18)];
    [bezierPath addCurveToPoint: CGPointMake(0, 9) controlPoint1: CGPointMake(4.03, 18) controlPoint2: CGPointMake(0, 13.97)];
    [bezierPath addCurveToPoint: CGPointMake(0.2, 7.12) controlPoint1: CGPointMake(0, 8.35) controlPoint2: CGPointMake(0.07, 7.72)];
    [bezierPath addCurveToPoint: CGPointMake(9, 0) controlPoint1: CGPointMake(1.06, 3.05) controlPoint2: CGPointMake(4.67, 0)];
    [bezierPath addCurveToPoint: CGPointMake(18, 9) controlPoint1: CGPointMake(13.97, 0) controlPoint2: CGPointMake(18, 4.03)];
    [bezierPath closePath];
//    [kTHLNUIAccentColor setFill];
//    [bezierPath fill];
    [bezierPath applyTransform:CGAffineTransformMakeScale(_scale, _scale)];
    return bezierPath;
}

- (UIBezierPath *)pendingPath {
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPath];
    [ovalPath moveToPoint: CGPointMake(20, 10)];
    [ovalPath addCurveToPoint: CGPointMake(10, 20) controlPoint1: CGPointMake(20, 15.52) controlPoint2: CGPointMake(15.52, 20)];
    [ovalPath addCurveToPoint: CGPointMake(0, 10) controlPoint1: CGPointMake(4.48, 20) controlPoint2: CGPointMake(0, 15.52)];
    [ovalPath addCurveToPoint: CGPointMake(10, 0) controlPoint1: CGPointMake(0, 4.48) controlPoint2: CGPointMake(4.48, 0)];
    [ovalPath addCurveToPoint: CGPointMake(20, 10) controlPoint1: CGPointMake(15.52, 0) controlPoint2: CGPointMake(20, 4.48)];
    [ovalPath closePath];
//    [kTHLNUIPendingColor setFill];
//    [ovalPath fill];
    [ovalPath applyTransform:CGAffineTransformMakeScale(_scale, _scale)];
    return ovalPath;
}

- (UIBezierPath *)declinedPath {
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPath];
    [ovalPath moveToPoint: CGPointMake(20, 10)];
    [ovalPath addCurveToPoint: CGPointMake(10, 20) controlPoint1: CGPointMake(20, 15.52) controlPoint2: CGPointMake(15.52, 20)];
    [ovalPath addCurveToPoint: CGPointMake(0, 10) controlPoint1: CGPointMake(4.48, 20) controlPoint2: CGPointMake(0, 15.52)];
    [ovalPath addCurveToPoint: CGPointMake(10, 0) controlPoint1: CGPointMake(0, 4.48) controlPoint2: CGPointMake(4.48, 0)];
    [ovalPath addCurveToPoint: CGPointMake(20, 10) controlPoint1: CGPointMake(15.52, 0) controlPoint2: CGPointMake(20, 4.48)];
    [ovalPath closePath];
//    [kTHLNUIRedColor setFill];
//    [ovalPath fill];
    [ovalPath applyTransform:CGAffineTransformMakeScale(_scale, _scale)];
    return ovalPath;
}

- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}
@end
