## CHDigitInput
The disadvantage of the standard picker view is that for example you want to enter the number 999999 but the control is currently on 555555 it will take some time to scroll to the desired value. An option would be to use an ordinary textfield. But if you want to change just the 3 digits in the middle it is also a paint cause you have to move the cursor, hit delete 3 times and then enter your new digits. Heres where CHDigitInput comes in. You get a configurable number of digits presented. When you tap on a digit a numpad shows up and you can immediately start entering a new digit, no matter if you want to change the first, the last or some digit in the middle. After setting a new value the focus goes to the next digit automatically until you reach the end or you dismiss the keyboard by yourself. So you are way faster than using a picker and way more comfortable than using an ordinary textview.

## Usage
- Refer to the **Demo**.
- Drag and Drop CHDigitInput files to your XCode Project

Create and configure the BubbleView in your ViewController

```objc
    digitInput = [[CHDigitInput alloc] initWithNumberOfDigits:6];

    digitInput.digitOverlayImage = [UIImage imageNamed:@"digitOverlay"];
    digitInput.digitBackgroundImage = [UIImage imageNamed:@"digitControlBG"];

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
    [digitInput addTarget:self action:@selector(didEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
```

- You **must call redrawControl** when you change the appeareance of the control

```objc
 	[digitInput redrawControl];
```

## License
Copyright 2012 Clemens Hammerl

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
 limitations under the License. 

Attribution is appreciated.