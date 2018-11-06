//
//  WSCell.m
//  WangYiSports
//
//  Created by 孙士博 on 2018/10/29.
//  Copyright © 2018 com.demo.sports. All rights reserved.
//

#import "WSCell.h"
#import "Masonry.h"
#import "UIImageView+AFNetworking.h"

@implementation WSCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 96, 80)];
        titleLable = [[UILabel alloc]initWithFrame:CGRectMake(126, 10, self.contentView.frame.size.width-126, 40)];
        mediaLable = [[UILabel alloc]initWithFrame:CGRectMake(126, 80, 96, 10)];
        commentLable = [[UILabel alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width-126, 80, 96, 10)];
        
        [self.contentView addSubview:imageView];
        [self.contentView addSubview:titleLable];
        [self.contentView addSubview:mediaLable];
        [self.contentView addSubview:commentLable];
        
        [imageView setImage:[UIImage imageNamed:@"defaultImage.jpg"]];
        
        [titleLable setText:@"title"];
        titleLable.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
        titleLable.lineBreakMode = NSLineBreakByCharWrapping;
        titleLable.numberOfLines = 0;
        
        [mediaLable setText:@"media"];
        mediaLable.font = [UIFont systemFontOfSize:10];
        mediaLable.textColor = [UIColor lightGrayColor];
        mediaLable.lineBreakMode = NSLineBreakByCharWrapping;
        mediaLable.numberOfLines = 0;
        
        [commentLable setText:@"comment"];
        commentLable.font = [UIFont systemFontOfSize:10];
        commentLable.textColor = [UIColor lightGrayColor];
        commentLable.lineBreakMode = NSLineBreakByCharWrapping;
        commentLable.numberOfLines = 0;
    }
    return self;
}

- (void)setData:(NSString*)imageURL
          title:(NSString*)titleStr
          media:(NSString*)mediaStr
        comment:(NSString*)commentStr {
    [imageView setImageWithURL:[NSURL URLWithString:imageURL]];
    [titleLable setText:titleStr];
    [mediaLable setText:mediaStr];
    [commentLable setText:commentStr];
}

@end
