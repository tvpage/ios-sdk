//
//  HelperObjC.m
//  TVPage Player
//


#import "HelperObjC.h"

@implementation HelperObjC

#pragma mark - Find button in UIView
+(UIButton*)findButtonOnView:(UIView*)view withText:(NSString*)text {

    __block UIButton *retButton = nil;
    
    [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)obj;
            if([button.titleLabel.text isEqualToString:text]) {
                retButton = button;
                *stop = YES;
            }
        }
        else if([obj isKindOfClass:[UIView class]]) {
            retButton = [self findButtonOnView:obj withText:text];
            
            if(retButton) {
                *stop = YES;
            }
        }
    }];
    
    return retButton;
}
#pragma mark - Get Network Type
+(NSString*)getNewtworkType {
    
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"] valueForKey:@"foregroundView"]subviews];
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    
    NSString *strNetworkType = @"";
    switch ([[dataNetworkItemView valueForKey:@"dataNetworkType"]integerValue]) {
        case 0:
            NSLog(@"No wifi or cellular");
            strNetworkType = @"NoWifiOrCellular";
            break;
            
        case 1:
            NSLog(@"2G");
            strNetworkType = @"2G";
            break;
            
        case 2:
            NSLog(@"3G");
            strNetworkType = @"3G";
            break;
            
        case 3:
            NSLog(@"4G");
            strNetworkType = @"4G";
            break;
            
        case 4:
            NSLog(@"LTE");
            strNetworkType = @"LTE";
            break;
            
        case 5:
            NSLog(@"Wifi");
            strNetworkType = @"Wifi";
            break;
            
        default:
            break;
    }
    return strNetworkType;
}
@end
