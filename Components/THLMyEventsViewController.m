//
//  THLMyEventsViewController.m
//  Hype
//
//  Created by Daniel Aksenov on 5/23/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLMyEventsViewController.h"
#import "Parse.h"
#import <ParseUI/PFCollectionViewCell.h>
#import "THLDashboardNotificationCell.h"
#import "THLEventInviteCell.h"
#import "THLPersonIconView.h"
#import "MBProgressHUD.h"


@interface THLMyEventsViewController()
@property(nonatomic, strong) MBProgressHUD *hud;
@end



@implementation THLMyEventsViewController

#pragma mark -
#pragma mark Init

- (instancetype)initWithClassName:(NSString *)className {
    self = [super initWithClassName:className];
    if (!self) return nil;
    
    self.title = @"My Events";
    self.pullToRefreshEnabled = YES;
    self.paginationEnabled = NO;
    
    return self;
}



#pragma mark -
#pragma mark UIViewController
- (void)loadView {
    [super loadView];

    [self.collectionView registerClass:[THLEventInviteCell class]
            forCellWithReuseIdentifier:[THLEventInviteCell identifier]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
    self.collectionView.backgroundColor = [UIColor blackColor];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    
    layout.sectionInset = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f);
    layout.minimumInteritemSpacing = 5.0f;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    
    const CGRect bounds = UIEdgeInsetsInsetRect(self.view.bounds, layout.sectionInset);
    CGFloat sideSize = MIN(CGRectGetWidth(bounds), CGRectGetHeight(bounds));
    layout.itemSize = CGSizeMake(ViewWidth(self.collectionView) - 25, 125);

}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    [self.hud show:YES];
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    if (!error) [self.hud hide:YES];
    [self.collectionView reloadData];
}



#pragma mark -
#pragma mark Data

- (PFQuery *)queryForCollection {
    PFQuery *query = [super queryForCollection];
    [query whereKey:@"Guest" equalTo:[PFUser currentUser]];
    [query includeKey:@"Guest"];
    [query includeKey:@"Guest.event"];
    [query includeKey:@"Guestlist.Owner"];
    [query includeKey:@"Guestlist.event.location"];
    
    return query;
}


#pragma mark -
#pragma mark CollectionView

- (PFCollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
                                  object:(PFObject *)object {
    
    THLEventInviteCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[THLEventInviteCell identifier]
                                                                           forIndexPath:indexPath];
    
//    cell.textLabel.textAlignment = NSTextAlignmentCenter;

//    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString: object[@"Guestlist"][@"event"][@"location"][@"name"] attributes:nil];
//    NSAttributedString *priorityString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\nPriority: %@", object[@"priority"]]
//                                                                         attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:13.0f],
//                                                                                       NSForegroundColorAttributeName : [UIColor grayColor] }];
//    [title appendAttributedString:priorityString];
//    cell.textLabel.attributedText = title;
    NSDate *date = (NSDate *)object[@"Guestlist"][@"event"][@"date"];
    NSString *invitationMessage = [NSString stringWithFormat:@"%@ invited you to their party", object[@"Guestlist"][@"Owner"][@"firstName"]];
    NSString *invitationDate = [NSString stringWithFormat:@"%@, %@", date.thl_weekdayString, date.thl_timeString];
    cell.senderIntroductionLabel.text = invitationMessage;
    cell.locationNameLabel.text = object[@"Guestlist"][@"event"][@"location"][@"name"];
    cell.dateLabel.text = invitationDate;
    
    
    PFFile *imageFile = object[@"Guestlist"][@"Owner"][@"image"];
    
    [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            UIImage *personIconPic = [UIImage imageWithData:data];
            cell.personIconView.image = personIconPic;
        }
    }];
    
    

    cell.contentView.layer.borderWidth = 1.0f;
    cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    [cell updateFromObject:object];

    return cell;
}
@end