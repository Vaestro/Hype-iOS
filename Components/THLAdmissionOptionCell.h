//
//  THLAdmissionOptionCell.h
//  Hype
//
//  Created by Daniel Aksenov on 6/2/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFCollectionViewCell.h"

@interface THLAdmissionOptionCell : PFCollectionViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;

+ (NSString *)identifier;
@end
