//
//  NSString+MD5.m
//  LeShare
//
//  Created by 吴雪琴 on 2017/3/16.
//  Copyright © 2017年 wxq. All rights reserved.
//

#import "NSString+MD5.h"
#import  "CommonCrypto/CommonDigest.h"

@implementation NSString (Md5)
-(NSString *)md5Encrypt
{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (int)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
    
}
@end
