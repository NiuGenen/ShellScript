# Shell 编程手册

## 选择 Shell 

在 Shell 脚本的第一行设置，如下选择 bash 来运行

```
#!/bin/bash
```

Linux 中的 Shell 有多种，常见有以下：

- Bourne Shell（sh），是 UNIX 最初使用的 Shell，在不同 UNIX 下均能使用。
    - sh 在 Shell 编程上非常好用，但在与用户的交互上不如其他。
- Bourne Again Shell（bash），是 Linux 系统默认的shell，基于 sh 扩展而来，与 sh 兼容。
    - 相对于 sh，bash 增加了许多特性，如命令行补全、命令行编辑、命令历史表等
- C Shell（csh）是一种比 sh 更适合于编程的 Shell，语法和 C 语言很相似。
    - Tcsh 是 Linux 为喜欢使用 csh 的人提供的，是 csh 的一个扩展版本。
- Korn Shell（ksh） 集合了 csh 和 sh 的优点，并且与 sh 完全兼容。
    - pdksh 是 Linux 提供的基于 ksh 扩展的一种 Shell，支持了任务控制，可以挂起、后台执行、唤醒、终止。
- Almquist shell（ash）是一个轻量级的 Unix Shell，诞生于 1980s，最初是 bash 的一个克隆版本，后来在 1990s 时 ash 取代 bash 成为 BSD 系的 Unix 的默认 Shell
- Z Shell（zsh）有着很多灵活的特性，更适合与人交互，在 2019 年苹果 WWDC 发布会上，zsh 已经取代 bash 成为 Mac 的默认 Shell
    - 著名的 Github 项目 `oh-my-zsh` 已经基本成为若干程序员的标配了

以下语法均以`bash`为主要背景，大多数 Shell 如 zsh 基本上都与`bash`兼容

## 变量

VAR_NAME="var value"

```
$ cat test.sh
VAR="asd"
echo ${VAR}
$ ./test.sh
asd
```

## 数组

bash 仅支持一维数组，元素以空格为区分。若一个元素包含空格，则应使用单引号或双引号将这个元素围起来。

```
$ cat test.sh
array=(qwe asd "zx c")
echo ${array[0]}
echo ${array[1]}
echo ${array[2]}
array[0]=QWE
echo ${array[0]}

$ ./test.sh
qwe
asd
zx c
QWE
```

常用的针对数组的操作:
- `${array[*]}`获取数组的所有元素
- `${#array[*]}`或`${#array[@]}`获取数组元素个数
- `array[i]=value`设置第`i`个元素的值


## 脚本的参数

通过`$0`来获取第 0 个参数，`$1`来获取第 1 个参数，以此类推
- `$#`代表参数个数
- `$*`代表所有参数，用一整个字符串表示
- `$@`代表所有参数，用每个参数表示
- `$$`代表运行脚本的当前进程 ID 号
- `$?`代表最后命令的退出状态，0表示没有错误，非0表示有错误
- `$!`代表后台运行的最后一个进程的 ID 号

```
$ cat test.sh
echo $1
echo $2
echo $#
$ ./test.sh arg1 arg2
arg1
arg2
2
```

`$*`和`$@`均代表所有参数，区别在于前者将所有参数组合成一个字符串，后者仍是分离的每个参数。

```
$ cat test.sh
echo $#
echo "------"
for arg in "$*"
do
    echo ${arg}
done
echo "------"
for arg in "$@"
do
    echo ${arg}
done

$ ./test.sh arg1 arg2
2
------
arg1 arg2
------
arg1
arg2
```

对于参数`arg1 arg2`:
- `$*`的背后含义是`"arg1 arg2"`
- `$@`的背后含义是`"arg1" "arg2"`

## 基本数学运算

`expr`命令支持加、减、乘、除、取余，均针对有符号整数运算。
- 乘法需要用`\`进行转义，即`\*`表示乘法
    - 仅`*`代表当前工作目录下的所有文件，可用`$(pwd)`来获取当前工作目录

```
$ cat test.sh
a=52
b=10
echo $a + $b = `expr $a + $b`
echo $a - $b = `expr $a - $b`
echo $a \* $b = `expr $a \* $b`
echo $a / $b = `expr $a / $b`
echo $a % $b = `expr $a % $b`

$ ./test.sh
52 + 10 = 62
52 - 10 = 42
52 * 10 = 520
52 / 10 = 5
52 % 10 = 2
```

也可以使用`((`和`))`来完成运算，基本使用方式是`$(( expressiong ))`

```
$ cat test.sh
a=52
b=10
echo $a + $b = $(($a + $b))
echo $a - $b = $(($a - $b))
echo $a \* $b = $(($a * $b))
echo $a / $b = $(($a / $b))
echo $a % $b = $(($a % $b))

$ ./test.sh
52 + 10 = 62
52 - 10 = 42
52 * 10 = 520
52 / 10 = 5
52 % 10 = 2
```

## 条件判断

条件运算位于`[]`中，并有空格隔开。主要有三类：
- 数字
- 字符串
- 文件

### 数字条件判断

- `-eq`判断是否相等，相等则返回`true`，等同于`==`
- `-ne`判断是否不等，不等则返回`true`，等同于`!=`
- `-gt`判断是否大于，若左边大于右边则返回`true`
- `-lt`判断是否小于，若左边小于右边则返回`true`
- `-ge`判断是否大于等于，若是则返回`true`
- `-le`判断是否小于等于，若是则返回`true`
- `-a`进行逻辑与操作，若两个条件都满足则返回`true`
- `-o`进行逻辑或运算，若至少一个条件满足则返回`true`

```
$ cat test.sh
a=1
b=2
if [ $a -lt $b ]; then
    echo "$a < $b"
else
    if [ $a -eq $b ]; then
        echo "$a = $b"
    else
        echo "$a > $b"
    fi
fi
if [ $a -eq 1 -a $b -eq 2 ]; then
    echo "a=1 & b=2"
else
    echo "a!=1 or b!=2"
fi

$ ./test.sh
1 < 2
a=1 & b=2
```

### 字符串条件判断

- `=`判断字符串是否相等，若相等则返回`true`
- `!=`判断字符串是否不等，若不等则返回`true`
- `-z`判断字符串长度是否为0，若为0则返回`true`
- `-n`判断字符串长度是否非0，若非0则返回`true`
- `$`也可以判断字符串是否为空，若不为空则返回`true`

```
$ cat test.sh
a=""

if [ $a ]; then
    echo "string is not empty"
else
    echo "string is empty"
fi

if [ -z $a ]; then
    echo "string is still empty"
else
    echo "string is still not empty"
fi

$ ./test.sh
string is empty
string is still empty
```

### 文件测试

用于判断某个文件的某个属性是否满足：
- `-r`判断文件是否可读，是则返回`true`
- `-w`判断文件是否可写，是则返回`true`
- `-x`判断文件是否可执行，是则返回`true`
- `-s`判断文件是否为空，不为空则返回`true`
- `-e`判断文件是否存在，存在则返回`true`
- `-d`判断文件是否是目录（文件夹），是则返回`true`
- `-b`判断文件是否是块设备文件，是则返回`true`
- `-c`判断文件是否是字符设备文件，是则返回`true`
- `-f`判断文件是否是普通文件，是则返回`true`
- `-g`判断文件是否设置了 SGID 位，是则返回`true`
- `-u`判断文件是否设置了 SUID 位，是则返回`true`
- `-k`判断文件是否设置了 Sticky Bit，是则返回`true`
- `-p`判断文件是否有名管道，是则返回`true`

```
$ cat test.sh
mkdir asd
if [ -e ./asd ]; then
    echo "./asd exists"
fi
if [ -d ./asd ]; then
    echo "./asd is a directory"
fi

$ ./test.sh
./asd exists
./asd is a directory
```

## if-while-for-case

控制流。

### if语句

关键字有`if`，`else`，`elif`，`fi`，`continue`，`break`。

```
$ cat test.sh
if [ $1 -eq $2 ]; then
    echo $1 == $2
else
    echo $1 != $2
fi

$ ./test.sh 1 2
1 != 2

$ ./test.sh 2 2
2 == 2
```

### while和until语句

关键字有`until`，`while`，`do`，`done`，`continue`，`break`。

```
$ cat test.sh
n=5
a=0
while [ $a -lt $n ]; do
    echo $a
    a=$(($a+1))
done

$ ./test.sh
0
1
2
3
4
```

### for语句

关键字有`for`，`do`，`done`，`continue`，`break`。循环内容以空格间隔。

```
$ cat test.sh
for item in qwe asd zxc; do
    echo $item
done

$ ./test.sh
qwe
asd
zxc
```

配合`ls`命令可以遍历某个目录下的所有文件

```
$ cat test.sh
cwd=`pwd`
cwdfiles=(`ls`)
echo Current Working Directory : $cwd
for f in $cwdfiles; do
    echo "$f : $cwd/$f"
done
```

### case语句

关键字有`case`，`in`，`esac`。

```
$ cat test.sh
input=$1
case $input in
    qwe)
        echo "input qwe"
        ;;
    asd)
        echo "input asd"
        ;;
    zxc)
        echo "input zxc"
        ;;
    *)
        echo "default input $input"
        ;;
esac

$ ./test.sh asd
input asd

$ ./test.sh xvxdgfds
default input xvxdgfds
```

## printf格式化输出

与 C 语言的语法基本一致

```
$ cat test.sh
printf "%-8s %-8s %-8s\n" title1 title2 title3
printf "%-8s %-8s %-8s\n" cnt1 cnt2 cnt3
printf "%-8s %-8s %-8s\n" cnt1 cnt2 cnt3
printf "%-8s %-8s %-8s\n" cnt1 cnt2 cnt3

$ ./test.sh
title1   title2   title3
cnt1     cnt2     cnt3
cnt1     cnt2     cnt3
cnt1     cnt2     cnt3
```

转义字符一览：
- `\n`换行，即 next line
- `\r`回车，即 return
- `\a`警告，即 alert
- `\f`换页，即 format
- `\b`后退，即 backspace
- `\t`水平制表符，即 tab
- `\v`垂直制表符，即 vertical tab
- `\c`抑制输出中结尾的换行，即 curb

## 函数及其传参

函数定义`function functionname()`
函数调用`functionname`
参数传递`functionname arg1 arg2`
获取参数`$1`、`$2`
函数返回值`return integer_value`，只能返回整数值
获取函数返回值`$?`

```
$ cat test.sh
function func(){
    echo number of func parameters $#
    echo parameters\[1\] = $1
    echo parameters\[2\] = $2
    return 123
}
func qwe zxc
echo "func return : $?"

$ ./test.shclea
number of func parameters 2
parameters[1] = qwe
parameters[2] = zxc
func return : 123
```


## 字符串操作

Shell 脚本下默认变量的值都是字符串，即使数字其本质仍是字符串，对数字的运算需要在特殊的环境下才能完成（如`expr`或`(( expression))`），因此学会操作字符串就很重要。

### 基本字符串操作

设一个字符串变量名为`string`
- `${#string}`获取字符串长度
- `${string:2}`获取从第 2 个字符开始之后的子串
- `${string:2:3}`获取从第 2 个字符开始、长度为 3 的子串
- `${string#asd}`从开头开始删除最短匹配`asd`的子串，即最短前缀
- `${string##asd}`从开头开始删除最长匹配`asd`的子串，即最长前缀
- `${string#asd}`从末尾开始删除最短匹配`asd`的子串，即最短后缀
- `${string##asd}`从末尾开始删除最长匹配`asd`的子串，即最长后缀
- `${string/asd/replace}`使用`relpace`代替从开头第一个匹配`asd`的子串
- `${string//asd/replace}`使用`replace`代替所有匹配`asd`的子串
- `${string/#asd/replace}`使用`replace`代替匹配`asd`的前缀
- `${string/%asd/replace}`使用`replace`代替匹配`asd`的后缀

```
$ cat test.sh
string="asd.asd.qwe.qwe"

function printfstr(){
    printf "%-15s | %-20s | %-15s\n" $1 $2 $3
}

function printfstringeachchar(){
    idx=0
    while [ $idx -lt ${#string} ]; do
        printfstr "string[$idx]" ${string:$idx:1} "$\{string:${idx}:1\}"
        idx=$(($idx+1))
    done
}

printfstr  "target"      value           usage
printfstr "---------------" "--------------------" "---------------"
printfstr "string"      ${string}       '${string}'
printfstringeachchar
printfstr "length"      ${#string}      '${#string}'
printfstr "string[2:]"  ${string:2}     '${string:2}'
printfstr "string[2:4]" ${string:2:3}   '${string:2:3}'
printfstr "string#asd"  ${string#asd}   '${string#asd}'
printfstr "string#a*d"  ${string#a*d}   '${string#a*d}'
printfstr "string##a*d" ${string##a*d}  '${string##a*d}'
printfstr "string%qwe"  ${string%qwe}   '${string%qwe}'
printfstr "string%q*e"  ${string%q*e}   '${string%q*e}'
printfstr "string%%q*e" ${string%%q*e}  '${string%%q*e}'
printfstr "string%.*"   ${string%.*}    '${string%.*}'
printfstr "string%%.*"  ${string%%.*}   '${string%%.*}'
printfstr "string/asd/ASD"  ${string/asd/ASD}   '${string/asd/ASD}'
printfstr "string/a*d/ASD"  ${string/a*d/ASD}   '${string/a*d/ASD}'
printfstr "string//asd/ASD" ${string//asd/ASD}  '${string//asd/ASD}'
printfstr "string/#asd/ASD" ${string/#asd/ASD}  '${string/#asd/ASD}'
printfstr "string/#qwe/QWE" ${string/#qwe/QWE}  '${string/#qwe/QWE}'
printfstr "string/#a*d/ASD" ${string/#a*d/ASD}  '${string/#a*d/ASD}'
printfstr "string/%qwe/QWE" ${string/%qwe/QWE}  '${string/%qwe/QWE}'
printfstr "string/%q*e/QWE" ${string/%q*e/QWE}  '${string/%q*e/QWE}'

$ ./test.sh
target          | value                | usage
--------------- | -------------------- | ---------------
string          | asd.asd.qwe.qwe      | ${string}
string[0]       | a                    | $\{string:0:1\}
string[1]       | s                    | $\{string:1:1\}
string[2]       | d                    | $\{string:2:1\}
string[3]       | .                    | $\{string:3:1\}
string[4]       | a                    | $\{string:4:1\}
string[5]       | s                    | $\{string:5:1\}
string[6]       | d                    | $\{string:6:1\}
string[7]       | .                    | $\{string:7:1\}
string[8]       | q                    | $\{string:8:1\}
string[9]       | w                    | $\{string:9:1\}
string[10]      | e                    | $\{string:10:1\}
string[11]      | .                    | $\{string:11:1\}
string[12]      | q                    | $\{string:12:1\}
string[13]      | w                    | $\{string:13:1\}
string[14]      | e                    | $\{string:14:1\}
length          | 15                   | ${#string}
string[2:]      | d.asd.qwe.qwe        | ${string:2}
string[2:4]     | d.a                  | ${string:2:3}
string#asd      | .asd.qwe.qwe         | ${string#asd}
string#a*d      | .asd.qwe.qwe         | ${string#a*d}
string##a*d     | .qwe.qwe             | ${string##a*d}
string%qwe      | asd.asd.qwe.         | ${string%qwe}
string%q*e      | asd.asd.qwe.         | ${string%q*e}
string%%q*e     | asd.asd.             | ${string%%q*e}
string%.*       | asd.asd.qwe          | ${string%.*}
string%%.*      | asd                  | ${string%%.*}
string/asd/ASD  | ASD.asd.qwe.qwe      | ${string/asd/ASD}
string/a*d/ASD  | ASD.qwe.qwe          | ${string/a*d/ASD}
string//asd/ASD | ASD.ASD.qwe.qwe      | ${string//asd/ASD}
string/#asd/ASD | ASD.asd.qwe.qwe      | ${string/#asd/ASD}
string/#qwe/QWE | asd.asd.qwe.qwe      | ${string/#qwe/QWE}
string/#a*d/ASD | ASD.qwe.qwe          | ${string/#a*d/ASD}
string/%qwe/QWE | asd.asd.qwe.QWE      | ${string/%qwe/QWE}
string/%q*e/QWE | asd.asd.QWE          | ${string/%q*e/QWE}
```

### 花式获取变量的值

获取变量的值也有很多种方法
- `${varname}`获取变量`varname`的值
- `${varname-asd}`若`varname`未定义，则使用`asd`作为该值，此后`varname`仍是未定义的
- `${varname:-asd}`若`varname`未定义，或值为空，则使用`asd`作为该值，此后`varname`仍是未定义的
- `${varname=asd}`若`varname`未定义，则使用`asd`作为该值，此后`varname`已定义且值为`asd`
- `${varname:=asd}`若`varname`未定义，或值为空，则使用`asd`作为该值，此后`varname`已定义且值为`asd`
- `${varname+asd}`若`varname`已定义，则使用`asd`作为该值，否则返回空，`varname`保持原值不变
- `${varname:+asd}`若`varname`已定义，则使用`asd`作为该值，否则返回空，`varname`保持原值不变
- `${varname?ERROR}`若`varname`未定义，则打印错误信息`ERROR`，同时脚本停止执行
- `${varname:?ERROR}`若`varname`未定义，或值为空，则打印错误信息`ERROR`，同时脚本停止执行

```
$ cat test.sh
varname=111
var2name=222
var3name=333
varname4=444
varname5=555
varnull=""
varnull2=""

printvar(){
    printf "%-20s  =  %-10s \n" $2 $1
}

echo "----------------------------------------"
echo "[test] all defined variables and their value"
printvar ${varname}      '${varname}'
printvar ${var2name}     '${var2name}'
printvar ${var3name}     '${var3name}'
printvar ${varname4}     '${varname4}'
printvar ${varname5}     '${varname5}'
printvar ${varnull}      '${varnull}'
printvar ${varnull2}     '${varnull2}'
echo "----------------------------------------"
echo "[test] varname5 is defined and has value 555"
printvar ${varname5+123}    '${varname+123}'
printvar ${varname5}        '${varname}'
printvar ${varname5:+123}   '${varname:+123}'
printvar ${varname5}        '${varname}'
echo "----------------------------------------"
echo "[test] varname6  and varname 7 is not defined"
printvar ${varname6-666}    '${varname6-666}'
printvar ${varname6}        '${varname6}'
printvar ${varname6:-666}   '${varname6:-666}'
printvar ${varname6}        '${varname6}'
printvar ${varname6=666}    '${varname6=666}'
printvar ${varname6}        '${varname6}'
printvar ${varname7}        '${varname7}'
printvar ${varname7=777}    '${varname7=777}'
printvar ${varname7}        '${varname7}'
echo "-----------------------------------------"
echo "[test] varnull is defined but its value is empty"
printvar ${varnull+asd}  '${varnull+asd}'
printvar ${varnull}      '${varnull}'
printvar ${varnull:+asd} '${varnull:+asd}'
printvar ${varnull}      '${varnull}'
printvar ${varnull:-123} '${varname:-123}'
printvar ${varnull}      '${varname}'
printvar ${varnull:=456} '${varname:=456}'
printvar ${varnull}      '${varname}'
echo "-----------------------------------------"
echo "[test] error message when accessing a variable"
printvar ${varNOT?ERRNOT} '${varNOT?ERRORNOT}'
echo "Shell script will be teriminated, this message won't be echoed"

$ ./test.sh
----------------------------------------
[test] all defined variables and their value
${varname}            =  111
${var2name}           =  222
${var3name}           =  333
${varname4}           =  444
${varname5}           =  555
${varnull}            =
${varnull2}           =
----------------------------------------
[test] varname5 is defined and has value 555
${varname+123}        =  123
${varname}            =  555
${varname:+123}       =  123
${varname}            =  555
----------------------------------------
[test] varname6  and varname 7 is not defined
${varname6-666}       =  666
${varname6}           =
${varname6:-666}      =  666
${varname6}           =
${varname6=666}       =  666
${varname6}           =  666
${varname7}           =
${varname7=777}       =  777
${varname7}           =  777
-----------------------------------------
[test] varnull is defined but its value is empty
${varnull+asd}        =  asd
${varnull}            =
${varnull:+asd}       =
${varnull}            =
${varname:-123}       =  123
${varname}            =
${varname:=456}       =  456
${varname}            =  456
-----------------------------------------
[test] error message when accessing a variable
./test.sh: line 53: varNOT: ERRNOT
```

### 批量获取变量名

然而只是获取变量名而已，不知道有啥用
- `${!var*}`匹配在该行之前所有以`var`开头的变量名
- `${!var@}`匹配在该行之前所有以`var`开头的变量名

```
$ cat test.sh
var1=1
var2=2
var3=3

for var in ${!var*}; do
    echo -e "${var} \c"
done
echo ""

asd1=1
asd2=2
asd3=3

for asd in ${!asd@}; do
    echo -e "${asd} \c"
done
echo ""

$ ./test.sh
var1 var2 var3
asd1 asd2 asd3
```

## 实用小技巧


### 括号的多种使用方式

方括号`[`和`]`通常用来作条件表达式的运算。个人最常用的是使用单方括号`[`和`]`进行条件判断。不过条件判断还有`test`和双方括号`[[`与`]]`这两种方式
- `test`：事实上`test`的作用和`[`加`]`的作用是一样的，都是 Shell 内建的命令，用于测试某个条件
    - 既然是命令，所以才需要类似指定`-eq`的选项
    - 既然是命令，因此对于`>`这种符号会被解释为“输出重定向”这样的语义
- 双方括号`[[ expression ]]`：`[[`和`]]`本质上是 Shell 的关键字，和`while`这样的关键字是同等地位
    - 关键字`[[`和`]]`内`expression`是条件表达式，因此可以直接使用`>`等符号来表示大于等操作

小括号单着用和双着用的意义并不一样
- 单小括号`( array )`的意义是数组
- 双小括号`$(( expression ))`可以进行数学运算
    - 这个`expression`是数学表达式，因为 Shell 内一切都是字符串，因此数学运算需要用`((`和`))`围起来才能运行

```
$ cat test.sh
a=1
b=2
if [ $a -lt $b ]; then
    echo "[ $a < $b ]"
fi
if [[ $a < $b ]]; then
    echo "[[ $a < $b ]]"
fi
c=$(( $a + $b ))
d="$a + $b"
echo c=$c
echo d=$d

$ ./test.sh
[ 1 < 2 ]
[[ 1 < 2 ]]
c=3
d=1 + 2
```

关键字`[[`和`]]`内使用`&&`和`||`来将多个`expression`连接起来，进行与、或运算。而`[`和`]`内则使用`-a`和`-o`来进行与、或运算。

```
$ cat test.sh
a=1
b=2
if [[ $a = 1 && $b > 1 ]]; then
    echo "a=1 & b>1"
fi

$ ./test.sh
a=1 & b>1
```


### echo不换行

每次`echo`命令输出的内容总是新的一行，而要不换行的话，也就是要两次`echo`输出的内容在同一行时：

```
$ cat ./test.sh
echo -e "asd \c"
echo "qwe"
echo "zxc"

$ ./test.sh
asd qwe
zxc
```

### 实时显示

使用`sleep 1`和`clear`命令在`while`循环里，以达到每隔一秒就输出新的信息的目的。

例如不断查看`dmesg`的最后`20`行。

```
$ cat topdmesg.sh
while ;
do
    clear
    sudo dmesg | tail -n 20
    sleep 1
done
```

### 优雅地使用参数

类似 C 语言里的`getopt_long`，Shell 里面也有一个`getopts`可以来优雅的处理传入的参数

```
$ cat test.sh
while getopts "hvf:" opt; do
    case $opt in
    h)
        echo "[help] This is the help info for test.sh"
        echo "----------------------------------------"
        echo "usage: test.sh [-h] [-v] [-f filename]"
    ;;
    f)
        echo "[file] $OPTARG"
    ;;
    v)
        echo "[version] test.sh 0.00000000000001"
    ;;
    *)
        echo "[test] unrealized arguments"
    ;;
done

$ ./test.sh -v
[version] test.sh 0.00000000000001

$ ./test.sh -h
[help] This is the help info for test.sh
----------------------------------------
usage: test.sh [-h] [-v] [-f filename]

$ ./test.sh -f asd
[file] asd
```

### 处理控制台输入

Shell 中可以使用`read`来获取控制台的输入，基本的用法是`read varname`，用户的输入会被保存到`varname`变量中

```
$ cat test.sh
echo "enter a number:"
read num
echo "num=$num"

$ ./test.sh
enter a number:
123
num=123
```

`read`命令有如下选项
- `-p message`打印`message`信息并等待输入，回车后返回 Shell 继续执行
- `-n`指定输入的字符个数，达到数量后会立刻返回 Shell 继续执行，可在此之前按回车以返回 Shell
    - 注意，使用方式是像`-n1`、`-n2`这样
- `-t`指定等待输入的时间，单位秒
- `-s`不回显用户的输入，通常用于输入密码

```
$ cat test.sh
read -n1 -p "Are you interested in Shell Script? [y/n]" ans
if [ $ans == "y" -o $ans == "Y" ]; then
    printf "\n"
    echo "Hope this article will help you!"
fi
if [ $ans == "n" -o $ans == "N" ]; then
    echo ""
    echo "Shell Script is very interesting!"
fi

$ ./test.sh
Are you interested in Shell Script? [y/n]y
Hope this article will help you!

$ ./test.sh
Are you interested in Shell Script? [y/n]n
Shell Script is very interesting!
```

### 执行命令并获取其返回值

Shell 脚本中可以执行命令行命令，如`ls`、`pwd`等并获取其本应该输出的内容

通过`pwd`命令获取当前工作目录
```
$ cat ./test.sh
PWD=$(pwd)
echo "current working directory is ${PWD}"

$ pwd
/home/name

$ ./test.sh
current working directory is /home/name
```

另一种方式就是使用反引号 \` 将命令括起来，这个键通常位于数字键`1`左边
```
$ cat ./test.sh
PWD=`pwd`
echo "current working directory is ${PWD}"

$ pwd
/home/name

$ ./test.sh
current working directory is /home/name
```

通过诸多命令的配合，可在脚本下方便的完成各种任务，如`awk`、`sed`。

### 它是不是 Shell 自带的

使用`type`命令可以查看某个命令是否是 Shell 内置的，还是另有一个程序来完成，比如`expr`实际上是`/bin/expr`这个程序，而不是 Shell 本身提供的运算功能。

```
$ type expr man date
expr is /bin/expr
man is /usr/bin/man
date is /bin/date

$ type ls grep
ls is an alias for ls -G
grep is an alias for grep  --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}

$ type pwd cd test [ "[[" echo printf break continue
pwd is a shell builtin
cd is a shell builtin
test is a shell builtin
[ is a shell builtin
getopts is a shell builtin
echo is a shell builtin
printf is a shell builtin
break is a shell builtin
continue is a shell builtin

$ type "[[" while do done if fi
[[ is a reserved word
while is a reserved word
do is a reserved word
done is a reserved word
if is a reserved word
fi is a reserved word
```