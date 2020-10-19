//
//  SDSegmentedControl.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/17.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDSegmentedControl.h"

@implementation SDSegmentedControl

static NSString *const SDHMSegmentedControlIndicatorLayer = @"_selectionIndicatorStripLayer";

- (id)initWithSectionTitles:(NSArray<NSString *> *)sectiontitles {
    if (self = [super initWithSectionTitles:sectiontitles]) {
        [self setupStyle];
    }
    return self;
}

- (void)setupStyle {
    self.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRGB:0x131413], NSFontAttributeName : [UIFont fontWithName:kSDPFRegularFont size: 16]};
    self.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:kSDGreenTextColor], NSFontAttributeName : [UIFont fontWithName:kSDPFMediumFont size: 16]};
    self.selectionIndicatorColor = [UIColor colorWithHexString:kSDGreenTextColor];
    self.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.selectionIndicatorHeight = 2.0f;
//    self.selectionIndicatorWidth = 25.0f;
    self.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.frame = CGRectMake(20, kTopHeight, SCREEN_WIDTH - 20 * 2, SegmentedControlH);
//    self.segmentEdgeInset = UIEdgeInsetsMake(0, 20, 0, 10);
    [self addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    CALayer *indicatorLayer = [self valueForKeyPath:SDHMSegmentedControlIndicatorLayer];
    indicatorLayer.cornerRadius = self.selectionIndicatorHeight * 0.5;
}

//- (void)setSelectionIndicatorWidth:(CGFloat)selectionIndicatorWidth {
//    _selectionIndicatorWidth = selectionIndicatorWidth;
//    if (self.sectionTitles.count > 0) {
//        [self updateSelectionIndicatorEdgeInsetsWithIndex:0];
//    }
//}

//- (CGSize)titleSizeAtIndex:(NSUInteger)index {
//    if (index >= self.sectionTitles.count) {
//        return CGSizeZero;
//    }
//    id title = self.sectionTitles[index];
//    CGSize size = CGSizeZero;
//    BOOL selected = (index == self.selectedSegmentIndex) ? YES : NO;
//    if ([title isKindOfClass:[NSString class]] && !self.titleFormatter) {
//        NSDictionary *titleAttrs = selected ? self.selectedTitleTextAttributes : [self titleTextAttributes];
//        size = [(NSString *)title sizeWithAttributes:titleAttrs];
//        UIFont *font = titleAttrs[@"NSFont"];
//        size = CGSizeMake(ceil(size.width), ceil(size.height-font.descender));
//    } else if ([title isKindOfClass:[NSString class]] && self.titleFormatter) {
//        size = [self.titleFormatter(self, title, index, selected) size];
//    } else if ([title isKindOfClass:[NSAttributedString class]]) {
//        size = [(NSAttributedString *)title size];
//    } else {
//        NSAssert(title == nil, @"Unexpected type of segment title: %@", [title class]);
//        size = CGSizeZero;
//    }
//    return CGRectIntegral((CGRect){CGPointZero, size}).size;
//}
//
//- (void)updateSelectionIndicatorEdgeInsetsWithIndex:(NSInteger)index {
//    CGFloat stringWidth = [self titleSizeAtIndex:index].width;
//    CGFloat offset = stringWidth - self.selectionIndicatorWidth;
//    if (offset < 0) {
//        offset = self.selectionIndicatorWidth;
//    }
//    self.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, offset * 0.5, 0, offset);
//}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    if (self.block) {
        self.block(segmentedControl.selectedSegmentIndex);
    }
}


@end
