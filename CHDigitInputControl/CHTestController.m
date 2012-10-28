//
//  CHTestController.m
//  CHDigitInputControl
//
//  Created by Clemens Hammerl on 27.10.12.
//  Copyright (c) 2012 Clemens Hammerl. All rights reserved.
//

#import "CHTestController.h"

@interface CHTestController (private)

-(void)didBeginEditing:(id)sender;
-(void)didEndEditing:(id)sender;
-(void)textDidChange:(id)sender;
-(void)valueChanged:(id)sender;

@end

@implementation CHTestController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    digitInput = [[CHDigitInput alloc] initWithNumberOfDigits:6];

    
    digitInput.digitOverlayImage = [UIImage imageNamed:@"digitOverlay"];
    digitInput.digitBackgroundImage = [UIImage imageNamed:@"digitControlBG"];
    
    //digitInput.backgroundView = digitBGView;
    
    digitInput.placeHolderCharacter = @"0";
    
    // we are using an overlayimage, so make the bg color clear color
    
    digitInput.digitViewBackgroundColor = [UIColor clearColor];
    digitInput.digitViewHighlightedBackgroundColor = [UIColor clearColor];
    
    digitInput.digitViewTextColor = [UIColor whiteColor];
    digitInput.digitViewHighlightedTextColor = [UIColor orangeColor];
    
    
    // we changed the default settings, so call redrawControl
    [digitInput redrawControl];
    
    [self.view addSubview:digitInput];

    // adding the target,actions for available events
    [digitInput addTarget:self action:@selector(didBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [digitInput addTarget:self action:@selector(didEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    [digitInput addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    [digitInput addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];

}

// dismissing the keyboard
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [digitInput resignFirstResponder];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    digitInput.frame = CGRectMake(10, 90, self.view.frame.size.width-20, 55);
}

/////////// recating on demo events ///////////
-(void)didBeginEditing:(id)sender
{
    CHDigitInput *input = (CHDigitInput *)sender;
    NSLog(@"did begin editing %i",input.value);
}

-(void)didEndEditing:(id)sender
{
    CHDigitInput *input = (CHDigitInput *)sender;
    NSLog(@"did end editing %i",input.value);
}

-(void)textDidChange:(id)sender
{
    CHDigitInput *input = (CHDigitInput *)sender;
    NSLog(@"text did change %i",input.value);
}

-(void)valueChanged:(id)sender
{
    CHDigitInput *input = (CHDigitInput *)sender;
    NSLog(@"value changed %i",input.value);
}



@end
