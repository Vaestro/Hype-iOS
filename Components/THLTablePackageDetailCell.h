//
//  THLTablePackageDetailCell.h
//  Hype
//
//  Created by Daniel Aksenov on 6/5/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ParseUI/PFCollectionViewCell.h>

@interface THLTablePackageDetailCell : PFCollectionViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UILabel *partySizeLabel;
+ (NSString *)identifier;
@end

