//
//  ScreenViewController.m
//  RadialMenu
//
//  Created by Erika Hoffman on 8/23/15.
//  Copyright (c) 2015 Erika Hoffman. All rights reserved.
//

#import "ScreenViewController.h"

@implementation ScreenViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont boldSystemFontOfSize:64];
    label.text = self.title;
    [label sizeToFit];
    label.center = self.view.center;
    label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
        UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleBottomMargin;

    [self.view addSubview:label];
}

@end
