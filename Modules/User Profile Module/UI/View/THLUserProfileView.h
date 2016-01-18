//
//  THLUserProfileView.h
//  TheHypelist
//
//  Created by Edgar Li on 11/10/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THLUserProfileView <NSObject>
@property (nonatomic, strong) RACCommand *selectedIndexPathCommand;
@property (nonatomic, strong) RACCommand *contactCommand;
@property (nonatomic, strong) RACCommand *logoutCommand;
@property (nonatomic, strong) NSURL *userImageURL;
@property (nonatomic, strong) NSString *userName;
-(void)showMailView;
@end
