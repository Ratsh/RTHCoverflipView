//
//  RTHCoverflipView.h
//  RTHCoverflip
//
//  Created by Ratsh on 24.11.14.
//  Copyright (c) 2014 rth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTHCoverflipView : UIView

@property (nonatomic)               CGSize          itemSize;

@property (nonatomic)               NSArray         *items;
@property (nonatomic, readonly)     NSUInteger      currentIndex;

@property (nonatomic)               UIScrollView    *scrollView;

@end
