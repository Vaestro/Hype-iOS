//
//  THLTicketScannerController.m
//  Hype
//
//  Created by Daniel Aksenov on 5/6/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLTicketScannerController.h"
#import "PQScanner.h"
#import "Parse.h"
#import "MBProgressHUD.h"
#import "THLGuestlistInvite.h"


@interface THLTicketScannerController () <PQScannerDelegate,UIAlertViewDelegate>
{
    @private PQScanner *_scanner;
}
@property (nonatomic, strong) MBProgressHUD *hud;

- (void)displayError:(NSError *)error;
- (void)displayTicketInfo:(NSDictionary *)ticketInfo;
- (PFQuery *)guestlistInviteQueryWithId:(NSString *)guestlistInviteId;
@end

@implementation THLTicketScannerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _scanner = [[PQScanner alloc]initWithTargetView:self.view withDelegate:self];
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    
    [_scanner setupAVCapture];
    
    [_scanner startScan:^(NSString *encodeStr, NSString *codeType) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.hud show:YES];
            
            NSArray *array = [encodeStr componentsSeparatedByString:@"_"];
            NSDictionary *scannerInfo = @{
                                          @"guestId": [array objectAtIndex:0],
                                          @"guestlistId": [array objectAtIndex:1]
                                          };
            
            [PFCloud callFunctionInBackground:@"validateTicket"
                               withParameters:scannerInfo
                                        block:^(NSDictionary *ticketInfo, NSError *error) {
                                            [self.hud hide:YES];
                                            if (error) {
                                                [self displayError:error];
                                            } else {
                                                [self displayTicketInfo:ticketInfo];
                                            }
                                        }];
        });
    }];
}

#pragma mark - PQScannerDelegate

-(void)scanner:(PQScanner *)scanner
didEncodeQRCode:(NSString *)encodeStr
      codeType:(NSString *)codeType
{
    
}


-(void)scanner:(PQScanner *)scanner
didOpenCaptureFaild:(NSError *)error
{
    [_scanner setupAVCapture];
}

#pragma mark - UIAlerViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        [_scanner continueScan];
    }
}


#pragma mark - helpers

- (void)displayError:(NSError *)error {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                      message:[error localizedDescription]
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                            otherButtonTitles:nil];
    [message show];
}

- (void)displayTicketInfo:(NSDictionary *)ticketInfo
{
    NSString *info = [NSString stringWithFormat:@"%@\n%@\n%@\n%@", [ticketInfo valueForKey:@"name"],[ticketInfo valueForKey:@"sex"], [ticketInfo valueForKey:@"venue"], [ticketInfo valueForKey:@"date"]];
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ticket"
                                                                   message:info
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *yesButton = [UIAlertAction actionWithTitle:@"Yes"
                                              style:UIAlertActionStyleDefault
                                              handler:^(UIAlertAction *action) {
                                                  [self.hud show:YES];
                                                  PFQuery *query = [PFQuery queryWithClassName:@"GuestlistInvite"];
                                                  [query getObjectInBackgroundWithId:[ticketInfo valueForKey:@"guestlistInviteId"] block:^(PFObject *guestlistInvite, NSError *error) {
                                                      [self.hud hide:YES];
                                                      if (error) {
                                                          [self displayError:error];
                                                      } else  {
                                                          guestlistInvite[@"checkInStatus"] = @YES;
                                                          [guestlistInvite saveInBackgroundWithBlock:^(BOOL succeeded, NSError *cloudError) {
                                                              if (cloudError) {
                                                                  [self displayError:cloudError];
                                                              }
                                                          }];
                                                      }
                                                      
                                                  }];
                                                  [_scanner continueScan];
                                              }];
    
    UIAlertAction *noButton = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [_scanner continueScan];
    }];
    
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (PFQuery *)guestlistInviteQueryWithId:(NSString *)guestlistInviteId
{
    PFQuery *query = [THLGuestlistInvite query];
    [query includeKey:@"Guest"];
    [query includeKey:@"Guestlist"];
    [query includeKey:@"Guestlist.Owner"];
    [query includeKey:@"Guestlist.event"];
    [query includeKey:@"Guestlist.event.host"];
    [query includeKey:@"Guestlist.event.location"];
    
    [query whereKey:@"objectId" equalTo:guestlistInviteId];
    return query;
}


@end
