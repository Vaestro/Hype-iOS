//
//  THLHostDashboardNotificationCell.h
//  TheHypelist
//
//  Created by Edgar Li on 12/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THLHostDashboardNotificationCellView.h"

@interface THLHostDashboardNotificationCell : UICollectionViewCell <THLHostDashboardNotificationCellView>

+ (NSString *)identifier;
@end