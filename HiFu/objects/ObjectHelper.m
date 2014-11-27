//
//  ObjectHelper.m
//  HiFu
//
//  Created by Yin Xu on 6/28/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//
#import <objc/runtime.h>
#import "ObjectHelper.h"

@implementation ObjectHelper

static const char *property_getTypeName(objc_property_t property) {
	const char *attributes = property_getAttributes(property);
	char buffer[1 + strlen(attributes)];
	strcpy(buffer, attributes);
	char *state = buffer, *attribute;
	while ((attribute = strsep(&state, ",")) != NULL) {
		if (attribute[0] == 'T') {
			return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
		}
	}
	return "@";
}

static NSMutableDictionary *propertyListByClass;
static NSMutableDictionary *propertyClassByClassAndPropertyName;

+ (NSArray *)propertyNames:(Class)aClass {
	if (!propertyListByClass) propertyListByClass = [[NSMutableDictionary alloc] init];
	
	NSString *className = NSStringFromClass(aClass);
	NSArray *value = [propertyListByClass objectForKey:className];
	
	if (value) {
		return value;
	}
	
	NSMutableArray *propertyNames = [[NSMutableArray alloc] init];
	unsigned int propertyCount = 0;
	objc_property_t *properties = class_copyPropertyList(aClass, &propertyCount);
	
	for (unsigned int i = 0; i < propertyCount; ++i) {
		objc_property_t property = properties[i];
		const char * name = property_getName(property);
		
		[propertyNames addObject:[NSString stringWithUTF8String:name]];
	}
	free(properties);
	
	[propertyListByClass setObject:propertyNames forKey:className];
	
	return propertyNames;
}

+ (Class)propertyClassForPropertyName:(NSString *)propertyName ofClass:(Class)aClass {
	if (!propertyClassByClassAndPropertyName) propertyClassByClassAndPropertyName = [[NSMutableDictionary alloc] init];
	
	NSString *key = [NSString stringWithFormat:@"%@:%@", NSStringFromClass(aClass), propertyName];
	NSString *value = [propertyClassByClassAndPropertyName objectForKey:key];
	
	if (value) {
		return NSClassFromString(value);
	}
	
	unsigned int propertyCount = 0;
	objc_property_t *properties = class_copyPropertyList(aClass, &propertyCount);
	
	const char * cPropertyName = [propertyName UTF8String];
	
	for (unsigned int i = 0; i < propertyCount; ++i) {
		objc_property_t property = properties[i];
		const char * name = property_getName(property);
		if (strcmp(cPropertyName, name) == 0) {
			free(properties);
			NSString *className = [NSString stringWithUTF8String:property_getTypeName(property)];
			[propertyClassByClassAndPropertyName setObject:className forKey:key];
			return NSClassFromString(className);
		}
	}
	free(properties);
	return nil;
}

@end
