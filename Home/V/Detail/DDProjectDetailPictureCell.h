//
//  DDProjectDetailPictureCell.h
//  GongChengDD
//
//  Created by xzx on 2018/5/23.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDProjectDetailPictureCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *headLab;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImg;
@property (weak, nonatomic) IBOutlet UILabel *descLab;

-(void)loadDataWithContent:(NSString *)content andPic:(NSString *)picture;

@end
