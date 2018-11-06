//
//  DetailViewController.m
//  WangYiSports
//
//  Created by 孙士博 on 2018/10/29.
//  Copyright © 2018 com.demo.sports. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void)initView {
    [self initHeader];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = webView;
    NSURL *url = [NSURL URLWithString:_webURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

- (void)initHeader {
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 16, 16)];
    [rightBtn setTitle:@"屏蔽该新闻" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [rightBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.layer.cornerRadius = 8.0;
    [rightBtn setBackgroundColor:[UIColor redColor]];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:10];
}

- (void)btnClick {
    NSLog(@"block!");
    if ([_isTitle isEqualToString:@"YES"]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"blockTitle" object:_dictionary];
    }
    else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"blockNews" object:_dictionary];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
