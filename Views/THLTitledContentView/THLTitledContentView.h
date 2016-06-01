//
//  THLTitledContentView.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THLTitledContentView : UIView
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *contentView;
- (void)addContentText:(NSString *)text;

@end
