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
#import "THLPartyViewController.h"
#import "Intercom/intercom.h"

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
    
    THLEventTicketViewController *eventTicketVC = [[THLEventTicketViewController alloc]initWithGuestlistInvite:_guestlistInvite];
    THLEventDetailsViewController *eventDetailsVC = [[THLEventDetailsViewController alloc]initWithEvent:_guestlistInvite[@"Guestlist"][@"event"] andShowNavigationBar:FALSE];
    THLPartyViewController *partyVC = [[THLPartyViewController alloc] initWithClassName:@"GuestlistInvite" withGuestlist:_guestlistInvite[@"Guestlist"]];

    [self.viewControllerArray addObjectsFromArray:@[eventTicketVC, eventDetailsVC, partyVC]];
    self.buttonText = @[@"TICKET", @"EVENT", @"PARTY"];
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
    [Intercom presentConversationList];
    
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