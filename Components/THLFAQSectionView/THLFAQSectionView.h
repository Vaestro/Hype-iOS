//
//  THLFAQSectionView.h
//  HypeUp
//
//  Created by Nik Cane on 02/02/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FAQSeparatorStyle){
    SlimWhiteLine
};

@interface THLFAQSectionView : UIView

- (instancetype) initWithTitle:(NSString *) title
                   description:(NSString *) description
                         image:(UIImage *) image
                separatorStyle:(FAQSeparatorStyle) separatorStyle;

@end
