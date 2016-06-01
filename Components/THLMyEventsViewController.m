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

#pragma mark -
#pragma mark SimpleCollectionReusableView

@interface SimpleCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong, readonly) UILabel *label;
@property (nonatomic, strong, readonly) UIView *separatorView;

@end

@implementation SimpleCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;

    _label = THLNUILabel(kTHLNUISectionTitle);
    _label.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_label];
    
    _separatorView = THLNUIView(kTHLNUIUndef);
    _separatorView.backgroundColor = kTHLNUIAccentColor;
    [self addSubview:_separatorView];

    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    WEAKSELF();
    [self.label makeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsHigh());
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_separatorView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF label].mas_baseline).insets(kTHLEdgeInsetsHigh());
        make.left.equalTo([WSELF label]);
        make.bottom.insets(kTHLEdgeInsetsHigh());

        make.size.equalTo(CGSizeMake(40, 2.5));

    }];
//    _label.frame = self.bounds;
}

@end

@interface THLMyEventsViewController()
{
    NSArray *_sectionSortedKeys;
    NSMutableDictionary *_sections;
}

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
    _sections = [NSMutableDictionary dictionary];

    return self;
}

#pragma mark -
#pragma mark UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = @"Tickets";
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    
    layout.sectionInset = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f);
    layout.minimumInteritemSpacing = 5.0f;
    
    [self.collectionView registerClass:[THLEventInviteCell class] forCellWithReuseIdentifier:[THLEventInviteCell identifier]];
    [self.collectionView registerClass:[THLAttendingEventCell class] forCellWithReuseIdentifier:[THLAttendingEventCell identifier]];

    [self.collectionView registerClass:[SimpleCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.itemSize = CGSizeMake(ViewWidth(self.collectionView) - 25, 125);
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    [self.hud show:YES];
}

- (void)objectsDidLoad:(NSError *)error {
//    [super objectsDidLoad:error];
//    if (!error) [self.hud hide:YES];
//    [self.collectionView reloadData];
    
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
        cell.partyTypeLabel.text = @"EVENT TICKEET";

        PFFile *imageFile = object[@"Guestlist"][@"event"][@"location"][@"image"];
        [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            if (!error) {
                UIImage *venuePic = [UIImage imageWithData:data];
                cell.venueImageView.image = venuePic;
            }
        }];
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
        SimpleCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
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
        return CGSizeMake(CGRectGetWidth(self.collectionView.bounds), 40.0f);
    }
    return CGSizeZero;
}

@end
