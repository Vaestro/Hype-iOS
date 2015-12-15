//
//  THLDashboardNotificationCell.h
//  TheHypelist
//
//  Created by Edgar Li on 11/24/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THLDashboardNotificationCellView.h"

@interface THLDashboardNotificationCell : UICollectionViewCell <THLDashboardNotificationCellView>

+ (NSString *)identifier;
@end
