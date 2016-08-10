//
//  THLTablePackageDetailView.m
//  Hype
//
//  Created by Edgar Li on 7/29/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLTablePackageDetailView.h"
#import "THLAppearanceConstants.h"

@interface THLTablePackageDetailView()
@property (nonatomic, strong) NSMutableArray<PFObject *>*items;
@end

@implementation THLTablePackageDetailView
- (instancetype)initWithTablePackageItems:(NSMutableArray<PFObject *> *)items {
    if (self = [super init]) {
        self.items = items;
        
        WEAKSELF();
        
    }
    return self;
}


@end