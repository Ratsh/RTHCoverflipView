//
//  RTHItemCoverflipView.m
//  RTHCoverflip
//
//  Created by Ratsh on 24.11.14.
//  Copyright (c) 2014 rth. All rights reserved.
//

#import "RTHItemCoverflipView.h"

@implementation RTHItemCoverflipView

- (id)init {
    self = [super init];
    
    if (self) {
        _imageButton                        = [UIButton new];
        _imageButton.imageView.contentMode  = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageButton];
        
        _selectButton                       = [UIButton new];
        _selectButton.backgroundColor       = [UIColor clearColor];
        [self addSubview:_selectButton];
        
        _titleLabel                         = [UILabel new];
        _titleLabel.backgroundColor         = [UIColor clearColor];
        _titleLabel.hidden                  = YES;
        _titleLabel.textAlignment           = NSTextAlignmentCenter;
        _titleLabel.textColor               = [UIColor blackColor];
        [self addSubview:_titleLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    CGFloat     height                      = self.bounds.size.height;
    CGFloat     width                       = self.bounds.size.width;
    CGFloat     labelHeight                 = 20.0;
    CGFloat     buttonHeight                = height - labelHeight;
    
    _imageButton.frame                      = CGRectMake(0.0, 0.0, width, buttonHeight);
    _selectButton.frame                     = self.bounds;
    _titleLabel.frame                       = CGRectMake(0.0, buttonHeight, width, labelHeight);
}

@end
