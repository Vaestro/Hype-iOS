//
//  THLUserProfileFooterView.h
//  TheHypelist
//
//  Created by Edgar Li on 12/8/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THLUserProfileFooterView : UITableViewHeaderFooterView
+ (NSString *)identifier;
@property (nonatomic, strong) RACCommand *emailCommand;
@property (nonatomic, strong) RACCommand *logoutCommand;

@end