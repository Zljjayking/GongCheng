//
//  DDValidityView.m
//  GongChengDD
//
//  Created by Koncendy on 2017/10/23.
//  Copyright © 2017年 Koncendy. All rights reserved.
//

#import "DDValidityView.h"
#import "UIButton+ImageFrame.h"

@implementation DDValidityView

-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kColorBackGroundColor;
        [self initWithView];
    }
    return self;
}

-(void)initWithView{
    self.bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,15, Screen_Width,45)];
    self.bgImageView.userInteractionEnabled = YES;
    self.bgImageView.backgroundColor = kColorWhite;
    [self addSubview:self.bgImageView];
    
    
    self.dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dateBtn.frame = CGRectMake(0, 0, Screen_Width,45);
    //[self.dateBtn setTitle:@"30日内到期(07.20-08.20)" forState:UIControlStateNormal];
    [self.dateBtn setImage:[UIImage imageNamed:@"cm_down_blue"] forState:UIControlStateNormal];
    [self.dateBtn setTitleColor:KColorBlackTitle forState:UIControlStateNormal];
    [self.dateBtn setBackgroundColor:kColorWhite];
    [self.dateBtn.titleLabel setFont:kFontSize30];
    [self.dateBtn addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    [self.bgImageView addSubview:self.dateBtn];
    
    [self.dateBtn layoutButtonWithEdgeInsetsStyle:YFButtonInsetsStyleRight imageTitleSpace:45];
}

-(NSString *)loadViewWithTimeType:(NSString*)timeType{
    NSString *daysNum;//返回的天数
    
    NSInteger date;
    NSString *title;
    if ([timeType isEqualToString:@"1"])
    {
        title = @"全部";
        date = 999;
        daysNum=@"999";
    }
    else if ([timeType intValue] == 2)
    {
        title = @"已到期";
        date = 0;
        daysNum=@"0";
    }
    else if ([timeType intValue] == 3)
    {
        title = @"7日内到期";
        date = 7;
        daysNum=@"7";
    }
    else if ([timeType intValue] == 4)
    {
        title = @"15日内到期";
        date = 15;
        daysNum=@"15";
    }
    else if ([timeType intValue] == 5)
    {
        title = @"30日内到期";
        date = 30;
        daysNum=@"30";
    }
    else if ([timeType intValue] == 6)
    {
        title = @"45日内到期";
        date = 45;
        daysNum=@"45";
    }
    else if ([timeType intValue] == 7)
    {
        title = @"60日内到期";
        date = 60;
        daysNum=@"60";
    }
    else if ([timeType intValue] == 8)
    {
        title = @"75日内到期";
        date = 75;
        daysNum=@"75";
    }
    else if ([timeType intValue] == 9)
    {
        title = @"90日内到期";
        date = 90;
        daysNum=@"90";
    }
    else {
        title = @"90日以上";
        date = 91;
        daysNum=@"91";
    }
//    else{
//        date = ([timeType intValue]-2)*15;
//        title = [NSString stringWithFormat:@"%ld日内到期",date];
//        daysNum=[NSString stringWithFormat:@"%ld",date];
//    }
    
    
    NSString *btnTitle;
    NSString *timeStr;
    if(date==999){//只显示全部
        btnTitle = [NSString stringWithFormat:@"%@",title];
    }
    else if (date == 0) {//只显示已到期
        btnTitle = [NSString stringWithFormat:@"%@",title];
    }
    else if (date == 91) {//只显示90日以上
        btnTitle = [NSString stringWithFormat:@"%@",title];
    }
    else{//显示组合信息
        NSString *time = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]* 1000];
        timeStr = [self newDate:time WithDays:date];
        btnTitle = [NSString stringWithFormat:@"%@%@",title,timeStr];
    }
    if ([btnTitle isEqualToString:@"全部"]) {
        btnTitle = @"有效期";
    }
    [self.dateBtn setTitle:btnTitle forState:UIControlStateNormal];
    [self.dateBtn setTitleColor:KColorFindingPeopleBlue forState:UIControlStateNormal];
    [self.dateBtn setTitleColor:KColorFindingPeopleBlue forState:UIControlStateHighlighted];
    [self.dateBtn setImage:[UIImage imageNamed:@"cm_down_blue"] forState:UIControlStateNormal];
    [self.dateBtn.titleLabel setFont:kFontSize30];
    [self.dateBtn layoutButtonWithEdgeInsetsStyle:YFButtonInsetsStyleRight imageTitleSpace:5];
    
    return daysNum;
}

//日期
- (NSString *)newDate:(NSString*)time WithDays:(NSInteger)days{
    //将时间戳转换成时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss.SSS"];
    NSDate*confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[time doubleValue]/1000.0];
    NSDate *newDate = [confromTimesp dateByAddingTimeInterval:60 * 60 * 24 * days];
    NSString *timeString = [formatter stringFromDate:confromTimesp];
    NSString *newTime = [formatter stringFromDate:newDate];
    //2017-07-25 11:39:07.891 timeString
    NSString *firstStr1 = [timeString substringWithRange:NSMakeRange(5, 2)];
    NSString *firstStr2 = [timeString substringWithRange:NSMakeRange(8, 2)];
    NSString *firstStr = [NSString stringWithFormat:@"%@.%@",firstStr1,firstStr2];
    
    NSString *secondStr1 = [newTime substringWithRange:NSMakeRange(5, 2)];
    NSString *secondStr2 = [newTime substringWithRange:NSMakeRange(8, 2)];
    NSString *secondStr = [NSString stringWithFormat:@"%@.%@",secondStr1,secondStr2];
    
    NSString *resultTime = [NSString stringWithFormat:@"(%@-%@)",firstStr,secondStr];
    
    return resultTime;
}

-(void)clickButton{
    if ([self.delegate respondsToSelector:@selector(validityViewButtonAction)]) {
        [self.delegate validityViewButtonAction];
    }
}

@end
