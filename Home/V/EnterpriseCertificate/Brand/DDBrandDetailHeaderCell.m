//
//  DDBrandDetailHeaderCell.m
//  GongChengDD
//
//  Created by csq on 2018/9/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDBrandDetailHeaderCell.h"
#import "UIImageView+WebCache.h"

@implementation DDBrandDetailHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //加圆角
    //    _brandImageView.layer.cornerRadius = 3;
    //    _brandImageView.clipsToBounds = YES;
    //加边框
    _brandImageView.layer.borderColor = KColorTableSeparator.CGColor;//边框颜色
    _brandImageView.layer.borderWidth = 0.5;//边框宽度
    _brandImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _brandImageView.backgroundColor = [UIColor whiteColor];
    
}
- (void)loadWithModel:(DDBrandDetailModel*)model{
    
    [_brandImageView sd_setImageWithURL:[NSURL URLWithString: model.brandImg] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image) {
            _brandImageView.image = image;
        }
    }];
}
+(CGFloat)height{
    return 159;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
