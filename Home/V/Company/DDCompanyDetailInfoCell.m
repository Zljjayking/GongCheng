//
//  DDCompanyDetailInfoCell.m
//  GongChengDD
//
//  Created by xzx on 2018/5/11.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDCompanyDetailInfoCell.h"
@interface DDCompanyDetailInfoCell()
@property(nonatomic,strong)UILabel *line1;
@property(nonatomic,strong)UILabel *line2;
@property(nonatomic,strong)UILabel *line3;
@end

@implementation DDCompanyDetailInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLab.text=@"南京和远建筑工程有限公司";
    self.titleLab.textColor=KColorBlackTitle;
    self.titleLab.font=KFontSize42Bold;
    
    self.refreshTimeLab.text=@"更新时间:今天";
    self.refreshTimeLab.textColor=kColorGrey;
    self.refreshTimeLab.font=kFontSize24;
    
    self.seenLab.text=@"浏览:337";
    self.seenLab.textColor=kColorGrey;
    self.seenLab.font=kFontSize24;
    

    self.peopleLab1.text=@"法定代表人";
    self.peopleLab1.textColor=KColorPlaceholderColor;
    self.peopleLab1.font=kFontSize24;
    
    [self.peopleBtn setTitle:@"方久和" forState:UIControlStateNormal];
    [self.peopleBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
    self.peopleBtn.titleLabel.font=kFontSize24;
    
    
    self.moneyLab1.text=@"注册资本";
    self.moneyLab1.textColor=KColorPlaceholderColor;
    self.moneyLab1.font=kFontSize24;
    
    self.moneyLab2.text=@"3000万元";
    self.moneyLab2.textColor=KColorBlackSubTitle;
    self.moneyLab2.font=kFontSize24;
    
    self.timeLab1.text=@"成立日期";
    self.timeLab1.textColor=KColorPlaceholderColor;
    self.timeLab1.font=kFontSize24;
    
    self.timeLab2.text=@"2017-12-25";
    self.timeLab2.textColor=KColorBlackSubTitle;
    self.timeLab2.font=kFontSize24;
    
    self.countTitle.text=@"综合评分";
    self.countTitle.textColor=KColorPlaceholderColor;
    self.countTitle.font=kFontSize24;
    
    self.countContent.text=@"-";
    self.countContent.textColor=KColorBlackSubTitle;
    self.countContent.font=kFontSize24;
    
    
    self.lineLab.backgroundColor=KColor10AlphaBlack;
    
    
    [self.telBtn setTitle:@"13252154124" forState:UIControlStateNormal];
    [self.telBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
    self.telBtn.titleLabel.font=kFontSize30;
    
    
    [self.moreInfoBtn setTitle:@"更多联络信息" forState:UIControlStateNormal];
    [self.moreInfoBtn setTitleColor:KColorBlackTitle forState:UIControlStateNormal];
    self.moreInfoBtn.titleLabel.font=kFontSize28;
    
    
    
    _line1=[[UILabel alloc]initWithFrame:CGRectMake(Screen_Width/4, 115+35, 1, 15)];
    _line1.backgroundColor=KColorTableSeparator;
    [self addSubview:_line1];
    
    _line2=[[UILabel alloc]initWithFrame:CGRectMake(Screen_Width/2, 115+35, 1, 15)];
    _line2.backgroundColor=KColorTableSeparator;
    [self addSubview:_line2];
    _line3=[[UILabel alloc]initWithFrame:CGRectMake(Screen_Width/4*3, 115+35, 1, 15)];
    _line3.backgroundColor=KColorTableSeparator;
    [self addSubview:_line3];
    
    self.statusLab.text=@" 在业 ";
    self.statusLab.textColor=kColorBlue;
    self.statusLab.font=kFontSize26;
    self.statusLab.backgroundColor=KColorUsedNameBg1;
//    self.statusLab.textAlignment=NSTextAlignmentCenter;
    self.statusLab.layer.masksToBounds = YES;
    self.statusLab.layer.cornerRadius=3;
 
    [self.usedNameBtn setTitle:@"曾用名" forState:UIControlStateNormal];
    [self.usedNameBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
    [self.usedNameBtn setBackgroundColor:KColorUsedNameBg1];
    self.usedNameBtn.titleLabel.font=kFontSize26;
    self.usedNameBtn.layer.cornerRadius=3;
    
    [self.billBtn setTitle:@"发票抬头" forState:UIControlStateNormal];
    [self.billBtn setTitleColor:KColorBillBtnText forState:UIControlStateNormal];
    [self.billBtn setBackgroundColor:KColorBillBtnBg];
    self.billBtn.titleLabel.font=kFontSize26;
    self.billBtn.layer.cornerRadius=3;
    
    [self.goCheckBtn setTitle:@"去认领" forState:UIControlStateNormal];
    [self.goCheckBtn  setTitleColor:KColorTextOrange forState:UIControlStateNormal];
    [self.goCheckBtn  setBackgroundColor:kColorWhite];
    self.goCheckBtn .titleLabel.font=kFontSize28;
    self.goCheckBtn .layer.borderColor=KColorTextOrange.CGColor;
    self.goCheckBtn .layer.borderWidth=0.5;
    self.goCheckBtn .layer.cornerRadius=3;
}

-(void)loadDataWithModel:(DDCompanyDetailModel1 *)model{
    self.titleLab.text=model.info.enterpriseName;
    
    if ([DDUtils isEmptyString:model.info.updateTime]) {
        self.refreshTimeLab.text=@"更新时间：";
    }
    else{
        //self.refreshTimeLab.text=[NSString stringWithFormat:@"更新时间:%@",[DDUtils getDateLineByStandardTime:model.info.updateTime]];
        self.refreshTimeLab.text=[NSString stringWithFormat:@"更新时间：%@",[DDUtils todayYesterdayTime:model.info.updateTime]];
    }
    
    if ([DDUtils isEmptyString:model.info.visits]) {
        self.seenLab.text=@"浏览：";
    }
    else{
        self.seenLab.text=[NSString stringWithFormat:@"浏览：%@",model.info.visits];
    }
    
    self.statusLab.text=[NSString stringWithFormat:@" %@ ",model.info.status];
    
    if ([model.info.status isEqualToString:@"注销"] || [model.info.status isEqualToString:@"吊销，未注销"] || [model.info.status isEqualToString:@"吊销"]) {
        self.statusLab.textColor=kColorRed;
        self.statusLab.backgroundColor=KColorUsedNameBg2;
    }
    else{
        self.statusLab.textColor=kColorBlue;
        self.statusLab.backgroundColor=KColorUsedNameBg1;
    }
    
    //如果usedNames为空，但status不为空，则隐藏曾用名按钮
    if (model.info.usedNames.count==0 && ![DDUtils isEmptyString:model.info.status]) {
        self.statusLabWidth.constant=45;
        self.seperateWidth1.constant=10;
        
        self.usedNameWidth.constant=0;
        self.seperateWidth2.constant=0;
    }
    //如果status为空，但usedNames不为空，则隐藏状态按钮
    else if (model.info.usedNames.count!=0 && [DDUtils isEmptyString:model.info.status]){
        self.statusLabWidth.constant=0;
        self.seperateWidth1.constant=0;
        
        self.usedNameWidth.constant=48;
        self.seperateWidth2.constant=10;
    }
    //如果status、usedNames都为空
    else if (model.info.usedNames.count==0 && [DDUtils isEmptyString:model.info.status]) {
        self.statusLabWidth.constant=0;
        self.seperateWidth1.constant=0;
        
        self.usedNameWidth.constant=0;
        self.seperateWidth2.constant=0;
    }
    else{//状态,曾用名都显示
        self.statusLabWidth.constant=45;
        self.seperateWidth1.constant=10;
        
        self.usedNameWidth.constant=48;
        self.seperateWidth2.constant=10;
    }
    
    
    
    if (![DDUtils isEmptyString:model.info.legalRepresentative]) {
        [self.peopleBtn setTitle:model.info.legalRepresentative forState:UIControlStateNormal];
    }
    else{
        [self.peopleBtn setTitle:@"-" forState:UIControlStateNormal];
    }
    
    if ([model.attestation isEqualToString:@"1"]||[model.attestation isEqualToString:@"2"]) {
        [self.goCheckBtn setTitle:@"已认领" forState:UIControlStateNormal];
        [self.goCheckBtn  setTitleColor:kColorBlue forState:UIControlStateNormal];
        self.goCheckBtn .layer.borderColor=kColorBlue.CGColor;
    }
    
    //后台返回的是元,转化成万元
    double newRegisterCapital = [model.info.registerCapital doubleValue]/10000;
    NSString * str1 = [NSString stringWithFormat:@"%.4f",newRegisterCapital];
    NSString * rsult1 = [DDUtils removeFloatAllZero:str1];//去掉末尾多余的0
    
    if ([model.info.registerCapitalCurrency isEqualToString:@"0"]) {//人民币
        if (![DDUtils isEmptyString:model.info.registerCapital]) {
    
            //NSString *moneyStr=[self removeFloatAllZero:[NSString stringWithFormat:@"%.4f",model.info.registerCapital.doubleValue/10000]];
            self.moneyLab2.text=[NSString stringWithFormat:@"%@万人民币",rsult1];
            
        }
        else{
            self.moneyLab2.text=@"-";
        }
    }
    else{//美元
        if (![DDUtils isEmptyString:model.info.registerCapital]) {
    
            //NSString *moneyStr=[self removeFloatAllZero:[NSString stringWithFormat:@"%.4f",model.info.registerCapital.doubleValue/10000]];
            self.moneyLab2.text=[NSString stringWithFormat:@"%@万美元",rsult1];
            
        }
        else{
            self.moneyLab2.text=@"-";
        }
    }

    
    if (![DDUtils isEmptyString:model.info.registerCapital]) {
        self.timeLab2.text=[DDUtils getDateLineByStandardTime:model.info.establishedDate];
    }
    else{
        self.timeLab2.text=@"-";
    }
    if (![DDUtils isEmptyString:model.info.comprehensiveScore]) {
        self.countContent.text=model.info.comprehensiveScore;
    }
    else{
        self.countContent.text=@"-";
    }
    if ([DDUtils isEmptyString:model.info.contactNumber]) {
        [self.telBtn setTitle:@"暂无电话" forState:UIControlStateNormal];
        [self.telBtn setTitleColor:KColorBidApprovalingWait forState:UIControlStateNormal];
    }
    else{
        [self.telBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
        if ([model.info.contactNumber containsString:@";"]) {
            NSArray *telArray=[model.info.contactNumber componentsSeparatedByString:@";"];
            [self.telBtn setTitle:telArray[0] forState:UIControlStateNormal];
        }
        else{
            [self.telBtn setTitle:model.info.contactNumber forState:UIControlStateNormal];
        }
    }
    _line1.centerY = _line2.centerY = _line3.centerY = _peopleV.centerY;
}

#pragma mark 去除小数点后多余的0
-(NSString *)removeFloatAllZero:(NSString *)string{
    NSString * testNumber = string;
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
    //价格格式化显示
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    NSString * formatterString = [formatter stringFromNumber:[NSNumber numberWithFloat:[outNumber doubleValue]]];
    //获取要截取的字符串位置
    NSRange range = [formatterString rangeOfString:@"."];
    if (range.length >0 ) {
        NSString * result = [formatterString substringFromIndex:range.location];
        if (result.length >= 4) {
            formatterString = [formatterString substringToIndex:formatterString.length - 1];
        }
    }
    
    return formatterString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
