//
//  THLEventHostingTableCell.h
//  TheHypelist
//
//  Created by Edgar Li on 11/9/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THLEventHostingTableCellView.h"

@interface THLEventHostingTableCell : UITableViewCell <THLEventHostingTableCellView>
+ (NSString *)identifier;
@end
