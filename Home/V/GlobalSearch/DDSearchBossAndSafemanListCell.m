//
//  DDSearchBossAndSafemanListCell.m
//  GongChengDD
//
//  Created by xzx on 2018/5/31.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSearchBossAndSafemanListCell.h"

@implementation DDSearchBossAndSafemanListCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.nameLab.textColor=KColorCompanyTitleBalck;
    self.nameLab.font=kFontSize34;
    
    self.tipLab.text=@"电话已公开";
    self.tipLab.textColor=KColorFindingPeopleBlue;
    self.tipLab.font=kFontSize26;
    self.tipLab.textAlignment=NSTextAlignmentCenter;
    self.tipLab.layer.cornerRadius=3;
    self.tipLab.layer.borderWidth=0.5;
    self.tipLab.layer.borderColor=KColorFindingPeopleBlue.CGColor;
    self.copanyLabels.font =kFontSize26;
    self.copanyLabels.textColor = KColorBlackSubTitle;
    
}

-(void)loadDataWithModel:(DDSearchBuilderAndManagerListModel *)model{
    self.nameLab.text=model.name;
    
    // 1公开，2不公开
    if ([model.isopen isEqualToString:@"1"]) {//公开
        self.tipLab.hidden=NO;
    }
    else{//不公开
        self.tipLab.hidden=YES;
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
    }
    
    
    return Y+20;
    
}

-(void)loadDataWithModel2:(DDMyCollectModel *)model{
    self.nameLab.text=model.name;
    if (11 == self.isappear) {
        
        self.copanyLabels.hidden = NO;
        self.copanyLabels.text = model.enterpriseName;

    }else{
        self.copanyLabels.hidden = YES;
    }
    // 1公开，2不公开
    if ([model.isopen isEqualToString:@"1"]) {//公开
        self.tipLab.hidden=NO;
    }
    else{//不公开
        self.tipLab.hidden=YES;
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
    for (DDMyCollectionRolesModel *rolesListModel in model.roles) {
        
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

+(CGFloat)heightWithModel2:(DDMyCollectModel *)model{
    CGFloat X=0;//初始化X值
    CGFloat Y=0;//初始化Y值
    
    //法人：1,项目经理：2,建造师：3,三类人员：4
    for (DDMyCollectionRolesModel *rolesListModel in model.roles) {
        
        CGRect frame_W = [rolesListModel.role boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
        
        CGFloat tempX=X+frame_W.size.width+16+10;
        
        if (tempX>Screen_Width-24) {
            X=0;
            Y=Y+20+10;
        }
        
        X=X+frame_W.size.width+16+10;
    }
    
    return Y+20;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
