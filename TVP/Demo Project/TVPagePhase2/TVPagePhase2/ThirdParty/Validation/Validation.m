//
//  Validation.m
//  SQLiteDemo
//
//  Created by  on 2/3/16.
//  Copyright © . All rights reserved.
//

#import "Validation.h"

@interface Validation ()

@end

@implementation Validation

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark -
#pragma mark "String Empty Validation"
+(BOOL)isFieldEmpty:(NSString*)checkString
{
    NSString *commentStr = [checkString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (commentStr.length==0)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}
#pragma mark -
#pragma mark "String NULL Validation"
+(NSString*)checkStrNull:(id)myObject
{
    NSString* tmpStr = [[NSString stringWithFormat:@"%@",myObject] lowercaseString];
    if([tmpStr isEqualToString:@"null"] || [tmpStr isEqualToString:@"<null>"] || [tmpStr isEqualToString:@"(null)"] || [tmpStr isEqualToString:@"nil"] || [tmpStr isEqualToString:@"<nil>"]|| [tmpStr isEqualToString:@"(nil)"] ){
        tmpStr = @"";
    }
    return tmpStr;
}
#pragma mark -
#pragma mark "Valid Range Validation"
+(BOOL)isValidRange:(NSString*)str minValue:(NSInteger)minNo maxValue:(NSInteger)maxNo
{
    return (str.length>=minNo?(str.length<=maxNo?1:0):0);
}
#pragma mark -
#pragma mark "E-Mail Validation"
+(BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
#pragma mark -
#pragma mark "Number Only Validation"
+(BOOL)isNumeric:(NSString*)checkString
{
    NSCharacterSet *charcter =[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered;
    filtered = [[checkString componentsSeparatedByCharactersInSet:charcter] componentsJoinedByString:@""];
    return [checkString isEqualToString:filtered];
}
#pragma mark -
#pragma mark "Alphabet And Number Only Validation"
+(BOOL)isAlphaNumeric:(NSString *)checkString
{
    NSString *alphaNum = @"[a-zA-Z0-9]+";
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", alphaNum];
    return [regexTest evaluateWithObject:checkString];
}
#pragma mark -
#pragma mark "Alphabet Only Validation"
+(BOOL)isAlphabet:(NSString *)checkString
{
    NSString *alphaNum = @"[a-zA-Z]+";
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", alphaNum];
    return [regexTest evaluateWithObject:checkString];
}
#pragma mark -
#pragma mark "Phone Number Validation"
+(BOOL)isPhoneNumberValid:(NSString *)checkNumber
{
    NSString *phoneRegex = @"^(\\d{0,2}[\\s-]?)?[\\(\\[\\s-]{0,2}?\\d{3}[\\)\\]\\s-]{0,2}?\\d{3}[\\s-]?\\d{4}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:checkNumber];
}
#pragma mark -
#pragma mark "Dictionary Validation"
+(NSDictionary*)checkDictionaryNull:(id)myObject
{
    NSDictionary* tmpDictn = @{};
    if([myObject isKindOfClass:[NSDictionary class]])
    {
        tmpDictn = myObject;
    }
    return tmpDictn;
}
#pragma mark -
#pragma mark "Array Validation"
+(NSArray*)checkArrayNull:(id)myObject
{
    NSArray* tmpAry = @[];
    if([myObject isKindOfClass:[NSArray class]])
    {
        tmpAry = myObject;
    }
    return tmpAry;
}
#pragma mark -
#pragma mark "Password Validation"
+(BOOL)isPasswordValid:(NSString *)checkString
{
    // 1. Upper case.
    if (![[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[checkString characterAtIndex:0]])
        return NO;
    
    // 2. Special characters.
    // Change the specialCharacters string to whatever matches your requirements.
    NSString *specialCharacters = @"!#€%&/()[]=?$§*'";
    if ([[checkString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:specialCharacters]] count] < 2)
        return NO;
    
    // 3. Numbers.
    if ([[checkString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]] count] < 2)
        return NO;
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end


