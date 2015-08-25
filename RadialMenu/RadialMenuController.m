//
//  RadialMenuController.m
//  RadialMenu
//
//  Created by Erika Hoffman on 8/23/15.
//  Copyright (c) 2015 Erika Hoffman. All rights reserved.
//

#import "RadialMenuController.h"

// Size of the radial menu buttons.
static const CGFloat buttonSize = 48;

// Angle between radial menu buttons.
static const CGFloat angleBetweenButtons = 60;

// Distance from where the user touches to the radial menu buttons.
static const CGFloat buttonDistance = 60;

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@implementation RadialMenuController {
    NSMutableArray *_buttons;
    NSInteger _selectedViewControllerIndex;
}

- (void) addChildViewController:(UIViewController *)childController {
    [super addChildViewController:childController];

    // Add the child view controller's view to our own view and update its visibility so it's
    // visible only if it's the selected one (this makes sure the home screen is visible by default,
    // for example).
    [self.view addSubview:childController.view];
    [self updateChildViewVisibility];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];

    // Create the buttons based on which view controller is currently shown.
    [self createMenuItems];

    // Figure out if we need to fan out to the right if the user taps on the left side or fan out to
    // the left if they tap on the right side.
    CGFloat midX = self.view.bounds.size.width / 2;
    BOOL fanOutRight = (location.x < midX);

    // Instantly show the items and update their starting location (where they will animate out
    // from).
    for (UILabel *button in _buttons) {
        button.center = location;
        button.alpha = 1;
    }

    // Animate the items to their final locations.
    [UIView animateWithDuration:0.2 animations:^{

        //
        for (NSInteger i = 0; i < _buttons.count; i++) {
            UILabel *button = _buttons[i];

            CGFloat angle = i * angleBetweenButtons;
            CGPoint offset = [self offsetAtAngle:angle distance:buttonDistance];

            if (fanOutRight) {
                offset.x = location.x + offset.x;
            } else {
                offset.x = location.x - offset.x;
            }
            offset.y = location.y - offset.y;

            button.center = offset;
        }
    }];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // Highlight the button the touch is in.
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];

    UIView *hitView = [self.view hitTest:location withEvent:event];
    for (UILabel *button in _buttons) {
        if (button == hitView) {
            button.backgroundColor = [UIColor darkGrayColor];
        } else {
            button.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        }
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];

    // Fade the items out instead of just hiding them instantly, and then remove them when they're
    // gone.
    NSArray *buttons = _buttons;
    [UIView animateWithDuration:0.2 animations:^{
        for (UILabel *button in buttons) {
            button.alpha = 0;
        }
    } completion:^(BOOL finished) {
        for (UILabel *button in buttons) {
            [button removeFromSuperview];
        }
    }];

    // Check if the view that was hit was one of the menu items, and if it was, get the view
    // controller index from its tag and animate the view controller in.
    BOOL wasMenuItem = NO;
    UIView *hitView = [self.view hitTest:location withEvent:event];
    for (UILabel *button in _buttons) {
        if (button == hitView) {
            wasMenuItem = YES;
        }
    }
    if (wasMenuItem) {
        [self animateInViewControllerAtIndex:hitView.tag];
    }
}

/** Returns an x,y offset for the point at the given angle and distance from 0 (polar to rectangular
 * conversion). */
- (CGPoint)offsetAtAngle:(CGFloat)angle distance:(CGFloat)distance {
    CGFloat x = distance * cos(DEGREES_TO_RADIANS(angle));
    CGFloat y = distance * sin(DEGREES_TO_RADIANS(angle));
    return CGPointMake(x, y);
}

/** Create the menu items after the user holds down on the screen. */
- (void) createMenuItems {
    _buttons = [NSMutableArray array];

    if (_selectedViewControllerIndex == 0) {
        // If on the home screen, show all the other menu items.
        for (NSInteger i = 1; i < self.childViewControllers.count; i++) {
            UIViewController *childViewController = self.childViewControllers[i];
            [self addMenuItemWithTitle:childViewController.title viewControllerIndex:i];
        }
    } else {
        // If not on the home screen, show the home screen and the adjacent items.
        UIViewController *homeScreen = self.childViewControllers[0];
        [self addMenuItemWithTitle:homeScreen.title viewControllerIndex:0];

        // Show the previous item if there is one.
        if (_selectedViewControllerIndex > 1) {
            UIViewController *previousScreen =
                self.childViewControllers[_selectedViewControllerIndex - 1];
            [self addMenuItemWithTitle:previousScreen.title
                   viewControllerIndex:_selectedViewControllerIndex - 1];
        }

        // Show the next item if there is one.
        if (_selectedViewControllerIndex < self.childViewControllers.count - 1) {
            UIViewController *nextScreen =
                self.childViewControllers[_selectedViewControllerIndex + 1];
            [self addMenuItemWithTitle:nextScreen.title
                   viewControllerIndex:_selectedViewControllerIndex + 1];
        }
    }
}

/** Returns a new menu item label with the given title. */
- (void) addMenuItemWithTitle:(NSString *)title
          viewControllerIndex:(NSInteger)viewControllerIndex {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, buttonSize, buttonSize)];
    label.userInteractionEnabled = YES;
    label.tag = viewControllerIndex;
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    label.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    // Hide it by default. Use alpha instead of hidden because alpha can be animated.
    label.alpha = 0;
    // Give the item a rounded border.
    label.layer.borderWidth = 2;
    label.layer.cornerRadius = buttonSize / 2;
    label.layer.borderColor = [UIColor blackColor].CGColor;
    // Make sure the background color is only inside the border.
    label.layer.masksToBounds = YES;

    [self.view addSubview:label];
    [_buttons addObject:label];
}

/** Makes the currently selected view controller visible and hides all the others. */
- (void) updateChildViewVisibility {
    for (int i = 0; i < self.childViewControllers.count; i++) {
        UIViewController *childViewController = self.childViewControllers[i];
        childViewController.view.hidden = (_selectedViewControllerIndex != i);
    }
}

/** Slide in the view controller with the given index and then hide the old one. This changes the
 * selection in the view controller. */
- (void)animateInViewControllerAtIndex:(NSInteger)index {
    CGRect bounds = self.view.bounds;
    CGPoint startingLocation;

    if (_selectedViewControllerIndex == 0) {
        // From the home screen, slide the new one in from the bottom.
        startingLocation.x = bounds.size.width / 2;
        startingLocation.y = bounds.size.height + bounds.size.height / 2;
    } else {
        if (index == 0) {
            // From another screen, slide the home screen in from the top.
            startingLocation.x = bounds.size.width / 2;
            startingLocation.y = -bounds.size.height / 2;
        } else if (index < _selectedViewControllerIndex) {
            // From another screen, slide the previous screen in from the left.
            startingLocation.x = -bounds.size.width / 2;
            startingLocation.y = bounds.size.height / 2;
        } else if (index > _selectedViewControllerIndex) {
            // From another screen, slide the next screen in from the right.
            startingLocation.x = bounds.size.width + bounds.size.width / 2;
            startingLocation.y = bounds.size.height / 2;
        }
    }

    NSInteger oldSelectedIndex = _selectedViewControllerIndex;
    _selectedViewControllerIndex = index;

    UIViewController *newViewController = self.childViewControllers[index];
    [self.view bringSubviewToFront:newViewController.view];
    newViewController.view.center = startingLocation;
    newViewController.view.hidden = NO;

    [UIView animateWithDuration:0.3
                     animations:^{
                         newViewController.view.center = self.view.center;
                     } completion:^(BOOL finished) {                         
                         UIView *view = [self.childViewControllers[oldSelectedIndex] view];
                         view.hidden = YES;
                         
                     }];
}

@end
