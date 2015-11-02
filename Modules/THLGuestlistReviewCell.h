//
//  THLGuestlistReviewCell.h
//  Hypelist2point0
//
//  Created by Edgar Li on 11/1/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

@interface THLGuestlistReviewCell : UICollectionViewCell
@property (nonatomic, copy) NSURL *iconImageURL;
@property (nonatomic, copy) NSString *name;
//TODO: Add property for Status

+ (NSString *)identifier;
@end