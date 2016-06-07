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
#import "THLAppearanceConstants.h"
#import "THLAttendingEventCell.h"
#import "SVProgressHUD.h"
#import "THLUser.h"
#import "THLGuestlistInvite.h"
#import "THLCollectionReusableView.h"
#import "Intercom/intercom.h"
#import "TTTAttributedLabel.h"

@interface THLMyEventsViewController()
{
    NSArray *_sectionSortedKeys;
    NSMutableDictionary *_sections;
}
@property (nonatomic, strong) TTTAttributedLabel *navBarTitleLabel;

@end

@implementation THLMyEventsViewController

#pragma mark -
#pragma mark Init

- (instancetype)initWithClassName:(NSString *)className {
    self = [super initWithClassName:className];
    if (!self) return nil;
    
    self.pullToRefreshEnabled = YES;
    self.paginationEnabled = NO;
    _sections = [NSMutableDictionary dictionary];

    return self;
}

#pragma mark -
#pragma mark UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.navigationItem.titleView = self.navBarTitleLabel;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithImage:[UIImage imageNamed:@"Help"]
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:@selector(messageButtonPressed)];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    
    layout.sectionInset = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f);
    layout.minimumInteritemSpacing = 5.0f;
    
    [self.collectionView registerClass:[THLEventInviteCell class] forCellWithReuseIdentifier:[THLEventInviteCell identifier]];
    [self.collectionView registerClass:[THLAttendingEventCell class] forCellWithReuseIdentifier:[THLAttendingEventCell identifier]];

    [self.collectionView registerClass:[THLCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadObjects];
}

- (BFTask<NSArray<__kindof PFObject *> *> *)loadObjects {
    if ([THLUser currentUser]) {
        return [super loadObjects];
    } else {
        return nil;

    }
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.itemSize = CGSizeMake(ViewWidth(self.collectionView) - 25, 125);
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
//    [SVProgressHUD show];
}

- (void)objectsDidLoad:(NSError *)error {
//    [SVProgressHUD dismiss];
    
    [super objectsDidLoad:error];
    
    [_sections removeAllObjects];
    for (PFObject *object in self.objects) {
        NSNumber *priority = object[@"response"];
        
        NSMutableArray *array = _sections[priority];
        if (array) {
            [array addObject:object];
        } else {
            _sections[priority] = [NSMutableArray arrayWithObject:object];
        }
        
    }

    _sectionSortedKeys = [[_sections allKeys] sortedArrayUsingSelector:@selector(compare:)];
    [self.collectionView reloadData];
}


- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sectionAray = _sections[_sectionSortedKeys[indexPath.section]];
    return sectionAray[indexPath.row];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [_sections count];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *sectionAray = _sections[_sectionSortedKeys[section]];
    return [sectionAray count];
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
    NSDate *date = [[NSDate date] dateBySubtractingHours:4];
    [query whereKey:@"date" greaterThan:date];
    return query;
}


#pragma mark -
#pragma mark CollectionView

- (PFCollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
                                  object:(PFObject *)object {
    
    NSNumber *response = _sectionSortedKeys[indexPath.section];
    if (response == [NSNumber numberWithInteger:2]) {
        THLEventInviteCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[THLEventInviteCell identifier] forIndexPath:indexPath];
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
        return cell;

    } else {
        THLAttendingEventCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[THLAttendingEventCell identifier] forIndexPath:indexPath];
        NSDate *date = (NSDate *)object[@"Guestlist"][@"event"][@"date"];
        NSString *invitationDate = [NSString stringWithFormat:@"%@, %@", date.thl_weekdayString, date.thl_timeString];
        cell.venueNameLabel.text = object[@"Guestlist"][@"event"][@"location"][@"name"];
        cell.dateLabel.text = invitationDate;
        cell.partyTypeLabel.text = @"EVENT TICKET";
        
        PFFile *imageFile = object[@"Guestlist"][@"event"][@"location"][@"image"];
        NSURL *url = [NSURL URLWithString:imageFile.url];
        [cell.venueImageView sd_setImageWithURL:url];
        
        return cell;

    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *object = [self objectAtIndexPath:indexPath];
    [self.delegate didSelectViewEventTicket:object];
    if (!(BOOL)object[@"didOpen"]) {
        object[@"didOpen"] = @YES;
        [object saveInBackground];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        THLCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        NSNumber *response = _sectionSortedKeys[indexPath.section];
        if (response == [NSNumber numberWithInteger:1]) {
            view.label.text = @"MY UPCOMING EVENTS";
        } else if (response == [NSNumber numberWithInteger:2]) {
            view.label.text = @"EVENT INVITES";
        }
        return view;
    }
    return [super collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if ([_sections count]) {
        return CGSizeMake(CGRectGetWidth(self.collectionView.bounds), 60.0f);
    }
    return CGSizeZero;
}

#pragma mark - Accessors

- (void)messageButtonPressed
{
    [Intercom presentConversationList];
}

- (TTTAttributedLabel *)navBarTitleLabel
{
    if (!_navBarTitleLabel) {
        _navBarTitleLabel = [TTTAttributedLabel new];
        _navBarTitleLabel.numberOfLines = 1;
        _navBarTitleLabel.textAlignment = NSTextAlignmentCenter;


        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"MY EVENTS"
                                                                        attributes:@{
                                                                                     (id)kCTForegroundColorAttributeName : (id)[UIColor whiteColor].CGColor,
                                                                                     NSFontAttributeName : [UIFont systemFontOfSize:16],
                                                                                     NSKernAttributeName : @4.5f
                                                                                     }];
        _navBarTitleLabel.text = attString;

        [_navBarTitleLabel sizeToFit];
    }
    
    return _navBarTitleLabel;
}



#pragma mark - EmptyDataSetDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @" ";
    if ([THLUser currentUser]) {
        text = @"You do not have any events";
    } else {
        text = @"You are not logged in";
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: kTHLNUIAccentColor};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @" ";
    if ([THLUser currentUser]) {
        text = @"When you purchase tickets or receive event invites from a friend, they'll show up here";
    } else {
        text = @"Please log in to attend an event or view your event invites";
    }
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return kTHLNUIPrimaryBackgroundColor;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f],
                                 NSForegroundColorAttributeName: kTHLNUIPrimaryFontColor,
                                 };
    
    NSString *text = @" ";
    if ([THLUser currentUser]) {
        text = @"Refresh";
    } else {
        text = @"Login";
    }
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
    //    [_refreshCommand execute:nil];
    if ([THLUser currentUser]) {
        [self loadObjects];
    } else {
        [self.delegate usersWantsToLogin];
    }
}

@end
