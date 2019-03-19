//
//  DDSearchAccidentSituationListCell.m
//  GongChengDD
//
//  Created by xzx on 2018/10/31.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSearchAccidentSituationListCell.h"

@implementation DDSearchAccidentSituationListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.serveContentLab.font=kFontSize34;
    self.serveContentLab.textColor=KColorBlackTitle;
    
    self.deptLab1.text=@"负责人:";
    self.deptLab1.textColor=KColorGreySubTitle;
    self.deptLab1.font=kFontSize28;
    
    //self.deptLab2.text=@"安徽省建筑业管";
    self.deptLab2.textColor=kColorBlue;
    self.deptLab2.font=kFontSize28;
    
    self.timeLab1.text=@"发布时间:";
    self.timeLab1.textColor=KColorGreySubTitle;
    self.timeLab1.font=kFontSize28;
    
    //self.timeLab2.text=@"2017-10-29";
    self.timeLab2.textColor=KColorGreySubTitle;
    self.timeLab2.font=kFontSize28;
}

-(void)loadDataWithModel:(DDSearchAccidentSituationListModel *)model{
    if (![DDUtils isEmptyString:model.accident_title]) {
        NSString *titleStr=[NSString stringWithFormat:@"<font color='#222222'>%@</font>",model.accident_title];
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
    
    self.deptLab2.text=model.staff_name;
    self.timeLab2.text=model.accident_issue_time;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
