//
//  SDPayMethodCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/11.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDPayMethodCell.h"

@interface SDPayMethodCell ()
@property (weak, nonatomic) IBOutlet UIImageView *payImageView;
@property (weak, nonatomic) IBOutlet UILabel *payMethodLabel;
@property (weak, nonatomic) IBOutlet UIImageView *payMethodSelected;

@end

@implementation SDPayMethodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
    // Configure the view for the selected state
}
- (void)setTitile:(NSString *)title icon:(NSString *)icon{
    self.payMethodLabel.text = title;
    self.payImageView.image = [UIImage imageNamed:icon];
}
- (void)selectMethod:(BOOL )selected{
    self.payMethodSelected.hidden = !selected;
}
@end
