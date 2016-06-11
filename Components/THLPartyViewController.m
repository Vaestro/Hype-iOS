//
//  THLPartyViewController.m
//  Hype
//
//  Created by Edgar Li on 5/30/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLPartyViewController.h"
#import "Parse.h"
#import <ParseUI/PFCollectionViewCell.h>
#import "MBProgressHUD.h"
#import "THLPartyMemberCell.h"
#import "THLPersonIconView.h"
#import "THLGuestlistInvite.h"
#import "SVProgressHUD.h"
#import "THLActionButton.h"
#import "THLAppearanceConstants.h"

static UIEdgeInsets const COLLECTION_VIEW_EDGEINSETS = {10, 10, 10, 10};
static CGFloat const CELL_SPACING = 10;

@interface THLPartyViewController()
@property(nonatomic, strong) PFObject *guestlist;
@property(nonatomic, strong) THLGuestlistInvite *usersInvite;

@property(nonatomic, strong) THLActionButton *inviteFriendsButton;
@property(nonatomic, strong) THLActionButton *checkoutButton;
@property (nonatomic, strong) NSArray *currentGuestsPhoneNumbers;

@end

@implementation THLPartyViewController

#pragma mark -
#pragma mark Init

- (instancetype)initWithClassName:(NSString *)className guestlist:(PFObject *)guestlist usersInvite:(PFObject *)usersInvite {
    self = [super initWithClassName:className];
    if (!self) return nil;

    self.pullToRefreshEnabled = YES;
    self.paginationEnabled = NO;
    _guestlist = guestlist;
    _usersInvite = (THLGuestlistInvite *)usersInvite;
    [_usersInvite setObject:guestlist forKey:@"Guestlist"];
    return self;
}

#pragma mark -
#pragma mark UIViewController
- (void)loadView {
    [super loadView];
    
    [self.collectionView registerClass:[THLPartyMemberCell class]
            forCellWithReuseIdentifier:[THLPartyMemberCell identifier]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:_hud];
    self.collectionView.backgroundColor = [UIColor blackColor];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    
    layout.sectionInset = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f);
    layout.minimumInteritemSpacing = 5.0f;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    CGFloat width = ([self contentViewWithInsetsWidth] - CELL_SPACING)/2.0;
    layout.itemSize = CGSizeMake(width, width + 10);
    
    WEAKSELF();
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(UIEdgeInsetsZero);
    }];
    
    if (_usersInvite.response == THLStatusAccepted) {
        [self.inviteFriendsButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(WSELF.collectionView.mas_bottom);
            make.bottom.left.right.equalTo(WSELF.view).insets(kTHLEdgeInsetsHigh());
            make.height.equalTo(60);
        }];
    } else {
        [self.checkoutButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(WSELF.collectionView.mas_bottom);
            make.bottom.left.right.equalTo(WSELF.view).insets(kTHLEdgeInsetsHigh());
            make.height.equalTo(60);
        }];
    }

}

- (CGFloat)contentViewWithInsetsWidth {
    return ScreenWidth - (COLLECTION_VIEW_EDGEINSETS.left + COLLECTION_VIEW_EDGEINSETS.right);
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
//    [SVProgressHUD show];
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
//    [SVProgressHUD dismiss];
    [self.collectionView reloadData];
        
    _currentGuestsPhoneNumbers = nil;
    _currentGuestsPhoneNumbers = [self collectGuestsPhoneNumbers:self.objects];
    [self emptyDataSetShouldDisplay:self.collectionView];

}

- (void)handleViewInvitationAction {
    [self.delegate partyViewControllerWantsToPresentInvitationControllerFor:(THLEvent *)_guestlist[@"event"] guestlistId:_guestlist.objectId currentGuestsPhoneNumbers:_currentGuestsPhoneNumbers];
}

- (NSArray *)collectGuestsPhoneNumbers:(NSArray *)guestlistInvites {
    return [guestlistInvites linq_select:^id(PFObject *guestlistInvite) {
        return guestlistInvite[@"phoneNumber"];
    }];
}


- (void)handleViewCheckoutAction {
    [self.delegate partyViewControllerWantsToPresentCheckoutForEvent:_guestlist[@"event"] withGuestlistInvite:_usersInvite];
}

#pragma mark -
#pragma mark Data

- (PFQuery *)queryForCollection {
    PFQuery *query = [super queryForCollection];
    [query whereKey:@"Guestlist" equalTo:_guestlist];
    [query includeKey:@"Guest"];
    [query includeKey:@"Guestlist"];
    [query includeKey:@"Guestlist.Owner"];
    [query includeKey:@"Guestlist.event"];
    [query includeKey:@"Guestlist.event.host"];
    [query includeKey:@"Guestlist.event.location"];
    
    return query;
}


#pragma mark -
#pragma mark CollectionView

- (PFCollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
                                  object:(PFObject *)object {
    
    THLPartyMemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[THLPartyMemberCell identifier]
                                                                         forIndexPath:indexPath];
    
    THLGuestlistInvite *guestlistInvite = (THLGuestlistInvite *)object;
    [cell setGuestlistInviteStatus:guestlistInvite.response];
    if (guestlistInvite.response == THLStatusPending || guestlistInvite.response == THLStatusAccepted || guestlistInvite.response == THLStatusDeclined) {
        cell.nameLabel.text = object[@"Guest"][@"firstName"];
        
        PFFile *imageFile = object[@"Guest"][@"image"];
        NSURL *url = [NSURL URLWithString:imageFile.url];
        [cell.iconImageView setImageURL:url];

    }
    else {
        //        TODO: Hack to get placeholder image to show, this logic should not be here
        cell.nameLabel.text = @"User";
        [cell.iconImageView setImage:nil];
    }
    
    return cell;
}

- (THLActionButton *)inviteFriendsButton
{
    if (!_inviteFriendsButton) {
        _inviteFriendsButton = [[THLActionButton alloc] initWithDefaultStyle];
        [_inviteFriendsButton setTitle:@"Invite Friends"];
        [_inviteFriendsButton addTarget:self action:@selector(handleViewInvitationAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_inviteFriendsButton];
    }
    return _inviteFriendsButton;
}

- (THLActionButton *)checkoutButton
{
    if (!_checkoutButton) {
        _checkoutButton = [[THLActionButton alloc] initWithDefaultStyle];
        [_checkoutButton setTitle:@"GO"];
        [_checkoutButton addTarget:self action:@selector(handleViewCheckoutAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_checkoutButton];
    }
    return _checkoutButton;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    if ([self.objects count] == 0) {
        return YES;
    } else {
        return NO;
    }
}
@end
