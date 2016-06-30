//
//  THLPerkStoreCell.h
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/24/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/PFCollectionViewCell.h>

@interface THLPerkStoreCell : PFCollectionViewCell
@property (nonatomic, strong) UIImageView *perkImageView;
@property (nonatomic, strong) UILabel *perkTitleLabel;
@property (nonatomic, strong) UILabel *perkCreditsLabel;
@property (nonatomic, strong) UILabel *perkDescriptionLabel;
+ (NSString *)identifier;
@end
