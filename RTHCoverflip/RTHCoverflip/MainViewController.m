//
//  MainViewController.m
//  RTHCoverflip
//
//  Created by Ratsh on 24.11.14.
//  Copyright (c) 2014 rth. All rights reserved.
//

#import "MainViewController.h"
#import "RTHCoverflipView.h"
#import "RTHItemCoverflipView.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray     *imgNamesArray          = @[@"test1",
                                            @"test2",
                                            @"test3",
                                            @"test4",
                                            @"test5",
                                            @"test1",
                                            @"test2",
                                            @"test3",
                                            @"test4",
                                            @"test5"
                                            ];
    
    NSMutableArray  *itemsArray         = @[].mutableCopy;
    
    for (int i = 0; i < 10; i++) {
        RTHItemCoverflipView    *item   = [RTHItemCoverflipView new];
        
        item.titleLabel.text            = imgNamesArray[i];
        [item.imageButton setImage:[UIImage imageNamed:imgNamesArray[i]] forState:UIControlStateNormal];
        [itemsArray addObject:item];
    }
    
    RTHCoverflipView    *coverflip      = [RTHCoverflipView new];
    coverflip.frame                     = CGRectMake(10.0, 100.0, self.view.bounds.size.width - 20.0, 200.0);
    coverflip.layer.borderWidth         = 1.0;
    coverflip.items                     = itemsArray;
    [self.view addSubview:coverflip];
}


@end
