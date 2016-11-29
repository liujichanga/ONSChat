//
//  NSString+Digest.h
//  GlassesIntroduce
//
//  Created by 王志明 on 14/12/16.
//  Copyright (c) 2014年 王志明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Digest)

- (NSString *)md5;
- (BOOL)stringContainsEmoji;

-(NSString*)sha1;

//urlencode
- (NSString *)UrlValueEncode;
@end
