//
//  THLDiscoveryViewController.m
//  Hype
//
//  Created by Daniel Aksenov on 5/26/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLDiscoveryViewController.h"
#import "THLEventDetailsViewController.h"
#import "Parse.h"
#import <ParseUI/PFCollectionViewCell.h>
#import "THLDashboardNotificationCell.h"
#import "THLDiscoveryCell.h"
#import <ParseUI/PFImageView.h>
#import "THLAppearanceConstants.h"
#import "Intercom/intercom.h"

#import "MBProgressHUD.h"

@interface THLDiscoveryViewController ()

@end

@implementation THLDiscoveryViewController

#pragma mark -
#pragma mark Init

- (instancetype)initWithClassName:(NSString *)className {
    self = [super initWithClassName:className];
    if (!self) return nil;
    
    self.title = @"THIS WEEK IN NEW YORK";
    self.pullToRefreshEnabled = YES;
    self.paginationEnabled = NO;
   
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Help"] style:UIBarButtonItemStylePlain target:self action:@selector(messageButtonPressed)];
    
    return self;
}



#pragma mark -
#pragma mark UIViewController
- (void)loadView {
    [super loadView];
    
    [self.collectionView registerClass:[THLDiscoveryCell class]
            forCellWithReuseIdentifier:[THLDiscoveryCell identifier]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor blackColor];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    
    layout.sectionInset = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f);
    layout.minimumInteritemSpacing = 0.5f;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    
    const CGRect bounds = UIEdgeInsetsInsetRect(self.view.bounds, layout.sectionInset);
    CGFloat sideSize = MIN(CGRectGetWidth(bounds), CGRectGetHeight(bounds));
    layout.itemSize = CGSizeMake(ViewWidth(self.collectionView) - 25, 125);
    
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    [self.collectionView reloadData];
}



#pragma mark -
#pragma mark Data

- (PFQuery *)queryForCollection {
    PFQuery *query = [super queryForCollection];
    [query includeKey:@"location"];
    [query includeKey:@"venue"];
    
    DTTimePeriod *eventDisplayPeriod = [DTTimePeriod timePeriodWithSize:DTTimePeriodSizeWeek amount:1 startingAt:[[NSDate date] dateByAddingTimeInterval:-60*300]];
    
    [query whereKey:@"date" lessThanOrEqualTo:eventDisplayPeriod.EndDate];
    [query whereKey:@"date" greaterThanOrEqualTo:eventDisplayPeriod.StartDate];
    return query;
}


#pragma mark -
#pragma mark CollectionView

- (PFCollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
                                  object:(PFObject *)object {
    
    THLDiscoveryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[THLDiscoveryCell identifier]
                                                                         forIndexPath:indexPath];
    
    NSDate *date = (NSDate *)object[@"date"];

    NSString *invitationDate = [NSString stringWithFormat:@"%@, %@", date.thl_weekdayString, date.thl_timeString];
    cell.titlesView.titleText = object[@"title"];
    cell.titlesView.dateText = invitationDate;
    cell.titlesView.locationNameText = object[@"location"][@"name"];
    cell.titlesView.locationNeighborhoodText = object[@"location"][@"neighborhood"];
    cell.venueImageView.file = object[@"location"][@"image"];
    [cell.venueImageView loadInBackground];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(DiscoveryCellWidth(collectionView), DiscoveryCellHeight(collectionView));
}




- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *object = [self objectAtIndexPath:indexPath];
   
    [self.delegate eventDiscoveryViewControllerWantsToPresentDetailsForEvent:object];
}


//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionViewCell *)collectionView {
//    
//    if (self.objects.count != 0) {
//        
//        return 1;
//        
//    } else {
//        
//        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//        
//        messageLabel.text = @"No data is currently available. Please pull down to refresh.";
//        messageLabel.textColor = [UIColor whiteColor];
//        messageLabel.numberOfLines = 0;
//        messageLabel.textAlignment = NSTextAlignmentCenter;
//        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
//        [messageLabel sizeToFit];
//        self.collectionView.backgroundView = messageLabel;
//    }
//    
//    return 0;
//}

#pragma mark - event handlers ()

- (void)messageButtonPressed
{
    [Intercom presentConversationList];
}




@end
