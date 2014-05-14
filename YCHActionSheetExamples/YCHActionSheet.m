//
//  YCHActionSheet.m
//  YCHActionSheetExamples
//
//  Created by Yaman JAIOUCH on 23/04/2014.
//  Copyright (c) 2014 Yaman JAIOUCH. All rights reserved.
//

#define CHECK_OUT_OF_BOUNDS(obj, idx, r, f, ...) \
{ \
    NSLog(@"%@", obj); \
    NSLog(@"%@", @(idx)); \
    NSLog(@"%@", @(obj.count)); \
    if (idx >= obj.count) \
    { \
        [NSException raise:r format:f, __VA_ARGS__]; \
    } \
}

#import "YCHActionSheet.h"

/**
 * YCHActionSheet implementation
 */

@interface YCHActionSheet ()
{
    NSMutableArray *_mutableSections;
}

@end

@implementation YCHActionSheet

- (instancetype)initWithSections:(NSArray *)sections cancelButtonTitle:(NSString *)cancelButtonTitle delegate:(id)delegate
{
    if (self = [super init])
    {
        _mutableSections = [sections mutableCopy];
    }
    return self;
}

- (void)layoutSubviews
{
    [self setupUI];
}

- (NSArray *)sections
{
    return [_mutableSections copy];
}

- (void)setSections:(NSArray *)sections
{
    _mutableSections = [sections mutableCopy];
}

- (NSInteger)addSection:(YCHActionSheetSection *)section
{
    [_mutableSections addObject:section];
    return _mutableSections.count-1;
}

- (YCHActionSheetSection *)sectionAtIndex:(NSInteger)index
{
    CHECK_OUT_OF_BOUNDS(_mutableSections, index, @"YCHActionSheetSection error", @"*** -[%@ %@]: index %ld out of bounds", NSStringFromClass(self.class), NSStringFromSelector(@selector(sectionAtIndex:)), (long)index);
    
    return _mutableSections[index];
}

- (void)show
{
    
}

- (void)setupUI
{
    CGFloat offsetY = 0;
    
    for (YCHActionSheetSection *section in self.sections)
    {
        // 1°) display title
        
        // 2°) display buttons
        NSArray *buttons = section.buttons;
        for (UIButton *button in buttons)
        {
            button.frame = CGRectMake(0, offsetY, 300, 44);
            [self addSubview:button];
            offsetY += 44;
        }
        
        offsetY += 10;
    }
}

@end

/**
 * YCHActionSheetSection implementation
 */

@interface YCHActionSheetSection ()
{
    NSMutableArray *_mutableButtonTitles;
    NSMutableArray *_mutableButtons;
}

@end

@implementation YCHActionSheetSection

- (instancetype)initWithTitle:(NSString *)title otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    if (self = [super init])
    {
        _title = title;
        
        _mutableButtonTitles = [NSMutableArray array];
        va_list args;
        va_start(args, otherButtonTitles);
        for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString *))
        {
            [_mutableButtonTitles addObject:arg];
        }
        va_end(args);
        
        [self createButtons];
    }
    return self;
}

- (NSArray *)buttonTitles
{
    return [_mutableButtonTitles copy];
}

- (void)setButtonTitles:(NSArray *)buttonTitles
{
    _mutableButtonTitles = [buttonTitles mutableCopy];
    [self createButtons];
}

- (NSArray *)buttons
{
    return [_mutableButtons copy];
}

- (NSInteger)addButtonWithTitle:(NSString *)title
{
    [_mutableButtonTitles addObject:title];
    return _mutableButtonTitles.count-1;
}

- (NSString *)buttonAtIndex:(NSInteger)index
{
    CHECK_OUT_OF_BOUNDS(_mutableButtonTitles, index, @"YCHActionSheetSection error", @"*** -[%@ %@]: index %ld out of bounds", NSStringFromClass(self.class), NSStringFromSelector(@selector(buttonTitleAtIndex:)), (long)index);
    
    return _mutableButtonTitles[index];
}

- (void)createButtons
{
    UIImage *bgNormal = [[UIImage imageNamed:@"bg_50"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    UIImage *bgSelected = [[UIImage imageNamed:@"bg_50_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    
    _mutableButtons = [NSMutableArray array];
    for (NSString *buttonTitle in _mutableButtonTitles)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundImage:bgNormal forState:UIControlStateNormal];
        [button setBackgroundImage:bgSelected forState:UIControlStateSelected];
        
        [_mutableButtons addObject:button];
    }
}

@end
