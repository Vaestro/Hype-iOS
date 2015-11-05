//
//  THLEventTitlesView.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THLEventTitlesView : UIView
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *dateText;
@property (nonatomic, copy) NSString *locationNameText;
@property (nonatomic, copy) NSString *locationNeighborhoodText;
@property (nonatomic, copy) UIColor *separatorColor;
@end
