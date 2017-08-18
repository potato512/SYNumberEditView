//
//  SYNumberEditView.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 17/4/25.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "SYNumberEditView.h"

#define borderCornerMin 0.0
#define borderCornerMax (self.frame.size.height / 2)
#define borderWidthMin 0.5
#define borderWidthMax 2.0

static NSString *const limitNumberText = @"0123456789";

@interface SYNumberEditView () <UITextFieldDelegate>

@property (nonatomic, strong) UIButton *buttonReduce;
@property (nonatomic, strong) UIButton *buttonAddMore;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIView *lineLeft;
@property (nonatomic, strong) UIView *lineRight;

@end

@implementation SYNumberEditView

@synthesize number = _number;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initializeInfo];
        
        [self setUI];
        [self resetUI];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initializeInfo];
        [self setUI];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    NSLog(@"%@~被释放了", self);
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void)layoutSubviews
{
    [self resetUI];
}

#pragma mark - 视图

- (void)initializeInfo
{
    _reduceTitleNormal = @"-";
//    _reduceTitleHighlight = @"-";
    _reduceFont = [UIFont systemFontOfSize:12.0];
    _reduceTitleColorNormal = [UIColor blackColor];
    _reduceTitleColorHighlight = [UIColor redColor];
    
    _addTitleNormal = @"+";
//    _addTitleHighlight = @"+";
    _addFont = [UIFont systemFontOfSize:12.0];
    _addTitleColorNormal = [UIColor blackColor];
    _addTitleColorHighlight = [UIColor redColor];
    
    _textFont = [UIFont systemFontOfSize:12.0];
    _textColor = [UIColor blackColor];
    
    _borderShow = NO;
    _borderCornerRadius = borderCornerMin;
    _borderColor = [UIColor blackColor];
    _borderWidth = borderWidthMin;
}

- (void)setUI
{
    self.buttonReduce = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.buttonReduce];
    self.buttonReduce.backgroundColor = [UIColor clearColor];
    [self.buttonReduce setTitle:_reduceTitleNormal forState:UIControlStateNormal];
    [self.buttonReduce setTitle:_reduceTitleNormal forState:UIControlStateHighlighted];
    [self.buttonReduce setTitleColor:_reduceTitleColorNormal forState:UIControlStateNormal];
    [self.buttonReduce setTitleColor:_reduceTitleColorHighlight forState:UIControlStateHighlighted];
    self.buttonReduce.titleLabel.font = _reduceFont;
    [self.buttonReduce addTarget:self action:@selector(buttonReduceClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.textField = [[UITextField alloc] init];
    [self addSubview:self.textField];
    self.textField.backgroundColor = [UIColor clearColor];
    self.textField.font = _textFont;
    self.textField.textColor = _textColor;
    self.textField.text = @"0";
    self.textField.textAlignment = NSTextAlignmentCenter;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.delegate = self;
    
    self.buttonAddMore = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.buttonAddMore];
    self.buttonAddMore.backgroundColor = [UIColor clearColor];
    [self.buttonAddMore setTitle:_addTitleNormal forState:UIControlStateNormal];
    [self.buttonAddMore setTitle:_addTitleNormal forState:UIControlStateHighlighted];
    [self.buttonAddMore setTitleColor:_addTitleColorNormal forState:UIControlStateNormal];
    [self.buttonAddMore setTitleColor:_addTitleColorHighlight forState:UIControlStateHighlighted];
    self.buttonAddMore.titleLabel.font = _addFont;
    [self.buttonAddMore addTarget:self action:@selector(buttonAddMoreClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.lineLeft = [[UIView alloc] init];
    [self.buttonReduce addSubview:self.lineLeft];
    self.lineLeft.backgroundColor = _borderColor;
    
    self.lineRight = [[UIView alloc] init];
    [self.buttonAddMore addSubview:self.lineRight];
    self.lineRight.backgroundColor = _borderColor;

    // 初始化
    self.lineLeft.hidden = !_borderShow;
    self.lineRight.hidden = !_borderShow;
    // 添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textEdictChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)resetUI
{
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    width = (width < height * 3) ? (height * 3) : width;
    
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
    
    CGFloat sizeButton = self.frame.size.height;
    self.buttonReduce.frame = CGRectMake(0.0, 0.0, sizeButton, sizeButton);
    self.buttonAddMore.frame = CGRectMake((self.frame.size.width - sizeButton), 0.0, sizeButton, sizeButton);
    self.textField.frame = CGRectMake(sizeButton, 0.0, (self.frame.size.width - sizeButton * 2), sizeButton);
    self.lineLeft.frame = CGRectMake((self.buttonReduce.frame.size.width - _borderWidth), 0.0, _borderWidth, sizeButton);
    self.lineRight.frame = CGRectMake(0.0, 0.0, _borderWidth, sizeButton);
}

#pragma mark - 响应

- (void)buttonReduceClick
{
    if ([self.textField isFirstResponder])
    {
        [self.textField resignFirstResponder];
    }
    
    NSString *numberText = self.textField.text;
    NSInteger number = numberText.integerValue;
    if (number > 0)
    {
        number--;
        numberText = [NSString stringWithFormat:@"%@", @(number)];
    }
    else
    {
        numberText = @"0";
    }
    self.textField.text = numberText;
    
    if (self.numberEdit)
    {
        self.numberEdit(number);
    }
}

- (void)buttonAddMoreClick
{
    if ([self.textField isFirstResponder])
    {
        [self.textField resignFirstResponder];
    }
    
    NSString *numberText = self.textField.text;
    NSInteger number = numberText.integerValue;
    number++;
    if (number >= self.numberMax && 0 < self.numberMax)
    {
        number = self.numberMax;
    }
    numberText = [NSString stringWithFormat:@"%@", @(number)];
    self.textField.text = numberText;
    
    if (self.numberEdit)
    {
        self.numberEdit(number);
    }
}

#pragma mark - UITextFieldDelegate

- (void)textEdictChange:(NSNotification *)notification
{
    NSString *numberText = self.textField.text;
    // 限制输入数字
    for (int i = 0; i < numberText.length; i++)
    {
        NSString *subText = [numberText substringWithRange:NSMakeRange(i, 1)];
        // 首个输入不能为0
        if (0 == i && subText.integerValue == 0)
        {
            numberText = [numberText stringByReplacingOccurrencesOfString:subText withString:@""];
        }
        
        NSRange range = [limitNumberText rangeOfString:subText];
        if (range.location == NSNotFound)
        {
            numberText = [numberText stringByReplacingOccurrencesOfString:subText withString:@""];
        }
    }
    
    // 限制最大值
    NSInteger number = numberText.integerValue;
    if (number >= self.numberMax && 0 < self.numberMax)
    {
        number = self.numberMax;
    }
    numberText = [NSString stringWithFormat:@"%@", @(number)];
    self.textField.text = numberText;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isFirstResponder])
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - getter

- (UIButton *)reduceButton
{
    return self.buttonReduce;
}

- (UIButton *)addButton
{
    return self.buttonAddMore;
}

#pragma mark - setter

#pragma mark 减按钮

- (void)setReduceImageNormal:(UIImage *)reduceImageNormal
{
    _reduceImageNormal = reduceImageNormal;
    if (_reduceImageNormal)
    {
        [self.buttonReduce setTitle:nil forState:UIControlStateNormal];
        [self.buttonReduce setImage:_reduceImageNormal forState:UIControlStateNormal];
    }
}

- (void)setReduceImageHighlight:(UIImage *)reduceImageHighlight
{
    _reduceImageHighlight = reduceImageHighlight;
    if (_reduceImageHighlight)
    {
        [self.buttonReduce setTitle:nil forState:UIControlStateHighlighted];
        [self.buttonReduce setImage:_reduceImageHighlight forState:UIControlStateHighlighted];
    }
}

- (void)setReduceTitleNormal:(NSString *)reduceTitleNormal
{
    _reduceTitleNormal = reduceTitleNormal;
    if (_reduceTitleNormal)
    {
        [self.buttonReduce setTitle:_reduceTitleNormal forState:UIControlStateNormal];
        [self.buttonReduce setTitle:(_reduceTitleHighlight ? _reduceTitleHighlight : _reduceTitleNormal) forState:UIControlStateHighlighted];
    }
}

- (void)setReduceTitleHighlight:(NSString *)reduceTitleHighlight
{
    _reduceTitleHighlight = reduceTitleHighlight;
    if (_reduceTitleHighlight)
    {
        [self.buttonReduce setTitle:_reduceTitleHighlight forState:UIControlStateHighlighted];
    }
}

- (void)setReduceFont:(UIFont *)reduceFont
{
    _reduceFont = reduceFont;
    if (_reduceFont)
    {
        self.buttonReduce.titleLabel.font = _reduceFont;
    }
}

- (void)setReduceTitleColorNormal:(UIColor *)reduceTitleColorNormal
{
    _reduceTitleColorNormal = reduceTitleColorNormal;
    if (_reduceTitleColorNormal)
    {
        [self.buttonReduce setTitleColor:_reduceTitleColorNormal forState:UIControlStateNormal];
    }
}

- (void)setReduceTitleColorHighlight:(UIColor *)reduceTitleColorHighlight
{
    _reduceTitleColorHighlight = reduceTitleColorHighlight;
    if (_reduceTitleColorHighlight)
    {
        [self.buttonReduce setTitleColor:_reduceTitleColorHighlight forState:UIControlStateHighlighted];
    }
}

#pragma mark 加按钮

- (void)setAddImageNormal:(UIImage *)addImageNormal
{
    _addImageNormal = addImageNormal;
    if (_addImageNormal)
    {
        [self.buttonAddMore setTitle:nil forState:UIControlStateNormal];
        [self.buttonAddMore setImage:_addImageNormal forState:UIControlStateNormal];
    }
}

- (void)setAddImageHighlight:(UIImage *)addImageHighlight
{
    _addImageHighlight = addImageHighlight;
    if (_addImageHighlight)
    {
        [self.buttonAddMore setTitle:nil forState:UIControlStateHighlighted];
        [self.buttonAddMore setImage:_addImageHighlight forState:UIControlStateHighlighted];
    }
}

- (void)setAddTitleNormal:(NSString *)addTitleNormal
{
    _addTitleNormal = addTitleNormal;
    if (_addTitleNormal)
    {
        [self.buttonAddMore setTitle:_addTitleNormal forState:UIControlStateNormal];
        [self.buttonAddMore setTitle:(_addTitleHighlight ? _addTitleHighlight : _addTitleNormal) forState:UIControlStateHighlighted];
    }
}

- (void)setAddTitleHighlight:(NSString *)addTitleHighlight
{
    _addTitleHighlight = addTitleHighlight;
    if (_addTitleHighlight)
    {
        [self.buttonAddMore setTitle:_addTitleHighlight forState:UIControlStateHighlighted];
    }
}

- (void)setAddFont:(UIFont *)addFont
{
    _addFont = addFont;
    if (_addFont)
    {
        self.buttonAddMore.titleLabel.font = _addFont;
    }
}

- (void)setAddTitleColorNormal:(UIColor *)addTitleColorNormal
{
    _addTitleColorNormal = addTitleColorNormal;
    if (_addTitleColorNormal)
    {
        [self.buttonAddMore setTitleColor:_addTitleColorNormal forState:UIControlStateNormal];
    }
}

- (void)setAddTitleColorHighlight:(UIColor *)addTitleColorHighlight
{
    _addTitleColorHighlight = addTitleColorHighlight;
    if (_addTitleColorHighlight)
    {
        [self.buttonAddMore setTitleColor:_addTitleColorHighlight forState:UIControlStateHighlighted];
    }
}

#pragma mark 编辑框

- (void)setTextFont:(UIFont *)textFont
{
    _textFont = textFont;
    if (_textFont)
    {
        self.textField.font = _textFont;
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    if (_textColor)
    {
        self.textField.textColor = _textColor;
    }
}

- (void)setNumber:(NSInteger)number
{
    _number = number;
    NSString *numberText = [NSString stringWithFormat:@"%@", @(_number)];
    if (0 >= number)
    {
        numberText = @"0";
    }
    self.textField.text = numberText;
}

- (NSInteger)number
{
    return self.textField.text.integerValue;
}

#pragma mark 样式

- (void)setBorderShow:(BOOL)borderShow
{
    _borderShow = borderShow;
    if (_borderShow)
    {
        self.layer.borderColor = _borderColor.CGColor;
        self.layer.borderWidth = _borderWidth;
        self.layer.cornerRadius = _borderCornerRadius;
        self.layer.masksToBounds = YES;
        
        self.lineLeft.hidden = NO;
        self.lineLeft.backgroundColor = _borderColor;
        CGRect rectLeft = self.lineLeft.frame;
        rectLeft.origin.x = (self.buttonReduce.frame.size.width - _borderWidth);
        rectLeft.size.width = _borderWidth;
        self.lineLeft.frame = rectLeft;
        
        self.lineRight.hidden = NO;
        self.lineRight.backgroundColor = _borderColor;
        CGRect rectRight = self.lineRight.frame;
        rectRight.size.width = _borderWidth;
        self.lineRight.frame = rectRight;
    }
    else
    {
        self.layer.borderColor = nil;
        self.layer.borderWidth = 0.0;
        self.layer.cornerRadius = 0.0;
        self.layer.masksToBounds = YES;
        
        self.lineLeft.hidden = YES;
        self.lineRight.hidden = YES;
    }
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    if (_borderShow)
    {
        self.layer.borderColor = _borderColor.CGColor;
        
        self.lineLeft.backgroundColor = _borderColor;
        self.lineRight.backgroundColor = _borderColor;
    }
}

- (void)setBorderCornerRadius:(CGFloat)borderCornerRadius
{
    _borderCornerRadius = borderCornerRadius;
    if (_borderShow)
    {
        _borderCornerRadius = (borderCornerMin > _borderCornerRadius ? borderCornerMin : (borderCornerMax < _borderCornerRadius ? borderCornerMax : _borderCornerRadius));
        self.layer.cornerRadius = _borderCornerRadius;
    }
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    if (_borderShow)
    {
        _borderWidth = (borderWidthMin > _borderWidth ? borderWidthMin : (borderWidthMax < _borderWidth ? borderWidthMax : _borderWidth));
        self.layer.borderWidth = _borderWidth;
        
        CGRect rectLeft = self.lineLeft.frame;
        rectLeft.origin.x = (self.buttonReduce.frame.size.width - _borderWidth);
        rectLeft.size.width = _borderWidth;
        self.lineLeft.frame = rectLeft;
        
        self.lineRight.backgroundColor = _borderColor;
        CGRect rectRight = self.lineRight.frame;
        rectRight.size.width = _borderWidth;
        self.lineRight.frame = rectRight;
    }
}

@end
