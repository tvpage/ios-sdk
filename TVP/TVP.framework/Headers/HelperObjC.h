//
//  HelperObjC.h
//  TVPage Player
//
//  Created by Devubha Manek on 5/2/17.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HelperObjC : NSObject

+(UIButton*)findButtonOnView:(UIView*)view withText:(NSString*)text;
+(NSString*)getNewtworkType;
@end
