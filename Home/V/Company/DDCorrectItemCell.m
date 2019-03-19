//
//  DDCorrectItemCell.m
//  GongChengDD
//
//  Created by csq on 2018/5/29.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDCorrectItemCell.h"

@implementation DDCorrectItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _pointButtonTagArray = [[NSMutableArray alloc] initWithCapacity:3];
}
- (void)loadWithTitles:(NSArray*)titles{

    CGFloat item_Width = (Screen_Width - (10*5))/4;//item宽度
    CGFloat item_height =  36;//item高度
    
    //行号和列号的计算和列数有关
    for (int i = 0; i<titles.count; i++) {
        //列号
        int col = i%4;//4列
        //行号：
        int row = i/4;//4列
        float itemX = 10 +col*(item_Width +10);
        float itemY = 10 +row*(item_height +10);
        
        UIButton *  button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(itemX, itemY, item_Width, item_height);
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.backgroundColor = KColorCompanyTransfetGray;
        button.titleLabel.font = kFontSize28;
        [button setTitleColor:KColorGreySubTitle forState:UIControlStateNormal];
        button.layer.cornerRadius = 3;
        button.clipsToBounds = YES;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i +101;//索引+101,传值时减100,这样如果用户点击了,那么传值肯定大于0
        [self.contentView addSubview:button];;
        
    }

}
+ (CGFloat)heightWithTitles:(NSArray*)titles{
    return 110;
}
+ (CGFloat)height{
    return 102;
}
- (void)buttonClick:(UIButton*)button{
    
    //按钮点击
    for (UIView * subView in self.contentView.subviews) {
        
        if (subView.tag == button.tag) {
            UIButton * tagButton = (UIButton*)subView;
            
            if (NO == tagButton.selected ) {
                //置为选中状态
                tagButton.backgroundColor = KColorCompanyTransfetBlue;
                [tagButton setTitleColor:kColorBlue forState:UIControlStateNormal];
                tagButton.selected = YES;
                _pointButtonTag = (tagButton.tag-100);//别忘记减100
                
                //如果数组中没有按钮tag,那么添加
                NSString * buttonTagString = [NSString stringWithFormat:@"%ld",(tagButton.tag-100)];
                
                if ([_pointButtonTagArray containsObject:buttonTagString]) {
                    //之前有了,不再添加
                }else{
                    [_pointButtonTagArray addObject:buttonTagString];
                }
                
            }else{
                //置为非选中状态
                tagButton.backgroundColor = KColorCompanyTransfetGray;
                [tagButton setTitleColor:KColorGreySubTitle forState:UIControlStateNormal];
                tagButton.selected = NO;
                _pointButtonTag = 0;
                //从数组中删除按钮tag
                NSString * buttonTagString = [NSString stringWithFormat:@"%ld",(tagButton.tag-100)];
                if ([_pointButtonTagArray containsObject:buttonTagString]) {
                    //之前有了,删除
                    [_pointButtonTagArray removeObject:buttonTagString];
                }
    
            }
           
        }
//        else{
//            //其它的全部置为未选中
//            UIButton * otherButton = (UIButton*)subView;
//            otherButton.backgroundColor = KColorCompanyTransfetGray;
//            [otherButton setTitleColor:KColorGreySubTitle forState:UIControlStateNormal];
//            otherButton.selected = NO;
//        }
        
    }
    
//    if ([_delegate respondsToSelector:@selector(selectInfoErrorItem:pointButtonTag:)]) {
//        [_delegate selectInfoErrorItem:self pointButtonTag:_pointButtonTag];
//    }
    if ([_delegate respondsToSelector:@selector(selectInfoErroeItem:pointButtonTagArray:)]) {
        [_delegate selectInfoErroeItem:self pointButtonTagArray:_pointButtonTagArray];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
