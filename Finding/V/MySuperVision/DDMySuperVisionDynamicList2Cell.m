//
//  DDMySuperVisionDynamicList2Cell.m
//  GongChengDD
//
//  Created by xzx on 2018/12/1.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDMySuperVisionDynamicList2Cell.h"

@implementation DDMySuperVisionDynamicList2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tipLab1.text=@"半日报";
    self.tipLab1.textColor = kColorWhite;
    self.tipLab1.font = kFontSize24;

    self.tipLab2.backgroundColor=UIColorFromRGB(0xFFF8F0);
    self.tipLab2.textColor = KColorTextOrange;
    self.tipLab2.font = kFontSize24;
    self.tipLab2.layer.cornerRadius=2;
    
    self.timeLab.textColor = KColorGreySubTitle;
    self.timeLab.font = kFontSize26;
    
    self.pointLab.backgroundColor=kColorRed;
    self.pointLab.layer.cornerRadius=3;
    self.pointLab.clipsToBounds=YES;
    
    self.rightTopLab.textColor = KColorGreySubTitle;
    self.rightTopLab.font = kFontSize26;
    
    self.attachLab.textColor = KColorBlackSubTitle;
    self.attachLab.font = kFontSize26;
}

-(void)loadDataWithModel:(DDMySuperVisionDynamicListModel *)model{
    [self.bgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //对应返回结果的main_type和sub_type
    // 监控的大类：1-公司证书，2-人员证书, 3-认领公司，4-关注公司，5-本人证书，6-半日报
    // 监控的子类：1-到期监控，2-中标监控，3-变更单位，4-公司名称变更，5-行政处罚，6-事故通知，7-人员电话公开，8-招标监控
    if ([model.subType isEqualToString:@"1"] ||[model.subType isEqualToString:@"5"]||[model.subType isEqualToString:@"6"]) {
        self.tipLab2.backgroundColor=KColorFFF5F5;
        self.tipLab2.textColor = KColorFF5D5D;
    }else{
        self.tipLab2.backgroundColor=UIColorFromRGB(0xFFF8F0);
        self.tipLab2.textColor = KColorTextOrange;
    }
    
    if ([model.subType isEqualToString:@"1"]) {
        self.tipLab2.text=@"到期监控";
    }
    else if([model.subType isEqualToString:@"2"]){
        self.tipLab2.text=@"中标监控";
    }
    else if([model.subType isEqualToString:@"3"]){
        self.tipLab2.text=@"变更单位";
    }
    else if([model.subType isEqualToString:@"4"]){
        self.tipLab2.text=@"公司名称变更";
    }
    else if([model.subType isEqualToString:@"5"]){
        self.tipLab2.text=@"行政处罚";
    }
    else if([model.subType isEqualToString:@"6"]){
        self.tipLab2.text=@"事故通知";
    }
    else if([model.subType isEqualToString:@"7"]){
        self.tipLab2.text=@"电话公开";
    }
    else if([model.subType isEqualToString:@"8"]){
        self.tipLab2.text=@"招标监控";
    }
    self.timeLab.text=[DDUtils compareMessageTime:model.pushTime];
    NSString *string = @"中标";
    NSString *rightString = @"中标";
    if([model.subType isEqualToString:@"8"]){
        string = @"招标";
        rightString = @"招标";
    }
    if([model.subType isEqualToString:@"7"]){
        rightString = @"";
        string = @"公开";
    }
    self.rightTopLab.text=[NSString stringWithFormat:@"共%@条%@",model.rightTopInfo,rightString];
    
    NSMutableAttributedString *labelAttStr=[[NSMutableAttributedString alloc] initWithString:_rightTopLab.text];
    NSRange btnR=NSMakeRange(1,_rightTopLab.text.length-2-rightString.length); //灰色
    [labelAttStr addAttribute:NSForegroundColorAttributeName value:KColorBlackTitle range:btnR];
    _rightTopLab.attributedText = labelAttStr;
    
    NSInteger countNum=model.lineSplited.count;
    if (model.lineSplited.count>3) {
        countNum=3;
    }
    for (int i=0; i<countNum; i++) {
        LineSplitedModel *mod=model.lineSplited[i];
        UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(0, i*25, 170, 15)];
        lab1.text=mod.regionName;
        lab1.textColor=KColorBlackSubTitle;
        lab1.font=kFontSize28;
        [self.bgView addSubview:lab1];
            
        UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake(170, i*25, 110, 15)];
        lab2.text=[NSString stringWithFormat:@"%@条%@",mod.count,string];
        lab2.textColor=KColorGreySubTitle;
        lab2.font=kFontSize26;
        NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc] initWithString:lab2.text];
        NSRange btnR=NSMakeRange(0,lab2.text.length-3); //灰色
        [attStr addAttribute:NSForegroundColorAttributeName value:KColorBlackTitle range:btnR];
        lab2.attributedText = attStr;
        [self.bgView addSubview:lab2];
    }
    if (model.lineSplited.count>3) {
        self.attachLab.hidden = NO;
        self.attachLab.text=@"...";
        self.bgViewHeight.constant=3*25;
    }else{
        self.attachLab.hidden = YES;
        self.bgViewHeight.constant=model.lineSplited.count*25;
    }
    if ([model.isReaded isEqualToString:@"1"]) {
        self.pointLab.hidden=YES;
    }
    else{
        self.pointLab.hidden=NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
