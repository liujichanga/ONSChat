//
//  KKCommonMacro.h
//  KuaiKuai
//
//  Created by jichang.liu on 15/6/25.
//  Copyright (c) 2015年 liujichang. All rights reserved.
//

#ifndef KuaiKuai_KKCommonMacro_h
#define KuaiKuai_KKCommonMacro_h


// Log打印，发布阶段自动关闭
#ifdef DEBUG
#define KKLog(...)  NSLog(__VA_ARGS__)
#else
#define KKLog(...)
#endif

//String bank
#define KKStringIsBlank(string)  [NSString isBlank:string]
#define KKStringIsNotBlank(string) [NSString isNotBlank:string]

//String empty
#define KKStringIsNotEmpty(string) [NSString isNotEmpty:string]

//StringFormat
#define KKStringWithFormat(format, ...) [NSString stringWithFormat:format, __VA_ARGS__]

//String->Url
#define KKURLWithString(string) [NSURL URLWithString:string]

//String->base64
#define KKBase64String(string) [[string dataUsingEncoding:NSASCIIStringEncoding] base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]

//Number->String
#define KKStringWithInt(num) [NSString stringWithFormat:@"%zd", num]
#define KKStringWithNSInteger(num) [NSString stringWithFormat:@"%ld", num]
#define KKStringWithNSUInteger(num) [NSString stringWithFormat:@"%lu", num]
#define KKStringWithFloat(num) [NSString stringWithFormat:@"%f", num]
#define KKStringWithDouble(num) [NSString stringWithFormat:@"%lf", num]
#define KKStringWithCGFloat(num) [NSString stringWithFormat:@"%lf", num]

//ImageView
#define KKImageViewWithUrlstring(imageView,url,placeholder) \
    [imageView sd_setImageWithURL:KKURLWithString(url)  \
            placeholderImage:[UIImage imageNamed:placeholder]]

//ImageViewCache 将imageurl缓存到cache plist
#define KKCacheImageViewWithUrlstring(imageView,url,placeholder) \
    [imageView sd_setImageWithURL:KKURLWithString(url) placeholderImage:[KKSharedImageCacheManager cacheImageForKey:placeholder] \
        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) { \
        [KKSharedImageCacheManager updateCacheKey:imageURL.absoluteString withImageKey:placeholder];}]


//Button
#define KKButtonWithUrlstring(btn,url,placeholder) \
[btn sd_setImageWithURL:KKURLWithString(url) forState:UIControlStateNormal \
placeholderImage:[UIImage imageNamed:placeholder]]

//ButtonImageViewCache 将imageurl缓存到cache plist
#define KKCacheButtonWithUrlstring(btn,url,placeholder) \
[btn sd_setImageWithURL:KKURLWithString(url) forState:UIControlStateNormal placeholderImage:[KKSharedImageCacheManager cacheImageForKey:placeholder] \
    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) { \
    [KKSharedImageCacheManager updateCacheKey:imageURL.absoluteString withImageKey:placeholder];}]


// RGB颜色转换（16进制->10进制）
#define KKColorFromRGB(rgbValue)    \
    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0    \
        green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0   \
        blue:((float)(rgbValue & 0xFF))/255.0 \
        alpha:1.0]

// 角度转弧度
#define KKANGLE(a) 2.0 * M_PI / 360.0 * a

//float比较大小
#define KKFloatIsEqual(float1,float2) fabs(float1-float2) < 0.0001

// 屏幕尺寸
#define KKMainScreen      [UIScreen mainScreen]
#define KKScreenSize      [UIScreen mainScreen].bounds.size
#define KKScreenBounds    [UIScreen mainScreen].bounds
#define KKScreenWidth     KKScreenSize.width
#define KKScreenHeight    KKScreenSize.height
#define KKCurrentScale    KKMainScreen.scale


#define KKScreenHeightIphone4s 480
#define KKScreenHeightIphone5  568
#define KKScreenHeightIphone6  667
#define KKScreenHeightIphone6p  736

#define KKScreenWidthIphone5  320
#define KKScreenWidthIphone6 375
#define KKScreenWidthIphone6p 414

//scale:iphone5:2.0 iphone6:2.0 iphone6+:3.0
//view:iphone5:320,568   640,1136  iphone6:375,667   750,1334    iphone6+:414,736   1242,2208

//沙盒路径
#define KKPathOfAppHome NSHomeDirectory()
#define KKPathOfTemp NSTemporaryDirectory()
#define KKPathOfDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)  objectAtIndex:0]
#define KKPathOfCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)  objectAtIndex:0]


//资源/路径
#define KKMainBundle [NSBundle mainBundle]
#define KKPathOfMainBundle(name, type) [KKMainBundle pathForResource:name ofType:type]
#define KKViewOfMainBundle(name) [KKMainBundle loadNibNamed:name owner:nil options:nil].firstObject

#define KKMainSB [UIStoryboard storyboardWithName:@"Main" bundle:nil]
#define KKInitViewControllerOfMainSB [KKMainSB instantiateInitialViewController]
#define KKViewControllerOfMainSB(identifier) [KKMainSB instantiateViewControllerWithIdentifier:identifier]

//Main SB
#define KKViewControllerOfHomeSB(identifier) [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:identifier]
#define KKViewControllerOfGiftSB(identifier) [[UIStoryboard storyboardWithName:@"Gift" bundle:nil] instantiateViewControllerWithIdentifier:identifier]
#define KKViewControllerOfFindSB(identifier) [[UIStoryboard storyboardWithName:@"Find" bundle:nil] instantiateViewControllerWithIdentifier:identifier]
#define KKViewControllerOfMeSB(identifier) [[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier:identifier]
#define KKViewControllerOfShopSB(identifier) [[UIStoryboard storyboardWithName:@"Shop" bundle:nil] instantiateViewControllerWithIdentifier:identifier]
#define KKViewControllerOfCourseQuestionSB(identifier) [[UIStoryboard storyboardWithName:@"CourseQuestion" bundle:nil] instantiateViewControllerWithIdentifier:identifier]
#define KKViewControllerOfRunSB(identifier) [[UIStoryboard storyboardWithName:@"Run" bundle:nil] instantiateViewControllerWithIdentifier:identifier]
#define KKViewControllerOfWatchSB(identifier)[[UIStoryboard storyboardWithName:@"Watch" bundle:nil] instantiateViewControllerWithIdentifier:identifier]

//Bundle 图片资源
#define KKPNGPath(name) KKPathOfMainBundle(name,@"png")
#define KKJPGPath(name) KKPathOfMainBundle(name,@"jpg")
#define KKPNGImage(name) [UIImage imageWithContentsOfFile:KKPNGPath(name)]
#define KKJPGImage(name) [UIImage imageWithContentsOfFile:KKJPGPath(name)]
#define KKImage(name,type) [UIImage imageWithContentsOfFile:KKPathOfMainBubdle(name, type)]

//字体
#define KKBoldSystemFont(fontsize) [UIFont boldSystemFontOfSize:fontsize]
#define KKSystemFont(fontsize)     [UIFont systemFontOfSize:fontsize]
#define KKFont(name, fontsize)     [UIFont fontWithName:(name) size:(fontsize)]

//导航栏颜色
#define KKColorNav  [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]

//通用紫色
#define KKColorPurple  [UIColor colorWithRed:210.0/255.0 green:88.0/255.0 blue:210.0/255.0 alpha:1.0]
//首页背景的颜色
#define KKColorHomeOrange  [UIColor colorWithHexString:@"#ff6000"]//f84d02


/**边框线的颜色*/
#define KKColorBorder [UIColor colorWithHexString:@"#d9d9d9"]
/**标题颜色 黑色*/
#define KKColorTitleBlack [UIColor colorWithHexString:@"#000000"]
/**输入框颜色 列表项颜色 淡黑*/
#define KKColorInputBlack [UIColor colorWithHexString:@"#333333"]
/**二级列表项颜色 深灰*/
#define KKColorDarkGray [UIColor colorWithHexString:@"#666666"]
/**输入框占位符的颜色*/
#define KKColorInputPlaceGray [UIColor colorWithHexString:@"#999999"]
/**首页cell背景颜色*/
#define KKHome2CellBackGroundColor [UIColor colorWithHexString:@"#fffbf5"]

//图片比例 宽/高
//通用顶部banner图片比例
#define KKTopPicRatio 830.0/1242.0

#define KKTopCarouseRatio (380.0/750.0)



/**系统信息*/
#define KKOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#define KKDeviceIsPhone  UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone
#define KKDeviceIsPad UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define KKCurrentLanguage [[NSLocale preferredLanguages] objectAtIndex:0]
#define KKIsZhHans [KKCurrentLanguage isEqualToString:@"zh-Hans"]

#define KKAppVersion [KKMainBundle infoDictionary][@"CFBundleShortVersionString"]
#define KKAppBuildVersion [KKMainBundle infoDictionary][@"CFBundleVersion"]

#define KKAppName [KKMainBundle infoDictionary][@"CFBundleName"]
#define KKUserDefaults [NSUserDefaults standardUserDefaults]

//IDFV
#define KKIDFV [[UIDevice currentDevice].identifierForVendor UUIDString]


/** 一天的秒数 */
#define KKSecondsOfDay            (24.f * 60.f * 60.f)
/** X天的秒数 */
#define KKSeconds(Days)           (24.f * 60.f * 60.f * (Days))

/** 一天的毫秒数 */
#define KKMillisecondsOfDay       (24.f * 60.f * 60.f * 1000.f)
/** X天的毫秒数 */
#define KKMilliseconds(Days)      (24.f * 60.f * 60.f * 1000.f * (Days))


// 为TextField设置左右空白
#define KKSetTextFieldLeftView(textFiled, padding) \
            textFiled.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, padding, 0.0)]; \
            textFiled.leftViewMode = UITextFieldViewModeAlways;

// View 圆角和加边框
#define KKViewRadiusBorder(view, radius, lineWidth, lineColor)    \
            [view.layer setCornerRadius:(radius)];\
            [view.layer setMasksToBounds:YES];  \
            [view.layer setBorderWidth:(lineWidth)];    \
            [view.layer setBorderColor:lineColor.CGColor];
// View 圆角
#define KKViewRadius(view, radius)    \
            [view.layer setCornerRadius:(radius)];  \
            [view.layer setMasksToBounds:YES];

// 正则判断手机号或者邮箱是否输入正确
#define KKRegexEmail  @"^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+((\\.[a-zA-Z0-9_-]{2,3}){1,2})$"
#define KKRegexPhone  @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$" //@"^1\\d{10}$" //@"^((\\86)|(\\+86 ))?1\\d{10}$"
#define KKRegexNotBlack  @"^.+$"
#define KKRegexPassWord  @"^([a-zA-Z0-9_]){6,16}$"
#define KKRegexNub @"^[0-9]*$"
#define KKRegexIdNumber @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)" //@"^(^[1-9]{7}((0)|(1[0-2]))(([0|1|2])|3[0-1]){3}$)|(^[1-9]{5}[1-9]{3}((0)|(1[0-2]))(([0|1|2])|3[0-1])(({4})|{3}[Xx])$)$" //
#define KKRegexNubFloat @"^[0-9]+([.]{0}|[.]{1}[0-9]+)$"

// Block weakself strongself
#define KKWEAKSELF __weak typeof(self) weakself = self;
#define KKSTRONGSELF __strong typeof(weakself) strongself = weakSelf;

//UIApplication AppDelegate
#define KKApplication [UIApplication sharedApplication]
#define KKAppDelegate ((AppDelegate*)KKApplication.delegate)
#define KKRootController  KKAppDelegate.window.rootViewController


// 状态栏
#define KKSetLightContentStatusBar KKApplication.statusBarStyle = UIStatusBarStyleLightContent
#define KKSetBlackContentStatusBar KKApplication.statusBarStyle = UIStatusBarStyleDefault

//Notification
#define KKNotificationCenter [NSNotificationCenter defaultCenter]
#define KKNotificationCenterAddObserverOfSelf(selectorName, notificationName, ojbect) \
            [KKNotificationCenter addObserver:self \
            selector:@selector(selectorName) \
            name:notificationName \
            object:ojbect];
#define KKNotificationCenterRemoveObserverOfSelf [KKNotificationCenter removeObserver:self];


//圈子里面的图片key
#define KKTopicImageOriginalKey @"original_pic"
#define KKTopicImageThumbnailKey @"bmiddle_pic"

//Frame
#define KKFrameOfOriginX(rect,x) CGRectMake(x, rect.origin.y, rect.size.width, rect.size.height)
#define KKFrameOfOriginY(rect,y) CGRectMake(rect.origin.x, y, rect.size.width, rect.size.height)
#define KKFrameOfSizeW(rect,width) CGRectMake(rect.origin.x, rect.origin.y, width, rect.size.height)
#define KKFrameOfSizeH(rect,height) CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, height)

//string from selector
#define KKStringFromSelector(selname) NSStringFromSelector(@selector(selname))

//视频图片添加一个播放图片
#define KKPlayImage [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_icon.png"]]
#define KKAddPlayImage(imageView,playImageView)  \
    playImageView.frame = CGRectMake(0, 0, 50, 50);  \
    playImageView.center = CGPointMake(imageView.frame.size.width*0.5, imageView.frame.size.height*0.5); \
    [imageView addSubview:playImageView];

//支付方式
#define PayTypeWX 1
#define PayTypeZFB 2

//电话
#define KKMobilePhone @"4008-362-136"

//分享APP网址
#define KKShareAppUrl @"http://www.kuaikuaikeji.com/appshare.html"

//网络异常时的显示信息
#define KKErrorInfo(error) [error.userInfo objectForKey:@"KKHttpError"]

//topic媒体存放的缓存目录
#define CacheTopic @"Topic"

//course媒体存放的缓存目录 - sra by 20151201
#define CacheKKCourse @"KKCourse"

//渠道id
#define ChannelId @"appstore"

#endif
