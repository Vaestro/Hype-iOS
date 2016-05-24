//
//  THLUserProfileInfoView.h
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/11/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THLPersonIconView.h"

@interface THLUserProfileInfoView : UIView
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSURL *userImageURL;
@end
