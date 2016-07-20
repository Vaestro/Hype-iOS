//
//  THLContactTableViewCell.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/8/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THLPersonIconView.h"

@interface THLContactTableViewCell : UITableViewCell
@property (nonatomic, strong) THLPersonIconView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneNumberLabel;

+ (NSString *)identifier;
@end
