//
//  WSTools.h
//  WangYiSports
//
//  Created by 孙士博 on 2018/10/29.
//  Copyright © 2018 com.demo.sports. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSTools : NSObject

+ (WSTools *)sharedInstance;

+ (AFHTTPSessionManager *)httpManager;

@end

NS_ASSUME_NONNULL_END
