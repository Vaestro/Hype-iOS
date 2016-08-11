//
//  THLDiscoveryCellCollectionViewCell.h
//  Hype
//
//  Created by Daniel Aksenov on 5/26/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/PFCollectionViewCell.h>
#import "THLEventTitlesView.h"

@interface THLDiscoveryCell : PFCollectionViewCell
@property(nonatomic, strong) THLEventTitlesView *titlesView;
@property(nonatomic, strong) PFImageView *venueImageView;
@property(nonatomic, strong) UILabel *eventCategoryLabel;

+ (NSString *)identifier;
@end
