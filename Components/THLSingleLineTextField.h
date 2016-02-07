//
//  THLSingleLineTextField.h
//  HypeUp
//
//  Created by Edgar Li on 2/5/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>

#define VALIDATION_INDICATOR_YES @"YES"
#define VALIDATION_INDICATOR_NO  @"NO"
#define VALIDATION_INDICATOR_COLOR @"VALIDATE_COLOR"

@class THLSingleLineTextField;

typedef NS_ENUM(NSInteger, THLSingleLineTextFieldStyle)
{
    THLSingleLineTextFieldStyleEmail,          //Default placeholder: 'Email';   Default validation: email validation regular expression
    THLSingleLineTextFieldStylePhone,          //Default placeholder: 'Phone';   Default format: '###-###-####'
    THLSingleLineTextFieldStylePassword,       //Default placeholder: 'Password; Default: secure text entry
    THLSingleLineTextFieldStyleNone,           //Default style
};

/**
 * Validation block to be applied to validate raw text synchronously or asynchronously.
 * @param text The raw text of the text field
 * @param textField
 * @return A dictionary with key of YES or NO and value of string to be displayed.
 */
typedef NSDictionary *(^ValidationBlock)(THLSingleLineTextField *textField, NSString *text);

IB_DESIGNABLE
@interface THLSingleLineTextField : UITextField

- (instancetype) initWithFrame:(CGRect)frame;

/**
 * Init with float label height
 *
 * @param frame The frame of text field
 * @param labelHeight Height of float label when displayed above textfield
 */
- (instancetype) initWithFrame:(CGRect)frame labelHeight:(CGFloat)labelHeight;

/**
 * Init with float label height and pre-defined style
 *
 * @param frame The frame of text field
 * @param labelHeight Height of float label when displayed above textfield
 * @param style Pre-defined style
 */
- (instancetype) initWithFrame:(CGRect)frame labelHeight:(CGFloat)labelHeight style:(THLSingleLineTextFieldStyle)style;

/**
 * Style of text: email, phone, password
 * Default is nil.
 */
@property (nonatomic, assign) THLSingleLineTextFieldStyle style;

/**
 * Height of floating Label.
 * Default is 0.5 * self.frame.height
 */
@property (nonatomic, assign) IBInspectable CGFloat floatingLabelHeight;

/**
 * Mask of input text. '#' represent any single character input
 * Default is nil.
 */
@property (nonatomic, copy) IBInspectable NSString *format;

/**
 * Text without mask.
 * Default is nil.
 */
@property (nonatomic, copy, readonly) NSString *rawText;

/**
 * Indicate whether the floating label animation is enabled.
 * Default is YES.
 */
@property (nonatomic) IBInspectable BOOL enableAnimation;

/**
 * Text color to be applied to floating placeholder text when editing.
 * Default is tint color.
 */
@property (nonatomic, strong) IBInspectable UIColor *placeholderActiveColor;

/**
 * Text color to be applied to floating placeholder text when not editing.
 * Default is 70% gray.
 */
@property (nonatomic, strong) IBInspectable UIColor *placeholderInactiveColor;

/**
 * Text to be displayed in the floating hint label.
 * Default is nil.
 */
@property (nonatomic, copy) IBInspectable NSString *hintText;

/**
 * Text color to be applied to the floating hint text.
 * Default is [UIColor grayColor].
 */
@property (nonatomic, strong) IBInspectable UIColor *hintTextColor;

/**
 * Set validation block.
 *
 * @param block The block to be applied to validate input text and return valid and invalid output.
 */
- (void) setValidationBlock:(ValidationBlock)block;

@end