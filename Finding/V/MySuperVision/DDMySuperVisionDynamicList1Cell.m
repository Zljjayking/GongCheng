//
//  DDMySuperVisionDynamicList1Cell.m
//  GongChengDD
//
//  Created by xzx on 2018/12/1.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDMySuperVisionDynamicList1Cell.h"

@implementation DDMySuperVisionDynamicList1Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tipLab1.text=@"公司证书";
    self.tipLab1.textColor = kColorWhite;
    self.tipLab1.font = kFontSize24;
    
    self.tipLab2.text=@"公司证书";
    self.tipLab2.backgroundColor=KColorFFF5F5;
    self.tipLab2.textColor = KColorFF5D5D;
    self.tipLab2.font = kFontSize24;
    self.tipLab2.layer.cornerRadius=2;
    
    self.timeLab.text=@"今天 08：31";
    self.timeLab.textColor = KColorGreySubTitle;
    self.timeLab.font = kFontSize26;
    
    self.pointLab.backgroundColor=kColorRed;
    self.pointLab.layer.cornerRadius=3;
    self.pointLab.clipsToBounds=YES;
    
    self.detailLab1.text=@"南京和远电力工程有限公司";
    self.detailLab1.textColor = kColorBlack;
    self.detailLab1.font = kFontSize30;
    
    self.detailLab2.text=@"安全生产许可证";
    self.detailLab2.textColor = KColorBlackSubTitle;
    self.detailLab2.font = kFontSize28;
    
    self.detailLab3.text=@"2018.12.12到期";
    self.detailLab3.textColor = KColorOrangeSubTitle;
    self.detailLab3.font = kFontSize28;
    
    [self.makeBtn setTitle:@"办理" forState:UIControlStateNormal];
    [self.makeBtn setTitleColor:KColorFindingPeopleBlue forState:UIControlStateNormal];
    self.makeBtn.titleLabel.font=kFontSize28;
    self.makeBtn.layer.borderColor=KColorFindingPeopleBlue.CGColor;
    self.makeBtn.layer.borderWidth=0.5;
    self.makeBtn.layer.cornerRadius=2;
    self.makeBtn.hidden=YES;
   
    self.infoLabel.text=@"请及时进行延续注册!";
    self.infoLabel.textColor = KColorBlackSubTitle;
    self.infoLabel.font = kFontSize28;
    self.infoLabel.hidden = YES;
}

-(void)loadDataWithModel:(DDMySuperVisionDynamicListModel *)model{
    //对应返回结果的main_type和sub_type
    // 监控的大类：1-公司证书，2-人员证书, 3-认领公司，4-关注公司，5-本人证书，6-半日报
    // 监控的子类：1-到期监控，2-中标监控，3-变更单位，4-公司名称变更，5-行政处罚，6-事故通知，7-人员电话公开，8-招标监控
    if ([model.mainType integerValue]==1) {
        self.tipLab1.text=@"公司证书";
    }
    else if([model.mainType integerValue]==2){
        self.tipLab1.text=@"个人证书";
    }
    else if([model.mainType integerValue]==3){
        self.tipLab1.text=@"认领公司";
    }
    else if([model.mainType integerValue]==4){
        self.tipLab1.text=@"关注公司";
    }
    else if([model.mainType integerValue]==5){
        self.tipLab1.text=@"本人证书";
    }

    if ([model.subType isEqualToString:@"1"] ||[model.subType isEqualToString:@"5"]||[model.subType isEqualToString:@"6"]) {
        self.tipLab2.backgroundColor=KColorFFF5F5;
        self.tipLab2.textColor = KColorFF5D5D;
    }else{
        self.tipLab2.backgroundColor=UIColorFromRGB(0xFFF8F0);
        self.tipLab2.textColor = KColorTextOrange;
    }
    
    if ([model.subType isEqualToString:@"1"]) {
        self.tipLab2.text=@"到期监控";
        NSString  *region_id = @"";
        if (model.redirectParamMap) {
            if ([DDUtils isEmptyString:model.redirectParamMap.region_id]) {
                 region_id = @"";
            }else{
                 region_id = [NSString stringWithFormat:@"%@",model.redirectParamMap.region_id];
            }
        }
        if ([model.typeCode isEqualToString:@"ECE_001"]||[model.typeCode isEqualToString:@"ECE_002"]||[model.typeCode isEqualToString:@"ECE_003"]||[model.typeCode isEqualToString:@"ECE_004"]||[model.typeCode isEqualToString:@"ECE_005"]||[model.typeCode isEqualToString:@"ECE_006"]||[model.typeCode isEqualToString:@"ECE_007"]||[model.typeCode isEqualToString:@"ECE_008"]) {
            self.makeBtn.hidden=YES;
            [self.makeBtn setTitle:@"办理" forState:UIControlStateNormal];
            [self.detailLab3 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(10);
                make.width.mas_equalTo(Screen_Width-90);
            }];
            [self.makeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(Screen_Width-80);
                make.width.mas_equalTo(70);
            }];
            
        }else if([model.typeCode isEqualToString:@"SCE_002"]||[model.typeCode isEqualToString:@"SCE_003"]) {//二建 //三类
            if([[region_id substringToIndex:2]isEqualToString:@"32"]){//江苏的加办理按钮
                self.makeBtn.hidden=NO;
                [self.makeBtn setTitle:@"办理" forState:UIControlStateNormal];
                [self.detailLab3 mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self).offset(10);
                    make.width.mas_equalTo(Screen_Width-90);
                }];
                [self.makeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self).offset(Screen_Width-80);
                    make.width.mas_equalTo(70);
                }];
            } else {
                self.makeBtn.hidden=YES;
            }
        }else {
            self.makeBtn.hidden=YES;
        }
    }
    else if([model.subType isEqualToString:@"2"]){
        self.tipLab2.text=@"中标监控";
        if(![DDUtils isEmptyString:model.lineB]){
            if (![model.lineBString.string hasPrefix:@"中标:"]) {
                model.lineBString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"中标: %@",model.lineBString.string]];
            }
        }
        
        self.detailLab3.textColor = KColorBlackSubTitle;
        if ([model.mainType integerValue]!=5){
            self.makeBtn.hidden=NO;
            if ([model.in3Month integerValue] == 1) {
                [self.makeBtn setTitle:@"买履约保证险" forState:UIControlStateNormal];
            } else {
                [self.makeBtn setTitle:@"买质量保证险" forState:UIControlStateNormal];
            }
            [self.detailLab3 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(10);
                make.width.mas_equalTo(Screen_Width-160);
            }];
            [self.makeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(Screen_Width-140);
                make.width.mas_equalTo(130);
            }];
        }else{
            self.makeBtn.hidden = YES;
        }
        
    }
    else if([model.subType isEqualToString:@"3"]){
        self.tipLab2.text=@"变更单位";
        self.makeBtn.hidden=YES;
    }
    else if([model.subType isEqualToString:@"4"]){
        self.tipLab2.text=@"公司名称变更";
        self.makeBtn.hidden=YES;
    }
    else if([model.subType isEqualToString:@"5"]){
        self.tipLab2.text=@"行政处罚";
        self.makeBtn.hidden=YES;
    }
    else if([model.subType isEqualToString:@"6"]){
        self.tipLab2.text=@"事故通知";
        self.makeBtn.hidden=YES;
    }
    else if([model.subType isEqualToString:@"7"]){
        self.tipLab2.text=@"电话公开";
        self.makeBtn.hidden=NO;
    }
    else if([model.subType isEqualToString:@"8"]){
        self.tipLab2.text=@"招标监控";
        self.makeBtn.hidden=NO;
    }
    if (self.makeBtn.hidden == YES) {
        [self.detailLab3 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
        }];
        [self.makeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(Screen_Width);
            make.width.mas_equalTo(70);
        }];
    }
    
    self.timeLab.text=[DDUtils compareMessageTime:model.pushTime];
    
    if ([model.isReaded isEqualToString:@"1"]) {
        self.pointLab.hidden=YES;
    }
    else{
        self.pointLab.hidden=NO;
    }
    if([model.typeCode isEqualToString:@"SCE_001"]){
        self.infoLabel.hidden = NO;
        self.makeBtn.hidden = YES;
    }else {
        self.infoLabel.hidden = YES;
    }
    self.detailLab1.text=model.lineA;
    //self.detailLab2.text=model.lineB;
    self.detailLab2.attributedText=model.lineBString;
    self.detailLab2.font=kFontSize28;
    self.detailLab3.attributedText=model.lineCString;
    self.detailLab3.font=kFontSize28;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
