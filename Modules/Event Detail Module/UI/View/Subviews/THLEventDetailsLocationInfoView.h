//
//  THLEventDetailsLocationInfoView.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLTitledContentView.h"

@interface THLEventDetailsLocationInfoView : THLTitledContentView
@property (nonatomic, copy) NSString *locationInfo;
@property (nonatomic, copy) NSString *locationName;
-(void)hideReadMoreTextButton;
@end
