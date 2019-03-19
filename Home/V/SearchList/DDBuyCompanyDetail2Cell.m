//
//  DDBuyCompanyDetail2Cell.m
//  GongChengDD
//
//  Created by xzx on 2018/5/30.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDBuyCompanyDetail2Cell.h"

@implementation DDBuyCompanyDetail2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    self.lineLab.backgroundColor=KColorTableSeparator;
    
//    if ([self.status isEqualToString:@"0"]) {
//        [self.moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
//    }
//    else{
//        [self.moreBtn setTitle:@"收起" forState:UIControlStateNormal];
//    }
//    [self.moreBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
//    self.moreBtn.titleLabel.font=kFontSize30;
//    [self.moreBtn addTarget:self action:@selector(moreOrLessClick) forControlEvents:UIControlEventTouchUpInside];
}

//查看更多或者收起按钮点击事件
-(void)moreOrLessClick{
    if([_delegate respondsToSelector:@selector(downOrUpBtnClick)]){
        [_delegate downOrUpBtnClick];
    }
}

-(void)loadWithArray:(NSArray *)array{
    [self.bgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if ([self.status isEqualToString:@"0"]) {
        [self.moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
    }
    else{
        [self.moreBtn setTitle:@"收起" forState:UIControlStateNormal];
    }
    [self.moreBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
    self.moreBtn.titleLabel.font=kFontSize30;
    [self.moreBtn addTarget:self action:@selector(moreOrLessClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (array.count<=5 && array.count>0) {//少于5个
        self.lineLab.hidden=YES;
        self.moreBtn.hidden=YES;
        self.bgViewHeight.constant=array.count*40;
        for (int i=0; i<array.count; i++) {
            DDCertTypeLevelListModel *model=array[i];
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, i*40, Screen_Width-24, 40)];
            label.text=[NSString stringWithFormat:@"%d.%@",i+1,model.value];
            label.textColor=KColorBlackSubTitle;
            label.font=kFontSize30;
            [self.bgView addSubview:label];
        }
    }
    else if(array.count>5){//多于5个，按照5个显示
        self.lineLab.hidden=NO;
        self.moreBtn.hidden=NO;
        
        if ([self.status isEqualToString:@"0"]) {
            self.bgViewHeight.constant=5*40;
            for (int i=0; i<5; i++) {
                DDCertTypeLevelListModel *model=array[i];
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, i*40, Screen_Width-24, 40)];
                label.text=[NSString stringWithFormat:@"%d.%@",i+1,model.value];
                label.textColor=KColorBlackSubTitle;
                label.font=kFontSize30;
                [self.bgView addSubview:label];
            }
        }
        else{
            self.bgViewHeight.constant=array.count*40;
            for (int i=0; i<array.count; i++) {
                DDCertTypeLevelListModel *model=array[i];
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, i*40, Screen_Width-24, 40)];
                label.text=[NSString stringWithFormat:@"%d.%@",i+1,model.value];
                label.textColor=KColorBlackSubTitle;
                label.font=kFontSize30;
                [self.bgView addSubview:label];
            }
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
