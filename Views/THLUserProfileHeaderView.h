//
//  THLUserProfileHeaderView.h
//  TheHypelist
//
//  Created by Edgar Li on 12/9/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THLUserProfileHeaderView : UITableViewHeaderFooterView
+ (NSString *)identifier;
@property (nonatomic, strong) UITapGestureRecognizer *photoTapRecognizer;

@end