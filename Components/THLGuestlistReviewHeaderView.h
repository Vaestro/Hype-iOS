//
//  THLGuestlistReviewHeaderView.h
//  Hype
//
//  Created by Daniel Aksenov on 1/4/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THLGuestlistReviewHeaderView : UIView
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *formattedDate;
@property (nonatomic, strong) NSURL *headerViewImage;
@property (nonatomic, strong) RACCommand *dismissCommand;
@property (nonatomic, strong) RACCommand *showMenuCommand;
- (void)compressView;
- (void)uncompressView;
@end
