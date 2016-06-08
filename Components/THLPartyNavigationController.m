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
#import "Intercom/intercom.h"
#import "THLGuestlistInvite.h"

@interface THLPartyNavigationController()
@property (nonatomic, strong) PFObject *guestlistInvite;
@property (nonatomic, strong) UIBarButtonItem *closeButton;
@property (nonatomic, strong) UIBarButtonItem *intercomBarButton;

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
    self.navigationItem.leftBarButtonItem = self.closeButton;
    self.navigationItem.rightBarButtonItem = self.intercomBarButton;

    self.navigationItem.titleView = [self navBarTitleLabel];
    self.navigationBar.barTintColor = kTHLNUIPrimaryBackgroundColor; //%%% bartint
    THLGuestlistInvite *invite = (THLGuestlistInvite *)_guestlistInvite;
    if (invite.response == THLStatusAccepted) {
        THLEventTicketViewController *eventTicketVC = [[THLEventTicketViewController alloc]initWithGuestlistInvite:_guestlistInvite];
        _eventDetailsVC = [[THLEventDetailsViewController alloc]initWithEvent:_guestlistInvite[@"Guestlist"][@"event"] guestlistInvite:nil showNavigationBar:FALSE];
        _partyVC = [[THLPartyViewController alloc] initWithClassName:@"GuestlistInvite" guestlist:_guestlistInvite[@"Guestlist"] usersInvite:_guestlistInvite];
        
        [self.viewControllerArray addObjectsFromArray:@[eventTicketVC, _eventDetailsVC, _partyVC]];
        self.buttonText = @[@"TICKET", @"EVENT", @"PARTY"];
    } else {
        _eventDetailsVC = [[THLEventDetailsViewController alloc]initWithEvent:_guestlistInvite[@"Guestlist"][@"event"] guestlistInvite:_guestlistInvite showNavigationBar:FALSE];
        _partyVC = [[THLPartyViewController alloc] initWithClassName:@"GuestlistInvite" guestlist:_guestlistInvite[@"Guestlist"] usersInvite:_guestlistInvite];
        
        [self.viewControllerArray addObjectsFromArray:@[_partyVC, _eventDetailsVC]];
        self.buttonText = @[@"PARTY", @"EVENT"];
    }

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    self.selectionBar.backgroundColor = kTHLNUIAccentColor;
}

-(void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIBarButtonItem *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(dismissViewController)];
        
        [_closeButton setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:
          kTHLNUIGrayFontColor, NSForegroundColorAttributeName,nil]
                            forState:UIControlStateNormal];
    }
    return _closeButton;
}

- (UIBarButtonItem *)intercomBarButton {
    if (!_intercomBarButton) {
        _intercomBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Help"] style:UIBarButtonItemStylePlain target:self action:@selector(messageButtonPressed)];
    }
    return _intercomBarButton;
}

- (void)messageButtonPressed
{
    [Intercom presentMessageComposer];
    
}

- (UILabel *)navBarTitleLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    NSDate *date =_guestlistInvite[@"Guestlist"][@"event"][@"date"];
    label.text = [NSString stringWithFormat:@"%@ \n %@",_guestlistInvite[@"Guestlist"][@"event"][@"location"][@"name"], date.thl_formattedDate];
    [label sizeToFit];
    return label;
}

@end