//
//  DDSearchBuilderAndManagerListCell.m
//  GongChengDD
//
//  Created by xzx on 2018/5/31.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSearchBuilderAndManagerListCell.h"

@implementation DDSearchBuilderAndManagerListCell

- (void)awakeFromNib {
    
    [super awakeFromNib];

    self.nameLab.textColor=KColorCompanyTitleBalck;
    self.nameLab.font=kFontSize34;
    
    self.certiLab1.text=@"证书";
    self.certiLab1.textColor=KColorGreySubTitle;
    self.certiLab1.font=kFontSize28;
    
    self.certiLab2.text=@"6";
    self.certiLab2.textColor=KColorBlackTitle;
    self.certiLab2.font=kFontSize28;
    
    
    self.projectLab1.text=@"承接项目";
    self.projectLab1.textColor=KColorGreySubTitle;
    self.projectLab1.font=kFontSize28;
    
    self.projectLab2.text=@"18";
    self.projectLab2.textColor=KColorBlackTitle;
    self.projectLab2.font=kFontSize28;
    
    
    self.punishLab1.text=@"行政处罚";
    self.punishLab1.textColor=KColorGreySubTitle;
    self.punishLab1.font=kFontSize28;
    
    self.punishLab2.text=@"0";
    self.punishLab2.textColor=KColorBlackTitle;
    self.punishLab2.font=kFontSize28;
    
    
    self.gloryLab1.text=@"获得荣誉";
    self.gloryLab1.textColor=KColorGreySubTitle;
    self.gloryLab1.font=kFontSize28;
    
    self.gloryLab2.text=@"6";
    self.gloryLab2.textColor=KColorBlackTitle;
    self.gloryLab2.font=kFontSize28;
    
//    UILabel *line1=[[UILabel alloc]initWithFrame:CGRectMake(Screen_Width/4, CGRectGetMinY(self.btnsView.frame)+27.5, 1, 20)];
//    line1.backgroundColor=KColorTableSeparator;
//    [self addSubview:line1];
//
//    UILabel *line2=[[UILabel alloc]initWithFrame:CGRectMake(Screen_Width/4*2, CGRectGetMinY(self.btnsView.frame)+27.5, 1, 20)];
//    line2.backgroundColor=KColorTableSeparator;
//    [self addSubview:line2];
//
//    UILabel *line3=[[UILabel alloc]initWithFrame:CGRectMake(Screen_Width/4*3, CGRectGetMinY(self.btnsView.frame)+27.5, 1, 20)];
//    line3.backgroundColor=KColorTableSeparator;
//    [self addSubview:line3];
    
    self.line1.backgroundColor=KColorTableSeparator;
    self.line2.backgroundColor=KColorTableSeparator;
    self.line3.backgroundColor=KColorTableSeparator;
}

-(void)loadDataWithModel:(DDSearchBuilderAndManagerListModel *)model;{
//    if (![DDUtils isEmptyString:model.name]) {
//        NSString *titleStr=[NSString stringWithFormat:@"<font color='#111111'>%@</font>",model.name];
//        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//
//        self.nameLab.attributedText = attributeStr;
//        self.nameLab.font=kFontSize34;
//    }
    self.nameLab.text=model.name;
    
    if (![DDUtils isEmptyString:model.allcert]) {
        self.certiLab2.text=model.allcert;
    }
    else{
        self.certiLab2.text=@"0";
    }
    
    if (![DDUtils isEmptyString:model.project]) {
        self.projectLab2.text=model.project;
    }
    else{
        self.projectLab2.text=@"0";
    }
    
    if (![DDUtils isEmptyString:model.punish]) {
        self.punishLab2.text=model.punish;
    }
    else{
        self.punishLab2.text=@"0";
    }
    
    if (![DDUtils isEmptyString:model.reward]) {
        self.gloryLab2.text=model.reward;
    }
    else{
        self.gloryLab2.text=@"0";
    }
    
    
    CGFloat X=0;//初始化X值
    CGFloat Y=0;//初始化Y值
    
    [self.btnsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //法人：1,项目经理：2,建造师：3,三类人员：4
    /*
    1 法人',
    2 项目经理',
    3 建造师等级 (0,1,2,3)',
    4 安全员等级',
    5 建筑师等级',
    6 结构师等级',
    7 土木工程师',
    8 公用设备师',
    9 电气工程师',
    10 化工工程师',
    11 监理工程师',
    12 造价工程师',
    13 消防工程师',
     */
    for (DDRolesListModel *rolesListModel in model.roles) {
        
        CGRect frame_W = [rolesListModel.role boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
        
        CGFloat tempX=X+frame_W.size.width+16+10;
        
        if (tempX>Screen_Width-24) {
            X=0;
            Y=Y+20+10;
        }
        
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(X, Y, frame_W.size.width+16, 20)];
        label.text=rolesListModel.role;
        label.font=kFontSize24;
        label.textAlignment=NSTextAlignmentCenter;
        label.layer.cornerRadius=3;
        label.clipsToBounds=YES;
        label.layer.borderWidth=0.5;
        
        if ([rolesListModel.code isEqualToString:@"1"]) {//法人
            label.textColor=kColorBlue;
            label.layer.borderColor=kColorBlue.CGColor;
            label.backgroundColor=KColorBgBlue;
        }
        else if([rolesListModel.code isEqualToString:@"2"]){//项目经理
            label.textColor=KColorTextOrange;
            label.layer.borderColor=KColorTextOrange.CGColor;
            label.backgroundColor=KColorBGOrange;
        }
        else if([rolesListModel.code isEqualToString:@"3"]){//建造师
            label.textColor=KColorTextGreen;
            label.layer.borderColor=KColorTextGreen.CGColor;
            label.backgroundColor=KColorBGGreen;
        }
        else if([rolesListModel.code isEqualToString:@"4"]){//三类人员
            label.textColor=KColorBlackSecondTitle;
            label.layer.borderColor=KColorBlackSecondTitle.CGColor;
            label.backgroundColor=KColorLinkBackViewColor;
        }
        else if([rolesListModel.code isEqualToString:@"5"]){//建筑师
            label.textColor=KColorArchitect;
            label.layer.borderColor=KColorArchitect.CGColor;
            label.backgroundColor=KColorArchitectBg;
        }
        else if([rolesListModel.code isEqualToString:@"6"]){//结构师
            label.textColor=KColorConstruct;
            label.layer.borderColor=KColorConstruct.CGColor;
            label.backgroundColor=KColorConstructBg;
        }
        else if([rolesListModel.code isEqualToString:@"7"]){//土木工程师
            label.textColor=KColorCivil;
            label.layer.borderColor=KColorCivil.CGColor;
            label.backgroundColor=KColorCivilBg;
        }
        else if([rolesListModel.code isEqualToString:@"8"]){//共用设备师
            label.textColor=KColorDevice;
            label.layer.borderColor=KColorDevice.CGColor;
            label.backgroundColor=KColorDeviceBg;
        }
        else if([rolesListModel.code isEqualToString:@"9"]){//电气工程师
            label.textColor=KColorElectric;
            label.layer.borderColor=KColorElectric.CGColor;
            label.backgroundColor=KColorElectricBg;
        }
        else if([rolesListModel.code isEqualToString:@"10"]){//化工工程师
            label.textColor=KColorChemical;
            label.layer.borderColor=KColorChemical.CGColor;
            label.backgroundColor=KColorChemicalBg;
        }
        else if([rolesListModel.code isEqualToString:@"11"]){//监理工程师
            label.textColor=KColorSupervisor;
            label.layer.borderColor=KColorSupervisor.CGColor;
            label.backgroundColor=KColorSupervisorBg;
        }else if([rolesListModel.code isEqualToString:@"12"]){//造价工程师
            label.textColor=KColorCost;
            label.layer.borderColor=KColorCost.CGColor;
            label.backgroundColor=KColorCostBg;
        }
        else if([rolesListModel.code isEqualToString:@"13"]){//消防工程师
            label.textColor=KColorFire;
            label.layer.borderColor=KColorFire.CGColor;
            label.backgroundColor=KColorFireBg;
        }
        
//        X=X+frame_W.size.width+16+10;
//
//        if (X>Screen_Width-24) {
//            X=0;
//            Y=Y+20+10;
//        }
        
        [self.btnsView addSubview:label];
        
        X=X+frame_W.size.width+16+10;
    }
    
    self.tipsHeight.constant=Y+20;
}

+(CGFloat)heightWithModel:(DDSearchBuilderAndManagerListModel *)model{
    CGFloat X=0;//初始化X值
    CGFloat Y=0;//初始化Y值
    
    //法人：1,项目经理：2,建造师：3,三类人员：4
    for (DDRolesListModel *rolesListModel in model.roles) {
        
        CGRect frame_W = [rolesListModel.role boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
        
        CGFloat tempX=X+frame_W.size.width+16+10;
        
        if (tempX>Screen_Width-24) {
            X=0;
            Y=Y+20+10;
        }

        X=X+frame_W.size.width+16+10;
        
        
//        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(X, Y, frame_W.size.width+16, 20)];
//        label.text=rolesListModel.role;
//        label.font=kFontSize24;
//        label.textAlignment=NSTextAlignmentCenter;
//        label.layer.cornerRadius=3;
//        label.clipsToBounds=YES;
//        label.layer.borderWidth=0.5;
//
//        if ([rolesListModel.code isEqualToString:@"1"]) {//法人
//            label.textColor=kColorBlue;
//            label.layer.borderColor=kColorBlue.CGColor;
//            label.backgroundColor=KColorBgBlue;
//        }
//        else if([rolesListModel.code isEqualToString:@"2"]){//项目经理
//            label.textColor=KColorTextOrange;
//            label.layer.borderColor=KColorTextOrange.CGColor;
//            label.backgroundColor=KColorBGOrange;
//        }
//        else if([rolesListModel.code isEqualToString:@"3"]){//建造师
//            label.textColor=KColorTextGreen;
//            label.layer.borderColor=KColorTextGreen.CGColor;
//            label.backgroundColor=KColorBGGreen;
//        }
//        else if([rolesListModel.code isEqualToString:@"4"]){//三类人员
//            label.textColor=KColorBlackSecondTitle;
//            label.layer.borderColor=KColorBlackSecondTitle.CGColor;
//            label.backgroundColor=KColorLinkBackViewColor;
//        }
        
//        X=X+frame_W.size.width+16+10;
//
//        if (X>Screen_Width-24) {
//            X=0;
//            Y=Y+20+10;
//        }
    }

    return Y+20;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
