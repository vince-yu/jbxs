//
//  SDBaseViewController.h
//  sndonongshang
//

#import "ViewController.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import <IQKeyboardManager/IQKeyboardManager.h>

typedef enum : NSUInteger {
    SDBSVCNaveTypeWhite = 0,
    SDBSVCNaveTypeGreen,
    SDBSVCNaveTypeCustomWeb,
} SDBSVCNaveType;

NS_ASSUME_NONNULL_BEGIN

@interface SDBaseViewController : ViewController
-(BOOL)navigationShouldPopOnBackButton;
- (void)changeNavType:(SDBSVCNaveType )type;
@end

NS_ASSUME_NONNULL_END
