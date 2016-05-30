//
//  THLPartyNavigationController.m
//  Hype
//
//  Created by Edgar Li on 5/27/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//
#import "THLPartyNavigationController.h"
#import "THLAppearanceConstants.h"
#import "THLEventTicketViewController.h"
#import "PFObject.h"
#import "THLEventDetailsViewController.h"

@interface THLPartyNavigationController()
@property (nonatomic, strong) PFObject *guestlistInvite;
@end

@implementation THLPartyNavigationController

- (id)initWithGuestlistInvite:(PFObject *)guestlistInvite
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _guestlistInvite = guestlistInvite;
            UIPageViewController *pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
            return [self initWithRootViewController:pageController];
            }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"MY EVENTS";
    self.navigationBar.barTintColor = kTHLNUIPrimaryBackgroundColor; //%%% bartint
    
    THLEventTicketViewController *eventTicketVC = [[THLEventTicketViewController alloc]initWithGuestlistInvite:_guestlistInvite];
    THLEventDetailsViewController *eventDetailsVC = [[THLEventDetailsViewController alloc]initWithEvent:_guestlistInvite[@"Guestlist"][@"event"] andShowNavigationBar:FALSE];
    UIViewController *vc2 = [UIViewController new];
    UIViewController *vc3 = [UIViewController new];

    [self.viewControllerArray addObjectsFromArray:@[eventTicketVC, eventDetailsVC, vc2, vc3]];
    self.buttonText = @[@"TICKET", @"EVENT", @"PARTY", @"CONCIERGE"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    self.selectionBar.backgroundColor = kTHLNUIAccentColor;
}

@end