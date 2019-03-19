//
//  DDNineGridCell.m
//  Certificate
//
//  Created by csq on 2017/7/6.
//  Copyright © 2017年 Koncendy. All rights reserved.
//

#import "DDNineGridCell.h"
#import "DDDefines.h"

#define btnNumMax 4   //每行最大按钮数量
#define btnHeight 100 //按钮高

@interface DDNineGridCell()

{
    NSDictionary *_dic;
}

@end

@implementation DDNineGridCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _dic=@{@"ue612":@"\U0000e612",
               @"ue61b":@"\U0000e61b",
               @"ue61c":@"\U0000e61c",
               @"ue616":@"\U0000e616",
               @"ue618":@"\U0000e618",
               @"ue614":@"\U0000e614",
               @"ue611":@"\U0000e611",
               @"ue617":@"\U0000e617",
               @"ue60e":@"\U0000e60e",
               @"ue610":@"\U0000e610",
               @"ue613":@"\U0000e613",
               @"ue615":@"\U0000e615",
               @"ue619":@"\U0000e619",
               @"ue61a":@"\U0000e61a",
               @"ue60f":@"\U0000e60f",
               @"ue621":@"\U0000e621",
               @"ue62a":@"\U0000e62a",
               @"ue625":@"\U0000e625",
               @"ue62c":@"\U0000e62c",
               @"ue624":@"\U0000e624",
               @"ue620":@"\U0000e620",
               @"ue62b":@"\U0000e62b",
               @"ue631":@"\U0000e631",
               @"ue62e":@"\U0000e62e",
               @"ue632":@"\U0000e632",
               @"ue62d":@"\U0000e62d",
               @"ue61e":@"\U0000e61e",
               @"ue629":@"\U0000e629",
               @"ue627":@"\U0000e627",
               @"ue623":@"\U0000e623",
               @"ue61d":@"\U0000e61d",
               @"ue628":@"\U0000e628",
               @"ue626":@"\U0000e626",
               @"ue630":@"\U0000e630",
               @"ue61f":@"\U0000e61f",
               @"ue622":@"\U0000e622",
               @"ue62f":@"\U0000e62f",
               @"ue633":@"\U0000e633",
               @"ue636":@"\U0000e636",
               @"ue639":@"\U0000e639",
               @"ue635":@"\U0000e635",
               @"ue634":@"\U0000e634",
               @"ue640":@"\U0000e640",
               @"ue63b":@"\U0000e63b",
               @"ue63e":@"\U0000e63e",
               @"ue63d":@"\U0000e63d",
               @"ue63c":@"\U0000e63c",
               @"ue637":@"\U0000e637",
               @"ue63a":@"\U0000e63a",
               @"ue638":@"\U0000e638",
               @"ue63f":@"\U0000e63f",
               };
    }
    return self;
}

- (void)loadCellWithImageArray:(NSArray*)imageArray andArray:(NSArray <DDSubModel *> *)array {
    
    for (UIView * subView in self.contentView.subviews) {
        if ( [subView isKindOfClass:[UIView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    //创建九宫格
    for (int i = 0; i<array.count; i++) {
        //列号
        int col = i%btnNumMax;
        //行号：
        int row = i/btnNumMax;
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor whiteColor];
        button.tag = i;
        button.frame = CGRectMake(col * Screen_Width / 4,  row * btnHeight, Screen_Width / 4, btnHeight);
        [button addTarget:self action:@selector(btnBeCliked:) forControlEvents:UIControlEventTouchUpInside];
        
//        UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width/3-21.5)/2, 25, 21.5, 21.5)];
//        //imgView.image=[UIImage imageNamed:imageArray[i]];
//
//        [button addSubview:imgView];
        
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake((Screen_Width/4-25)/2, 25-1.25, 25, 25)];
        [button addSubview:lab];
        
        DDSubModel *model=array[i];
        
        lab.font = [UIFont fontWithName:@"iconfont" size:25];
        if (imageArray.count==0) {//做了特别处理,企业证书这一块
            if (i==0) {
                lab.textColor=kColorBlue;
            }
            else if(i==array.count-1){
                lab.textColor=kColorBlue;
            }
            else{
                if ([model.totalNum isEqualToString:@"0"] || [DDUtils isEmptyString:model.totalNum]) {
                    lab.textColor=kColorGrey;
                }
                else{
                    lab.textColor=kColorBlue;
                }
            }
        }
        else if(imageArray.count==2){//人员证书这一块
            if ([model.totalNum isEqualToString:@"0"] || [DDUtils isEmptyString:model.totalNum]) {
                lab.textColor=kColorGrey;
            }
            else{
                lab.textColor=KColorChemical;
            }
        }
        else if(imageArray.count==3){//中标业绩这一块
            if ([model.totalNum isEqualToString:@"0"] || [DDUtils isEmptyString:model.totalNum]) {
                lab.textColor=kColorGrey;
            }
            else{
                lab.textColor=KColorWinBidIconFont;
            }
        }
        else if(imageArray.count==4){//风险信息这一块
            if ([model.totalNum isEqualToString:@"0"] || [DDUtils isEmptyString:model.totalNum]) {
                lab.textColor=kColorGrey;
            }
            else{
                lab.textColor=KColorRiskInfoIconFont;
            }
        }
        else if(imageArray.count==5){//奖惩荣誉这一块
            if ([model.totalNum isEqualToString:@"0"] || [DDUtils isEmptyString:model.totalNum]) {
                lab.textColor=kColorGrey;
            }
            else{
                lab.textColor=KColorBillBtnText;
            }
        }
        else if(imageArray.count==6){//信用情况这一块
            if ([model.totalNum isEqualToString:@"0"] || [DDUtils isEmptyString:model.totalNum]) {
                lab.textColor=kColorGrey;
            }
            else{
                lab.textColor=KColorBillBtnText;
            }
        }
        lab.text=_dic[model.icoClass];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lab.frame)+15, Screen_Width/4, 15)];
        label.text=model.name;
        //label.textColor=KColorBlackTitle;
        label.font=kFontSize26;
        label.textAlignment=NSTextAlignmentCenter;
        [button addSubview:label];
        
        UILabel *numLab=[[UILabel alloc]initWithFrame:CGRectMake(Screen_Width/4-7-50, 7, 50, 15)];
        if (imageArray.count==0) {//做了特别处理
            if (i==0 || i==2 || i==array.count-1) {
                numLab.hidden=YES;
                if (i==0) {
                    label.textColor=KColorBlackTitle;
                }
                else{
                    if ([DDUtils isEmptyString:model.totalNum] || [model.totalNum isEqualToString:@"0"]) {
                        label.textColor=KColorBlackSecondTitle;
                    }
                    else{
                        label.textColor=KColorBlackTitle;
                    }
                }
            }
            else{
                numLab.hidden=NO;
                if ([DDUtils isEmptyString:model.totalNum] || [model.totalNum isEqualToString:@"0"]) {
                    numLab.text=@"0";
                    numLab.textColor=KColorBlackSecondTitle;
                    label.textColor=KColorBlackSecondTitle;
                }
                else{
                    numLab.text=model.totalNum;
                    numLab.textColor=KColorBlackTitle;
                    label.textColor=KColorBlackTitle;
                }
            }
        }
        else{
            numLab.hidden=NO;
            if ([DDUtils isEmptyString:model.totalNum] || [model.totalNum isEqualToString:@"0"]) {
                numLab.text=@"0";
                numLab.textColor=KColorBlackSecondTitle;
                label.textColor=KColorBlackSecondTitle;
            }
            else{
                numLab.text=model.totalNum;
                numLab.textColor=KColorBlackTitle;
                label.textColor=KColorBlackTitle;
            }
        }
        //numLab.textColor=KColorBlackTitle;
        numLab.font=KFontSize22;
        numLab.textAlignment=NSTextAlignmentRight;
        [button addSubview:numLab];
        
        [self.contentView addSubview:button];
        
//        //添加九宫格竖线
//        if (col==0) {
//
//        }
//        else{
//            UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(col * Screen_Width / 3, row * btnHeight+20, 0.5, 60)];
//            line.backgroundColor=KColor10AlphaBlack;
//            [self.contentView addSubview:line];
//        }
    }
    
    //添加九宫格横线
    if (array.count>4) {
        for (int i=0; i<array.count/4; i++) {
            UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, (i+1)*99.5, Screen_Width, 0.5)];
            line.backgroundColor=KColor10AlphaBlack;
            [self.contentView addSubview:line];
        }
    }
    else{
        
    }
    
    //添加九宫格竖线
    NSInteger rows=0;
    if (array.count>0) {
        rows=array.count/4;
        if (array.count%4>0) {
            rows=rows+1;
        }
        
        for (NSInteger i=0; i<rows; i++) {
            UILabel *line1=[[UILabel alloc]initWithFrame:CGRectMake(Screen_Width / 4, i * btnHeight+20, 0.5, 60)];
            line1.backgroundColor=KColor10AlphaBlack;
            [self.contentView addSubview:line1];
            
            UILabel *line2=[[UILabel alloc]initWithFrame:CGRectMake(Screen_Width / 4 * 2, i * btnHeight+20, 0.5, 60)];
            line2.backgroundColor=KColor10AlphaBlack;
            [self.contentView addSubview:line2];
            
            UILabel *line3=[[UILabel alloc]initWithFrame:CGRectMake(Screen_Width / 4 * 3, i * btnHeight+20, 0.5, 60)];
            line3.backgroundColor=KColor10AlphaBlack;
            [self.contentView addSubview:line3];
        }
    }
}

+(CGFloat)heightWithArrayNum:(NSInteger)arrayNum{
    NSInteger shang = arrayNum/4;
    NSInteger yushu =  arrayNum%4;
    
    if (0 == yushu ) {
        return shang*btnHeight;
    }else{
        return (shang+1)*btnHeight;
    }
    
}

- (void)btnBeCliked:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(nineGridCell:index:)]) {
        [_delegate nineGridCell:self index:btn.tag];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
