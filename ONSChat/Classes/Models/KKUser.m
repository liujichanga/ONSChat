//
//  KKUser.m
//  KuaiKuai
//
//  Created by jichang.liu on 15/6/26.
//  Copyright (c) 2015年 liujichang. All rights reserved.
//

#import "KKUser.h"

@implementation KKUser


//显示省份+地区
-(NSString*)provinceAndCityDisplay
{
    NSString *areaStr=@"北京";
    if(KKStringIsNotBlank(self.province))
    {
        areaStr=self.province;
    }
    if(KKStringIsNotBlank(self.city))
    {
        areaStr=KKStringWithFormat(@"%@ %@",areaStr,self.city);
    }
    
    return areaStr;
}

//显示性别
-(NSString*)sexDisplay
{
    NSString *sexStr=@"未知";
    
    if(self.sex == KKMale) sexStr = @"男";
    else if(self.sex == KKFemale) sexStr = @"女";
    
    return sexStr;
}

//年龄
-(NSInteger)age
{
    NSDate * currentdate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY"];
    
    NSString * locationString=[dateformatter stringFromDate:currentdate];
    
    NSString *strUrl = [self.birthday stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if(strUrl.length>=6)
    {
        NSString *str = [strUrl substringToIndex:4];
        
        NSInteger age = [locationString integerValue] - [str integerValue];
        
        return age;
    }
    else return 0;
}


//标准体重=身高(米)*身高*性别(男22，女21）
//BMI=体重(公斤)/身高(米)/身高
-(CGFloat)calBMI
{
    CGFloat bmi=0;
    if(self.height>0 && self.weight>0)
    {
        bmi=self.weight/(self.height / 100)/(self.height / 100);
    }
    
    return bmi;
}

-(NSString *)calBMIDesc
{
    CGFloat bmi = [self calBMI];
    NSString *bmidesc=@"无";
    if(bmi>0)
    {
        if(bmi<20)
        {
            bmidesc=@"苗条";
        }
        else if(bmi>=20&&bmi<=22.6)
        {
            bmidesc=@"健康";
        }
        else if(bmi>22.6&&bmi<=30)
        {
            bmidesc=@"超重";
        }
        else if(bmi>30)
        {
            bmidesc=@"肥胖";
        }
        
    }
    
    return bmidesc;
}


#pragma mark - 转16进制数据
-(NSString*)hexWithUserID
{
    return [NSString stringWithFormat:@"%08lx",(long)self.userCode.integerValue];
}
-(NSString*)hexWithHeight
{
    return [NSString stringWithFormat:@"%02x",(int)self.height];
}
-(NSString*)hexWithWeight
{
    NSString *strweight1=[NSString stringWithFormat:@"%02x",(int)floor(self.weight)];
    NSString *strweight2=[NSString stringWithFormat:@"%02x",(int)floor((self.weight-floor(self.weight))*100)];
    NSString *strweight=[NSString stringWithFormat:@"%@%@",strweight1,strweight2];
    
    return strweight;
}
-(NSString*)hexWithAge
{
    return [NSString stringWithFormat:@"%02x",(int)self.age];
    
}
-(NSString*)hexWithSex
{
    return [NSString stringWithFormat:@"%02x",(int)self.sex];
}
-(NSString*)hexWithPulse
{
    return [NSString stringWithFormat:@"%02x",(int)self.pulse];
}
-(NSString *)hexWithPhone
{
    //    NSMutableString *str=[NSMutableString string];
    //    for (int i=0; i<self.phone.length; i++) {
    //        [str appendString:[NSString stringWithFormat:@"0%@",[self.phone substringWithRange:NSMakeRange(i, 1)]]];
    //
    //    }
    //
    //    return str;
    
    return @"";
}

@end
