//
//  DDJudgePaperCell.m
//  GongChengDD
//
//  Created by xzx on 2018/6/4.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDJudgePaperCell.h"
#import "DDLabelUtil.h"

@implementation DDJudgePaperCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //self.titleLab.text=@"廖永红  昆山红枫房地产有限公司  昆山东方云顶广场有限公司与中信信托有限责任公司其他合同纠纷二审民事判决书";
    self.titleLab.textColor=KColorBlackTitle;
    self.titleLab.font=kFontSize34;
    
    self.numLab1.text=@"判决案号:";
    self.numLab1.textColor=KColorGreySubTitle;
    self.numLab1.font=kFontSize28;
    
    self.numLab2.text=@"（2017）苏8602民初787号";
    self.numLab2.textColor=KColorGreySubTitle;
    self.numLab2.font=kFontSize28;
    
    self.dateLab1.text=@"执行法院:";
    self.dateLab1.textColor=KColorGreySubTitle;
    self.dateLab1.font=kFontSize28;
    
    self.dateLab2.text=@"2017-12-28";
    self.dateLab2.textColor=KColorGreySubTitle;
    self.dateLab2.font=kFontSize28;
    
    self.roleLab1.text=@"发布日期:";
    self.roleLab1.textColor=KColorGreySubTitle;
    self.roleLab1.font=kFontSize28;
    
    self.roleLab2.text=@"原告：厦门萌力星球网络有限公司";
    self.roleLab2.textColor=KColorGreySubTitle;
    self.roleLab2.font=kFontSize28;
}

-(void)loadDataWithModel:(DDSearchJudgePaperListModel *)model{
    if (![DDUtils isEmptyString:model.judgment_title]) {
        NSString *titleStr=[NSString stringWithFormat:@"<font color='#222222'>%@</font>",model.judgment_title];
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        
        self.titleLab.attributedText = attributeStr;
        self.titleLab.font=kFontSize34;
    }

    
//    NSString *str=[self textString:attributeStr];
//    CGRect frame = [str boundingRectWithSize:CGSizeMake(Screen_Width-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize32} context:nil];
//    self.titleLabHeight.constant=frame.size.height;
    
    
    //[DDLabelUtil setHTMLLabelSpace:self.titleLab withValue:model.judgment_title withFont:kFontSize32];
    self.numLab2.text=model.judgment_case_number;
    //self.dateLab2.text=model.judgment_identity;
    //self.dateLab2.text=model.court;
    self.roleLab2.text=model.judgment_publish_date;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
