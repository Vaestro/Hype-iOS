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

#import "TTTAttributedLabel.h"
#import "THLParseQueryFactory.h"
#import "THLUser.h"

@interface THLDiscoveryViewController ()
@property (nonatomic, strong) TTTAttributedLabel *navBarTitleLabel;
@property (nonatomic, strong) THLParseQueryFactory *parseQueryFactory;

@end

@implementation THLDiscoveryViewController

#pragma mark -
#pragma mark Init

- (instancetype)initWithClassName:(NSString *)className {
    self = [super initWithClassName:className];
    if (!self) return nil;
    
    self.navigationItem.titleView = self.navBarTitleLabel;
    self.pullToRefreshEnabled = YES;
    self.paginationEnabled = NO;
   
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithImage:[UIImage imageNamed:@"Help"]
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:@selector(messageButtonPressed)];
    _parseQueryFactory = [THLParseQueryFactory new];
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
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = YES;

    
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;

}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    
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
    [query orderByAscending:@"date"];
    [query includeKey:@"location"];
    [query includeKey:@"venue"];
    
    DTTimePeriod *eventDisplayPeriod = [DTTimePeriod timePeriodWithSize:DTTimePeriodSizeMonth amount:1 startingAt:[[NSDate date] dateByAddingTimeInterval:-60*300]];
    
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

    cell.titlesView.titleText = object[@"title"];
    cell.titlesView.dateText = [NSString stringWithFormat:@"%@", date.thl_weekdayString];
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
    if ([THLUser currentUser]) {
        [[[_parseQueryFactory localQueryForAcceptedInviteForEvent:object.objectId ] getFirstObjectInBackground] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
            if (task.result != nil) {
                [self.delegate eventDiscoveryViewControllerWantsToPresentDetailsForAttendingEvent:object invite:task.result];
            } else {
                [self.delegate eventDiscoveryViewControllerWantsToPresentDetailsForEvent:object];
                
            }
            return task;
        }];
    } else {
        [self.delegate eventDiscoveryViewControllerWantsToPresentDetailsForEvent:object];

    }

}


#pragma mark - event handlers ()

- (void)messageButtonPressed
{
    [Intercom presentConversationList];
}

- (TTTAttributedLabel *)navBarTitleLabel
{
    if (!_navBarTitleLabel) {
        _navBarTitleLabel = [TTTAttributedLabel new];
        _navBarTitleLabel.textColor = [UIColor whiteColor];
        _navBarTitleLabel.font = [UIFont fontWithName:@"Raleway-Regular" size:14];
        _navBarTitleLabel.numberOfLines = 0;
        _navBarTitleLabel.linkAttributes = @{NSForegroundColorAttributeName: kTHLNUIPrimaryFontColor,
                                             NSUnderlineColorAttributeName: kTHLNUIAccentColor,
                                    NSUnderlineStyleAttributeName: @(NSUnderlineStyleThick)};
        _navBarTitleLabel.activeLinkAttributes = @{NSForegroundColorAttributeName: kTHLNUIPrimaryFontColor,
                                          NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
        _navBarTitleLabel.textAlignment = NSTextAlignmentCenter;
        NSString *labelText = @"THIS WEEK IN NEW YORK";
        _navBarTitleLabel.text = labelText;
        NSRange city = [labelText rangeOfString:@"NEW YORK"];
        [_navBarTitleLabel addLinkToURL:[NSURL URLWithString:@""] withRange:city];
        
        [_navBarTitleLabel sizeToFit];
    }

    return _navBarTitleLabel;
}

#pragma mark - EmptyDataSetDelegate
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"Oops there was an error fetching events";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return kTHLNUISecondaryBackgroundColor;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f],
                                 NSForegroundColorAttributeName: kTHLNUIPrimaryFontColor,
                                 };
    
    NSString *text = @"Refresh";
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
    [self loadObjects];
}


@end
