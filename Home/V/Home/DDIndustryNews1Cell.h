//
//  DDIndustryNews1Cell.h
//  GongChengDD
//
//  Created by xzx on 2018/5/10.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDIndustryNews1Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *serveContentLab;
@property (weak, nonatomic) IBOutlet UILabel *attachLab1;
@property (weak, nonatomic) IBOutlet UILabel *attachLab2;
@property (weak, nonatomic) IBOutlet UILabel *attachLab3;

@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftDistance;

-(void)loadDataWithContent:(NSString *)content;
//+(CGFloat)heightWithContent:(NSString *)content;

@end
