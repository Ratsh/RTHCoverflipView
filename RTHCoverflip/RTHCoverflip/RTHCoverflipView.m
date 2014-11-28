//
//  RTHCoverflipView.m
//  RTHCoverflip
//
//  Created by Ratsh on 24.11.14.
//  Copyright (c) 2014 rth. All rights reserved.
//

#import "RTHCoverflipView.h"
#import "RTHItemCoverflipView.h"

@implementation RTHCoverflipView {
    CGFloat         baseDecrease;
    CGFloat         bottomOffset;
    CGFloat         decreaseKoef;
    CGFloat         minDecrease;
    NSInteger       minDecreaseIndex;
}

- (id)init {
    self = [super init];
    
    if (self) {
        _items                          = @[];
        _currentIndex                   = 0;
        _itemSize                       = CGSizeMake(100.0, 100.0);
        
        _scrollView                     = [UIScrollView new];
        _scrollView.showsHorizontalScrollIndicator  = NO;
        [self addSubview:_scrollView];
        
        baseDecrease                    = 1.8;
        decreaseKoef                    = 0.9;
        minDecrease                     = 2.8;
        minDecreaseIndex                = [self indexWithBase:1/baseDecrease
                                                         step:decreaseKoef
                                                     minValue:1/minDecrease];
        bottomOffset                    = 20.0;
        
        animationBlocks                 = @[].mutableCopy;
    }
    
    return self;
}

- (NSInteger)indexWithBase:(CGFloat)base step:(CGFloat)step minValue:(CGFloat)min {
    CGFloat         value               = base * step;
    NSInteger       result              = 1;
    
    for (;value > min; result++) {
        value                          *= step;
    }
    
    return result - 1;
}

- (void)layoutSubviews {
    CGFloat         y;
    CGSize          scrollSize          = _scrollView.contentSize;
    CGSize          selfSize            = self.bounds.size;
    
    if (scrollSize.height <= selfSize.height) {
        y                               = (selfSize.height - scrollSize.height) / 2;
    }
    _scrollView.frame                   = CGRectMake(0.0, y,
                                                     selfSize.width, scrollSize.height);
}

#pragma mark - animations

NSMutableArray* animationBlocks;

typedef void(^animationBlock)(BOOL);

animationBlock (^getNextAnimation)() = ^{
    animationBlock block                = animationBlocks.count > 0 ? (animationBlock)animationBlocks[0] : nil;
    if (block){
        [animationBlocks removeObjectAtIndex:0];
        return block;
    }else{
        return ^(BOOL finished){};
    }
};

- (void)moveOneStepWithRightDirection:(int)direction {
    NSUInteger      visibleItemsNumber  = [self visibleItemsNumber];
    NSUInteger      minLowIndex         = (int)_currentIndex - (int)visibleItemsNumber < 0 ? 0 :
                                            _currentIndex - visibleItemsNumber;
    NSUInteger      maxHighIndex        = _currentIndex + visibleItemsNumber + 1 > _items.count ? _items.count :
                                            _currentIndex + visibleItemsNumber + 1;
    
    [animationBlocks addObject:^(BOOL finished){;
        [UIView animateWithDuration:0.6 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            CGFloat     offsetX         = ((UIView *)_items[minLowIndex]).frame.origin.x;
            
            _currentIndex              += direction;
            
            for (NSUInteger i = minLowIndex; i < maxHighIndex; i++) {
                [self fillItemFrameWithIndex:i offsetX:&offsetX];
            }
            
            CGRect  frame               = ((UIView *)_items[_currentIndex]).frame;
            [_scrollView setContentOffset:CGPointMake(frame.origin.x + frame.size.width / 2 -
                                                      self.bounds.size.width / 2,
                                                      0.0)];
            
        } completion: getNextAnimation()];
    }];
}

- (NSUInteger)visibleItemsNumber {
    CGFloat         width               = self.bounds.size.width / 2;
    NSUInteger      result              = 1;
    
    width                              -= _itemSize.width / 2;
    for (int i = 1; i < minDecreaseIndex; i++, result++) {
        if (width < 0) {
            return result;
        }
        CGFloat     decreaseStep        = pow(decreaseKoef, abs((int)_currentIndex - (int)index)-1);
        width                          -= _itemSize.width / baseDecrease * decreaseStep;
    }
    for (; width > 0; result++) {
        width                          -= _itemSize.width / minDecrease;
    }
    
    return result;
}

#pragma mark - fill items

- (void)fillScroll {
    CGFloat         offsetXbase         = (self.bounds.size.width - _itemSize.width) / 2;
    CGFloat         offsetX             = offsetXbase;
    
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i < _items.count; i++) {
        RTHItemCoverflipView    *item   = (RTHItemCoverflipView *)_items[i];
        
        [self fillItemFrameWithIndex:i offsetX:&offsetX];

        item.index                      = i;
        
        [item.selectButton addTarget:self
                              action:@selector(selectItem:)
                    forControlEvents:UIControlEventTouchUpInside];
        
        [_scrollView addSubview:item];
    }
    
    _scrollView.contentSize             = CGSizeMake(offsetX + offsetXbase, _itemSize.height);
}

- (void)fillItemFrameWithIndex:(NSUInteger)index offsetX:(CGFloat *)offsetX {
    CGFloat         height;
    CGFloat         width;
    CGFloat         y;
    RTHItemCoverflipView    *item       = (RTHItemCoverflipView *)_items[index];
    
    if (index == _currentIndex) {
        height                          = _itemSize.height;
        width                           = _itemSize.width;
        
        item.selectButton.hidden        = YES;
        item.titleLabel.hidden          = NO;
        
        y                               = 0;
    } else {
        int deltaI                      = abs((int)_currentIndex - (int)index);
        
        if (deltaI <= minDecreaseIndex) {
            height                      = _itemSize.height / baseDecrease * pow(decreaseKoef, deltaI-1);
            width                       = _itemSize.width / baseDecrease * pow(decreaseKoef, deltaI-1);
            item.selectButton.hidden    = NO;
            item.titleLabel.hidden      = YES;
        } else {
            height                      = _itemSize.height / minDecrease;
            width                       = _itemSize.width / minDecrease;
        }
        y                               = _itemSize.height - bottomOffset - height;
    }
    item.frame                          = CGRectMake(*offsetX, y, width, height);
    *offsetX                           += width;
}

- (void)selectItem:(UIButton *)sender {
    NSUInteger      newIndex  = ((RTHItemCoverflipView *)[sender superview]).index;
    int             direction   = newIndex > _currentIndex ? 1 : -1;
    NSUInteger      currIndexIter     = _currentIndex;
    while (currIndexIter != newIndex) {
        currIndexIter += direction;
        [self moveOneStepWithRightDirection:direction];
    }
    getNextAnimation()(YES);
}

#pragma mark - setters

- (void)setItems:(NSArray *)items {
    _items                              = items;
    _currentIndex                       = 0;
    [self fillScroll];
}

- (void)setItemSize:(CGSize)itemSize {
    _itemSize                           = itemSize;
    [self fillScroll];
}

@end
