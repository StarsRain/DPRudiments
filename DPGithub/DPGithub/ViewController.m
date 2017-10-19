//
//  ViewController.m
//  DPGithub
//
//  Created by myApple on 2017/10/19.
//  Copyright © 2017年 myApple. All rights reserved.
//

#import "ViewController.h"
#import "SubSequenceViewController.h"

#define Swidth  [UIScreen mainScreen].bounds.size.width
#define Sheight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITextFieldDelegate>
{
    UITextField * inputTextFiled;
    NSMutableArray * dimensionalArray;//具体值的二维数组
    NSInteger sumCount;
    NSMutableArray * maxDimensioalArray;//每个二维数组的最大值
    UILabel * resultLabel;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    dimensionalArray = [[NSMutableArray alloc]init];
    maxDimensioalArray = [[NSMutableArray alloc]init];
    [self prepareView];
}

#pragma mark - 页面布局
-(void)prepareView
{
    CGFloat x = 20;
    CGFloat y = 70;
    CGFloat width = Swidth - 2 * x;
    CGFloat height = 50;
    
    inputTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(x, y, width, height)];
    inputTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    inputTextFiled.delegate = self;
    inputTextFiled.returnKeyType = UIReturnKeyDone;
    inputTextFiled.placeholder = @"输入三角形的列数 1~11";
    inputTextFiled.backgroundColor = [UIColor greenColor];
    [self.view addSubview:inputTextFiled];
    
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(50, Sheight - 100, Swidth - 100, 40);
    [btn setTitle:@"最长升序" forState:0];
    [btn setBackgroundColor:[UIColor greenColor]];
    [btn addTarget:self action:@selector(pushNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}


#pragma mark - 最长升序方案
-(void)pushNext
{
        SubSequenceViewController * ssvc = [[SubSequenceViewController alloc]init];
        [self.navigationController pushViewController:ssvc animated:YES];
}


#pragma mark - 试图展示
-(void)prepareTriangleView:(NSInteger)length
{
    CGFloat offX = 20;
    CGFloat offY = 20;
    CGFloat height = 25;
    CGFloat width = 30;
    CGFloat x = 0;
    CGFloat y = 0;
    for (int i = 0; i <= length; i ++) {
        y = offY + height * i + 110;
        x = 0;
        NSMutableArray * array = [[NSMutableArray alloc]init];
        NSMutableArray * maxArray =[[NSMutableArray alloc]init];
        for (int j = 0; j <= i ; j++) {
            x = j * width + offX;
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(x,y , width, height)];
            label.text = [NSString stringWithFormat:@"%d",arc4random() % 11];
            label.font = [UIFont systemFontOfSize:15.0];
            label.textColor = [UIColor blackColor];
            [self.view addSubview:label];
            [array addObject:label.text];
            [maxArray addObject:@"-1"];//初始化为-1
        }
        [dimensionalArray addObject:array];
        [maxDimensioalArray addObject:maxArray];
    }
    
    resultLabel = [[UILabel alloc]initWithFrame:CGRectMake((Swidth - 60)/2.0, (Sheight - 30)/2.0,60, 30)];
    resultLabel.textColor = [UIColor redColor];
    resultLabel.font = [UIFont systemFontOfSize:20];
    resultLabel.textAlignment = NSTextAlignmentCenter;
    resultLabel.layer.borderWidth = 2;
    resultLabel.layer.borderColor = [UIColor greenColor].CGColor;
    resultLabel.layer.masksToBounds = YES;
    [self.view addSubview:resultLabel];
    
    [self readyGo];
}


#pragma mark - 开始计算
-(void)readyGo
{
    NSInteger count = [self countMaxLength:0 row:0];
    resultLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
}

#pragma mark - 算路径最大值,算出的最大的值都记下来
-(NSInteger)countMaxLength:(NSInteger)x row:(NSInteger)y
{
    if ([self getValueOfArray:x row:y] != -1) {
        return [self getValueOfArray:x row:y];
    }
    if (x == [inputTextFiled.text integerValue]) {
        [self maxValueOf:x row:y value:[self currentNumber:x row:y]];
    }
    else
    {
        NSInteger z = [self countMaxLength:x + 1 row:y];
        NSInteger t = [self countMaxLength:x + 1 row:y + 1];
        NSInteger result = (MAX(z, t) + [self currentNumber:x row:y]);
        [self maxValueOf:x row:y value:result];
    }
    return [self getValueOfArray:x row:y];
}


#pragma mark - 显示当前二维码数组的数值
-(NSInteger)currentNumber:(NSInteger)x row:(NSInteger)y
{
    NSArray * rowArray = dimensionalArray[x];
    NSString * str = rowArray[y];
    NSInteger result = [str integerValue];
    return result;
}


#pragma mark - 将value写入最大值的数组里面
-(void)maxValueOf:(NSInteger)x row:(NSInteger)y value:(NSInteger)value
{
    NSMutableArray * rowArray = maxDimensioalArray[x];
    [rowArray replaceObjectAtIndex:y withObject:[NSString stringWithFormat:@"%ld",(long)value]];
}

#pragma mark - 读取最大值数组的值
-(NSInteger)getValueOfArray:(NSInteger)x row:(NSInteger)y
{
    NSArray * rowArray = maxDimensioalArray[x];
    NSString * str = rowArray[y];
    NSInteger result = [str integerValue];
    return result;
}

#pragma mark - 点击屏幕计算最大值
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [dimensionalArray removeAllObjects];
    [maxDimensioalArray removeAllObjects];
    for (UIView * view in self.view.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    NSInteger count = [inputTextFiled.text integerValue];
    if (count < 1 || count > 11) {
        NSLog(@"请输入 1～11之间的正整数");
    }
    else
    {
        NSLog(@"Ready Go");
        [self prepareTriangleView:count];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
