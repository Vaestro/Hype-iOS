//
//  THLAdmissionsViewController.m
//  Hype
//
//  Created by Daniel Aksenov on 5/26/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLAdmissionsViewController.h"
#import "Parse.h"
#import "THLAppearanceConstants.h"


@interface THLAdmissionsViewController ()
@property (nonatomic) PFObject *event;
@property (nonatomic, strong) UILabel *ticketLabel;
@end

@implementation THLAdmissionsViewController

-(id)initWithEvent:(PFObject *)event
{
    if (self = [super init]) {
        self.event = event;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kTHLNUISecondaryBackgroundColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    
   
}


@end
