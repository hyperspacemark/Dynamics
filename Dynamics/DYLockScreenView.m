//
//  DYLockScreenView.m
//  Dynamics
//
//  Created by Mark Adams on 9/22/13.
//  Copyright (c) 2013 Mark Adams. All rights reserved.
//

#import "DYLockScreenView.h"

@implementation DYLockScreenView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.contents = (id)[[UIImage imageNamed:@"Background.png"] CGImage];
}

@end
