//
//  THLDashboardNotificationSectionTitleCell.h
//  TheHypelist
//
//  Created by Edgar Li on 11/28/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THLDashboardNotificationSectionTitleCell : UICollectionReusableView
@property (nonatomic, copy) NSString *titleText;
+ (NSString *)identifier;

@end
