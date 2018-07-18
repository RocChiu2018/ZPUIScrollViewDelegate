//
//  ViewController.m
//  UIScrollView的代理
//
//  Created by apple on 16/5/4.
//  Copyright © 2016年 apple. All rights reserved.
//

/**
 用户用手指刚一拖拽UIScrollView控件的内容层时就会调用scrollViewWillBeginDragging方法，然后内容层就开始滚动，然后用户的手指离开控件，当用户的手指离开控件的那一刻就会调用scrollViewDidEndDragging方法，这个时候控件由正常滚动状态变为减速滚动状态，直至最后停止滚动，当控件停止滚动的那一刻，就会调用scrollViewDidEndDecelerating方法，在上述的整个过程中，只要控件是滚动状态，就会不断调用scrollViewDidScroll方法。
 */
#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UITextField *textField;

@end

@implementation ViewController

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //设置UIScrollView控件
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"6"]];
    [self.scrollView addSubview:self.imageView];
    self.scrollView.contentSize = self.imageView.frame.size;
    self.scrollView.backgroundColor = [UIColor blueColor];
    self.scrollView.delegate = self;  //设置UIScrollView控件的代理
    
    //创建UITextField控件
    self.textField = [[UITextField alloc] init];
    self.textField.frame = CGRectMake(100, 400, 200, 30);
    self.textField.backgroundColor = [UIColor redColor];
    self.textField.delegate = self;  //设置UITextField控件的代理
    [self.view addSubview:self.textField];
    
    /**
     要想监听UITextField控件的编辑事件，有两种方法，一种是使用addTarget方法来监听，另一种是设置UITextField控件的代理，通过代理方法来监听；
     下面是上述的第一种方法，通过addTarget方法来监听；
     后面的UITextFieldDelegate代理方法是上述的第二种方法，通过代理方法来监听。
     */
//    [self.textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    
    /**
     如果想要把在UIScrollView控件上的子控件拖动进行缩放的话则必须要设置下面的缩放比例，并且实现协议UIScrollViewDelegate里面相关的代理方法。
     */
    self.scrollView.maximumZoomScale = 2.0;
    self.scrollView.minimumZoomScale = 0.2;
}

#pragma mark ————— 点击空白处 —————
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
}

#pragma mark ————— 通过addTarget方法来监听UITextField控件的编辑事件 —————
/**
 当用户点击UITextField控件，此时键盘会弹出来，然后当用户在键盘上输入内容的时候就会调用这个方法。
 */
-(void)textChange:(UITextField *)textField
{
    NSLog(@"%@", textField.text);
}

#pragma mark ————— UITextFieldDelegate —————
/**
 用户点击UITextField控件，此时就会调用这个方法，调用此方法之后键盘才会弹出来。
 */
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"开始编辑");
}

/**
 用户点击UITextField控件，此时键盘会弹出来，然后用户在键盘上输入内容的时候就会调用这个方法；
 这个方法的意思是用户在键盘上输入的字符是否可以代替UITextField控件中光标的位置，如果返回的是YES则可以输入进去，如果返回的是NO则不能够输入进去；
 这个方法的作用是用于判断UITextField控件中是否允许输入数字或者特殊符号之类的字符。
 */
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //可以过滤掉不想让用户输入的字符
    if ([string isEqualToString:@"0"])
    {
        return NO;
    }else
    {
        NSLog(@"%@", string);
        
        return YES;
    }
}

/**
 编辑结束（键盘退下）的时候会调用这个方法。
 */
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"编辑结束");
}

#pragma mark ————— UIScrollViewDelegate —————
/**
 UIScrollView控件的内容层只要处在滚动状态的话就会不停的调用这个方法。
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"UIScrollView控件的内容层正在滚动");
}

/**
 当用户的手指刚一拖拽UIScrollView控件的内容层时就会调用这个方法。
 */
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"UIScrollView控件的内容层即将开始拖拽");
}

/**
 用户用手指拖拽UIScrollView控件，使控件开始滚动，然后用户手指离开控件的那一刻就会调用这个方法。
 */
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"用户手指离开UIScrollView控件");
}

/**
 用户用手指拖拽UIScrollView控件，使控件开始滚动，然后用户的手指离开控件，控件开始从正常滚动状态开始慢慢减速滚动直至最后停止滚动，在停止滚动那一刻会调用这个方法。
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"UIScrollView控件已经停止滚动");
}

/**
 想要具有缩放功能则必须要实现这个方法；
 此方法的返回值决定了要缩放的内容（返回值只能是UIScrollView的子控件）。
 */
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

/**
 UIScrollView控件上的子控件正在缩放的时候就会调用这个方法。
 */
-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    NSLog(@"正在缩放，缩放比例为：%f", scrollView.zoomScale);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
