//
//  DDPeopleListCell.m
//  GongChengDD
//
//  Created by xzx on 2018/5/21.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDPeopleListCell.h"

@implementation DDPeopleListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLab.textColor=KColorCompanyTitleBalck;
    self.nameLab.font=kFontSize34;
}

-(void)loadDataWithModel:(DDSearchPeopleListModel *)model{
    self.nameLab.text=model.name;
    
    CGFloat X=0;//初始化X值
    [self.btnsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //法人：1,项目经理：2,建造师：3,三类人员：4
    for (DDRoleListModel *roleListModel in model.roles) {
        
        CGRect frame_W = [roleListModel.role boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(X, 0, frame_W.size.width+16, 20)];
        label.text=roleListModel.role;
        label.font=kFontSize24;
        label.textAlignment=NSTextAlignmentCenter;
        label.layer.cornerRadius=3;
        label.clipsToBounds=YES;
        label.layer.borderWidth=0.5;
        
        if ([roleListModel.code isEqualToString:@"1"]) {//法人
            label.textColor=kColorBlue;
            label.layer.borderColor=kColorBlue.CGColor;
            label.backgroundColor=KColorBgBlue;
        }
        else if([roleListModel.code isEqualToString:@"2"]){//项目经理
            label.textColor=KColorTextOrange;
            label.layer.borderColor=KColorTextOrange.CGColor;
            label.backgroundColor=KColorBGOrange;
        }
        else if([roleListModel.code isEqualToString:@"3"]){//建造师
            label.textColor=KColorTextGreen;
            label.layer.borderColor=KColorTextGreen.CGColor;
            label.backgroundColor=KColorBGGreen;
        }
        else if([roleListModel.code isEqualToString:@"4"]){//三类人员
            label.textColor=KColorBlackSecondTitle;
            label.layer.borderColor=KColorBlackSecondTitle.CGColor;
            label.backgroundColor=KColorLinkBackViewColor;
        }
        
        
        //X=X+frame_W.size.width+16+10;
        
        X=X+label.size.width+10;
        
        [self.btnsView addSubview:label];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
