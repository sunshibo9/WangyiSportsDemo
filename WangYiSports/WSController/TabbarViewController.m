//
//  TabbarViewController.m
//  WangYiSports
//
//  Created by 孙士博 on 2018/10/29.
//  Copyright © 2018 com.demo.sports. All rights reserved.
//

#import "TabbarViewController.h"
#import "MainViewController.h"
#import "ProfileViewController.h"
#import "WStabbar.h"

@interface TabbarViewController ()

@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initController];
}

- (void)initController {
    MainViewController *mainVC = [[MainViewController alloc]init];
    mainVC.navigationItem.title = @"网易新闻";
    UINavigationController *firstNav = [[UINavigationController alloc]initWithRootViewController:mainVC];
    [self setTabBarItem:mainVC.tabBarItem title:@"网易新闻" titleSize:13.0 titleFontName:@"HeiTi" selectedImage:@"home.png" selectedTitleColor:[UIColor redColor] normalImage:@"home.png" normalTitleColor:[UIColor grayColor]];
    
    ProfileViewController *profileVC = [[ProfileViewController alloc]init];
    profileVC.navigationItem.title = @"Profile";
    UINavigationController *secondNav = [[UINavigationController alloc]initWithRootViewController:profileVC];
    [self setTabBarItem:profileVC.tabBarItem title:@"Profile" titleSize:13.0 titleFontName:@"HeiTi" selectedImage:@"profile.png" selectedTitleColor:[UIColor redColor] normalImage:@"profile.png" normalTitleColor:[UIColor grayColor]];
    
    self.viewControllers = @[firstNav,secondNav];
}

- (void)setTabBarItem:(UITabBarItem *)tabbarItem
                title:(NSString *)title
            titleSize:(CGFloat)size
        titleFontName:(NSString *)fontName
        selectedImage:(NSString *)selectedImage
   selectedTitleColor:(UIColor *)selectColor
          normalImage:(NSString *)unselectedImage
     normalTitleColor:(UIColor *)unselectColor
{
    
    //设置图片
    tabbarItem = [tabbarItem initWithTitle:title image:[[UIImage imageNamed:unselectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    // S未选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:unselectColor,NSFontAttributeName:[UIFont systemFontOfSize:size]} forState:UIControlStateNormal];
    
    // 选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:selectColor,NSFontAttributeName:[UIFont systemFontOfSize:size]} forState:UIControlStateSelected];
}


@end
