//
//  MainViewController.m
//  WangYiSports
//
//  Created by 孙士博 on 2018/10/29.
//  Copyright © 2018 com.demo.sports. All rights reserved.
//

#import "MainViewController.h"
#import "WSTools.h"
#import "MJRefresh.h"
#import "WSCell.h"
#import "MJRefresh.h"
#import "DetailViewController.h"
#import "SDCycleScrollView.h"
#import "BlockViewController.h"

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface MainViewController () <UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>{
    UITableView *maintable;
    UIImageView *imageView;
    NSMutableArray *dataArray;
    NSMutableArray *titleArray;
    NSMutableArray *blockArray;
    NSMutableArray *blockTitleArray;
    SDCycleScrollView *scrollView;
    NSDictionary *selectedDic;
}

@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArray = [[NSMutableArray alloc]init];
    titleArray = [[NSMutableArray alloc]init];
    blockArray = [[NSMutableArray alloc]init];
    blockTitleArray = [[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(blockClick:)name:@"blockNews" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(blockTitleClick:)name:@"blockTitle" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recoverNewsClick:)name:@"recoverNews" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recoverTitleClick:)name:@"recoverTitle" object:nil];
    [self initView];
    [self firstInit];
}

- (void)firstInit {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults integerForKey:@"first_time"] == 1) {
        NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path1 = [documents[0] stringByAppendingPathComponent:@"dataArray.plist"];
        NSString *path2 = [documents[0] stringByAppendingPathComponent:@"titleArray.plist"];
        NSString *path3 = [documents[0] stringByAppendingPathComponent:@"blockArray.plist"];
        NSString *path4 = [documents[0] stringByAppendingPathComponent:@"blockTitleArray.plist"];
        
        dataArray = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:path1]];
        titleArray = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:path2]];
        blockArray = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:path3]];
        blockTitleArray = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:path4]];
        
        [self scrollViewHidden];
        [self loadtable];
    }
    else {
        [self->maintable.mj_header beginRefreshing];
    }
}

- (void)initView {
    [self initHeader];
    [self loadtable];
}

- (void)initHeader {
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 16, 16)];
    [rightBtn setTitle:@"屏蔽列表" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [rightBtn addTarget:self action:@selector(listClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadtable {
    if (maintable) {
        [maintable reloadData];
        [self scrollViewHidden];
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in self->titleArray) {
            [array addObject:[dic objectForKey:@"imgsrc"]];
        }
        self->scrollView.imageURLStringsGroup = array;
    }
    else {
        maintable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
        [maintable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        maintable.delegate = self;
        maintable.dataSource = self;
        [self.view addSubview:maintable];
        [maintable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, 0, 200) delegate:self placeholderImage:[UIImage imageNamed:@"defaultImage.jpg"]];
        
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in self->titleArray) {
            [array addObject:[dic objectForKey:@"imgsrc"]];
        }
        self->scrollView.imageURLStringsGroup = array;
        
        maintable.tableHeaderView = scrollView;
        maintable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    }
}

- (void)loadData {
    AFHTTPSessionManager *manager = [WSTools httpManager];
    NSString *URL = @"http://c.m.163.com/nc/article/list/T1348649145984/0-10.html";
    [manager GET:URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"成功！！！！！！！");
        NSLog(@"%@",responseObject);
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
        dictionary = [NSMutableDictionary dictionaryWithDictionary:responseObject];
        self->dataArray = [NSMutableArray arrayWithArray:[dictionary valueForKey:@"T1348649145984"]];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults integerForKey:@"first_time"] == 1) {

            self->dataArray = [self filterData:self->blockArray :self->dataArray];
            self->dataArray = [self filterData:self->titleArray :self->dataArray];
            self->dataArray = [self filterData:self->blockTitleArray :self->dataArray];
            self->titleArray = [self filterData:self->blockTitleArray :self->titleArray];
        }
        else {
            [defaults setInteger:1 forKey:@"first_time"];
            [defaults synchronize];
            if ([self->dataArray count]>3) {
                [self->titleArray addObject:[self->dataArray objectAtIndex:0]];
                [self->titleArray addObject:[self->dataArray objectAtIndex:1]];
                [self->titleArray addObject:[self->dataArray objectAtIndex:2]];
                [self->dataArray removeObjectAtIndex:0];
                [self->dataArray removeObjectAtIndex:0];
                [self->dataArray removeObjectAtIndex:0];
            }
            else {
                [self->titleArray addObjectsFromArray:self->dataArray];
                [self->dataArray removeAllObjects];
            }
            NSMutableArray *array = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in self->titleArray) {
                [array addObject:[dic objectForKey:@"imgsrc"]];
            }
            self->scrollView.imageURLStringsGroup = array;
        }
        //文件读写
        NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path1 = [documents[0] stringByAppendingPathComponent:@"dataArray.plist"];
        NSString *path2 = [documents[0] stringByAppendingPathComponent:@"titleArray.plist"];
        
        [[self->dataArray copy] writeToFile:path1 atomically:YES];
        [[self->titleArray copy] writeToFile:path2 atomically:YES];
        
        [self loadtable];
        [self->maintable.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        NSLog(@"失败！！！！！！！！");
        [self->maintable.mj_header endRefreshing];
    }];
}

#pragma mark - UITableView

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    WSCell *cell = [maintable dequeueReusableCellWithIdentifier:@"maincell"];
    if (cell == nil) {
        cell = [[WSCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ufcell"];
    }
    @autoreleasepool {
        NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.row];
        NSString *imageURL = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"imgsrc"]];
        NSString *titleStr = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"title"]];
        NSString *mediaStr = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"source"]];
        NSString *commentStr = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"replyCount"]];
        if ([dictionary objectForKey:@"replyCount"] == nil) {
            commentStr = @"直播";
        }
        
        [cell setData:imageURL title:titleStr media:mediaStr comment:commentStr];
    }
    return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *detailVC = [[DetailViewController alloc]init];
     NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.row];
    selectedDic = [NSDictionary dictionaryWithDictionary:dictionary];
    detailVC.dictionary = selectedDic;
    detailVC.webURL = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"url"]];
    detailVC.isBlock = @"NO";
    detailVC.isTitle = @"NO";
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    DetailViewController *detailVC = [[DetailViewController alloc]init];
    NSDictionary *dictionary = [titleArray objectAtIndex:index];
    selectedDic = [NSDictionary dictionaryWithDictionary:dictionary];
    detailVC.webURL = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"url"]];
    detailVC.dictionary = selectedDic;
    detailVC.isBlock = @"NO";
    detailVC.isTitle = @"YES";
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)scrollViewHidden {
    if ([titleArray count] == 0) {
        //scrollView.hidden = YES;
        [scrollView removeFromSuperview];
        maintable.tableHeaderView = nil;
    }
    else {
        //scrollView.hidden = NO;
        scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, 0, 200) delegate:self placeholderImage:[UIImage imageNamed:@"defaultImage.jpg"]];
        
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in self->titleArray) {
            [array addObject:[dic objectForKey:@"imgsrc"]];
        }
        self->scrollView.imageURLStringsGroup = array;
        
        maintable.tableHeaderView = scrollView;
    }
}

- (void) blockClick:(NSNotification *)blockDic {
    [blockArray addObject:selectedDic];
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path1 = [documents[0] stringByAppendingPathComponent:@"blockArray.plist"];
    NSString *path2 = [documents[0] stringByAppendingPathComponent:@"dataArray.plist"];
    [[self->blockArray copy] writeToFile:path1 atomically:YES];

    dataArray = [self filterData:blockArray :dataArray];
    [[self->dataArray copy] writeToFile:path2 atomically:YES];
    [self loadtable];
    //[self->maintable.mj_header beginRefreshing];
}

- (void) blockTitleClick:(NSNotification *)blockDic {
    [blockTitleArray addObject:selectedDic];
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path1 = [documents[0] stringByAppendingPathComponent:@"blockTitleArray.plist"];
    NSString *path2 = [documents[0] stringByAppendingPathComponent:@"titleArray.plist"];
    [[self->blockTitleArray copy] writeToFile:path1 atomically:YES];

    titleArray = [self filterData:blockTitleArray :titleArray];
    [[self->titleArray copy] writeToFile:path2 atomically:YES];
    [self scrollViewHidden];
    [self loadtable];
    
}

- (void)recoverNewsClick:(NSNotification *)blockDic {
    NSDictionary* dic = blockDic.object;
    [blockArray removeObject:dic];
    [dataArray addObject:dic];
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path1 = [documents[0] stringByAppendingPathComponent:@"blockArray.plist"];
    NSString *path2 = [documents[0] stringByAppendingPathComponent:@"dataArray.plist"];
    [[self->dataArray copy] writeToFile:path2 atomically:YES];
    [[self->blockArray copy] writeToFile:path1 atomically:YES];
    [self loadtable];
}

- (void)recoverTitleClick:(NSNotification *)blockDic {
    NSDictionary* dic = blockDic.object;
    [blockTitleArray removeObject:dic];
    [titleArray addObject:dic];
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path1 = [documents[0] stringByAppendingPathComponent:@"blockTitleArray.plist"];
    NSString *path2 = [documents[0] stringByAppendingPathComponent:@"titleArray.plist"];
    [[self->titleArray copy] writeToFile:path2 atomically:YES];
    [[self->blockTitleArray copy] writeToFile:path1 atomically:YES];
    [self loadtable];
}

- (void)listClick {
    BlockViewController *blockVC = [[BlockViewController alloc]init];
    blockVC.dataArray = blockArray;
    blockVC.titleArray = blockTitleArray;
    [self.navigationController pushViewController:blockVC animated:YES];
}

//查重判断
- (NSMutableArray *)filterData:(NSMutableArray *)givenArray
                  :(NSMutableArray *)orientedArray{
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:orientedArray];
    for (NSDictionary *dic in givenArray) {
        for (NSDictionary *dic2 in tempArray) {
            if ([dic isEqualToDictionary:dic2]) {
                [orientedArray removeObject:dic2];
            }
        }
    }
    return orientedArray;
}

@end
