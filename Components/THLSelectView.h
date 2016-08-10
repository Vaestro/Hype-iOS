//
//  THLSelectView.h
//  
//
//  Created by Edgar Li on 7/28/16.
//
//

#import "THLTitledContentView.h"

@protocol THLSelectViewDelegate <NSObject>
-(void)selectViewDidChangeValue;
@end

@interface THLSelectView : THLTitledContentView
@property (nonatomic, weak) id<THLSelectViewDelegate> delegate;
@property (nonatomic, strong) UILabel *selectedItemLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) NSArray *values;

- (instancetype)initWithValues:(NSMutableArray *)values;

@end