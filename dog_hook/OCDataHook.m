//
//  OCDataHook.c
//  dxHook
//
//  Created by fcj on 2018/10/11.
//

#include "OCDataHook.h"
#include <mach-o/dyld.h>
#include <substrate.h>
#include <objc/objc-runtime.h>
#import <AdSupport/ASIdentifierManager.h>
#import <UIKit/UIKit.h>


static OCDataHook* m_TestHook;

IMP NSString_stringWithCString;
IMP NSString_stringwithFormat;
IMP NSString_cStringUsingEncoding;

IMP NSString_UTF8String;
IMP NSDictionary_objectkey;
IMP NSDictionary_dictionaryWithObjects_forkeys_cnt;
//NSString
NSString* rep_NSString_stringWithCString(id self,SEL _cmd,const char* str,int selc);
NSString * rep_NSString_stringwithFormat(id self,SEL _cmd,NSString * format,...);
const char * rep_NSString_cStringUsingEncoding(id self,SEL _cmd,int selc);
const char * rep_UTF8String(id self,SEL _cmd);
//NSDictionary
id  rep_NSDictionary_objectkey(id self,SEL _cmd,id key);
NSDictionary * rep_NSDictionary_dictionaryWithObjects_forkeys_cnt(id self,SEL _cmd,id  objs,id keys,NSUInteger cnt);
//NSArray
id  rep_NSArray_objectAtIndex(id self,SEL _cmd,NSUInteger index);
NSDictionary* rep_NSJSONSerialization_JSONObjectWithData(id self,SEL _cmd,NSData *data,NSJSONReadingOptions opt,NSError ** error);
void rep_NSMutableDictionary_setvalue(id self,SEL _cmd,id key,id value);
//UIDevice
NSData * rep_NSJSONSerialization_dataWithJSONObject(id self,SEL _cmd,id object,NSJSONWritingOptions opt,NSError ** error);
IMP  UIDevice_name;
IMP  UIDevice_systemVersion;
IMP  UIDevice_identifierForVendor;
NSUUID* rep_ASIdentifierManager_advertisingIdentifier(id self,SEL _cmd);
NSString*  rep_UIDevice_name(id self,SEL _cmd);
NSString*  rep_UIDevice_systemVersion(id self,SEL _cmd);
NSUUID* rep_UIDevice_identifierForVendor(id self,SEL _cmd);
@implementation OCDataHook
+(OCDataHook*)sharedInstance
{
    
    if(m_TestHook ==NULL){
        m_TestHook=[[OCDataHook alloc] init];
    }
    return  m_TestHook;
}

NSString* rep_NSString_stringWithCString(id self,SEL _cmd,const char* str,int selc)
{
    NSString *result=NSString_stringWithCString(self,_cmd,str,selc);
    NSLog(@"--------- rep_NSString_stringWithCString ==%@",result);
    return result;
}
NSString * rep_NSString_stringwithFormat(id self,SEL _cmd,NSString * format,...)
{
    va_list arg_list;
    va_start(arg_list, format);
    va_end(arg_list);
    NSString* result= [[NSString alloc] initWithFormat:format arguments:arg_list];
    NSLog(@"--------- rep_NSString_stringwithFormat ==%@",result);
    return result;
}
const char * rep_NSString_cStringUsingEncoding(id self,SEL _cmd,int selc)
{
    
    const char* result= (__bridge void*)NSString_cStringUsingEncoding(self,_cmd,selc);
    NSLog(@"--------- rep_NSString_cStringUsingEncoding ==%@",self);
    return result;
}
const char * rep_UTF8String(id self,SEL _cmd)
{
    
    NSLog(@"--------- rep_UTF8String ==%@",self);
    return  (__bridge void*)NSString_UTF8String(self,_cmd);
}
//@selector(objectForKey:)
id  rep_NSDictionary_objectkey(id self,SEL _cmd,id key)
{
    NSLog(@"-----------------rep_NSDict_objectkey ==%@",self);
    return (__bridge id)((__bridge void*)NSDictionary_objectkey(self,_cmd,key));
}
//@selector(dictionaryWithObjects:forKeys:count:)
NSDictionary * rep_NSDictionary_dictionaryWithObjects_forkeys_cnt(id self,SEL _cmd,id  objs,id keys,NSUInteger cnt)
{
    NSLog(@"-----------------rep_NSDictionary_dictionaryWithObjects");
    return NSDictionary_dictionaryWithObjects_forkeys_cnt(self,_cmd,objs,keys,cnt);
}
//
IMP NSArray_objectAtIndex;
id  rep_NSArray_objectAtIndex(id self,SEL _cmd,NSUInteger index)
{
    NSLog(@"-----------------rep_NSArray_objectAtIndex");
    return NSArray_objectAtIndex(self,_cmd,index);
    
}
IMP NSJSONSerialization_JSONObjectWithData;
NSDictionary* rep_NSJSONSerialization_JSONObjectWithData(id self,SEL _cmd,NSData *data,NSJSONReadingOptions opt,NSError ** error)
{
    NSDictionary *ret= NSJSONSerialization_JSONObjectWithData(self,_cmd,data,opt,error);
    NSLog(@"-----------------rep_NSJSONSerialization_JSONObjectWithData ==%@",ret);
    return ret;
}
IMP  NSMutableDictionary_setvalue;
void rep_NSMutableDictionary_setvalue(id self,SEL _cmd,id key,id value)
{
    NSLog(@"-----------------rep_NSMutableDictionary_setvalue key ==%@  value ==%@",key,value);
     NSMutableDictionary_setvalue(self,_cmd,key,value);
}

NSString*  rep_UIDevice_name(id self,SEL _cmd)
{
   
    NSString *ret= UIDevice_name(self,_cmd);
    NSLog(@"-----------------rep_UIDevice_name ==%@",ret);
    return ret;
}
NSString*  rep_UIDevice_systemVersion(id self,SEL _cmd)
{
    NSString *ret= UIDevice_systemVersion(self,_cmd);
    NSLog(@"-----------------UIDevice_systemVersion ==%@",ret);
    return ret;
}
NSUUID* rep_UIDevice_identifierForVendor(id self,SEL _cmd)
{
    NSUUID *ret= UIDevice_identifierForVendor(self,_cmd);
    NSLog(@"-----------------rep_UIDevice_identifierForVendor ==%@",ret);
    return ret;
}
IMP NSJSONSerialization_dataWithJSONObject;

NSData * rep_NSJSONSerialization_dataWithJSONObject(id self,SEL _cmd,id object,NSJSONWritingOptions opt,NSError ** error)
{
    NSLog(@"-----------------rep_NSJSONSerialization_dataWithJSONObject ==%@",object);
    return NSJSONSerialization_dataWithJSONObject(self,_cmd,object,opt,error);
}
IMP ASIdentifierManager_advertisingIdentifier;
NSUUID* rep_ASIdentifierManager_advertisingIdentifier(id self,SEL _cmd)
{
    NSUUID *ret=ASIdentifierManager_advertisingIdentifier(self,_cmd);
    NSLog(@"-----------------ASIdentifierManager_advertisingIdentifier ==%@",ret);
    return ret;

}
-(void)doHook
{
    //NSString
    MSHookMessageEx(objc_getMetaClass("NSString"), @selector(stringWithCString:encoding:),(IMP)rep_NSString_stringWithCString, (IMP*)&NSString_stringWithCString);
    //MSHookMessageEx(objc_getMetaClass("NSString"), @selector(stringWithFormat:),(IMP)rep_NSString_stringwithFormat, (IMP*)&NSString_stringwithFormat);
    MSHookMessageEx([NSString class], @selector(cStringUsingEncoding:),(IMP)rep_NSString_cStringUsingEncoding, (IMP*)&NSString_cStringUsingEncoding);
    MSHookMessageEx([NSString class], @selector(UTF8String),(IMP)rep_UTF8String, (IMP*)&NSString_UTF8String);

    //NSDictionary
    MSHookMessageEx([NSDictionary class], @selector(objectForKey:),(IMP)rep_NSDictionary_objectkey ,(IMP*)&NSDictionary_objectkey );
    //MSHookMessageEx(objc_getMetaClass("NSDictionary"), @selector(dictionaryWithObjects:forKeys:count:),(IMP)rep_NSDictionary_dictionaryWithObjects_forkeys_cnt ,(IMP*)&NSDictionary_dictionaryWithObjects_forkeys_cnt );
    //NSArray
    MSHookMessageEx([NSArray class], @selector(objectAtIndex:), (IMP)rep_NSArray_objectAtIndex,(IMP*)&NSArray_objectAtIndex);
    MSHookMessageEx([NSMutableDictionary class], @selector(setObject:forKey:),(IMP)rep_NSMutableDictionary_setvalue , &NSMutableDictionary_setvalue);
    //NSJSONSerialization
    MSHookMessageEx(objc_getMetaClass("NSJSONSerialization"), @selector(JSONObjectWithData:options:error:),(IMP)rep_NSJSONSerialization_JSONObjectWithData,(IMP*)&NSJSONSerialization_JSONObjectWithData);
    MSHookMessageEx(objc_getMetaClass("NSJSONSerialization"), @selector(dataWithJSONObject:options:error:), NSJSONSerialization_dataWithJSONObject, &NSJSONSerialization_dataWithJSONObject);
   // NSArray *arr1;
    //UIDevice
    MSHookMessageEx([UIDevice class],@selector(name),(IMP)rep_UIDevice_name,(IMP*)&UIDevice_name);
    MSHookMessageEx([UIDevice class],@selector(systemVersion),(IMP)rep_UIDevice_systemVersion,(IMP*)&UIDevice_systemVersion);
    MSHookMessageEx([UIDevice class],@selector(identifierForVendor),(IMP)rep_UIDevice_identifierForVendor,(IMP*)&UIDevice_identifierForVendor);
    
    MSHookMessageEx([ASIdentifierManager class], @selector(advertisingIdentifier), (IMP)rep_ASIdentifierManager_advertisingIdentifier, (IMP*)&ASIdentifierManager_advertisingIdentifier);

}
@end
