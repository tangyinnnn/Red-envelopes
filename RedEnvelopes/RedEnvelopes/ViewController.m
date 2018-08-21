//
//  ViewController.m
//  RedEnvelopes
//
//  Created by tangyin on 2018/8/21.
//  Copyright © 2018年 tangyin. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "NewUserGift.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button  = [[UIButton alloc]initWithFrame:CGRectZero];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"打开红包" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.equalTo(@(150));
        make.height.equalTo(@(50));
    }];
    
}

- (void)buttonAction {
    //调用
    [NewUserGift showNewUserWithIdentifier:@"这里是用户唯一标示，用来判断是否已经抽取过红包" completion:^(BOOL finished) {
        //点击立即使用，回调方法
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
