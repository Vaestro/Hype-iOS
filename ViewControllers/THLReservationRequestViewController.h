//
//  THLReservationRequestViewController.h
//  Hype
//
//  Created by Edgar Li on 7/29/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Parse/PFObject.h>

@protocol THLReservationRequestViewControllerDelegate <NSObject>
- (void)reservationRequestControllerWantsToPresentReviewForReservation:(PFObject *)event andAdmissionOption:(PFObject *)admissionOption;

@end

@interface THLReservationRequestViewController : UIViewController

@property (nonatomic, weak) id<THLReservationRequestViewControllerDelegate> delegate;

- (instancetype)initWithEvent:(PFObject *)event admissionOption:(PFObject *)admissionOption;
@end