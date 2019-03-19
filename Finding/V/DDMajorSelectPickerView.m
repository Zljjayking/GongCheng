//
//  DDMajorSelectPickerView.m
//  GongChengDD
//
//  Created by csq on 2018/11/6.
//  Copyright © 2018 Koncendy. All rights reserved.
//

#import "DDMajorSelectPickerView.h"

@implementation DDMajorSelectPickerView

-(id)init
{
    self = [super init];
    if(self)
    {
        self.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
        self.backgroundColor = KColor30AlphaBlack;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSelf)];
        [self addGestureRecognizer:tap];
        
        _titleArr = [NSMutableArray arrayWithCapacity:10];
    
        
    }
    return self;
}

- (void)loadWithTitle:(NSString*)title dataArray:(NSArray*)dataArray{
    [_titleArr addObjectsFromArray:dataArray];
    
    //背景view
    UIView * bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.frame = CGRectMake(0, Screen_Height-260, Screen_Width, 260);
    [self addSubview:bgView];
    
    //顶部view
    UIView * headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0,Screen_Width, 46);
    headerView.backgroundColor = kColorBackGroundColor;
    [bgView addSubview:headerView];
    
    //取消
    UILabel * canceLab = [[UILabel alloc]init];
    canceLab.frame = CGRectMake(10, 0, 50, 46);
    canceLab.font = kFontSize30;
    canceLab.text = KMainCancel;
    canceLab.textColor = KColorBlackTitle;
    canceLab.userInteractionEnabled = YES;
    UITapGestureRecognizer * cancelTapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelTapGesAction)];
    [canceLab addGestureRecognizer:cancelTapGes];
    [headerView addSubview:canceLab];
    
    //确定
    UILabel * sureLab = [[UILabel alloc]init];
    sureLab.frame = CGRectMake(WIDTH(bgView)-60, 0, 50, 46);
    sureLab.font = kFontSize30;
    sureLab.text = KMainOk;
    sureLab.textColor = kColorBlue;
    sureLab.textAlignment = NSTextAlignmentRight;
    sureLab.userInteractionEnabled = YES;
    UITapGestureRecognizer * sureTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sureTapGesAction)];
    [sureLab addGestureRecognizer:sureTapGes];
    [headerView addSubview:sureLab];
    
    //中间标题
    UILabel * titleLab = [[UILabel alloc] init];
    titleLab.frame = CGRectMake(RIGHT(canceLab), 12, (Screen_Width-100-20), 20);
    titleLab.text = title;
    titleLab.font = kFontSize30;
    titleLab.textColor = KColorGreySubTitle;
    titleLab.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:titleLab];
    
    
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.frame = CGRectMake(0, 46, Screen_Width, HEIGHT(bgView)-46);
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [pickerView selectRow:_firstComponentSelectRow inComponent:0 animated:YES];
    [bgView addSubview:pickerView];
}
#pragma mark UIPickerViewDelegate   UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _titleArr.count;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{
    
     //设置分割线的颜色
    for (UIView * singleLine in pickerView.subviews) {
        if (singleLine.frame.size.height < 1) {
            singleLine.backgroundColor = KColorTableSeparator;
        }
    }

    UILabel * lab = [[UILabel alloc] init];
    lab.text = _titleArr[row];
    lab.textColor = KColorBlackTitle;
    lab.font = kFontSize34;
    lab.textAlignment = NSTextAlignmentCenter;
    return lab;
    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return Screen_Width;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 46;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
   _firstComponentSelectRow = row;
    
}
#pragma mark --
-(void)show{
    NSArray *windows = [UIApplication sharedApplication].windows;
    UIWindow *mainWin = windows[0];
    UIWindow *winodw = mainWin;
    for (NSInteger  i = windows.count-1; i >= 0; i--) {
        UIWindow *win = windows[i];
        if (CGRectEqualToRect(win.bounds, mainWin.bounds) && (win.windowLevel == UIWindowLevelNormal)) {
            winodw = win;
            break;
        }
    }
    [winodw addSubview:self];
}
- (void)hideSelf{
    [self hide];
}
- (void)hide{
    [self removeFromSuperview];
}
- (void)cancelTapGesAction{
    [self hide];
}
- (void)sureTapGesAction{
    [self hideSelf];
    
    if ([_delegate respondsToSelector:@selector(majorSelectPickerViewClickFinsh:row:)]) {
        [_delegate majorSelectPickerViewClickFinsh:self row:_firstComponentSelectRow];
    }
}
@end
