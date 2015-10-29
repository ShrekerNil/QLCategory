//
//  NSString+QLString.m
//  SinaNMB
//
//  Created by Shrek on 12/23/13.
//  Copyright (c) 2013 Shrek. All rights reserved.
//

#import "NSString+QLString.h"
#import "RegexKitLite.h"

@implementation NSString (QLString)

#pragma mark - QLString
/**
 *  @brief 给文件名后面,扩展名前追加一个字符串
 *
 *  @param strNeedToJoint 要追加的字符串
 *
 *  @return 返回追加之后的新字符串
 */
- (NSString *)stringByJointString:(NSString *)strNeedToJoint {
    NSString *strTemp = [self stringByDeletingPathExtension];
    strTemp = [strTemp stringByAppendingString:strNeedToJoint];
    strTemp = [strTemp stringByAppendingPathExtension:[self pathExtension]];
    return strTemp;
}

/**
 *  把字典的键值对用&符号连接起来
 *
 *  @param dicData 参数字典
 *
 *  @return 返回一个把字典的键值对用&符号连接起来的字符串
 */
+ (NSString *)stringByJointParameterWithDictionary:(NSDictionary *)dicData {
    NSMutableString *strMRes = [NSMutableString string];
    __block NSUInteger index = 0;
    [dicData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [strMRes appendString:[NSString stringWithFormat:@"%@%@=%@", (index ++ == 0)?@"":@"&", key, obj]];
    }];    
    return (NSString *)strMRes;
}

/**
 *  拼接完整GET请求链接
 *
 *  @param strUrl  链接完整地址
 *  @param dicData 参数字典
 *
 *  @return 返回完整GET请求链接
 */
+ (NSString *)stringByJointParameterWithUrl:(NSString *)strUrl Dictionary:(NSDictionary *)dicData {
    NSMutableString *strMRes = [NSMutableString stringWithFormat:@"%@", strUrl];
    
    __block NSUInteger index = 0;
    [dicData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [strMRes appendString:[NSString stringWithFormat:@"?%@%@=%@", (index ++ == 0)?@"":@"&", key, obj]];
    }];
    return (NSString *)strMRes;
    //return nil;
}

/**
 *  @brief 把一个NSData对象转换成NSString对象
 *
 *  @param data     需要转换成字符串的NSData对象
 *  @param encoding 字符编码的格式
 *
 *  @return 根据NSData对象返回一个对应的NSString对象
 */
+ (NSString *)stringWithData:(NSData *)data encoding:(NSStringEncoding)encoding {
    return [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:encoding];
}

/**
 *  @brief  根据unixTime字符串对象生成标准的时间格式
 *
 *  @param strFormat 返回时间的格式,如:"2014-02-05",默认为"2014年02月05日"
 *
 *  @return 返回标准的时间格式
 */
- (NSString *)unixtimeToDateStringWithFormat:(NSString *)strFormat {
    NSTimeInterval interval = [self doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setLocale:[NSLocale currentLocale]];
    if (strFormat) {
        [formatter setDateFormat:strFormat];
    } else {
        [formatter setDateFormat:@"yyyy年M月d日"];
    }
    
    return [formatter stringFromDate:date];
}

/**
 *  @brief 判断是否是中文字符
 *
 *  @return 返回字符串对象是否是中文字符
 */
- (BOOL)isChineseString {
    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

/**
 *  @brief  获得一个非nil/NSNull的值
 *
 *  @param obj 元数据
 *
 *  @return 返回元数据对应的字符串,当元数据为nil/NSNull的时候返回@""
 */
+ (NSString *)getValidStringWithObject:(id)obj {
    /**
     *  nil->(null)
     *  NSNull-><null>
     */
    if ([obj isKindOfClass:[NSString class]]) {
        NSString *strValue = obj;
        if (strValue && ![strValue isEqualToString:@"<null>"] && ![strValue isEqualToString:@"(null)"] && ![strValue isEqualToString:@""]) {
            return strValue;
        } else {
            return @"";
        }
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@", obj];
    } else {
        return @"";
    }
}

/**
 *  @brief  判断字符串对象是否为一个nil/NSNull/@""
 *
 *  @return 返回字符处啊对象是否是一个nil/NSNull/@""
 */
- (BOOL)isNilOrNSNullOrEmptyString {
    BOOL isNullString = YES;
    if (self && ![self isKindOfClass:[NSNull class]] && ![self isEqualToString:@"<null>"] && ![self isEqualToString:@"(null)"] && ![self isEqualToString:@""] && ![self isEqualToString:@"<nil>"]) {
        isNullString = NO;
    }
    return isNullString;
}

#pragma mark - Emoji
/**
 *  @brief 根据字符串对象判断是否是Emoji表情
 *
 *  @return 返回一个BOOL,表示该字符串对象是否是一个
 */
- (BOOL)isEmoji {
    BOOL isEmoji = NO;
    const unichar hs = [self characterAtIndex:0];
    // surrogate pair
    if (0xd800 <= hs && hs <= 0xdbff) {
        if (self.length > 1) {
            const unichar ls = [self characterAtIndex:1];
            const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
            if (0x1d000 <= uc && uc <= 0x1f77f) {
                isEmoji = YES;
            }
        }
    } else if (self.length > 1) {
        const unichar ls = [self characterAtIndex:1];
        if (ls == 0x20e3) {
            isEmoji = YES;
        } else if (ls == 0xfe0f) {
            if (hs == 0x203c || hs == 0x2049 || hs == 0x231a || hs == 0x231b || hs == 0x24c2 ||
                hs == 0x2934 || hs == 0x2935 || hs == 0x303d || hs == 0x3297 || hs == 0x3299) {
                isEmoji = YES;
            }else if (hs >= 0x2139 && hs <= 0x21aa){
                isEmoji = YES;
            }else if (hs >= 0x25aa && hs <= 0x27a1 ){
                isEmoji = YES;
            }else if (hs >= 0x2b05 && hs <= 0x2b55 ){
                isEmoji = YES;
            }
        }
        
    } else {
        // non surrogate
        if (0x2100 <= hs && hs <= 0x27ff) {
            isEmoji = YES;
        } else if (0x2B05 <= hs && hs <= 0x2b07) {
            isEmoji = YES;
        } else if (0x2934 <= hs && hs <= 0x2935) {
            isEmoji = YES;
        } else if (0x3297 <= hs && hs <= 0x3299) {
            isEmoji = YES;
        } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
            isEmoji = YES;
        }
    }
    return isEmoji;
}
- (BOOL)isContainsEmoji {
    __block BOOL result = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                              if ([substring isEmoji]) {
                                  *stop = YES;
                                  result = YES;
                              }
                          }];
    return result;
}
- (instancetype)removedEmojiString {
    __block NSMutableString* buffer = [NSMutableString stringWithCapacity:[self length]];
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                              [buffer appendString:([substring isEmoji])? @"": substring];
                          }];
    return buffer;
}

#pragma mark - Json
+ (NSData *)jsonDataWithNSDictionary:(NSDictionary *)dict{
    NSError *error = nil;
    NSData *dataJson = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    if(error) {
        QLLog(@"Serialization Eror: %@",error);
        NSAssert(0>1, @"解析JSONObject出错");
    } else {
        //QLLog(@"Serialization body: %@",dict);
    }
    return dataJson;
}

+ (id)jsonObjectWithData:(NSData *)data{
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if(error) {
        QLLog(@"Serialization Eror: %@",error);
        NSAssert(0 > 1, @"解析Json出错");
    } else {
        //QLLog(@"Serialization body: %@",jsonObject);
    }
    return json;
}

+ (NSString *)jsonStringWithNSDictionary:(NSDictionary *)dict{
    NSData *dataJson = [NSString jsonDataWithNSDictionary:dict];
    NSString *strJson = [[NSString alloc] initWithData:dataJson encoding:NSUTF8StringEncoding];
    return strJson;
}

+ (id)jsonObjectWithNSString:(NSString *)strJson{
    NSData *jsonData = [strJson dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObject = [NSString jsonObjectWithData:jsonData];
    return jsonObject;
}

#pragma mark - HTML
+ (NSString *)transformString:(NSString *)originalStr
{
    NSString *text = originalStr;
    
    //jiexi
    NSString *regex_attach = @"<a.*?href='(.*?)'>(.*?)</a>";//话题的正则表达式
    NSArray *array_attach = [text componentsMatchedByRegex:regex_attach];
    
    if ([array_attach count]) {
        int indexLength=0;
        for (NSString *str in array_attach) {
            NSRange range = [text rangeOfString:str];
            //            NSRange range =[text rangeOfString:str options:NSCaseInsensitiveSearch range:NSMakeRange(indexLength,text.length-indexLength)];
            NSString *funUrlStr = [NSString stringWithFormat:@"[fujian]%@",str];
            //            text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:funUrlStr];
            text=[text stringByReplacingOccurrencesOfString:str withString:funUrlStr];
            indexLength+=range.location+range.length;
        }
        
        NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"(\\[fujian]){1,}" options:0 error:nil] ;
        text=[regularExpretion stringByReplacingMatchesInString:text options:NSMatchingReportProgress range:NSMakeRange(0, text.length) withTemplate:@"[fujian]"];//把多个"[fujian]"匹配为一个"[fujian]"
    }
    
    
    //    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<a.*?href='(.*?)'>(.*?)</a>" options:NSRegularExpressionCaseInsensitive error:nil];
    //    NSArray *array =    nil;
    //    array = [regex matchesInString:contentStr options:0 range:NSMakeRange(0, [contentStr length])];
    //    DebugLog(@"==%@",contentStr);
    //    NSString *attachUrlStr = nil;
    //    int  i=0;
    //    int     rangeIndex=0;
    //    for (NSTextCheckingResult* b in array)
    //    {
    //        //str1 是每个和表达式匹配好的字符串。
    //        //        attachUrlStr = [contentStr substringWithRange:b.range];
    //
    //        DebugLog(@"==%d==%d",b.range.location,rangeIndex);
    //        attachUrlStr = [contentStr substringWithRange:NSMakeRange(b.range.location-rangeIndex, b.range.length)];
    //        DebugLog(@"%@",attachUrlStr);
    //        NSString    *tempStr=[self removeHTML:attachUrlStr];
    //        //        DebugLog(@"%@",attachUrlStr);
    //        //        contentStr=[contentStr stringByReplacingOccurrencesOfString:attachUrlStr withString:@""];
    //
    //        //        contentStr=[contentStr stringByReplacingCharactersInRange:b.range withString:@""];
    //        contentStr=[contentStr stringByReplacingCharactersInRange:NSMakeRange(b.range.location-rangeIndex, b.range.length) withString:@""];
    //
    //
    //        if (i==0) {
    //            contentStr=[NSString stringWithFormat:@"%@[fujian]%@",contentStr,tempStr];
    //        }else{
    //            contentStr=[NSString stringWithFormat:@"%@[*fujian]%@",contentStr,tempStr];
    //        }
    //        DebugLog(@"==%@",contentStr);
    //        i++;
    //        rangeIndex+=b.range.length;
    //    }
    
    
    
    //解析http://短链接
    //    NSString *regex_http = @"http(s)?://([a-zA-Z|\\d]+\\.)+[a-zA-Z|\\d]+(/[a-zA-Z|\\d|\\-|\\+|_./?%&=]*)?";//http://短链接正则表达式
    NSString *regex_http = @"(http|https)://[a-zA-Z0-9+&@#/%?=~_\\-|!:,\\.;]*[a-zA-Z0-9+&@#/%=~_|]";//http://短链接正则表达式
    NSArray *array_http = [text componentsMatchedByRegex:regex_http];
    if ([array_http count]) {
        for (NSString *str in array_http) {
            NSRange range = [text rangeOfString:str];
            NSString *funUrlStr = [NSString stringWithFormat:@"<a href=%@>%@</a>",str, str];
            text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, str.length) withString:funUrlStr];
        }
    }
    
    //解析@
    //@[\\u4e00-\\u9fa5\\w\\-]+
    //@[^ ]*|#([^\\#|.]+)#
    //    NSString *regex_at = @"@[^ ]*";//@的正则表达式
    //    NSArray *array_at = [text componentsMatchedByRegex:regex_at];
    //    if ([array_at count]) {
    //        NSMutableArray *test_arr = [[NSMutableArray alloc] init];
    //        int i=0;
    //        for (NSString *str in array_at) {
    //            NSRange range = [text rangeOfString:str];
    //            if (![test_arr containsObject:str]) {
    //                [test_arr addObject:str];
    //                NSString *funUrlStr = [NSString stringWithFormat:@"<a href=%@>%@</a>",str,str];
    //                text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:funUrlStr];
    //                i++;
    //            }
    //
    //        }
    //        [test_arr release];
    //    }
    
    
    //    //解析&
    //    NSString *regex_dot = @"\\$\\*?[\u4e00-\u9fa5|a-zA-Z|\\d]{2,8}(\\((SH|SZ)?\\d+\\))?";//&的正则表达式
    //    NSArray *array_dot = [text componentsMatchedByRegex:regex_dot];
    //    if ([array_dot count]) {
    //        NSMutableArray *test_arr = [[NSMutableArray alloc] init];
    //        for (NSString *str in array_dot) {
    //            NSRange range = [text rangeOfString:str];
    //            if (![test_arr containsObject:str]) {
    //                [test_arr addObject:str];
    //                NSString *funUrlStr = [NSString stringWithFormat:@"<a href=%@>%@</a>",str, str];
    //                text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:funUrlStr];
    //            }
    //        }
    //        [test_arr release];
    //    }
    
    //解析话题
    NSString *regex_pound = @"#([^\\#|.]+)#";//话题的正则表达式
    NSArray *array_pound = [text componentsMatchedByRegex:regex_pound];
    
    if ([array_pound count]) {
        for (NSString *str in array_pound) {
            NSRange range = [text rangeOfString:str];
            NSString *funUrlStr = [NSString stringWithFormat:@"<a href=%@>%@</a>",str, str];
            text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:funUrlStr];
        }
    }
    
    
    
    //解析表情
    NSString *regex_emoji = @"\\[fujian]";//表情的正则表达式[[a-zA-Z0-9\\u4e00-\\u9fa5]+\]
    NSArray *array_emoji = [text componentsMatchedByRegex:regex_emoji];
    if ([array_emoji count]) {
        for (NSString *str in array_emoji) {
            NSRange range = [text rangeOfString:str];
            //            NSString *i_transCharacter=@"fujian";
            NSString *i_transCharacter=@"Link";
            if (i_transCharacter) {
                NSString *imageHtml = [NSString stringWithFormat:@"<img src =%@> ",  i_transCharacter];
                text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:[imageHtml stringByAppendingString:@" "]];
            }
        }
    }
    //返回转义后的字符串
    //    return [text stringByReplacingOccurrencesOfString:@"查看详情</a>" withString:@""];
    
    return text;
}


+ (NSString *)stringWithCutingHtmlTextWithSource:(NSString *)strSource
{
    //strSource = [strSource stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    strSource = [strSource stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    strSource = [strSource stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    strSource = [strSource stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    strSource = [strSource stringByReplacingOccurrencesOfString:@"&nbsp; " withString:@""];
    strSource = [strSource stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    
    NSMutableString *strMSource = [NSMutableString stringWithFormat:@"%@", strSource];
    
    while (1) {
        NSRange rangeOfB = [strMSource rangeOfString:@"<"];
        NSRange rangeOfE = [strMSource rangeOfString:@">"];
        NSRange rangeCut = NSMakeRange(rangeOfB.location, rangeOfE.location+1-rangeOfB.location);
        //NSLog(@"%i, %i", rangeCut.location, rangeCut.length);
        if (rangeOfB.length != 0 && rangeOfE.length != 0) {
            [strMSource deleteCharactersInRange:rangeCut];
            //NSLog(@"%@", strMSource);
        } else {
            break;
        }
    }
    NSString *strRes = [NSString stringWithFormat:@"%@", strMSource];
    return [strRes stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
