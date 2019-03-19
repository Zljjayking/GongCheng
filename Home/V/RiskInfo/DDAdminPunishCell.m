//
//  DDAdminPunishCell.m
//  GongChengDD
//
//  Created by xzx on 2018/5/17.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDAdminPunishCell.h"

@implementation DDAdminPunishCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.serveContentLab.font=kFontSize34;
    self.serveContentLab.textColor=KColorBlackTitle;
    
    self.deptLab1.text=@"处罚机关:";
    self.deptLab1.textColor=KColorGreySubTitle;
    self.deptLab1.font=kFontSize28;
    
    self.deptLab2.text=@"安徽省建筑业管";
    self.deptLab2.textColor=KColorGreySubTitle;
    self.deptLab2.font=kFontSize28;
    
    self.timeLab1.text=@"发布时间:";
    self.timeLab1.textColor=KColorGreySubTitle;
    self.timeLab1.font=kFontSize28;
    
    self.timeLab2.text=@"2017-10-29";
    self.timeLab2.textColor=KColorGreySubTitle;
    self.timeLab2.font=kFontSize28;
}

//加载数据
-(void)loadDataWithContent:(NSString *)content andDept:(NSString *)dept andTime:(NSString *)time{
    if (![DDUtils isEmptyString:content]) {
        NSString *titleStr=[NSString stringWithFormat:@"<font color='#222222'>%@</font>",content];
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        
        self.serveContentLab.attributedText = attributeStr;
        self.serveContentLab.font=kFontSize34;
    }
    
//    if (![DDUtils isEmptyString:content]) {
//        [DDLabelUtil setLabelSpace:self.serveContentLab withValue:content withFont:kFontSize32];
//    }
//    else{
//        self.serveContentLab.text=@"";
//    }
    
    self.deptLab2.text=dept;
    self.timeLab2.text=time;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
