//
//  CHDigitInput.m
//  CHDigitInputControl
//
//  Created by Clemens Hammerl on 27.10.12.
//  Copyright (c) 2012 Clemens Hammerl. All rights reserved.
//

#import "CHDigitInput.h"

#define kDefaultDigitPadding 5.0f
#define kDefaultPlaceHolderCharacter @"0"

#define kDefaultHighlightedBackgroundColor [UIColor blueColor]
#define kDefaultNormalBackgroundColor [UIColor greenColor]

#define kDefaultHighlightedTextColor [UIColor whiteColor]
#define kDefaultNormalTextColor [UIColor blackColor]

#define kDefaultNormalShadowOffset CGSizeMake(0.0,1.0)
#define kDefaultHighlightedShadowOffset CGSizeMake(0.0,-1.0)

#define kDefaultNormalShadowColor [UIColor clearColor]
#define kDefaultHighlightedShadowColor [UIColor clearColor]

#define kDefaultFont [UIFont boldSystemFontOfSize:30]

#define kControlBackgroundColor [UIColor clearColor]
#define kControlHighlightedBackgroundColor [UIColor clearColor]

@interface CHDigitInput (private)

-(void)setupDigitViews;
-(void)highlightIndex:(NSInteger)indexToHighlight;
-(void)unhighlightAll;
-(BOOL)setText:(NSString *)text ForIndex:(NSInteger)index;


@end

@implementation CHDigitInput

@synthesize value = _value;
@synthesize matchNumberOfDigitsWithValueLength = _matchNumberOfDigitsWithValueLength;
@synthesize numberOfDigits = _numberOfDigits;

@synthesize placeHolderCharacter = _placeHolderCharacter;

@synthesize digitPadding = _digitPadding;
@synthesize backgroundView = _backgroundView;
@synthesize digitOverlayImage = _digitOverlayImage;
@synthesize digitBackgroundImage = _digitBackgroundImage;

@synthesize backgroundColor = _backgroundColor;
@synthesize highlightedBackgroundColor = _highlightedBackgroundColor;

@synthesize digitViewBackgroundColor = _digitViewBackgroundColor;
@synthesize digitViewHighlightedBackgroundColor = _digitViewHighlightedBackgroundColor;
@synthesize digitViewTextColor = _digitViewTextColor;
@synthesize digitViewHighlightedTextColor = _digitViewHighlightedTextColor;
@synthesize digitViewFont = _digitViewFont;
@synthesize digitViewShadowColor = _digitViewShadowColor;
@synthesize digitViewShadowOffset = _digitViewShadowOffset;
@synthesize digitViewHighlightedShadowColor = _digitViewHighlightedShadowColor;
@synthesize digitViewHighlightedShadowOffset = _digitViewHighlightedShadowOffset;

/////////////////// Initialization ///////////////////
#pragma mark - Initializaion

-(id)init
{
    self = [super init];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

-(id)initWithNumberOfDigits:(NSInteger)digitCount
{
    self = [self init];
    
    if (self) {
        
        [self setNumberOfDigits:digitCount];
    }
    
    return self;
}

-(void)redrawControl
{
    [self setupDigitViews];
}

- (void)setup
{
    // setting a default background view
    
    _backgroundColor = kControlBackgroundColor;
    _highlightedBackgroundColor = kControlHighlightedBackgroundColor;
    
    
    _backgroundView = [[UIView alloc] init];
    _backgroundView.backgroundColor = _backgroundColor;
    [self addSubview:_backgroundView];
    
    // creating the array that holds the digit views and the bg image views
    
    digitViews = [[NSMutableArray alloc] init];
    bgImageViews = [[NSMutableArray alloc] init];
    
    // setting a dafault digitview appearance
    
    _digitViewHighlightedBackgroundColor = kDefaultHighlightedBackgroundColor;
    _digitViewBackgroundColor = kDefaultNormalBackgroundColor;
    
    _digitViewHighlightedTextColor = kDefaultHighlightedTextColor;
    _digitViewTextColor = kDefaultNormalTextColor;
    
    _digitViewShadowColor = kDefaultNormalShadowColor;
    _digitViewShadowOffset = kDefaultNormalShadowOffset;
    
    _digitViewHighlightedShadowOffset = kDefaultHighlightedShadowOffset;
    _digitViewHighlightedShadowColor = kDefaultHighlightedShadowColor;
    
    _digitViewFont = kDefaultFont;
    
    _matchNumberOfDigitsWithValueLength = NO;
    
    _placeHolderCharacter = kDefaultPlaceHolderCharacter;
}

//////////////// Overriden property setters ///////////////////
#pragma mark - overriden property setters

-(void)setPlaceHolderCharacter:(NSString *)placeHolderCharacter
{
    if (placeHolderCharacter.length > 1) {
        
        NSRange range;
        range.length = 1;
        range.location = 0;
        
        _placeHolderCharacter = [placeHolderCharacter substringWithRange:range];

        @throw [NSException exceptionWithName:@"PlaceholderCharacterTooLong" reason:@"The Placeholder character must be an NSString with a maximum length of 1" userInfo:nil];
        
    }else {
        _placeHolderCharacter = placeHolderCharacter;
    }
    
    // redraw everything
    [self setupDigitViews];
}

-(void)setMatchNumberOfDigitsWithValueLength:(BOOL)matchNumberOfDigitsWithValueLength
{
    _matchNumberOfDigitsWithValueLength = matchNumberOfDigitsWithValueLength;
    
    // redraw everthing
    [self setValue:_value];
}


// Override property setter
-(void)setNumberOfDigits:(NSInteger)numberOfDigits
{
    _numberOfDigits = numberOfDigits;
    
    if (numberOfDigits > 9) {
        @throw [NSException exceptionWithName:@"NSRangeExeption" reason:@"To many digits for NSInteger" userInfo:nil];
    }
    
    [self setupDigitViews];
}

// Set a new integer value
-(void)setValue:(NSInteger)value
{
    // do magic for displaying
    
    _value = value;

    NSString *valueString = [NSString stringWithFormat:@"%i",value];
    activeString = valueString;
    int valueStringLength = valueString.length;
    
    // if lenght of value is bigger than
    // the number of digit view we set up
    // a new number according to the length, but
    // only if matchNumberOfDigitsWithValueLength is TRUE
    if (_matchNumberOfDigitsWithValueLength) {
        self.numberOfDigits = valueStringLength;
    }
    
    int padding = _numberOfDigits-valueStringLength;

    if (padding < 0) {
        padding = 0;
    }
    
    int currentPos = 0;
    int stringIndex = 0;
    
    for (UILabel *digitView in digitViews) {
        
        if (currentPos >= padding) {
            
            NSRange range;
            range.location = stringIndex;
            range.length = 1;
            digitView.text = [valueString substringWithRange:range];

            stringIndex++;
            
        }
        
        currentPos++;
        
    }
}

-(void)setBackgroundView:(UIView *)backgroundView
{
    [_backgroundView removeFromSuperview];
    _backgroundView = backgroundView;
    
    [self insertSubview:_backgroundView atIndex:0];
}

////////////////// Private Methods //////////////////////
#pragma mark - private methods

// generate the digit views
-(void)setupDigitViews
{
    
    // remove the old views
    
    for (UIView *digitView in digitViews) {
        [digitView removeFromSuperview];
    }
    
    for (UIView *bgView in bgImageViews) {
        [bgView removeFromSuperview];
    }
    
    [digitViews removeAllObjects];
    [bgImageViews removeAllObjects];
    
    // generate new views and set default digit to 0
    
    for (int i = 0; i < _numberOfDigits; i++) {
        
        UILabel *newDigitView = [[UILabel alloc] init];
        
        // configuring the label
        
        newDigitView.textAlignment = UITextAlignmentCenter;
        newDigitView.textColor = _digitViewTextColor;
        newDigitView.highlightedTextColor = _digitViewHighlightedTextColor;
        newDigitView.shadowColor = _digitViewShadowColor;
        newDigitView.shadowOffset = _digitViewShadowOffset;
        newDigitView.backgroundColor = _digitViewBackgroundColor;
        newDigitView.font = _digitViewFont;
        newDigitView.adjustsFontSizeToFitWidth = YES;
        newDigitView.text = _placeHolderCharacter;
        
        // adding the custom background if available
        
        if (_digitOverlayImage) {
            
            UIImageView *overlayImageView = [[UIImageView alloc] initWithImage:_digitOverlayImage];
            
            [newDigitView addSubview:overlayImageView];
        }

        if (_digitBackgroundImage) {
            UIImageView *bgDigitView = [[UIImageView alloc] initWithImage:_digitBackgroundImage];
            
            [self addSubview:bgDigitView];
            [bgImageViews addObject:bgDigitView];
        }
        
        // adding the digit to the view and the digitview array
        
        [self addSubview:newDigitView];
        [digitViews addObject:newDigitView];
        
    }
    
    [self setNeedsLayout];
}

// highlights the digit view with the given index
-(void)highlightIndex:(NSInteger)indexToHighlight
{
    
    for (int i = 0; i < [digitViews count]; i++) {
        
        UILabel *digitView = [digitViews objectAtIndex:i];
        
        if (i == indexToHighlight) {
            digitView.backgroundColor = _digitViewHighlightedBackgroundColor;
            digitView.highlighted = YES;
            
            digitView.shadowColor = _digitViewHighlightedShadowColor;
            digitView.shadowOffset = _digitViewHighlightedShadowOffset;
            
            
        }else {
            digitView.backgroundColor = _digitViewBackgroundColor;
            
            digitView.shadowColor = _digitViewShadowColor;
            digitView.shadowOffset = _digitViewShadowOffset;
            
            digitView.highlighted = NO;
        }
        
    }
}

// Unhighlights all digit views
-(void)unhighlightAll
{
    for (UILabel *digitView in digitViews) {
        
        digitView.backgroundColor = _digitViewBackgroundColor;
        digitView.shadowColor = _digitViewShadowColor;
        digitView.shadowOffset = _digitViewShadowOffset;

        digitView.highlighted = NO;
    }
}

// Set text for a given digitview index
-(BOOL)setText:(NSString *)text ForIndex:(NSInteger)index
{
    if (!isdigit([text characterAtIndex:0]))
        return NO;
    
    UILabel *activeDigitView = [digitViews objectAtIndex:index];
    
    activeDigitView.text = text;
    
    NSString *valueString = @"";
    
    for (UILabel *digitView in digitViews) {
        
        NSString *digitString = digitView.text;
        
        if ([digitString isEqualToString:_placeHolderCharacter]) {
            valueString = [valueString stringByAppendingString:@"0"];
        }else {
            valueString =[valueString stringByAppendingString:digitString];
        }
        
    }

    activeString = valueString;
    _value = [valueString integerValue];
    
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

////////////////// UIKeyInput Protocol implementation ///////////////////
#pragma mark - UIKeyInput Protocol implementation

// gets called when keyboard text is entered
- (void)insertText:(NSString *)text
{
    
    // set the entered text in the digit view
    // at the current index
    
    if ([self setText:text ForIndex:currentIndex]) {
        // automatically jump to the next digit
        
        currentIndex++;
        
        // if currentindex is bigger than
        // number of digitviews we assume
        // that we are done with entering
        // digits and are hiding the keyboard
        
        if (currentIndex >= _numberOfDigits) {
            
            [self resignFirstResponder];
            return;
        }

        [self highlightIndex:currentIndex];
    }
}

// get called when keboard delete button is pressed
// Delete button action is just moving
// the current position on position to
// the left
- (void)deleteBackward
{
    
    /*
     for (int i = 0; i <= currentIndex; i++) {
     NSLog(@"current index");
     [self setText:_placeHolderCharacter ForIndex:i];
     }
     */
    //currentIndex = 0;
    
    /*
     if (currentIndex >= 1) {
     
     UILabel *previousDigitView = [digitViews objectAtIndex:(currentIndex-1)];
     
     if ([previousDigitView.text isEqualToString:_placeHolderCharacter]) {
     [self setText:_placeHolderCharacter ForIndex:currentIndex];
     return;
     }
     
     }
     */
    
    currentIndex--;
    
    if (currentIndex <= 0) {
        
        currentIndex = 0;
    }
    
    [self highlightIndex:currentIndex];
    
}

-(BOOL)hasText
{
    return activeString != nil;
}

///////////////////// UITextInputTraits protocol implementation ////////////////
#pragma mark - UITextInputTraits protocol implementation

// always return a number pad keyboard
-(UIKeyboardType)keyboardType
{
    return UIKeyboardTypeNumberPad;
}

//////////////////// View Stuff and other internal stuff //////////////////
#pragma mark - view stuff and other internal stuff

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _backgroundView.frame = self.bounds;
    
    CGFloat xOffset = 0;
    CGFloat digitWidth = (self.bounds.size.width-((_numberOfDigits+1)*kDefaultDigitPadding)) / (CGFloat)_numberOfDigits;
    
    for (UIView *digitView in digitViews) {
        
        digitView.frame = CGRectMake(kDefaultDigitPadding+xOffset, kDefaultDigitPadding, digitWidth, self.bounds.size.height-2*kDefaultDigitPadding);

        xOffset = digitView.frame.origin.x+digitView.bounds.size.width;
        
    }
    
    xOffset = 0;
    
    // TODO: remove duplicate code and implement better solulition for setting
    // frames of bgimage views
    if (_digitBackgroundImage) {
        for (UIView *bgDigitView in bgImageViews) {
            
            bgDigitView.frame = CGRectMake(kDefaultDigitPadding+xOffset, kDefaultDigitPadding, digitWidth, self.bounds.size.height-2*kDefaultDigitPadding);
            
            xOffset = bgDigitView.frame.origin.x+bgDigitView.bounds.size.width;
            
        }
    }
    
    
}


// always return yes
-(BOOL)canBecomeFirstResponder
{
    [self setHighlighted:YES];
    [self sendActionsForControlEvents:UIControlEventEditingDidBegin];
    return YES;
}

// Unhighlight all digitviews
// and hide keyboard
-(BOOL)resignFirstResponder
{
    
    [self unhighlightAll];
    
    if (self.highlighted) {
        [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
        
    }
    [self setHighlighted:NO];
    
    return [super resignFirstResponder];
}

// determine active index and show up keyboard
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    
    // TODO: ignore padding to have a bigger touch area
    
    // Check if a touch is inside a digitview
    // if so set the currentIndex and show
    // up the keyboard by becoming the first
    // responder
    
    NSInteger touchedIndex = 0;
    
    for (UIView *digitView in digitViews) {
        
        if (CGRectContainsPoint(digitView.frame, touchPoint)) {
            currentIndex = touchedIndex;
            
            [self highlightIndex:currentIndex];
            
            [self becomeFirstResponder];
            break;
        }
        
        touchedIndex++;
        
    }

}

//////////////// UIControl Methods //////////////////
#pragma mark - UIControl Methods

-(void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    if (enabled) {
        
        for (UIView *digitView in digitViews) {
            digitView.alpha = 1.0;
        }
        
    }else {
        for (UIView *digitView in digitViews) {
            digitView.alpha = 0.5;
        }
    }
}

-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.backgroundView.backgroundColor = _highlightedBackgroundColor;
    }else {
        self.backgroundView.backgroundColor = _backgroundColor;
    }
}

@end
