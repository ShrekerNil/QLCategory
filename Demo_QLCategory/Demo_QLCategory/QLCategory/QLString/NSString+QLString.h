//
//  NSString+QLString.h
//  QLString
//
//  Created by Shrek on 12/23/13.
//  Copyright (c) 2013 Shrek. All rights reserved.
//  文件名操作

#import <Foundation/Foundation.h>

@interface NSString (QLString)

#pragma mark - QLString
/**
 *  @brief 给文件名后面,扩展名前追加一个字符串
 *
 *  @param strNeedToJoint 要追加的字符串
 *
 *  @return 返回追加之后的新字符串
 */
- (NSString *)stringByJointString:(NSString *)strNeedToJoint;

/**
 *  把字典的键值对用&符号连接起来
 *
 *  @param dicData 参数字典
 *
 *  @return 返回一个把字典的键值对用&符号连接起来的字符串
 */
+ (NSString *)stringByJointParameterWithDictionary:(NSDictionary *)dicData;

/**
 *  拼接完整GET请求链接
 *
 *  @param strUrl  主地址
 *  @param dicData 参数字典
 *
 *  @return 返回完整GET请求链接
 */
+ (NSString *)stringByJointParameterWithUrl:(NSString *)strUrl Dictionary:(NSDictionary *)dicData;

/**
 *  @brief 把一个NSData对象转换成NSString对象
 *
 *  @param data     需要转换成字符串的NSData对象
 *  @param encoding 字符编码的格式
 *
 *  @return 根据NSData对象返回一个对应的NSString对象
 */
+ (NSString *)stringWithData:(NSData *)data encoding:(NSStringEncoding)encoding;

/**
 *  @brief  获得一个非nil/NSNull的值
 *
 *  @param obj 元数据
 *
 *  @return 返回元数据对应的字符串,当元数据为nil/NSNull的时候返回@""
 */
+ (NSString *)getValidStringWithObject:(id)obj;

/**
 *  @brief  判断字符串对象是否为一个nil/NSNull/@""
 *
 *  @return 返回字符处啊对象是否是一个nil/NSNull/@""
 */
- (BOOL)isNilOrNSNullOrEmptyString;

#pragma mark - Emoji
/**
 *  @brief 根据字符串对象判断是否是Emoji表情
 *
 *  @return 返回一个BOOL,表示该字符串对象是否是一个Emoji
 */
- (BOOL)isEmoji;

/**
 *  @brief  根据unixTime字符串对象生成标准的时间格式
 *
 *  @param strFormat 返回时间的格式,如:"2014-02-05",默认为"2014年02月05日"
 *
 *  @return 返回标准的时间格式
 */
- (NSString *)unixtimeToDateStringWithFormat:(NSString *)strFormat;

/**
 *  @brief 判断是否是中文字符
 *
 *  @return 返回字符串对象是否是中文字符
 */
- (BOOL)isChineseString;

/**
 *  @brief  金额转成特定格式（11,111,111.00）
 *
 *  @param priceValue 价格字符串
 *
 *  @return 返回生成的固定格式的字符串
 */
+ (NSString *)formattedPriceFromString:(NSString *)priceValue;

#pragma mark - Json
+ (NSData *)jsonDataWithNSDictionary:(NSDictionary *)dict;
+ (id)jsonObjectWithData:(NSData *)data;
+ (NSString *)jsonStringWithNSDictionary:(NSDictionary *)dict;
+ (id)jsonObjectWithNSString:(NSString *)strJson;

#pragma mark - HTML
+ (NSString *)transformString:(NSString *)originalStr;
+ (NSString *)stringWithCutingHtmlTextWithSource:(NSString *)strSource;

@end
