//
//  RTHItemCoverflipView.h
//  RTHCoverflip
//
//  Created by Ratsh on 24.11.14.
//  Copyright (c) 2014 rth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTHItemCoverflipView : UIView

@property (nonatomic) NSUInteger    index;

@property (nonatomic) UIButton      *imageButton;
@property (nonatomic) UIButton      *selectButton;

@property (nonatomic) UILabel       *titleLabel;

@end
