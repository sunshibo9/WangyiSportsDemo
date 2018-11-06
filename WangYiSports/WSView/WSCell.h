//
//  WSCell.h
//  WangYiSports
//
//  Created by 孙士博 on 2018/10/29.
//  Copyright © 2018 com.demo.sports. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WSCell : UITableViewCell {
    UIImageView *imageView;
    UILabel *titleLable;
    UILabel *mediaLable;
    UILabel *commentLable;
}

- (void)setData:(NSString*)imageURL
          title:(NSString*)titleStr
          media:(NSString*)mediaStr
        comment:(NSString*)commentStr;

@end

NS_ASSUME_NONNULL_END
