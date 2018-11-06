//
//  WSTools.m
//  WangYiSports
//
//  Created by 孙士博 on 2018/10/29.
//  Copyright © 2018 com.demo.sports. All rights reserved.
//

#import "WSTools.h"

@implementation WSTools

+ (WSTools *)sharedInstance {
    static WSTools *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WSTools alloc]init];
    });
    return sharedInstance;
}

+ (AFHTTPSessionManager *)httpManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    manager.requestSerializer.timeoutInterval = 20;
    manager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    return manager;
}

@end
