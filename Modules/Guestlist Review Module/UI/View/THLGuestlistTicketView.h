//
//  THLGuestlistTicketView.h
//  HypeUp
//
//  Created by Edgar Li on 2/28/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THLGuestlistTicketView : UIViewController

@property (nonatomic, strong) RACCommand *viewEventDetailsCommand;
@property (nonatomic, strong) RACCommand *dismissCommand;
@property (nonatomic, strong) RACCommand *viewPartyCommand;

@property (nonatomic, strong) NSString *listNumber;
@property (nonatomic, strong) NSString *venueName;
@property (nonatomic, strong) NSString *eventDate;
@property (nonatomic, strong) NSString *arrivalMessage;

@end
