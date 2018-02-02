//
//  HelperObjC.h
//  TVPage Player
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HelperObjC : NSObject

+(UIButton*)findButtonOnView:(UIView*)view withText:(NSString*)text;
+(NSString*)getNewtworkType;
@end
