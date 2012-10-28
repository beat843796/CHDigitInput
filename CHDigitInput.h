//
//  CHDigitInput.h
//  CHDigitInputControl
//
//  This Control is an alternative to the UIPickerView
//  for entering numbers. The disadvantage of the
//  standard picker view is that for example you want to
//  enter the number 999999 but the control is currently on
//  555555 it will take some time to scroll to the desired value.
//  An option would be to use an ordinary textfield. But if you
//  want to change just the 3 digits in the middle it is also
//  a paint cause you have to move the cursor, hit delete 3 times
//  and then enter your new digits.
//
//  Heres where CHDigitInput comes in. You get a configurable
//  number of digits presented. When you tap on a digit a numpad
//  shows up and you can immediately start entering a new digit, no
//  matter if you want to change the first, the last or some digit in
//  the middle. After setting a new value the focus goes to the next
//  digit automatically until you reach the end or you dismiss the keyboard
//  by yourself. So you are way faster than using a picker and way more
//  comfortable than using an ordinary textview.
//
//  I have created that control for entering the current mileage of a
//  car in a drivers logbook application for wich that control is perfect
//  because the mileage normally changes the last 3 digits
//
//  Created by Clemens Hammerl on 27.10.12.
//  Copyright (c) 2012 Clemens Hammerl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHDigitInput : UIControl <UITextInputTraits, UIKeyInput>
{
    
    @protected
    NSInteger currentIndex;         // The current active digitview index
    NSMutableArray *digitViews;     // array containt UILabels
    NSString *activeString;         // The current string representation of all digitviews
    NSMutableArray *bgImageViews;    // The background imageviews for all digitViews
}

@property (nonatomic, assign) NSInteger numberOfDigits;                     // number of digitViews
@property (nonatomic, assign) NSInteger value;                              // value represented by the digitViews
@property (nonatomic, assign) BOOL matchNumberOfDigitsWithValueLength;      // sets number of digits according to value legth


//////// Digit View Appearance /////////

// After changing something here call -(void)redrawControl afterwards

@property (nonatomic, strong) NSString *placeHolderCharacter;                   // Placeholder for empty digitView, default is 0

@property (nonatomic, assign) CGFloat digitPadding;                             // space between digitviews
@property (nonatomic, strong) UIView *backgroundView;                           // Background view of the control
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *highlightedBackgroundColor;

@property (nonatomic, strong) UIImage *digitBackgroundImage;                    // backgroundImage vor digitview
@property (nonatomic, strong) UIImage *digitOverlayImage;                       // Overlayimage vor digitview
@property (nonatomic, strong) UIColor *digitViewBackgroundColor;                // set to clearcolor when using digitBackgroundView
@property (nonatomic, strong) UIColor *digitViewHighlightedBackgroundColor;     // set to clearcolor when using digitBackgroundView
@property (nonatomic, strong) UIColor *digitViewTextColor;
@property (nonatomic, strong) UIColor *digitViewHighlightedTextColor;
@property (nonatomic, strong) UIFont *digitViewFont;
@property (nonatomic, strong) UIColor *digitViewShadowColor;
@property (nonatomic, assign) CGSize digitViewShadowOffset;
@property (nonatomic, strong) UIColor *digitViewHighlightedShadowColor;
@property (nonatomic, assign) CGSize digitViewHighlightedShadowOffset;

-(id)initWithNumberOfDigits:(NSInteger)digitCount;

/*
 Redraws the control, needed after setting colors, fonts, and sizes
 */
-(void)redrawControl;

@end
