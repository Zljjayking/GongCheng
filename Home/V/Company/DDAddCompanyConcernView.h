//
//  DDAddCompanyConcernView.h
//  GongChengDD
//
//  Created by csq on 2018/5/28.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

// didSelectRowAtIndexPath:(NSIndexPath *)indexPath

@protocol DDAddCompanyConcernViewDelegate<NSObject>
@optional
//选中了某一行
//- (void)addCompanyConcernViewdidSelectRow:(NSInteger)row;
//选中的关注结果
- (void)addCompanyConcernViewdidSelectRowArray:(NSArray*)rowArray;
@end

@interface DDAddCompanyConcernView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)  UIView *whiteBgView;
@property (strong, nonatomic)  UILabel *titleLab;
@property (strong, nonatomic)  UILabel *subTitleLab;
@property (strong, nonatomic)  UITableView *tableView;
@property (strong, nonatomic)  UIView *bottomline;
@property (strong, nonatomic)  UIView *bottonCenterLine;
@property (strong, nonatomic)  UIButton *cancelButton;
@property (strong, nonatomic)  UIButton *sureButtton;
@property (weak, nonatomic)id<DDAddCompanyConcernViewDelegate>delegate;
@property (strong,nonatomic)NSMutableArray * rowArr;


- (void)hide;
- (void)show;

@end
