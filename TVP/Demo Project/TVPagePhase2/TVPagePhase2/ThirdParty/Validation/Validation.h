//
//  Validation.h
//  SQLiteDemo
//
//  Created by  on 2/3/16.
//  Copyright © . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Validation : UIViewController
+(BOOL)isFieldEmpty:(NSString*)checkString;
+(BOOL)isValidRange:(NSString*)str minValue:(NSInteger)minNo maxValue:(NSInteger)maxNo;
+(BOOL) isValidEmail:(NSString *)checkString;
+(BOOL)isNumeric:(NSString*)checkString;
+(BOOL)isPhoneNumberValid:(NSString *)checkString;
+(BOOL)isAlphaNumeric:(NSString *)checkString;
+(BOOL)isAlphabet:(NSString *)checkString;
+(NSDictionary*)checkDictionaryNull:(id)myObject;
+(NSArray*)checkArrayNull:(id)myObject;
+(NSString*)checkStrNull:(id)myObject;
+(BOOL)isPasswordValid:(NSString *)checkString;
@end

