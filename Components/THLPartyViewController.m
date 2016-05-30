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

static UIEdgeInsets const COLLECTION_VIEW_EDGEINSETS = {10, 10, 10, 10};
static CGFloat const CELL_SPACING = 10;

@interface THLPartyViewController()
@property(nonatomic, strong) MBProgressHUD *hud;
@property(nonatomic, strong) PFObject *guestlist;

@end

@implementation THLPartyViewController

#pragma mark -
#pragma mark Init

- (instancetype)initWithClassName:(NSString *)className withGuestlist:(PFObject *)guestlist {
    self = [super initWithClassName:className];
    if (!self) return nil;

    self.pullToRefreshEnabled = YES;
    self.paginationEnabled = NO;
    _guestlist = guestlist;
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
}

- (CGFloat)contentViewWithInsetsWidth {
    return ScreenWidth - (COLLECTION_VIEW_EDGEINSETS.left + COLLECTION_VIEW_EDGEINSETS.right);
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
//    [self.hud show:YES];
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
//    if (!error) [self.hud hide:YES];
    [self.collectionView reloadData];
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
        
        [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            if (!error) {
                UIImage *personIconPic = [UIImage imageWithData:data];
                cell.iconImageView.image = personIconPic;
            }
        }];
    }
    else {
        //        TODO: Hack to get placeholder image to show, this logic should not be here
        cell.nameLabel.text = @"Pending Signup";
        [cell.iconImageView setImage:nil];
    }
    
    return cell;
}
@end
