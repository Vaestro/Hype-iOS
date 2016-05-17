//
//  THLTicketScannedTableViewController.m
//  Hype
//
//  Created by Daniel Aksenov on 5/17/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLTicketScannedTableViewController.h"
#import <Parse/PFObject.h>
#import <Parse/PFQuery.h>

#import <ParseUI/PFTableViewCell.h>


@interface THLTicketScannedTableViewController ()
{
    NSArray *_sectionSortedKeys;
    NSMutableDictionary *_sections;
}

@end

@implementation THLTicketScannedTableViewController

#pragma mark -
#pragma mark Init

- (instancetype)initWithClassName:(NSString *)className {
    self = [super initWithClassName:className];
    if (self) {
        self.title = @"Scanned Tickets";
        self.pullToRefreshEnabled = YES;
        
        _sections = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark -
#pragma mark Data

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    [_sections removeAllObjects];
    for (PFObject *object in self.objects) {
        NSNumber *priority = object[@"priority"];
        
        NSMutableArray *array = _sections[priority];
        if (array) {
            [array addObject:object];
        } else {
            _sections[priority] = [NSMutableArray arrayWithObject:object];
        }
    }
    
    _sectionSortedKeys = [[_sections allKeys] sortedArrayUsingSelector:@selector(compare:)];
    [self.tableView reloadData];
}

- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sectionArray = _sections[_sectionSortedKeys[indexPath.section]];
    return sectionArray[indexPath.row];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_sections count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Priority %@", [_sectionSortedKeys[section] stringValue]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionAray = _sections[_sectionSortedKeys[section]];
    return [sectionAray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = object[@"title"];
    
    return cell;
}

@end