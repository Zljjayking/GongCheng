//
//  DDAllSearchRecentCell.m
//  GongChengDD
//
//  Created by xzx on 2018/5/14.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDAllSearchRecentCell.h"

@implementation DDAllSearchRecentCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

//阵列加载按钮
-(void)loadCellWithBtns:(NSArray *)array{
    CGFloat butX = 15;//初始距离左侧是15的距离
    CGFloat butY = 10;//初始距离上侧是10的距离
    
    [self.btnsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for(int i = 0; i < array.count; i++){
        //宽度自适应
        CGRect frame_W = [array[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
        
        if (i==0) {
            if (butX+frame_W.size.width+15>Screen_Width-15) {
//                butX = 15;//回到初始的距离左边15
//                butY += 55;//换一行，加55
            }
        }
        else{
            if (butX+frame_W.size.width+15>Screen_Width-15) {
                butX = 15;//回到初始的距离左边15
                butY += 55;//换一行，加55
            }
        }
        
        UIButton *but;
        
        if (butX+frame_W.size.width+15>Screen_Width-15) {//表示这个按钮超过屏幕宽
            but = [[UIButton alloc]initWithFrame:CGRectMake(butX, butY, Screen_Width-30, 36)];//原先40
        }
        else{
            but = [[UIButton alloc]initWithFrame:CGRectMake(butX, butY, frame_W.size.width+28, 36)];//原先40
        }
        
        [but setTitle:array[i] forState:UIControlStateNormal];
        but.titleLabel.font = kFontSize30;
        but.titleLabel.numberOfLines=1;
        but.layer.cornerRadius = 3;
        but.clipsToBounds=YES;
        [but setBackgroundColor:kColorNavBarGray];
        [but setTitleColor:KColorBlackTitle forState:UIControlStateNormal];
        but.tag=i+400;
        [but addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnsView addSubview:but];
        
        butX = CGRectGetMaxX(but.frame)+10;//同行两个按钮间距10
    }
    
    if (array.count>0) {
        _btnsViewHeight.constant=butY+55;
    }
    else{
        _btnsViewHeight.constant=butY;
    }
}

//按钮点击代代理回调
-(void)buttonClick:(UIButton *)sender{
    if([_delegate respondsToSelector:@selector(allSearchRecentCellSelectButton:buttonIndex:)]){
        [_delegate allSearchRecentCellSelectButton:self buttonIndex:sender.tag-400];
    }
}

//计算按钮的总高度
+(CGFloat)heightWithBtns:(NSArray *)array{
    CGFloat butX = 15;
    CGFloat butY = 10;
    
    for(int i = 0; i < array.count; i++){
        //宽度自适应
        CGRect frame_W = [array[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
        
        if (i==0) {
            if (butX+frame_W.size.width+15>Screen_Width-15) {
//                butX = 15;//回到初始的距离左边15
//                butY += 55;//换一行，加55
            }
        }
        else{
            if (butX+frame_W.size.width+15>Screen_Width-15) {
                butX = 15;//回到初始的距离左边15
                butY += 55;//换一行，加55
            }
        }
        
        UIButton *but;
        
        if (butX+frame_W.size.width+15>Screen_Width-15) {//表示这个按钮超过屏幕宽
            but = [[UIButton alloc]initWithFrame:CGRectMake(butX, butY, Screen_Width-30, 36)];//原先40
        }
        else{
            but = [[UIButton alloc]initWithFrame:CGRectMake(butX, butY, frame_W.size.width+28, 36)];//原先40
        }
        
        butX = CGRectGetMaxX(but.frame)+10;//同行两个按钮间距10
    }
    
    if (array.count>0) {
        return butY+55+5;
    }
    else{
        return butY+5;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
