//
//  BlockViewController.m
//  WangYiSports
//
//  Created by 孙士博 on 2018/10/30.
//  Copyright © 2018 com.demo.sports. All rights reserved.
//

#import "BlockViewController.h"
#import "WSCell.h"
#import "DetailViewController.h"

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface BlockViewController () <UITableViewDelegate,UITableViewDataSource>{
    UITableView *blockTable;
    NSDictionary *selectedDic;
    NSMutableArray *showArray;
}

@end

@implementation BlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"屏蔽列表";
    [self initData];
    [self loadTable];
}

- (void)initData {
    showArray = [[NSMutableArray alloc]init];
    [showArray addObjectsFromArray:_dataArray];
    [showArray addObjectsFromArray:_titleArray];
}

- (void)loadTable {
    if (blockTable) {
        [blockTable reloadData];
    }
    else {
        blockTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
        [blockTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        blockTable.delegate = self;
        blockTable.dataSource = self;
        [self.view addSubview:blockTable];
    }
}

#pragma mark - UITableView

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    WSCell *cell = [blockTable dequeueReusableCellWithIdentifier:@"maincell"];
    if (cell == nil) {
        cell = [[WSCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ufcell"];
    }
    @autoreleasepool {
        NSDictionary *dictionary = [showArray objectAtIndex:indexPath.row];
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
    return [showArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *detailVC = [[DetailViewController alloc]init];
    NSDictionary *dictionary = [showArray objectAtIndex:indexPath.row];
    selectedDic = [NSDictionary dictionaryWithDictionary:dictionary];
    detailVC.dictionary = selectedDic;
    detailVC.webURL = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"url"]];
    detailVC.isBlock = @"YES";
    detailVC.isTitle = @"NO";
    [self.navigationController pushViewController:detailVC animated:YES];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger dataCount = [_dataArray count];
    //NSUInteger titleCount = [_titleArray count];
    // 删除模型
    NSUInteger count = indexPath.row;
    if (count+1>dataCount) {
        count = count - dataCount;
         [[NSNotificationCenter defaultCenter]postNotificationName:@"recoverTitle" object:[showArray objectAtIndex:indexPath.row]];
        //[_titleArray removeObjectAtIndex:count];
    }
    else {
         [[NSNotificationCenter defaultCenter]postNotificationName:@"recoverNews" object:[showArray objectAtIndex:indexPath.row]];
        //[_dataArray removeObjectAtIndex:count];
    }
///////////////////////////////
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"recoverNews" object:[showArray objectAtIndex:indexPath.row]];
    
    [showArray removeObjectAtIndex:indexPath.row];
    
    // 刷新
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    
}

@end
