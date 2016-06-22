//
//  THLTablePackageAdmissionCell.h
//  Hype
//
//  Created by Daniel Aksenov on 6/10/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ParseUI/PFCollectionViewCell.h>

@interface THLTablePackageAdmissionCell : PFCollectionViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *perPersonLabel;
@property (nonatomic, strong) UILabel *partySizeLabel;

+ (NSString *)identifier;
@end
