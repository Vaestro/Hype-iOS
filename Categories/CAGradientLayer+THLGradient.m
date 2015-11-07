//
//  CAGradientLayer+THLGradient.m
//  TheHypelist
//
//  Created by Edgar Li on 11/7/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "CAGradientLayer+THLGradient.h"

@implementation CAGradientLayer (THLGradient)
+ (CAGradientLayer *)dimGradientLayer
{
    UIColor *topColor = [UIColor whiteColor];
    UIColor *bottomColor = [UIColor blackColor];
    
    NSArray *gradientColors = [NSArray arrayWithObjects:(id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    NSArray *gradientLocations = [NSArray arrayWithObjects:[NSNumber numberWithInt:0.0],[NSNumber numberWithInt:1.0], nil];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = gradientColors;
    gradientLayer.locations = gradientLocations;
    
    return gradientLayer;
}
@end
